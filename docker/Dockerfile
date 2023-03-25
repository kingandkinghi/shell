# syntax=docker/dockerfile:1.3-labs

ARG VARIANT
ARG IMAGE
FROM "${IMAGE}-${VARIANT}"

ARG TOOLS
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends ${TOOLS}

ARG USER
USER "${USER}"

ARG TARBALL
ARG REPO_NAME
ADD "${TARBALL}" /workspaces/${REPO_NAME}/
RUN --security=insecure \
    GITHUB_USER=fidalgotesting \
        bash -c ". /workspaces/${REPO_NAME}/prebuild.sh"
RUN sudo rm -f -r /workspaces/
