// package com.example.sydkic

// import io.flutter.embedding.android.FlutterActivity

// class MainActivity: FlutterActivity()
package com.example.sydkic

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    private val SMS_RECEIVED_CHANNEL = "com.example.sydkic/sms"
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_RECEIVED_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    registerReceiver(smsReceiver, IntentFilter("SMS_RECEIVED"))
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    unregisterReceiver(smsReceiver)
                }
            }
        )
    }

    private val smsReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val sender = intent?.getStringExtra("sender")
            val message = intent?.getStringExtra("message")
            if (sender != null && message != null) {
                eventSink?.success(mapOf("sender" to sender, "message" to message))
            }
        }
    }
}
