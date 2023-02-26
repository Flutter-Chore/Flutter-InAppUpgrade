#ifndef FLUTTER_PLUGIN_UPGRADE_PLUGIN_H_
#define FLUTTER_PLUGIN_UPGRADE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace upgrade {

class UpgradePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  UpgradePlugin();

  virtual ~UpgradePlugin();

  // Disallow copy and assign.
  UpgradePlugin(const UpgradePlugin&) = delete;
  UpgradePlugin& operator=(const UpgradePlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace upgrade

#endif  // FLUTTER_PLUGIN_UPGRADE_PLUGIN_H_
