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

nix::chroot::initialize() {
    : "${NIX_CHROOT_DIR?}"
    
    local UNPACKED="$1"
    shift

    if ! nix::chroot::test; then
        # clone unpacked deboostrap
        (
            nix::log::subproc::begin 'nix: shim: chroot: cloning'
            sudo cp -pr "${UNPACKED}" "${NIX_CHROOT_DIR}"
        )
    fi

    # initialize chroot
    (
        nix::log::subproc::begin 'nix: shim: chroot: initializing locale'
        nix::chroot::initialize::locale
    )
    (
        nix::log::subproc::begin 'nix: shim: chroot: exporting environment'
        nix::chroot::initialize::nix
    )
    (
        nix::log::subproc::begin 'nix: shim: chroot: update user skeleton'
        nix::chroot::initialize::bash_login
    )

    # computer name changes so we cannot burn this initialization into the image
    (
        nix::log::subproc::begin 'nix: shim: chroot: update loopback'
        nix::chroot::initialize::loopback
    )
}

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

nix::chroot::user::test() {
    local ALIAS="$1"
    shift

    nix::chroot::eval id "$ALIAS" >/dev/null 2>&1
}

nix::chroot::user::add() {
    : "${NIX_CHROOT_DIR?}"
    
    local ALIAS="$1"
    shift

    if nix::chroot::user::test "${NIX_CHROOT_DIR}" "${ALIAS}"; then
        return
    fi

    # create user
    nix::chroot::eval adduser --disabled-password --gecos "" "${ALIAS}"

    # password-less sudo
    echo "${ALIAS} ALL=(root) NOPASSWD:ALL" \
        | sudo tee "${NIX_CHROOT_ETC_SUDOERS_DIR}/${ALIAS}" >/dev/null
    sudo chmod 0440 "${NIX_CHROOT_ETC_SUDOERS_DIR}/${ALIAS}"

    # sudo userdel -R "${NIX_CHROOT_DIR}" -r chrkin >/dev/null 2>&1
    # sudo useradd --create-home -R "${NIX_CHROOT_DIR}" "${ALIAS}"
}

nix::chroot::remove() {
    : "${NIX_CHROOT_DIR?}"

    if ! nix::chroot::umount; then
        return
    fi

    sudo rm -r -f "${NIX_CHROOT_DIR}"
}
