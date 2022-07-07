//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import r_crypto
import shared_preferences_macos
import sodium_libs

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  RCryptoPlugin.register(with: registry.registrar(forPlugin: "RCryptoPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SodiumLibsPlugin.register(with: registry.registrar(forPlugin: "SodiumLibsPlugin"))
}
