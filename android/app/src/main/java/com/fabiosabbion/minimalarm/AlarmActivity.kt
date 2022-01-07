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
        ringtone.play()

        if(vibrate) {
            val vibrator: Any
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                vibrator = applicationContext.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                vibrator.vibrate(CombinedVibration.createParallel(VibrationEffect.createOneShot(500, VibrationEffect.DEFAULT_AMPLITUDE)))

            } else {
                vibrator = applicationContext.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                vibrator.vibrate(500)
            }
        }


        closeBtn.setOnClickListener {
            ringtone.stop()
            finish()
        }


    }
}