import java.util.Properties

plugins {
    alias(libs.plugins.android.application)
}

val keystorePropsFile = rootProject.file("keystore.properties")
val keystoreProps = Properties().apply {
    if (keystorePropsFile.exists()) load(keystorePropsFile.inputStream())
}

android {
    namespace = "fr.entrelacs.app"
    compileSdk {
        version = release(36) {
            minorApiLevel = 1
        }
    }

    defaultConfig {
        applicationId = "fr.entrelacs.app"
        minSdk = 28
        // targetSdk 34 conservé volontairement : les API 35+ ignorent
        // android:statusBarColor au profit d'edge-to-edge, non géré dans ce scope.
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildFeatures {
        buildConfig = true
    }

    signingConfigs {
        create("release") {
            if (keystorePropsFile.exists()) {
                storeFile = file("${keystoreProps["storeFile"]}")
                storePassword = "${keystoreProps["storePassword"]}"
                keyAlias = "${keystoreProps["keyAlias"]}"
                keyPassword = "${keystoreProps["keyPassword"]}"
            }
        }
    }

    buildTypes {
        debug {
            buildConfigField(
                "String",
                "BASE_URL",
                "\"https://macbook-pro-de-damien.tail854d17.ts.net\""
            )
        }
        release {
            buildConfigField(
                "String",
                "BASE_URL",
                "\"https://entrelacs.dlet.fr\""
            )
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

kotlin {
    jvmToolchain(17)
}

dependencies {
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    implementation(libs.androidx.activity)
    implementation(libs.androidx.constraintlayout)
    implementation(libs.hotwire.core)
    implementation(libs.hotwire.navigation.fragments)
    implementation(libs.androidx.core.splashscreen)
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
}