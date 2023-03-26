ROOT=$(dirname "${BASH_SOURCE}")

. "${ROOT}/shim.sh" nix::tool::install::all
. "${ROOT}/nix/shim/src/debootstrap.sh"

nix::debootstrap::clean focal
