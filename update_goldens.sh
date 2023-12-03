flutter_version=3.16.2

project_dir=$(git rev-parse --show-toplevel)

flutter_dir=$(which flutter | rev | cut -c12- | rev)

flutter_cache=~/.pub-cache/hosted/pub.dev/

docker run --rm -ti -v $project_dir:/project -v $flutter_dir:$flutter_dir -v $flutter_cache:$flutter_cache -e PACKAGE_PATH="/project/" docker_tests /bin/sh -c "/project/docker/docker_test.sh --update-goldens"