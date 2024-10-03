// package com.example.wasissta_project

// import android.content.BroadcastReceiver
// import android.content.Context
// import android.content.Intent
// import android.os.Bundle
// import android.telephony.SmsMessage
// import android.util.Log
// import io.flutter.plugin.common.MethodChannel

// class SmsReceiver : BroadcastReceiver() {

//     companion object {
//         var channel: MethodChannel? = null
//     }

//     override fun onReceive(context: Context, intent: Intent) {
//         val bundle: Bundle? = intent.extras
//         val messages: Array<SmsMessage?>
//         var strMessage = ""
//         if (bundle != null) {
//             try {
//                 val pdus = bundle.get("pdus") as Array<Any>?
//                 messages = arrayOfNulls(pdus!!.size)
//                 for (i in pdus.indices) {
//                     messages[i] = SmsMessage.createFromPdu(pdus[i] as ByteArray)
//                     val sender = messages[i]?.originatingAddress
//                     val messageBody = messages[i]?.messageBody
//                     Log.d("SmsReceiver", "Received SMS from $sender: $messageBody") // Debug log
//                     strMessage += "SMS from $sender: $messageBody\n"

//                     // Send the message to Flutter
//                     channel?.invokeMethod("smsReceived", mapOf("sender" to sender, "message" to messageBody))
//                 }
//             } catch (e: Exception) {
//                 e.printStackTrace()
//             }
//         }
//     }
// }


package com.example.sydkic

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.telephony.SmsMessage
import android.util.Log

class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action.equals("android.provider.Telephony.SMS_RECEIVED")) {
            val bundle: Bundle? = intent?.extras
            try {
                if (bundle != null) {
                    val pdus = bundle["pdus"] as Array<Any>
                    for (pdu in pdus) {
                        val smsMessage = SmsMessage.createFromPdu(pdu as ByteArray)
                        val sender = smsMessage.displayOriginatingAddress
                        val message = smsMessage.displayMessageBody

                        Log.d("SmsReceiver", "SMS received from $sender: $message")

                        // Save message to SharedPreferences
                        val prefs: SharedPreferences = context!!.getSharedPreferences("SMS_PREFS", Context.MODE_PRIVATE)
                        val editor: SharedPreferences.Editor = prefs.edit()
                        val messages = prefs.getStringSet("messages", mutableSetOf())?.toMutableSet() ?: mutableSetOf()
                        messages.add("$sender: $message")
                        editor.putStringSet("messages", messages)
                        editor.apply()

                        // Send broadcast to Flutter
                        val smsIntent = Intent("SMS_RECEIVED")
                        smsIntent.putExtra("sender", sender)
                        smsIntent.putExtra("message", message)
                        context.sendBroadcast(smsIntent)
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}
