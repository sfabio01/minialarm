package com.fabiosabbion.minimalarm

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
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
            if (call.method == "setAlarm") {
                val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as? AlarmManager

                alarmIntent = Intent(context, AlarmReceiver::class.java).let { intent ->
                    PendingIntent.getBroadcast(context, 0, intent, 0)
                }
                val time = call.arguments<Long>()
                alarmManager?.setExact(AlarmManager.RTC_WAKEUP, time, alarmIntent)

                result.success(0)
            } else {
                result.notImplemented()
            }
        }
    }
}