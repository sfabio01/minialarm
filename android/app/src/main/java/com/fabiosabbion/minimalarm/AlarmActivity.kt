package com.fabiosabbion.minimalarm

import android.app.Activity
import android.content.Context
import android.media.RingtoneManager
import android.net.Uri
import android.os.*
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

class AlarmActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_alarm)

        val closeBtn: Button = findViewById(R.id.closebtn)

        val vibrate = intent.getBooleanExtra("vibrate", false)
        val ringtoneUri = intent.getStringExtra("ringtone")

        val ringtone = RingtoneManager.getRingtone(applicationContext, Uri.parse(ringtoneUri))
        if (!ringtone.isPlaying)
            ringtone.play()

        val vibrator = applicationContext.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        if (vibrate) {
            vibrator.vibrate(longArrayOf(2000, 750),0)
        }

        /*
        if(vibrate) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vibrator = applicationContext.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                vibrator.vibrate(CombinedVibration.createParallel(VibrationEffect.createWaveform(
                    longArrayOf(1000, 500), intArrayOf(0, VibrationEffect.DEFAULT_AMPLITUDE),1
                )))

            } else {
                val vibrator = applicationContext.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    vibrator.vibrate(VibrationEffect.createWaveform(longArrayOf(1000, 500), intArrayOf(0, VibrationEffect.DEFAULT_AMPLITUDE),1))
                } else {
                    vibrator.vibrate(longArrayOf(1000, 500),1)
                }
            }
        }
        */

        closeBtn.setOnClickListener {
            ringtone.stop()
            vibrator.cancel()
            finish()
        }


    }
}