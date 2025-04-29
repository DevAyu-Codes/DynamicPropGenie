#!/system/bin/sh

MODDIR=${0%/*}
sleep 10

# Source your data file
. "$MODDIR/data.prop"

# Get system values
rom_full=$(getprop ro.product.system.name)
device_code=$(getprop ro.build.product)

# Extract ROM name by removing _<codename> from full string
rom_name=${rom_full%_$device_code}

# Fallback to data.prop if ROM name extraction fails
if [ -z "$rom_name" ]; then
    rom_name="$ROMNAME"  # Fallback from data.prop
fi

# If still empty, set to default value 'aosp'
[ -z "$rom_name" ] && rom_name="aosp"

# Set dynamic props
resetprop ro.${rom_name}.maintainer "$MAINTAINER"
resetprop ro.product.marketname "$MARKETNAME"
resetprop ro.${rom_name}.build.status "$BUILD_STATUS"
resetprop ro.${rom_name}.buildtype "$BUILDTYPE"
resetprop -n ro.${rom_name}.display "$DISPLAY"
resetprop -n ro.${rom_name}.camera "$CAMERA"
resetprop -n ro.${rom_name}.soc "$SOC"

exit 0