get_platform() {
  platform=$(uname -s)
  case "${platform}" in
    Linux*)  os=linux;;
    Darwin*) os=macos;;
    *)       os=unknow
  esac
  command printf ${os}
}
