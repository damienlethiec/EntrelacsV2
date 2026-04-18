package fr.entrelacs.app

import android.os.Bundle
import android.view.View
import android.webkit.CookieManager
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.lifecycle.lifecycleScope
import com.google.android.material.bottomnavigation.BottomNavigationView
import dev.hotwire.core.config.Hotwire
import dev.hotwire.navigation.activities.HotwireActivity
import dev.hotwire.navigation.navigator.NavigatorConfiguration
import fr.entrelacs.app.util.Config
import fr.entrelacs.app.util.MobileTab
import fr.entrelacs.app.util.RemoteConfig
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : HotwireActivity() {

    private var currentTabs: List<MobileTab> = emptyList()

    override fun onCreate(savedInstanceState: Bundle?) {
        installSplashScreen()
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Cookie indiquant au serveur qu'on est en contexte Hotwire Native.
        CookieManager.getInstance().apply {
            setAcceptCookie(true)
            setCookie(Config.BASE_URL, "hotwire_native=android; Path=/; SameSite=Lax")
            flush()
        }

        // Charger la path configuration depuis Rails (settings + rules, tabs ignoré ici).
        runCatching {
            Hotwire.loadPathConfiguration(
                context = applicationContext,
                location = dev.hotwire.core.turbo.config.PathConfiguration.Location(
                    remoteFileUrl = "${Config.BASE_URL}/mobile/config"
                )
            )
        }

        refreshTabs()
    }

    override fun onResume() {
        super.onResume()
        // Re-fetch les tabs à chaque retour au premier plan : capture les
        // changements de session quand l'utilisateur revient dans l'app.
        refreshTabs()
    }

    override fun navigatorConfigurations() = listOf(
        NavigatorConfiguration(
            name = "main",
            startLocation = Config.BASE_URL,
            navigatorHostId = R.id.main_nav_host
        )
    )

    private fun refreshTabs() {
        lifecycleScope.launch {
            val tabs = withContext(Dispatchers.IO) {
                RemoteConfig.fetchTabs(Config.BASE_URL)
            }

            if (tabs != currentTabs) {
                currentTabs = tabs
                wireBottomNav(tabs)
            }
        }
    }

    private fun wireBottomNav(tabs: List<MobileTab>) {
        val bottomNav = findViewById<BottomNavigationView>(R.id.bottom_nav)
        bottomNav.menu.clear()

        if (tabs.isEmpty()) {
            bottomNav.visibility = View.GONE
            return
        }

        bottomNav.visibility = View.VISIBLE
        tabs.forEachIndexed { index, tab ->
            bottomNav.menu.add(0, index, index, tab.label)
                .setIcon(resolveIcon(tab.icon))
        }

        bottomNav.setOnItemSelectedListener { item ->
            val tab = tabs.getOrNull(item.itemId) ?: return@setOnItemSelectedListener false
            delegate.currentNavigator?.route("${Config.BASE_URL}${tab.path}")
            true
        }
    }

    private fun resolveIcon(name: String): Int = when (name) {
        "ic_bar_chart" -> R.drawable.ic_tab_bar_chart
        "ic_home" -> R.drawable.ic_tab_home
        "ic_group" -> R.drawable.ic_tab_group
        "ic_event" -> R.drawable.ic_tab_event
        "ic_person" -> R.drawable.ic_tab_person
        "ic_account" -> R.drawable.ic_tab_account
        else -> R.drawable.ic_tab_home
    }
}
