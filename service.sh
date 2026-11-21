#!/system/bin/sh
# Second pass after boot.
MODDIR=${0%/*}
. "$MODDIR/common.sh"
while [ "$(getprop sys.boot_completed)" != "1" ]; do sleep 2; done
clean_props
