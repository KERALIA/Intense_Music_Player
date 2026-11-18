# Flutter ProGuard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native JNI methods and registrations
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep app package and JNI caller classes
-keep class com.mossapps.flick.** { *; }
-keepclassmembers class com.mossapps.flick.** { *; }

# Cargokit & Flutter Rust Bridge
-keep class com.cargokit.** { *; }
-keep class * implements com.cargokit.** { *; }

# Isar Database
-keep class io.isar.** { *; }
-dontwarn io.isar.**

# Audio plugins & Jetpack Media
-keep class com.ryanheise.just_audio.** { *; }
-keep class com.ryanheise.audio_session.** { *; }
-dontwarn com.ryanheise.**
-keep class androidx.media.** { *; }

# Jetpack Glance & Widgets
-keep class androidx.glance.** { *; }
-keep class androidx.documentfile.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
