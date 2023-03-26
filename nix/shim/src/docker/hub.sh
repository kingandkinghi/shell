nix::docker::hub::login() {
    docker login \
        --username "${NIX_DOCKERHUB_USER}" \
        --password-stdin \
        <<< "${NIX_DOCKERHUB_PASSWORD}"
}

nix::docker::hub::publish() {
    nix::docker::hub::login
    docker push "${NIX_DOCKER_CHROOT_FULLNAME}"
}
