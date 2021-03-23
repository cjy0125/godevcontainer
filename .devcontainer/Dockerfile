# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.163.1/containers/alpine/.devcontainer/base.Dockerfile
# Make sure the linux distribution of base image is alpine
FROM godevcontainer:latest

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apk update && ash /tmp/library-scripts/common-alpine.sh "true" "vscode" "1000" ""     && rm -rf /tmp/library-scripts

