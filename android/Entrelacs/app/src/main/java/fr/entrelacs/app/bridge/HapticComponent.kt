package fr.entrelacs.app.bridge

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.util.Log
import dev.hotwire.core.bridge.BridgeComponent
import dev.hotwire.core.bridge.BridgeDelegate
import dev.hotwire.core.bridge.Message
import dev.hotwire.navigation.destinations.HotwireDestination

/**
 * Bridge component "haptic" : reçoit un message "vibrate" depuis Stimulus
 * (app/javascript/controllers/bridge/haptic_controller.js) et déclenche une
 * vibration native de durée variable selon le style (light/medium/heavy).
 */
class HapticComponent(
    name: String,
    delegate: BridgeDelegate<HotwireDestination>
) : BridgeComponent<HotwireDestination>(name, delegate) {

    // Delegate parent est private, on stocke notre propre référence pour accéder
    // à la destination (HotwireWebFragment qui est un Fragment).
    private val bridgeDelegate = delegate

    override fun onReceive(message: Message) {
        if (message.event != "vibrate") return

        val style = message.data<Map<String, String>>()?.get("style") ?: "medium"
        Log.d("HapticComponent", "vibrate reçu style=$style")
        vibrate(style)
    }

    private fun vibrate(style: String) {
        val fragment = bridgeDelegate.destination as? androidx.fragment.app.Fragment ?: return
        val vibrator = vibrator(fragment.requireContext()) ?: return

        val durationMs = when (style) {
            "light" -> 10L
            "heavy" -> 40L
            else -> 20L
        }

        val effect = VibrationEffect.createOneShot(durationMs, VibrationEffect.DEFAULT_AMPLITUDE)
        vibrator.vibrate(effect)
    }

    private fun vibrator(context: Context): Vibrator? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val manager = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            manager.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            context.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
        }
    }
}
