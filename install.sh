SKIPMOUNT=true
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

REPLACE="
"

print_modname() {
  ui_print ""
  ui_print ""
  ui_print "- DynamicPropGenie"
  ui_print "- by Ayu Kashyap 😎"
  ui_print ""
  ui_print ""
}

on_install() {
  ui_print "- Extracting module files"
  unzip -o "$ZIPFILE" -d $MODPATH >&2
}

set_permissions() {
  # Set default permissions recursively
  set_perm_recursive $MODPATH 0 0 0755 0644

  # Set executable permissions for your scripts
  set_perm $MODPATH/service.sh 0 0 0755
  set_perm $MODPATH/post-fs-data.sh 0 0 0755

  # Set readable permissions for your data file
  set_perm $MODPATH/data.prop 0 0 0644
}
