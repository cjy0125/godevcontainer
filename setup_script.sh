#!/bin/bash
IMAGE="godevcontainer"
IMAGE_VERSION="latest"
USERNAME="vscode"
USER_UID="1000"
USER_GID=""
INSTALL_ZSH=true
LINUX_DISTRIBUTE=$1

if [[ "$LINUX_DISTRIBUTE" == "" ]]; then
echo "Require one argument: alpine|ubuntu"
exit
fi

mkdir .devcontainer
pushd .devcontainer
git clone --no-checkout --depth 1 git://github.com/microsoft/vscode-dev-containers
pushd vscode-dev-containers
git checkout HEAD script-library
popd
mv vscode-dev-containers/script-library ./library-scripts
rm -rf vscode-dev-containers

# create .devcontainer.json
cat >devcontainer.json <<EOL
// For format details, see https://aka.ms/devcontainer.json. For config options, see the README at:
// https://github.com/microsoft/vscode-dev-containers/tree/v0.163.1/containers/alpine
{
	"name": "${IMAGE}-${IMAGE_VERSION}",
	"build": {
		"dockerfile": "Dockerfile",
		//"args": { "VARIANT": "3.11" }
	},
	
	// Set *default* container specific settings.json values on container create. 
	"settings": {
		"terminal.integrated.shell.linux": "/bin/zsh"
	},

	// Add the IDs of extensions you want installed when the container is created.
	// Note that some extensions may not work in Alpine Linux. See https://aka.ms/vscode-remote/linux.
	"extensions": [],

	// Use 'forwardPorts' to make a list of ports inside the container available locally.
	// "forwardPorts": [],

	// Uncomment when using a ptrace-based debugger like C++, Go, and Rust
	// "runArgs": [ "--cap-add=SYS_PTRACE", "--security-opt", "seccomp=unconfined" ],
	//"runArgs": ["--net=devcontainer"]
}
EOL

# create Dockerfile for devcontainer
cat >Dockerfile <<EOL
# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.163.1/containers/${LINUX_DISTRIBUTE}/.devcontainer/base.Dockerfile
# Make sure the linux distribution of base image is ${LINUX_DISTRIBUTE}
FROM ${IMAGE}:${IMAGE_VERSION}

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
EOL
if [[ "$LINUX_DISTRIBUTE" == "alpine" ]]; then
cat >>Dockerfile <<EOL
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apk update && ash /tmp/library-scripts/common-alpine.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" \
    && rm -rf /tmp/library-scripts

EOL
elif [[ "$LINUX_DISTRIBUTE" == "ubuntu" ]]; then
cat >>Dockerfile <<EOL
COPY library-scripts/*.sh /tmp/library-scripts/
RUN yes | unminimize 2>&1 \ 
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts
EOL
fi

popd

# build project image as base development image
docker build -t ${IMAGE}:${IMAGE_VERSION} .

echo "Ready to open project with VScode remote container"