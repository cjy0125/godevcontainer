# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.163.1/containers/alpine/.devcontainer/base.Dockerfile

# [Choice] Alpine version: 3.13, 3.12, 3.11, 3.10
ARG VARIANT=3.11
#FROM alpine:${VARIANT}
FROM godevcontainer:latest

# [Option] Install zsh
ARG INSTALL_ZSH="true"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apk update && ash /tmp/library-scripts/common-alpine.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" \
    && rm -rf /tmp/library-scripts
