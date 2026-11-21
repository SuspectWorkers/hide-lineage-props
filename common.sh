#!/system/bin/sh
# Pure prop & vbmeta sanitizer (all M5-specific tweaks live in m5_system_tweaks).

LOG=/dev/null

log() { :; }

find_resetprop() {
  for p in resetprop \
           /data/adb/ksu/bin/resetprop \
           /data/adb/ap/bin/resetprop \
           /data/adb/magisk/resetprop; do
    if command -v "$p" >/dev/null 2>&1; then
      RP="$p"
      return 0
    fi
  done
  return 1
}

DELETE_PROPS="ro.modversion ro.lineage.version"

clean_value() {
  printf '%s' "$1" | sed \
    -e 's/[Ll][Ii][Nn][Ee][Aa][Gg][Ee][Oo][Ss]_*//g' \
    -e 's/[Ll][Ii][Nn][Ee][Aa][Gg][Ee]_*//g' \
    -e 's/userdebug/user/g' \
    -e 's/dev-keys/release-keys/g' \
    -e 's/test-keys/release-keys/g'
}

clean_props() {
  find_resetprop || { log "resetprop not found, aborting"; return 1; }

  names="$DELETE_PROPS"
  for n in $(getprop | sed -n 's/^\[\([^]]*[Ll][Ii][Nn][Ee][Aa][Gg][Ee][^]]*\)\]: .*$/\1/p'); do
    names="$names $n"
  done
  for n in $names; do
    if [ -n "$(getprop "$n")" ]; then
      "$RP" -n --delete "$n" && log "deleted $n"
    fi
  done

  getprop | sed -n 's/^\[\([^]]*\)\]: \[\(.*\)\]$/\1=\2/p' | while IFS= read -r line; do
    name=${line%%=*}
    value=${line#*=}
    case "$value" in
      *[Ll][Ii][Nn][Ee][Aa][Gg][Ee]*|*dev-keys*|*test-keys*|*userdebug*) ;;
      *) continue ;;
    esac
    new=$(clean_value "$value")
    if [ "$new" != "$value" ]; then
      "$RP" -n "$name" "$new" && log "$name: '$value' -> '$new'"
    fi
  done

  case "$(getprop ro.bootimage.build.version.incremental)" in
    eng.*)
      inc=$(getprop ro.build.version.incremental)
      [ -n "$inc" ] && "$RP" -n ro.bootimage.build.version.incremental "$inc"
      ;;
  esac
}
