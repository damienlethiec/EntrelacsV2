package fr.entrelacs.app

import android.os.Bundle
import android.webkit.CookieManager
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import dev.hotwire.navigation.activities.HotwireActivity
import dev.hotwire.navigation.navigator.NavigatorConfiguration
import fr.entrelacs.app.util.Config

class MainActivity : HotwireActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen()
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Signal au serveur Rails qu'on est en contexte Hotwire Native via un cookie.
        // Le User-Agent de la WebView n'est pas fiablement modifié par Hotwire en 1.2.7,
        // donc on utilise un cookie explicite à la place.
        CookieManager.getInstance().apply {
            setAcceptCookie(true)
            setCookie(Config.BASE_URL, "hotwire_native=android; Path=/; SameSite=Lax")
            flush()
        }
    }

    override fun navigatorConfigurations() = listOf(
        NavigatorConfiguration(
            name = "main",
            startLocation = Config.BASE_URL,
            navigatorHostId = R.id.main_nav_host
        )
    )
}
