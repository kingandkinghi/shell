nix::docker::buildx::instance::create() {
    if nix::docker::buildx::instance::test; then
        return
    fi

    docker buildx create \
        --driver-opt image=moby/buildkit:master \
        --use \
        --name "${NIX_DOCKER_BUILDX_INSTANCE}" \
        --buildkitd-flags "--allow-insecure-entitlement security.insecure"

}

nix::docker::buildx::instance::test() {
    docker buildx ls \
        | grep "${NIX_DOCKER_BUILDX_INSTANCE}" \
        >/dev/null 2>/dev/null
}

nix::docker::buildx::instance::remove() {
    docker buildx rm "${NIX_DOCKER_BUILDX_INSTANCE}"
}

nix::docker::buildx::tar() {
    local TARBALL="${NIX_DOCKER_REPO_NAME}.tar.gz"

    if [[ -f "${TARBALL}" ]]; then
        sudo rm "${TARBALL}"
    fi

    tar \
        -C "/workspaces/${NIX_DOCKER_REPO_NAME}/" \
        -cf "/tmp/${TARBALL}" \
        . \
        >/dev/null 

    cp "/tmp/${TARBALL}" .
}

nix::docker::buildx::build() {
    local TARBALL="${NIX_DOCKER_REPO_NAME}.tar.gz"

    nix::docker::buildx::instance::create

    docker buildx use "${NIX_DOCKER_BUILDX_INSTANCE}"

    if [[ ! -f "${TARBALL}" ]]; then
        nix::docker::buildx::tar
    fi

    docker buildx build --allow security.insecure . \
        --progress=plain \
        --build-arg REPO_NAME="${NIX_DOCKER_REPO_NAME}" \
        --build-arg VARIANT="${NIX_DOCKER_PREBUILD_VARIANT}" \
        --build-arg IMAGE="${NIX_DOCKER_PREBUILD_IMAGE}" \
        --build-arg TOOLS="${NIX_DOCKER_PREBUILD_TOOLS}" \
        --build-arg USER="${NIX_DOCKER_USER}" \
        --build-arg TARBALL="${TARBALL}" \
        --tag "${NIX_DOCKER_CHROOT_FULLNAME}" \
        --output "type=docker" \
        --file "${NIX_DIR_NIX_SHIM_SRC_DOCKER}/Dockerfile"
}
