package com.fabiosabbion.minimalarm

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.RingtoneManager
import android.os.Build
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.fabiosabbion.minimalarm/alarm"
    private lateinit var alarmIntent: PendingIntent

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "setAlarm" -> {
                    val time = call.arguments<Long>()
                    val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
                    if (alarmManager != null){
                        alarmIntent = Intent(context, AlarmReceiver::class.java).let { intent ->
                            PendingIntent.getBroadcast(context, 2001410, intent, 0)
                        }
                        alarmManager.setAlarmClock(AlarmManager.AlarmClockInfo(time, alarmIntent), alarmIntent)
                        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                        val tempUri =
                            prefs.getString(prefix+"sound", "default==default")?.split("==")?.get(0)
                        result.success(tempUri)
                    } else {
                        result.error("100", "Couldn't retrieve AlarmManager object", null)
                    }
                }
                "cancelAlarm" -> {
                    val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager
                    if (alarmManager != null) {
                        alarmManager.cancel(alarmIntent)
                        result.success(0)
                    } else {
                        result.error("100", "Couldn't retrieve AlarmManager object", null)
                    }

                }
                "getSounds" -> {
                    val ringtoneManager = RingtoneManager(applicationContext)
                    ringtoneManager.setType(RingtoneManager.TYPE_ALARM)
                    val cur = ringtoneManager.cursor
                    val map = LinkedHashMap<String, String>()
                    while(!cur.isAfterLast && cur.moveToNext()) {
                        val i = cur.position
                        map[ringtoneManager.getRingtoneUri(i).toString()] =
                            ringtoneManager.getRingtone(i).getTitle(applicationContext)
                    }
                    cur.close()
                    result.success(map)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}