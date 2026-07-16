# Android NDK Setup for Rust Libraries

## Problem
When using Rust libraries with `flutter_rust_bridge` on Android, you may encounter these errors:

1. **Missing libc++_shared.so**:
```
Failed to load dynamic library 'librust_lib_flick_player.so': 
dlopen failed: library "libc++_shared.so" not found
```

2. **Android context not initialized** (when using cpal/oboe):
```
PanicException(android context was not initialized)
```

## Root Causes

### 1. Missing libc++_shared.so
The Rust library (via `cpal` with `oboe-shared-stdcxx` feature) requires `libc++_shared.so` from the Android NDK, but this library is not automatically included in the APK.

### 2. Android Context Not Initialized
When using cpal with Oboe for audio on Android, the NDK context must be initialized before the library is loaded. This requires loading the native library from the Java/Kotlin side before Dart loads it.

## Solutions

### Solution 1: Include libc++_shared.so

We've implemented an automated solution that copies `libc++_shared.so` from the Android NDK to the app's `jniLibs` directory during the build process.

#### Files Modified

1. **android/app/build.gradle.kts**
   - Added `sourceSets` configuration to include jniLibs
   - Added `pickFirsts` for `libc++_shared.so` to handle duplicates
   - Added `copyNdkLibs` task that runs before `preBuild`

2. **android/copy_ndk_libs.sh**
   - Script that copies `libc++_shared.so` from NDK to jniLibs for all ABIs
   - Automatically detects NDK location from `ANDROID_NDK_HOME` or `ANDROID_HOME`
   - Supports multiple NDK versions and directory structures

### Solution 2: Initialize Android NDK Context

For cpal/oboe to work, we need to initialize the NDK context before Dart loads the library.

#### Files Modified

1. **rust/Cargo.toml**
   - Added `jni` and `ndk-context` dependencies for Android target

2. **rust/src/lib.rs**
   - Added `JNI_OnLoad` function to initialize NDK context when library is loaded

3. **android/app/src/main/kotlin/.../MainActivity.kt**
   - Added `init` block to load the Rust library before Dart does
   - This ensures `JNI_OnLoad` is called and NDK context is initialized

### Build Process
The `libc++_shared.so` library is now automatically copied during the build:
```bash
flutter build apk
# or
flutter build appbundle
```

### Manual Copy (if needed)
If you need to manually copy the libraries:
```bash
./android/copy_ndk_libs.sh
```

### Supported ABIs
- arm64-v8a (64-bit ARM)
- armeabi-v7a (32-bit ARM)
- x86_64 (64-bit Intel)
- x86 (32-bit Intel)

### Requirements
- Android NDK must be installed
- `ANDROID_HOME` or `ANDROID_NDK_HOME` environment variable must be set

### Verification
After building, verify the libraries are included:
```bash
find android/app/src/main/jniLibs -name "*.so"
```

You should see `libc++_shared.so` for each ABI.

## References
- [flutter_rust_bridge NDK Init Guide](https://cjycode.com/flutter_rust_bridge/guides/how-to/ndk-init)
- [cpal Android Support](https://github.com/RustAudio/cpal)
- [Oboe Rust Bindings](https://github.com/katyo/oboe-rs)
