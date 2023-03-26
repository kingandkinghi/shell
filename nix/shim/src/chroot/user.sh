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
