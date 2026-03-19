buildscript {
    dependencies {
        classpath("org.yaml:snakeyaml:2.0")
    }
}

import org.yaml.snakeyaml.Yaml
import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    //id("com.google.gms.google-services")
}

// Load configuration from YAML file
@Suppress("UNCHECKED_CAST")
fun loadYamlConfig(): Map<String, Any> {
    val yaml = Yaml()
    val configFile = file("../../../back/config.yaml")
    return yaml.load(FileInputStream(configFile)) as Map<String, Any>
}

fun loadLocalProperties(): Properties {
    val properties = Properties()
    val localPropertiesFile = rootProject.file("local.properties")
    localPropertiesFile.inputStream().use(properties::load)
    return properties
}

val config = loadYamlConfig()
val localProperties = loadLocalProperties()

@Suppress("UNCHECKED_CAST")
val appConfig = config["app"] as Map<String, Any>

@Suppress("UNCHECKED_CAST")
val privacyConfig = config["privacy"] as Map<String, Any>

@Suppress("UNCHECKED_CAST")
val notificationsConfig = config["notifications"] as Map<String, Any>

@Suppress("UNCHECKED_CAST")
val requestParamsConfig = config["request_params"] as Map<String, Any>

@Suppress("UNCHECKED_CAST")
val appsflyerConfig = config["appsflyer"] as Map<String, Any>

@Suppress("UNCHECKED_CAST")
val encryptionConfig = config["encryption"] as Map<String, Any>

val APP_NAME = appConfig["name"] as String
val APP_ID = appConfig["app_id"] as String
val BUNDLE_ID = appConfig["bundle_id"] as String

val APPSFLYER_DEV_KEY = appsflyerConfig["appsflyer_dev_key"] as String

val DOMAIN = appConfig["domain"] as String
val INSTALLER_PARAM = requestParamsConfig["installer_param"] as String
val USER_ID_PARAM = requestParamsConfig["user_id_param"] as String
val GAID_PARAM = requestParamsConfig["google_ad_id_param"] as String
val APPSFLYER_ID_PARAM = requestParamsConfig["appsflyer_id_param"] as String
val APPSFLYER_SOURCE_PARAM = requestParamsConfig["appsflyer_source_param"] as String
val APPSFLYER_CAMPAIGN_PARAM = requestParamsConfig["appsflyer_campaign_param"] as String
val PRIVACY_CALLBACK = privacyConfig["callback"] as String
val PRIVACY_ACCEPTED_PARAM = privacyConfig["accepted_param"] as String
val NOTIFICATIONS_SKIP_PARAM = notificationsConfig["skip_param"] as String
val NOTIFICATIONS_TOKEN_PARAM = notificationsConfig["token_param"] as String

val PRIVACY_ACCEPTANCE_LINK = "https://$DOMAIN/privacy/"

val SUPPORT_WEBPAGE = "https://$DOMAIN/contact.html"
val PRIVACY_WEBPAGE = "https://$DOMAIN/privacy.html"

val SPLASH_IMAGE_URL = "https://$DOMAIN/splash/get_splash.php"
val AES_KEY = encryptionConfig["aes_key"] as String
val flutterSdkPath = requireNotNull(localProperties.getProperty("flutter.sdk")) {
    "flutter.sdk not set in android/local.properties"
}
val dartExecutable = file("$flutterSdkPath/bin/dart${if (System.getProperty("os.name").startsWith("Windows")) ".bat" else ""}")


android {
    namespace = "com.application"
    compileSdk = 36
    ndkVersion = "29.0.13846066"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = BUNDLE_ID
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 29
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        ndk {
            abiFilters += listOf("arm64-v8a")
            debugSymbolLevel = "NONE"
        }

        setProperty("archivesBaseName", "$applicationId-$versionCode($versionName)")

        // DOMAIN is used by Kotlin code (e.g. RetrofitClient) — needed in all build types
        buildConfigField("String", "DOMAIN", "\"$DOMAIN\"")

        manifestPlaceholders["appName"] = APP_NAME
    }

    signingConfigs {
        create("release") {
            storeFile = file("keystore/$APP_ID.keystore")
            storePassword = APP_ID
            keyAlias = APP_ID
            keyPassword = APP_ID
        }
    }

    buildFeatures {
        buildConfig = true
    }

    buildTypes {
        debug {
            // Config values for debug MethodChannel (src/debug/kotlin/MainActivity.kt).
            // Release uses dart-defines instead — no BuildConfig fields needed.
            buildConfigField("String", "INSTALLER_PARAM", "\"$INSTALLER_PARAM\"")
            buildConfigField("String", "USER_ID_PARAM", "\"$USER_ID_PARAM\"")
            buildConfigField("String", "GAID_PARAM", "\"$GAID_PARAM\"")
            buildConfigField("String", "APPSFLYER_ID_PARAM", "\"$APPSFLYER_ID_PARAM\"")
            buildConfigField("String", "APPSFLYER_SOURCE_PARAM", "\"$APPSFLYER_SOURCE_PARAM\"")
            buildConfigField("String", "APPSFLYER_CAMPAIGN_PARAM", "\"$APPSFLYER_CAMPAIGN_PARAM\"")
            buildConfigField("String", "APPSFLYER_DEV_KEY", "\"$APPSFLYER_DEV_KEY\"")
            buildConfigField("String", "PRIVACY_ACCEPTANCE_LINK", "\"$PRIVACY_ACCEPTANCE_LINK\"")
            buildConfigField("String", "PRIVACY_CALLBACK", "\"$PRIVACY_CALLBACK\"")
            buildConfigField("String", "PRIVACY_ACCEPTED_PARAM", "\"$PRIVACY_ACCEPTED_PARAM\"")
            buildConfigField("String", "NOTIFICATIONS_SKIP_PARAM", "\"$NOTIFICATIONS_SKIP_PARAM\"")
            buildConfigField("String", "NOTIFICATIONS_TOKEN_PARAM", "\"$NOTIFICATIONS_TOKEN_PARAM\"")
            buildConfigField("String", "SUPPORT_WEBPAGE", "\"$SUPPORT_WEBPAGE\"")
            buildConfigField("String", "PRIVACY_WEBPAGE", "\"$PRIVACY_WEBPAGE\"")
            buildConfigField("String", "SPLASH_IMAGE_URL", "\"$SPLASH_IMAGE_URL\"")
            buildConfigField("String", "AES_KEY", "\"$AES_KEY\"")
        }
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

tasks.register("generateFlutterIcons") {
    group = "build"
    description = "Generates app icons using flutter_launcher_icons"

    doLast {
        val flutterRoot = file("../..")
        require(dartExecutable.exists()) {
            "Dart executable not found at ${dartExecutable.absolutePath}"
        }
        println("Generating Flutter icons from: ${flutterRoot.absolutePath}")

        val result = project.exec {
            workingDir = flutterRoot
            commandLine(dartExecutable.absolutePath, "run", "flutter_launcher_icons")
        }

        if (result.exitValue == 0) {
            println("Icon generation completed successfully.")
        } else {
            throw GradleException("Icon generation failed with exit code: ${result.exitValue}")
        }
    }
}

tasks.matching { it.name.startsWith("assemble") || it.name.startsWith("bundle") }.configureEach {
    dependsOn("generateFlutterIcons")
}
