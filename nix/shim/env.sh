readonly NIX_CHROOT_DIR="${HOME}/chroot"    
readonly NIX_CHROOT_ROOT_DIR="${NIX_CHROOT_DIR}${NIX_ROOT_DIR}/"
readonly NIX_CHROOT_ETC_HOSTS="${NIX_CHROOT_DIR}/etc/hosts"
readonly NIX_CHROOT_ETC_PROFILE_NIX="${NIX_CHROOT_DIR}/etc/profile.d/nix.sh"
readonly NIX_CHROOT_ETC_SKEL_BASH_LOGIN="${NIX_CHROOT_DIR}/etc/skel/.bash_login"
readonly NIX_CHROOT_ETC_SUDOERS_DIR="${NIX_CHROOT_DIR}/etc/sudoers.d"
readonly NIX_CHROOT_ETC_LOCALE="en_US.UTF-8"

# https://hub.docker.com/repositories/kingandkingesq
# https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/docker-in-docker.md
# https://superuser.com/questions/1401919/cannot-start-docker-when-using-chroot

readonly NIX_DOCKERHUB_USER='kingandkingesq'
readonly NIX_DOCKERHUB_PASSWORD="${NIX_CODESPACE_SECRET_DOCKERHUB_PASSWORD}"
readonly NIX_DOCKER_BUILDX_INSTANCE=insecure-builder
readonly NIX_DOCKER_REPO_NAME='shell'
readonly NIX_DOCKER_USER='vscode'
readonly NIX_DOCKER_PREBUILD_VARIANT='jammy'
readonly NIX_DOCKER_PREBUILD_IMAGE='mcr.microsoft.com/vscode/devcontainers/base:0'
readonly NIX_DOCKER_PREBUILD_TOOLS='debootstrap'
readonly NIX_DOCKER_CHROOT_SUITE='focal'
readonly NIX_DOCKER_CHROOT_TAG='devcontainer'
readonly NIX_DOCKER_CHROOT_VERSION='v0.0.2'
readonly NIX_DOCKER_CHROOT_FULLNAME="${NIX_DOCKERHUB_USER}/${NIX_DOCKER_CHROOT_TAG}:${NIX_DOCKER_CHROOT_VERSION}"
