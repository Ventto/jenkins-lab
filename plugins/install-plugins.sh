#!/bin/sh

# The MIT License (MIT)
#
# Copyright (c) 2018-2019 Thomas "Ventto" Venriès <thomas.venries@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
set -e

check_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "${1}: command does not exist"
        exit 2
    fi
}

usage() {
    echo "Usage: ./install-plugins.sh JENKINS_URL"; exit 2
}

main() {
    check_command 'python'
    check_command 'curl'

    [ "$#" -ne 1 ] && usage

    _url="$1"; shift

    printf "Username: "; read -r _username
    printf "Password: ";
    # Read secret string
    stty -echo; trap 'stty echo' EXIT; read -r _pwd; stty echo; trap - EXIT; echo

    printf '\nInstalling plugins...\n\n'

    # Get a CSRF token
    # See also https://wiki.jenkins.io/display/JENKINS/Jenkins+Script+Console
    token=$(curl --user "${_username}:${_pwd}" \
                   -s "${_url}/crumbIssuer/api/json" \
                | python -c 'import sys,json;j=json.load(sys.stdin);print(j["crumbRequestField"] + "=" + j["crumb"])')

    script=$(cat ./plugins.groovy)

    # Run the `plugins.groovy` script remotely
    curl --user "${_username}:${_pwd}" \
         -d "$token" --data-urlencode "script=${script}" "${_url}/scriptText"
}

main "$@"
