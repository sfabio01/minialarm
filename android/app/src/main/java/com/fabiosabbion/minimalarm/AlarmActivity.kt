package com.fabiosabbion.minimalarm

import android.app.Activity
import android.content.Context
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.*
import android.widget.TextView

class AlarmActivity : Activity() {

    private lateinit var ringtone: Ringtone
    private lateinit var vibrator: Vibrator

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_alarm)

        val hintTV = findViewById<TextView>(R.id.hintTV)

        hintTV.setOnTouchListener(object : OnSwipeTouchListener(this){
            override fun onSwipeBottom() {
                ringtone.stop()
                vibrator.cancel()
                finish()
            }
        })

        val vibrate = intent.getBooleanExtra("vibrate", false)
        val ringtoneUri = intent.getStringExtra("ringtone")
        val duration = intent.getLongExtra("duration", 5)

        ringtone = RingtoneManager.getRingtone(applicationContext, Uri.parse(ringtoneUri))
        if (!ringtone.isPlaying)
            ringtone.play()

        vibrator = applicationContext.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        if (vibrate) {
            vibrator.vibrate(longArrayOf(2000, 750),0)
        }

        object : CountDownTimer(duration*60000, 1000) {
            override fun onTick(millisUntilFinished: Long) {}

            override fun onFinish() {
                ringtone.stop()
                vibrator.cancel()
                finish()
            }
        }.start()

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


    }

    override fun onBackPressed() {
        ringtone.stop()
        vibrator.cancel()
        super.onBackPressed()
    }


}