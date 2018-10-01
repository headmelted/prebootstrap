#!/bin/bash#!/bin/bash
sudo apt-get install -y jq;
export GITHUB_RELEASE_TAG=$(date +%b-%y);
JSON_DATA="{\"tag_name\": \"$GITHUB_RELEASE_TAG\",\"target_commitish\": \"master\",\"name\": \"$GITHUB_RELEASE_TAG\",\"body\": \"Build as of $GITHUB_RELEASE_TAG\",\"draft\": true, \"prerelease\": false}";
echo "Pushing:";
echo $JSON_DATA;
echo "To:";
CREATE_RELEASE_URL="https://api.github.com/repos/headmelted/prebootstrap/releases";
github_response=$(curl --request POST -H "Content-Type: application/json" -H "Authorization: token $GITHUB_PAT" --data "$JSON_DATA" $CREATE_RELEASE_URL);
GITHUB_RELEASE_ID=$(echo $github_response | jq -r ".id");
assets_url_template=$(echo $github_response | jq -r ".upload_url");
GITHUB_ASSETS_URL=${assets_url_template%"{?name,label}"};
echo "Release ID: $GITHUB_RELEASE_ID";
echo "Retrieved assets URL for later: $GITHUB_ASSETS_URL";
drop_folder="$SYSTEM_ARTIFACTSDIRECTORY/_headmelted.prebootstrap/drop";
echo "Listing assets to upload:";
ls $drop_folder;
for filename in $drop_folder/*.tar.gz
do
  echo "Uploading [$filename] to Github release [$GITHUB_RELEASE_ID]";
  curl --request POST --data-binary "@$filename" -H "Authorization: token $GITHUB_PAT" -H "Content-Type: application/octet-stream" $GITHUB_ASSETS_URL?name=$(basename $filename);
done
JSON_DATA="{\"tag_name\": \"$GITHUB_RELEASE_TAG\",\"target_commitish\": \"master\",\"name\": \"$GITHUB_RELEASE_TAG\",\"body\": \"Build as of $GITHUB_RELEASE_TAG\",\"draft\": false, \"prerelease\": false}";
echo "Pushing:";
echo $JSON_DATA;
echo "To:";
EDIT_RELEASE_URL="https://api.github.com/repos/headmelted/prebootstrap/releases/$GITHUB_RELEASE_ID";
curl --request PATCH -H "Authorization: token $GITHUB_PAT" -H "Content-Type: application/json" --data "$JSON_DATA" "$EDIT_RELEASE_URL";
