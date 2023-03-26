nix::chroot::main() (
    : "${NIX_CHROOT_DIR?}"
    
    local ALIAS="$1"
    shift

    nix::chroot::mount
    trap "nix::chroot::umount" EXIT 

    local CMD=(
        'sudo' 'chroot' "${NIX_CHROOT_DIR}" 'su' '--login' "${ALIAS}"
    )

    # automated
    if (( $# > 0 )); then
        "${CMD[@]}" < <(echo "$@")
        return $?
    fi

    "${CMD[@]}"
)

nix::chroot::test() {
    : "${NIX_CHROOT_DIR?}"
    
    [[ -d "${NIX_CHROOT_DIR}" ]]
}

# declare -g NIX_CHROOT_DIR="${HOME}/chroot"

nix::chroot::remove() (
    : "${NIX_CHROOT_DIR?}"
    
    if ! nix::chroot::test; then
        nix::log::echo "nix: shim: chroot: not found at ${NIX_CHROOT_DIR}."
        return
    fi

    if nix::chroot::mount::test; then
        nix::log::echo "nix: shim: chroot: unable to remove because mounts remain."
        return
    fi

    nix::log::subproc::begin 'nix: shim: chroot: removing'
    nix::chroot::remove
)

nix::chroot::eval() {
    : "${NIX_CHROOT_DIR?}"
    sudo chroot "${NIX_CHROOT_DIR}" "$@"
}

nix::chroot::remove() {
    : "${NIX_CHROOT_DIR?}"

    if ! nix::chroot::umount; then
        return
    fi

    sudo rm -r -f "${NIX_CHROOT_DIR}"
}
