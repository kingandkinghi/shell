(
    declare -rx NIX_EXIT_REMAIN=101
    declare -rx NIX_REPO_DIR="$(cd "$(dirname ${BASH_SOURCE})"; pwd)"
    declare -rx NIX_HOST_ROOT_DIR="$(dirname ${NIX_REPO_DIR})"
    declare -rx NIX_ROOT_DIR="/workspaces"
    declare -rx NIX_DIR="${NIX_REPO_DIR}/nix"
    declare -rx NIX_DIR_NIX_USR="${NIX_DIR}/usr"
    declare -rx NIX_DIR_NIX_SRC="${NIX_DIR}/src"
    declare -rx NIX_DIR_NIX_SHIM="${NIX_DIR}/shim"
    declare -rx NIX_DIR_NIX_SHIM_SRC="${NIX_DIR_NIX_SHIM}/src"
    declare -rx NIX_LOADER="${NIX_DIR}/loader.sh"

    if [[ "$@" ]]; then
        . "${NIX_DIR_NIX_SHIM}/loader.sh" "$@"
        return $?
    fi

    bash --rcfile "${NIX_DIR_NIX_SHIM}/loader.sh"
)