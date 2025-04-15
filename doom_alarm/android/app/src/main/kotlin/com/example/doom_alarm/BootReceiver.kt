package com.example.doom_alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        Log.e("BootReceiver", "🪵 onReceive triggered with intent: ${intent?.action}")

        if (intent?.action == Intent.ACTION_BOOT_COMPLETED && context != null) {
            Log.e("BootReceiver", "🔥 BOOT_COMPLETED received — preparing to start Dart isolate")

            try {
                Log.e("BootReceiver", "🚀 Initializing FlutterLoader")
                val loader = FlutterLoader()
                loader.startInitialization(context)

                Log.e("BootReceiver", "✅ startInitialization done — ensuring completion")
                loader.ensureInitializationComplete(context, null)
                Log.e("BootReceiver", "✅ ensureInitializationComplete done")

                Log.e("BootReceiver", "🛠 Creating FlutterEngine")
                val engine = FlutterEngine(context)

                Log.e("BootReceiver", "📦 Finding Dart entrypoint path")
                val entrypointPath = loader.findAppBundlePath()
                Log.e("BootReceiver", "📦 Dart entrypoint path: $entrypointPath")

                Log.e("BootReceiver", "🎯 Executing Dart entrypoint: bootReschedule")
                engine.dartExecutor.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint(entrypointPath, "bootReschedule")
                )

                Log.e("BootReceiver", "✅ Dart isolate execution launched successfully")
            } catch (e: Exception) {
                Log.e("BootReceiver", "❌ Failed to launch Dart isolate", e)
            }
        } else {
            Log.w("BootReceiver", "⚠️ Ignored intent: ${intent?.action}")
        }
    }
}
