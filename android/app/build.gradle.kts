plugins {
    id("com.android.application")
    id("kotlin-android")
<<<<<<< HEAD
=======
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
    id("dev.flutter.flutter-gradle-plugin")
}

android {
<<<<<<< HEAD
    namespace = "com.meeragold.app"
=======
    namespace = "com.gold.goldproject"
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
<<<<<<< HEAD
        isCoreLibraryDesugaringEnabled = true   // Kotlin DSL correct syntax
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.meeragold.app"
=======
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.gold.goldproject"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

<<<<<<< HEAD
    signingConfigs {
        create("release") {
            storeFile = file(project.property("MYAPP_UPLOAD_STORE_FILE") as String)
            storePassword = project.property("MYAPP_UPLOAD_STORE_PASSWORD") as String
            keyAlias = project.property("MYAPP_UPLOAD_KEY_ALIAS") as String
            keyPassword = project.property("MYAPP_UPLOAD_KEY_PASSWORD") as String
        }
    }

    buildTypes {
        getByName("release") {
=======
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
<<<<<<< HEAD

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    implementation(platform("com.google.firebase:firebase-bom:33.2.0"))
}
=======
>>>>>>> d7fd81377560e5863f8e9a99cef7f586049698c6
