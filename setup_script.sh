#!/bin/bash

mkdir .devcontainer
pushd .devcontainer
git clone --no-checkout --depth 1 git://github.com/microsoft/vscode-dev-containers
pushd vscode-dev-containers
git checkout HEAD script-library
popd
mv vscode-dev-containers/script-library ./library-scripts
rm -rf vscode-dev-containers
docker build -t godevcontainer:latest .
