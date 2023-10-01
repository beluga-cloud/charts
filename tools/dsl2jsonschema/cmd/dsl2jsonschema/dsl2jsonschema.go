// convert BelugApps JsonSchema DSL to valid JsonSchema
//
// DSL documentation:
//
// This DSL is mainly base on the uage of custom YAML tags to change the property of a field.
// Here is the list of all available tags:
//
//	Scalar types:
//	  `!!str` - the field will be a JsonSchema object typed as string
//	  `!!int` - the field will be a JsonSchema object typed as integer
//	  `!!float` - the field will be a JsonSchema object typed as float
//	  `!!bool` - the field will be a JsonSchema object typed as boolean
//	  `!!ref` - the field will be a JsonSchema reference to an internal schema node
//	            NOTE: the reference must be given as value
//	  `!!enum` - the field will be a JsonSchema object typed as string with an enum property
//	Mapping types:
//	  nothing or `!!map` - the field will be a JsonSchema object typed as object and all sub-fields will be added as properties
//	  `!!defs` - the field will be a JsonSchema object typed as object and all sub-fields will be added as definitions
//	  `!!array` - the field will be a JsonSchema object typed as array and the items will be a JsonSchema object typed as object with all sub-fields as properties
//	  `!!dict` - the field will be a JsonSchema object typed as object and the additionalProperties will be a JsonSchema object typed as object with all sub-fields as properties
//	Complex tags:
//	  `!!array_of_<type>` - the field will be a JsonSchema object typed as array and the items will be of the given type
//	                        NOTE: the type can be anything but the special tags
//	  `!!dict_of_<type>` - the field will be a JsonSchema object typed as object and the additionalProperties will be of the given type
//	                       NOTE: the type can be anything but the special tags
//	  `!!ref_on_<external_ref>` - the field will be a JsonSchema reference to an external schema (configured with --dsl.external-reference)
//	Special tags:
//	  `!!jsonschema` - everything inside this tag will be added as is to the JsonSchema object (only apply on mapping types)
package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"os"
	"regexp"
	"strings"
	"text/template"

	"github.com/invopop/jsonschema"
	"github.com/stoewer/go-strcase"
	"github.com/urfave/cli/v3"
	orderedmap "github.com/wk8/go-ordered-map/v2"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/yaml.v3"
)

var (
	rxCommentCleaned = regexp.MustCompile(`(:?^|(\n))#\s?`)
	rxTagSplitter    = regexp.MustCompile(`(_of_|_on_)`)

	log = zap.Must(zap.NewDevelopment(
		zap.AddStacktrace(zapcore.PanicLevel),
	)).Sugar()
	externalReferences = map[string]string{}
)

func main() {
	app := &cli.Command{
		Name:  "dsl2jsonschema",
		Usage: "convert BelugApps JsonSchema DSL to valid JsonSchema",
		Flags: []cli.Flag{
			&cli.StringFlag{Name: "dsl.path", Usage: "jsonschema DSL file to convert", Required: true, TakesFile: true},
			&cli.StringMapFlag{Name: "dsl.external-reference", Usage: "external references used with !!ref_on_<external_ref> tag (`name=url`)"},
			&cli.BoolFlag{Name: "verbose", Aliases: []string{"v"}, Value: false, Usage: "make the operation more talkative"},
		},
		Suggest: true,
		Action: func(cCtx *cli.Context) error {
			externalReferences = cCtx.StringMap("dsl.external-reference")
			if cCtx.Bool("verbose") {
				log = log.WithOptions(zap.IncreaseLevel(zapcore.DebugLevel))
			}

			// read the DSL file
			raw, err := os.ReadFile(cCtx.String("dsl.path"))
			if err != nil {
				return fmt.Errorf("failed to read DSL file: %w", err)
			}

			// parse YAML file
			var node yaml.Node
			err = yaml.Unmarshal(raw, &node)
			if err != nil {
				return fmt.Errorf("failed to read DSL file: %w", err)
			}

			// convert DSL to JsonSchema
			schema := ToJsonSchema(node.Content[0])
			if schema == nil || schema.Properties.Len() == 0 {
				return fmt.Errorf("no schema found")
			}
			schema = schema.Properties.Newest().Value

			// convert JsonSchema to raw JSON
			var buff bytes.Buffer
			raw, err = schema.MarshalJSON()
			if err != nil {
				return fmt.Errorf("failed to marshal JsonSchema: %w", err)
			}
			err = json.Indent(&buff, raw, "", "  ")
			if err != nil {
				buff.Write(raw)
			}

			// handle external reference template
			data := map[string]string{}
			for name, url := range externalReferences {
				strcase.UpperCamelCase(name)
				data[strcase.UpperCamelCase(name)+"ReferenceURL"] = url
			}

			tmpl, err := template.New("schema").Parse(buff.String())
			if err != nil {
				return fmt.Errorf("failed to parse JsonSchema: %s", err)
			}

			buff.Reset()
			err = tmpl.Option("missingkey=error").Execute(&buff, data)
			if err != nil {
				return fmt.Errorf("failed to execute template: %s", err)
			}

			// display the result
			fmt.Println(buff.String())
			return nil
		},
	}

	if err := app.Run(context.TODO(), os.Args); err != nil {
		log.Error(err)
		os.Exit(1)
	}
}

type Token string

const (
	ArrayToken         Token = "array"
	BooleanScalarToken Token = "bool"
	DefinitionToken    Token = "defs"
	DictionaryToken    Token = "dict"
	EnumScalarToken    Token = "enum"
	FloatScalarToken   Token = "float"
	IntegerScalarToken Token = "int"
	JsonschemaToken    Token = "jsonschema"
	ObjectToken        Token = "map"
	ReferenceToken     Token = "ref"
	StringScalarToken  Token = "str"
)

func tokenizeYAMLNode(node *yaml.Node) []Token {
	var tokens []Token

	tags := []string{strings.TrimPrefix(node.Tag, "!!")}
	if rxTagSplitter.MatchString(tags[0]) {
		tags = rxTagSplitter.Split(tags[0], -1)
	}

	for _, tag := range tags {
		tokens = append(tokens, Token(tag))
	}
	return tokens
}

func schemaDescription(comments ...string) string {
	return rxCommentCleaned.ReplaceAllString(
		strings.TrimSpace(strings.Join(comments, "\n")),
		"$1",
	)
}

// ToJsonSchema converts a YAML node to a JsonSchema node.
func ToJsonSchema(node *yaml.Node, path ...string) *jsonschema.Schema {
	schema := &jsonschema.Schema{
		Description: schemaDescription(node.HeadComment, node.LineComment, node.FootComment),
	}
	tokens := tokenizeYAMLNode(node)

	if len(tokens) == 0 {
		log.Error("invalid YAML node: no tokens found... aborted")
		return schema
	}

	toTokenizedJsonSchema(tokens, node, schema, path)
	return schema
}

func toTokenizedJsonSchema(tokens []Token, node *yaml.Node, schema *jsonschema.Schema, path []string) {
	if len(tokens) == 0 {
		return
	}
	token := tokens[0]

	switch token {
	case ArrayToken:
		toJsonSchemaArray(tokens, node, schema, path)
	case BooleanScalarToken:
		toJsonSchemaBoolean(node, schema, path)
	case DefinitionToken:
		toDefinitionSchema(node, schema, path)
	case DictionaryToken:
		toDictionarySchema(tokens, node, schema, path)
	case EnumScalarToken:
		toJsonSchemaEnum(node, schema, path)
	case FloatScalarToken:
		toJsonSchemaFloat(node, schema, path)
	case IntegerScalarToken:
		toJsonSchemaInteger(node, schema, path)
	case ObjectToken:
		toObjectSchema(node, schema, path)
	case ReferenceToken:
		toJsonSchemaReference(tokens, node, schema, path)
	case StringScalarToken:
		toJsonSchemaString(node, schema, path)
	default:
		log.Errorf("!!%s failed to be converted on %s: unknown type", token, strings.Join(path, "/"))
	}
}

func toJsonSchemaFloat(node *yaml.Node, schema *jsonschema.Schema, path []string) {
	if node.Kind != yaml.ScalarNode {
		log.Errorf("!!float can't be converted to `number`: %s not a scalar node", strings.Join(path, "/"))
		return
	}
	schema.Type = "number"
}
func toJsonSchemaInteger(node *yaml.Node, schema *jsonschema.Schema, path []string) {
	if node.Kind != yaml.ScalarNode {
		log.Errorf("!!int can't be converted to `integer`: %s not a scalar node", strings.Join(path, "/"))
		return
	}
	schema.Type = "integer"
}
func toJsonSchemaBoolean(node *yaml.Node, schema *jsonschema.Schema, path []string) {
	if node.Kind != yaml.ScalarNode {
		log.Errorf("!!bool can't be converted to `boolean`: %s not a scalar node", strings.Join(path, "/"))
		return
	}
	schema.Type = "boolean"
}
func toJsonSchemaString(node *yaml.Node, schema *jsonschema.Schema, path []string) {
	if node.Kind != yaml.ScalarNode {
		log.Errorf("!!str can't be converted to `string`: %s not a scalar node", strings.Join(path, "/"))
		return
	}
	schema.Type = "string"
}

func toJsonSchemaReference(tokens []Token, node *yaml.Node, schema *jsonschema.Schema, path []string) {
	if node.Kind != yaml.ScalarNode {
		log.Errorf("!!ref can't be converted to `$ref`: %s not a scalar node", strings.Join(path, "/"))
		return
	}

	if len(tokens) == 1 {
		schema.Ref = "#/$defs/" + node.Value
		return
	}

	_, exists := externalReferences[string(tokens[1])]
	if !exists {
		log.Errorf("!!ref can't be converted to `$ref`: %s unknown external reference '%s'", strings.Join(path, "/"), tokens[1])
		return
	}
	schema.Ref = fmt.Sprintf("{{ .%s }}#/$defs/%s", strcase.UpperCamelCase(string(tokens[1]))+"ReferenceURL", node.Value)
}

func toJsonSchemaEnum(node *yaml.Node, schema *jsonschema.Schema, path []string) {
	if node.Kind != yaml.SequenceNode {
		log.Errorf("!!enum can't be converted to `enum`: %s not a sequence node", strings.Join(path, "/"))
		return
	}

	schema.Type = "string"
	for _, n := range node.Content {
		schema.Enum = append(schema.Enum, n.Value)
		// NOTE: using a tag (`!!enum`) in a sequence node moves the inline comments to the first item.
		schema.Description = schemaDescription(schema.Description, n.HeadComment, n.LineComment, n.FootComment)
	}
}
func toJsonSchemaArray(tokens []Token, node *yaml.Node, schema *jsonschema.Schema, path []string) {
	if node.Kind != yaml.ScalarNode && node.Kind != yaml.MappingNode {
		log.Errorf("!!array can't be converted to `array`: %s not a scalar or mapping node", strings.Join(path, "/"))
	}

	schema.Type = "array"
	schema.Items = &jsonschema.Schema{}
	if len(tokens) >= 2 {
		toTokenizedJsonSchema(tokens[1:], node, schema.Items, path)
	} else if node.Kind == yaml.MappingNode {
		toTokenizedJsonSchema([]Token{ObjectToken}, node, schema.Items, path)
	} else {
		log.Errorf("!!array can't be converted to `array`: %s is not a map or didn't defined item type (array_of_<type>)", strings.Join(path, "/"))
	}
}
func toDictionarySchema(tokens []Token, node *yaml.Node, schema *jsonschema.Schema, path []string) {
	if node.Kind != yaml.ScalarNode && node.Kind != yaml.MappingNode {
		log.Errorf("!!dict can't be converted to `object` with additionalProperties: %s not a scalar or mapping node", strings.Join(path, "/"))
	}

	schema.Type = "object"

	schema.AdditionalProperties = &jsonschema.Schema{}
	if len(tokens) >= 2 {
		toTokenizedJsonSchema(tokens[1:], node, schema.AdditionalProperties, path)
	} else if node.Kind == yaml.MappingNode {
		toTokenizedJsonSchema([]Token{ObjectToken}, node, schema.AdditionalProperties, path)
	} else {
		log.Errorf("!!dict can't be converted to `object` with additionalProperties: %s is not a map or didn't defined item type (dict_of_<type>)", strings.Join(path, "/"))
	}
}
func toDefinitionSchema(node *yaml.Node, schema *jsonschema.Schema, path []string) {
	if node.Kind != yaml.MappingNode {
		log.Errorf("!!defs can't be converted to `object` with definitions: %s not a mapping node", strings.Join(path, "/"))
	}

	definitions := jsonschema.Definitions{}
	for i := 0; i+1 < len(node.Content); i += 2 {
		if node.Content[i+1].Tag == string("!!"+JsonschemaToken) {
			applyJsonSchemaTags(node.Content[i+1], schema, append(path, node.Content[i].Value))
			continue
		}
		definition := ToJsonSchema(node.Content[i+1], append(path, node.Content[i].Value)...)
		definition.Description = schemaDescription(node.HeadComment, node.LineComment, node.FootComment, definition.Description)
		definitions[node.Content[i].Value] = definition
	}

	if len(definitions) > 0 {
		schema.Type = "object"
		schema.Definitions = definitions
	}
}

func toObjectSchema(node *yaml.Node, schema *jsonschema.Schema, path []string) {
	if node.Kind != yaml.MappingNode {
		log.Errorf("!!obj can't be converted to `object`: %s not a mapping node", strings.Join(path, "/"))
		return
	}

	properties := orderedmap.New[string, *jsonschema.Schema]()
	for i := 0; i+1 < len(node.Content); i += 2 {
		if node.Content[i+1].Tag == string("!!"+JsonschemaToken) {
			applyJsonSchemaTags(node.Content[i+1], schema, append(path, node.Content[i].Value))
			continue
		}
		property := ToJsonSchema(node.Content[i+1], append(path, node.Content[i].Value)...)
		property.Description = schemaDescription(node.Content[i].HeadComment, node.Content[i].LineComment, node.Content[i].FootComment, property.Description)
		properties.Set(node.Content[i].Value, property)
	}

	if properties.Len() > 0 {
		schema.Type = "object"
		schema.Properties = properties
	}
}

func applyJsonSchemaTags(node *yaml.Node, target *jsonschema.Schema, path []string) {
	var obj interface{}

	raw, _ := yaml.Marshal(node)
	err := yaml.Unmarshal(raw, &obj)
	if err != nil {
		log.Errorf("!!jsonschema can't be converted to json schema: %s %s", strings.Join(path, "/"), err)
		return
	}

	raw, err = json.Marshal(obj)
	if err != nil {
		log.Errorf("!!jsonschema can't be converted to json schema: %s %s", strings.Join(path, "/"), err)
		return
	}

	err = target.UnmarshalJSON(raw)
	if err != nil {
		log.Errorf("!!jsonschema can't be converted to json schema: %s %s", strings.Join(path, "/"), err)
		return
	}
}
