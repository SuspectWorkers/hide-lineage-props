#!/system/bin/sh
# Runs before zygote starts.
MODDIR=${0%/*}
. "$MODDIR/common.sh"
clean_props
