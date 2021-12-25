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
        // val vibrator: Vibrator = context?.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        // TODO: check if to vibrate
        Toast.makeText(context, "Alarm! Wake up! Wake up!", Toast.LENGTH_LONG).show()
        val prefs = context?.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        if (prefs != null) {
            vibrate = prefs.getBoolean(prefix+"vibrate", false)
            ringtoneUri = prefs.getString(prefix+"sound", defaultRingtoneUri).toString()
            val editor = prefs.edit()
            editor.remove(prefix+"hour")
            editor.remove(prefix+"min")
            editor.apply()
        }


        // val ringtone = RingtoneManager.getRingtone(context, Uri.parse(ringtoneUri))
        // ringtone.play()


    }

}
