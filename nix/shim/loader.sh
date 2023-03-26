nix::shim::loader() {
    . "${NIX_DIR_NIX_SHIM}/env.sh"
    . "${NIX_DIR}/env.sh"
    
    # source *.sh files
    while read; do source "${REPLY}"; done \
        < <(find "${NIX_DIR_NIX_SHIM_SRC}" -type f -name "*.sh")

    while read; do source "${REPLY}"; done \
        < <(find "${NIX_DIR_NIX_SRC}" -type f -name "*.sh")

    if [[ "${GITHUB_USER}" == "${NIX_USR_PREBUILD}" ]]; then
        return
    fi

    nix::shim::main "$@"

    local EXIT_CODE=$?
    if (( EXIT_CODE == NIX_EXIT_REMAIN )); then
        return
    fi

    exit "${EXIT_CODE}"
}

nix::shim::loader "$@"
