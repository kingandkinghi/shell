alias fd-docker-reload=". $(readlink -f ${BASH_SOURCE})"
alias fd-docker-build="nix::docker::main"
alias fd-docker-package="nix::docker::buildx::tar"
alias fd-docker-buildx="nix::docker::buildx::build"
alias fd-docker-hub-login="nix::docker::hub::login"
alias fd-docker-hub-publish="nix::docker::hub::publish"

nix::docker::main() {
    nix::docker::buildx::tar
    nix::docker::buildx::build
    nix::docker::hub::login
    nix::docker::hub::publish
}
