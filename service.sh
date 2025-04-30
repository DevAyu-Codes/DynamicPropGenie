#!/system/bin/sh

MODDIR=${0%/*}
sleep 10

# Load custom user-defined properties
. "$MODDIR/data.prop"

# Get ROM and device identification info
rom_full=$(getprop ro.product.system.name)
device_code=$(getprop ro.build.product)
rom_name=${rom_full%_$device_code}

# Fallback if rom_name is empty
if [ -z "$rom_name" ]; then
    rom_name="$ROMNAME"
fi

# Abort if rom_name is still not found
if [ -z "$rom_name" ]; then
    echo "Error: ROM name could not be determined. Aborting."
    exit 1
fi

# Helper function to reset the property only if it's set in data.prop and already exists in build.prop
maybe_resetprop() {
    prop_name=$1
    prop_value=$2
    # Check if value is not empty and the property exists in build.prop
    if [ -n "$prop_value" ] && [ -n "$(getprop "$prop_name")" ]; then
        echo "Applying property: $prop_name with value: $prop_value"
        resetprop "$prop_name" "$prop_value"
    else
        echo "Skipping $prop_name: Either value is empty or property doesn't exist in build.prop."
    fi
}

maybe_resetprop_n() {
    prop_name=$1
    prop_value=$2
    # Check if value is not empty and the property exists in build.prop
    if [ -n "$prop_value" ] && [ -n "$(getprop "$prop_name")" ]; then
        echo "Applying property (with -n flag): $prop_name with value: $prop_value"
        resetprop -n "$prop_name" "$prop_value"
    else
        echo "Skipping $prop_name (with -n flag): Either value is empty or property doesn't exist in build.prop."
    fi
}

# System-level properties
maybe_resetprop "ro.product.marketname" "$MARKETNAME"
maybe_resetprop "ro.product.vendor.model" "$VENDOR_MODEL"
maybe_resetprop "ro.product.device" "$DEVICE"
maybe_resetprop "ro.product.brand" "$BRAND"
maybe_resetprop "ro.product.name" "$NAME"
maybe_resetprop "ro.product.system.model" "$SYSTEM_MODEL"

# Build info with fallback to system defaults if empty
maybe_resetprop "ro.build.description" "$DESCRIPTION"
maybe_resetprop "ro.build.id" "$BUILD_ID"
maybe_resetprop "ro.build.date" "$BUILD_DATE"
maybe_resetprop "ro.build.host" "$BUILD_HOST"
maybe_resetprop "ro.build.user" "$BUILD_USER"

# ROM versioning
maybe_resetprop "ro.${rom_name}.version" "$ROM_VERSION"
maybe_resetprop "ro.lineage.version" "$ROM_VERSION"
maybe_resetprop "ro.crdroid.version" "$ROM_VERSION"
maybe_resetprop "ro.evolution.version" "$ROM_VERSION"
maybe_resetprop "ro.aicp.version" "$ROM_VERSION"
maybe_resetprop "ro.arrow.version" "$ROM_VERSION"
maybe_resetprop "ro.modversion" "$ROM_VERSION"
maybe_resetprop "ro.pixelexperience.version" "$ROM_VERSION"

# Build type and maintainer
maybe_resetprop "ro.${rom_name}.buildtype" "$BUILDTYPE"
maybe_resetprop "ro.${rom_name}.build.status" "$BUILD_STATUS"
maybe_resetprop "ro.lineage.build.type" "$BUILDTYPE"
maybe_resetprop "ro.pixelexperience.build_type" "$BUILDTYPE"
maybe_resetprop "ro.${rom_name}.maintainer" "$MAINTAINER"
maybe_resetprop "ro.lineage.maintainer" "$MAINTAINER"
maybe_resetprop "ro.maintainer" "$MAINTAINER"
maybe_resetprop "ro.maintainer.name" "$MAINTAINER"

# Display and hardware (only reset if values exist in data.prop and build.prop)
maybe_resetprop_n "ro.${rom_name}.display" "$DISPLAY"
maybe_resetprop_n "ro.${rom_name}.camera" "$CAMERA"
maybe_resetprop_n "ro.${rom_name}.soc" "$SOC"
maybe_resetprop_n "ro.${rom_name}.battery" "$BATTERY"

# Security patches
maybe_resetprop "ro.vendor.build.security_patch" "$VENDOR_SECURITY_PATCH"
maybe_resetprop "ro.build.version.security_patch" "$SYSTEM_SECURITY_PATCH"

# Apply build type correctly for system build type
maybe_resetprop "ro.system.build.type" "$BUILDTYPE"

exit 0
