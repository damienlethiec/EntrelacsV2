package fr.entrelacs.app

import android.os.Bundle
import dev.hotwire.navigation.activities.HotwireActivity
import dev.hotwire.navigation.navigator.NavigatorConfiguration
import fr.entrelacs.app.util.Config

class MainActivity : HotwireActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    override fun navigatorConfigurations() = listOf(
        NavigatorConfiguration(
            name = "main",
            startLocation = Config.BASE_URL,
            navigatorHostId = R.id.main_nav_host
        )
    )
}
