package fr.entrelacs.app.util

import android.webkit.CookieManager
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL

data class MobileTab(
    val label: String,
    val path: String,
    val icon: String
)

/**
 * Fetch la liste de tabs depuis /mobile/config.
 * Les cookies de la WebView (session Devise + hotwire_native) sont envoyés
 * manuellement pour que Rails retourne la config adaptée au user loggé.
 * Retourne liste vide en cas d'échec ou si non loggé.
 */
object RemoteConfig {
    fun fetchTabs(baseUrl: String): List<MobileTab> = runCatching {
        val url = URL("$baseUrl/mobile/config")
        val conn = url.openConnection() as HttpURLConnection
        conn.requestMethod = "GET"
        conn.connectTimeout = 5000
        conn.readTimeout = 5000

        CookieManager.getInstance().getCookie(baseUrl)?.let { cookies ->
            conn.setRequestProperty("Cookie", cookies)
        }

        val body = conn.inputStream.bufferedReader().use { it.readText() }
        val root = JSONObject(body)

        root.optJSONArray("tabs")?.let { arr ->
            (0 until arr.length()).map { i ->
                val t = arr.getJSONObject(i)
                MobileTab(
                    label = t.getString("label"),
                    path = t.getString("path"),
                    icon = t.getString("icon")
                )
            }
        } ?: emptyList()
    }.getOrElse { emptyList() }
}
