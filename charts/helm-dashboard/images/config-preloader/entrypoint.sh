#!/usr/bin/env sh
#  Copyright (c) 2023
#
#  Permission is hereby granted, free of charge, to any person
#  obtaining a copy of this software and associated documentation
#  files (the "Software"), to deal in the Software without
#  restriction, including without limitation the rights to use,
#  copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the
#  Software is furnished to do so, subject to the following
#  conditions:
#
#  The above copyright notice and this permission notice shall be
#  included in all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
#  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
#  OTHER DEALINGS IN THE SOFTWARE.

# This entrypoint use an exist Helm configuration containing
# default Helm repositories and merge it to an existing one.

[ -z "${1}" ] && (echo "usage: $0 <DEFAULT_REPOSITORY_FILE>"; exit 1)
# shellcheck disable=SC2016
[ -f "${HELM_CONFIG_HOME}/repositories.yaml" ] \
  && yq eval-all '. as $doc ireduce ([]; . + $doc.repositories) | {"apiVersion": "", "generated": now, "repositories": (group_by(.name) | map(.[0]))}' "$1" "${HELM_CONFIG_HOME}/repositories.yaml" \
  || echo cp "$1" "${HELM_CONFIG_HOME}/repositories.yaml"
