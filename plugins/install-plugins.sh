#!/bin/sh

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
