#!/bin/bash

echo "Installing jq";
sudo apt-get install -y jq;

github_release_tag=$(date +%b-%y);
echo "Setting github_release_tag to $github_release_tag";

echo "Creating draft release at Github"
json_create_release="{\"tag_name\": \"$github_release_tag\",\"target_commitish\": \"master\",\"name\": \"$github_release_tag\",\"body\": \"Build as of $github_release_tag\",\"draft\": true, \"prerelease\": false}";
create_release_url="https://api.github.com/repos/headmelted/prebootstrap/releases";
github_response=$(curl --request POST -H "Content-Type: application/json" -H "Authorization: token $GITHUB_PAT" --data "$json_create_release" $create_release_url);

echo "Parsing Github response"
github_release_id=$(echo $github_response | jq -r ".id");
github_assets_url_template=$(echo $github_response | jq -r ".upload_url");
github_assets_url=${github_assets_url_template%"{?name,label}"};
echo "Release ID: $github_release_id";
echo "Retrieved assets URL for later: $github_assets_url";

drop_folder="$SYSTEM_ARTIFACTSDIRECTORY/_headmelted.prebootstrap/drop";
echo "Assets to upload:";
ls $drop_folder;
for filename in $drop_folder/*.tar.gz
do
  echo "Uploading [$filename] to Github release [$github_release_id]";
  curl --request POST --data-binary "@$filename" -H "Authorization: token $GITHUB_PAT" -H "Content-Type: application/octet-stream" $github_assets_url?name=$(basename $filename);
done

echo "Marking release as final at Github"
json_edit_release="{\"tag_name\": \"$github_release_tag\",\"target_commitish\": \"master\",\"name\": \"$github_release_tag\",\"body\": \"Build as of $github_release_tag\",\"draft\": false, \"prerelease\": false}";
edit_release_url="https://api.github.com/repos/headmelted/prebootstrap/releases/$github_release_id";
curl --request PATCH -H "Authorization: token $GITHUB_PAT" -H "Content-Type: application/json" --data "$json_edit_release" "$edit_release_url";
