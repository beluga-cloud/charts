package main

import (
	"encoding/json"
	"fmt"
	"github.com/invopop/jsonschema"
	"github.com/urfave/cli/v2"
	"go.uber.org/zap"
	"io"
	"os"
	"strings"
)

var log = zap.Must(zap.NewDevelopment()).Sugar()

func main() {
	handleErr := func(err error) {
		if err != nil {
			log.Fatal(err)
		}
	}

	app := &cli.App{
		Name:  "normalize",
		Usage: "Normalize a JSON schema",
		Action: func(cCtx *cli.Context) error {
			raw, err := io.ReadAll(os.Stdin)
			handleErr(err)

			var obj map[string]interface{}
			err = json.Unmarshal(raw, &obj)
			handleErr(err)

			definition2def(obj, "properties", "")
			raw, err = json.Marshal(obj)
			handleErr(err)

			schema := &jsonschema.Schema{}
			err = schema.UnmarshalJSON(raw)
			handleErr(err)

			schema.Version = "http://json-schema.org/draft-07/schema#"
			raw, err = schema.MarshalJSON()
			handleErr(err)

			fmt.Println(string(raw))
			return nil
		},
	}

	err := app.Run(os.Args)
	handleErr(err)
}

// Convert all definitions to $defs (draft-07)
func definition2def(obj map[string]interface{}, parentKey, currentKey string) {
	// if parent node is a `properties` field and current node is not a `properties` field, this object is
	// certainly an object.
	if _, exists := obj["definitions"]; parentKey == "properties" && currentKey != "properties" && exists {
		obj["$defs"] = obj["definitions"]
		delete(obj, "definitions")
	}

	for key, value := range obj {
		switch o := value.(type) {
		case map[string]interface{}:
			definition2def(o, currentKey, key)
		case []interface{}:
			for _, v := range o {
				if m, ok := v.(map[string]interface{}); ok {
					definition2def(m, currentKey, key)
				}
			}
		case string:
			// fix all $ref fields with the new $defs
			if key == "$ref" {
				obj[key] = strings.ReplaceAll(o, "/definitions/", "/$defs/")
			}
		}
	}
}
