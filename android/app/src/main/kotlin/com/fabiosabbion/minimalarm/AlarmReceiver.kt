package com.fabiosabbion.minimalarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.media.RingtoneManager
import android.net.Uri
import android.widget.Toast
import io.flutter.plugin.common.MethodChannel

const val prefix = "flutter."

class AlarmReceiver: BroadcastReceiver(){
    override fun onReceive(context: Context?, intent: Intent?) {
        val defaultRingtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM).toString()
        var vibrate = false
        var ringtoneUri  = defaultRingtoneUri
        val prefs = context?.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        if (prefs != null) {
            vibrate = prefs.getBoolean(prefix+"vibrate", false)
            val tempUri =
                prefs.getString(prefix+"sound", "default==default")?.split("==")?.get(0)
            print(tempUri)
            if (tempUri != null && tempUri != "default") {
                ringtoneUri = tempUri
            }
            val editor = prefs.edit()
            editor.remove(prefix+"hour")
            editor.remove(prefix+"min")
            editor.apply()
        }

        val alarmIntent = Intent(context, AlarmActivity::class.java)
        alarmIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        alarmIntent.putExtra("vibrate", vibrate)
        alarmIntent.putExtra("ringtone", ringtoneUri)
        context?.startActivity(alarmIntent)

    }

}
