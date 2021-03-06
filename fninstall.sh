#!/bin/sh
set -e

# Install script to install fn

version=`curl --silent https://api.github.com/repos/fnproject/cli/releases/latest  | grep tag_name | cut -f 2 -d : | cut -f 2 -d '"'`

command_exists() {
  command -v "$@" > /dev/null 2>&1
}

case "$(uname -m)" in
  *64)
    ;;
  *)
    echo >&2 'Error: you are not using a 64bit platform.'
    echo >&2 'Functions CLI currently only supports 64bit platforms.'
    exit 1
    ;;
esac

user="$(id -un 2>/dev/null || true)"

sh_c='sh -c'

curl=''
if command_exists curl; then
  curl='curl -sSL -o'
elif command_exists wget; then
  curl='wget -qO'
elif command_exists busybox && busybox --list-modules | grep -q wget; then
  curl='busybox wget -qO'
else
    echo >&2 'Error: this installer needs the ability to run wget or curl.'
    echo >&2 'We are unable to find either "wget" or "curl" available to make this happen.'
    exit 1
fi

url='https://github.com/fnproject/cli/releases/download'

# perform some very rudimentary platform detection
case "$(uname)" in
  Linux)
    $sh_c "$curl /tmp/fn_linux $url/$version/fn_linux"
    $sh_c "mv /tmp/fn_linux ./fn"
    $sh_c "chmod +x ./fn"
    #./fn --version
    ;;
  *)
    cat >&2 <<'EOF'

  Either your platform is not easily detectable or is not supported by this
  installer script (yet - PRs welcome! [fn/install]).
  Please visit the following URL for more detailed installation instructions:

    https://github.com/fnproject/fn

EOF
    exit 1
esac

cat >&2 <<'EOF'

        ______
       / ____/___
      / /_  / __ \
     / __/ / / / /
    /_/   /_/ /_/`

EOF
exit 0
