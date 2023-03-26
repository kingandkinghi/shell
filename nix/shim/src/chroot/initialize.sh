nix::chroot::initialize::loopback::test() {
    : "${NIX_CHROOT_DIR?}"
    
    if nix::chroot::initialize::loopback::test; then
        return
    fi

    cat "${NIX_CHROOT_ETC_HOSTS}" \
        | grep "${HOSTNAME}" \
        >/dev/null 2>&1
}

nix::chroot::initialize::loopback() {
    : "${NIX_CHROOT_DIR?}"
    
    # fix: sudo: unable to resolve host codespaces-02adf7: Name or service not known
    # loopback networking chroot setup
    echo "127.0.0.1 ${HOSTNAME}" \
        | sudo tee -a "${NIX_CHROOT_ETC_HOSTS}" \
        >/dev/null
}

nix::chroot::initialize::locale() {
    : "${NIX_CHROOT_DIR?}"
    
    nix::chroot::eval locale-gen "${NIX_CHROOT_ETC_LOCALE}" > /dev/null
    nix::chroot::eval update-locale LANG="${NIX_CHROOT_ETC_LOCALE}" > /dev/null
}

nix::chroot::initialize::nix() (
    : "${NIX_CHROOT_DIR?}"
    
    # export NIX variables into chroot
    nix::shim::export::emit \
        | sudo tee "${NIX_CHROOT_ETC_PROFILE_NIX}" \
        >/dev/null
)

nix::chroot::initialize::bash_login() {
    : "${NIX_CHROOT_DIR?}"
    
    # default bash_login sources the loader
    cat <<-EOF | sudo tee "${NIX_CHROOT_ETC_SKEL_BASH_LOGIN}" > /dev/null
		. "\${HOME}/.profile"
		. "\${NIX_LOADER}"
		EOF
}
