package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.Log;

import io.flutter.embedding.engine.FlutterEngine;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  private static final String TAG = "GeneratedPluginRegistrant";
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    try {
      flutterEngine.getPlugins().add(new com.sebdeveloper6952.amberflutter.amberflutter.AmberflutterPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin amberflutter, com.sebdeveloper6952.amberflutter.amberflutter.AmberflutterPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new relaystr.dart_ndk.DartNdkPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin dart_ndk, relaystr.dart_ndk.DartNdkPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.isar.isar_flutter_libs.IsarFlutterLibsPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin isar_flutter_libs, dev.isar.isar_flutter_libs.IsarFlutterLibsPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.pathprovider.PathProviderPlugin());
    } catch (Exception e) {
      Log.e(TAG, "Error registering plugin path_provider_android, io.flutter.plugins.pathprovider.PathProviderPlugin", e);
    }
  }
}
