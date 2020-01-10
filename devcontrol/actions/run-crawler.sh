#!/bin/bash

set -euo pipefail

# @description Run crawler
#
# @example
#   run-crawler
#
# @arg $1 Task: "brief", "help" or "exec"
#
# @exitcode The result of the crawler run
#
# @stdout "Not implemented" message if the requested task is not implemented
#
function run-crawler() {

    # Init
    local briefMessage
    local helpMessage

    briefMessage="Execute cypress crawler"
    helpMessage=$(cat <<EOF
Execute the crawler over the URL listed in the "cypress/fixtures/example.json" file.
After that, find the related screenshots and videos under the "results" directory
EOF
)

    # Task choosing
    case $1 in
        brief)
            showBriefMessage "${FUNCNAME[0]}" "$briefMessage"
            ;;
        help)
            showHelpMessage "${FUNCNAME[0]}" "$helpMessage"
            ;;
        exec)
            mkdir -p results
            ctid=$(docker run --rm -d teecke/docker-cypress-crawler tail -f /dev/null)
            docker cp cypress/fixtures "${ctid}:/workspace/cypress"
            docker exec "${ctid}" npm run cypress:run
            docker cp "${ctid}:/workspace/cypress/screenshots" results
            docker cp "${ctid}:/workspace/cypress/videos"      results
            docker rm -f "${ctid}"
            ;;
        *)
            showNotImplemtedMessage "$1" "${FUNCNAME[0]}"
            return 1
    esac
}

# Main
run-crawler "$@"

