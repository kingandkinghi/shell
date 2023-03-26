nix::chroot::mount::list() {
    mount -l | grep chroot
}

nix::chroot::mount::test() {
    nix::chroot::mount::list \
        >/dev/null 2>&1
}

nix::chroot::mount() {
    : "${NIX_CHROOT_DIR?}"
    
    sudo mkdir -p "${NIX_CHROOT_ROOT_DIR}"
    sudo mount --bind "${NIX_HOST_ROOT_DIR}/" "${NIX_CHROOT_ROOT_DIR}/"
    sudo mount --bind "/proc/" "${NIX_CHROOT_DIR}/proc/"
    sudo mount --bind "/dev/pts" "${NIX_CHROOT_DIR}/dev/pts"
}

nix::chroot::umount() {
    : "${NIX_CHROOT_DIR?}"
    
    if ! nix::chroot::mount::test; then
        return
    fi
    
    sudo umount "${NIX_CHROOT_ROOT_DIR}/"
    sudo umount "${NIX_CHROOT_DIR}/proc/"
    sudo umount "${NIX_CHROOT_DIR}/dev/pts/"

    nix::chroot::mount::test
}
