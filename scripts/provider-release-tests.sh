#!/bin/bash

# Trigger the cicd-playground-downstream release tests in CI.

# Variables:
# ACCESS_TOKEN: a GitHub Personal Access Token with repo and workflow permissions. Required.
# LIBOQS_REF: the cicd-playground-upstream branch or tag on which to run. Defaults to "main" if not specified.
# PROVIDER_REF: the cicd-playground-downstream branch or tag on which to run. Defaults to "main" if not specified.
# CURL_FLAGS: additional flags (e.g., "--silent") to pass to the curl command

if [ -z $ACCESS_TOKEN ]; then
    echo "This script requires a GitHub Personal Access Token with repo and workflow permissions."
    exit 1
fi

# default to running on cicd-playground-upstream main / provider main
if [ -z $LIBOQS_REF ]; then
    export LIBOQS_REF="main"
fi
if [ -z $PROVIDER_REF ]; then
    export PROVIDER_REF="main"
fi

curl $CURL_FLAGS \
    --request POST \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: Bearer $ACCESS_TOKEN" \
    --header "X-GitHub-Api-Version: 2022-11-28" \
    --data "{
              \"event_type\": \"cicd-playground-upstream-release\",
              \"client_payload\": {
                                  \"cicd-playground-upstream_ref\": \"$LIBOQS_REF\",
                                  \"provider_ref\": \"$PROVIDER_REF\"
              }
            }" \
    https://api.github.com/repos/swilson4/cicd-playground-downstream/dispatches
