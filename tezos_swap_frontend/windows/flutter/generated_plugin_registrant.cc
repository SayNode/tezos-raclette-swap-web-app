//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <r_crypto/r_crypto_plugin.h>
#include <sodium_libs/sodium_libs_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  RCryptoPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("RCryptoPlugin"));
  SodiumLibsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SodiumLibsPlugin"));
}
