#!/bin/bash
export GITHUB_RELEASE_TAG=$(date +%b-%y)
JSON_DATA="{\"tag_name\": \"$GITHUB_RELEASE_TAG\",\"target_commitish\": \"master\",\"name\": \"$GITHUB_RELEASE_TAG\",\"body\": \"Build as of $GITHUB_RELEASE_TAG\",\"draft\": true, \"prerelease\": false}"
echo "Pushing:"
echo $JSON_DATA;
echo "To:"
CREATE_RELEASE_URL=https://api.github.com/repos/headmelted/prebootstrap/releases?access_token=$(GITHUB_PAT)
github_response=$(curl -H "Content-Type: application/json" --data "$JSON_DATA" $CREATE_RELEASE_URL)
GITHUB_RELEASE_ID=$(echo $github_response | jq -r ".id")
assets_url_template=$(echo $github_response | jq -r ".upload_url")
GITHUB_ASSETS_URL=${assets_url_template%"{?name,label}"}
echo "Release ID: $GITHUB_RELEASE_ID"
echo "Retrieved assets URL for later: $GITHUB_ASSETS_URL"
echo "Listing assets to upload:"
ls $(Build.ArtifactStagingDirectory)
for filename in $(Build.ArtifactStagingDirectory)/*.tar.gz
do
  echo "Uploading [$filename] to Github release [$GITHUB_RELEASE_ID]";
  curl -H "Content-Type: application/gzip" -F "$filename" $GITHUB_ASSETS_URL
done
JSON_DATA="{\"tag_name\": \"$GITHUB_RELEASE_TAG\",\"target_commitish\": \"master\",\"name\": \"$GITHUB_RELEASE_TAG\",\"body\": \"Build as of $GITHUB_RELEASE_TAG\",\"draft\": false, \"prerelease\": false}"
echo "Pushing:"
echo $JSON_DATA;
echo "To:"
CREATE_RELEASE_URL=https://api.github.com/repos/headmelted/prebootstrap/releases/$GITHUB_RELEASE_ID?access_token=$(GITHUB_PAT)
curl -H "Content-Type: application/json" --data "$JSON_DATA" $CREATE_RELEASE_URL
