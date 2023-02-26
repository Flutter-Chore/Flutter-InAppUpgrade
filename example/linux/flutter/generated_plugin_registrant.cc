//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <upgrade/upgrade_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) upgrade_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UpgradePlugin");
  upgrade_plugin_register_with_registrar(upgrade_registrar);
}
