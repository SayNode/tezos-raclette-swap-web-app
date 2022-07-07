//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <r_crypto/r_crypto_plugin.h>
#include <sodium_libs/sodium_libs_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) r_crypto_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "RCryptoPlugin");
  r_crypto_plugin_register_with_registrar(r_crypto_registrar);
  g_autoptr(FlPluginRegistrar) sodium_libs_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SodiumLibsPlugin");
  sodium_libs_plugin_register_with_registrar(sodium_libs_registrar);
}
