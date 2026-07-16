# Weekly Internship & Project Development Report

**Project Title:** Intense Audio Player (A High-Performance Audiophile Music Player for Android)  
**Student Name:** PATEL AUM SHIRISHKUMAR  
**Enrollment No:** 12302040601004  
**Branch:** CP (Computer Programming)  
**Reporting Period:** 15th May 2026 to 16th July 2026  

---

## Executive Summary
This weekly report details the architectural exploration, implementation, and optimization milestones achieved during the development of the **Intense Audio Player**. Bypassing standard, lower-fidelity Android audio frameworks, the project involved designing a custom low-level playback engine in **Rust** that utilizes raw USB transfers and high-performance HAL interfaces (`AAudio`/`Oboe`), combined with a fluid, state-managed **Flutter** frontend. 

The timeline begins with a structured 15-day learning period (May 15 – May 30) focusing on digital signal processing, USB transfer protocols, and FFI architectures. Following this initial training, a systematic 7-week development phase was executed to implement, test, and polish the application features.

---

## Weekly Work Breakdown

### Phase 1: Conceptual Study & Learning Period (May 15 – May 30, 2026)

#### Week 1: May 15 – May 22, 2026
- **Focus:** Android Audio Frameworks & Low-Level DSP Principles.
- **Key Activities:**
  - Evaluated the limitations of the default Android `MediaPlayer` and `ExoPlayer` APIs, specifically examining how the Android Audio Flinger forces resampling to 48kHz, degrading high-resolution audiophile formats.
  - Studied the architecture of **OpenSL ES** and **AAudio** frameworks for low-latency output.
  - Explored digital audio fundamentals: linear PCM representation, sample rates (up to 384kHz), quantization noise, bit-depth boundaries (16-bit, 24-bit, 32-bit), and channel layouts.
- **Outcomes:** Established the conceptual foundation for a direct, exclusive hardware-access output system.

#### Week 2: May 23 – May 30, 2026
- **Focus:** Cross-Platform FFI Architecture & USB Protocol Research.
- **Key Activities:**
  - Investigated the **USB Audio Class 2.0 (UAC 2.0)** protocol specification, focusing on isochronous endpoints, feedback endpoints, and descriptors.
  - Studied the use of the `rusb` (libusb wrapper for Rust) crate to access Android's USB Host APIs directly from a native layer.
  - Set up the cross-compilation toolchain for compiling Rust libraries to Android architectures (`aarch64-linux-android`, `armv7-linux-androideabi`).
  - Analyzed the architecture of `flutter_rust_bridge` (v2) for asynchronous message passing and shared memory buffers.
- **Outcomes:** Validated the feasibility of running a Rust-based driver on Android to control USB DACs.

---

### Phase 2: System Development & Implementation (May 31 – July 16, 2026)

#### Week 3: May 31 – June 6, 2026
- **Focus:** Core Audio Decoding Engine & Native HAL Output.
- **Key Activities:**
  - Implemented the first version of the native decoder engine using the `Symphonia` Rust library, supporting decoding of FLAC, WAV, MP3, and AAC.
  - Integrated the `Oboe` C++ wrapper into Rust via FFI, allowing exclusive-mode AAudio output to bypass the system mixer.
  - Developed a dynamic memory buffer in Rust to stream decoded PCM blocks to the Oboe write loop.
- **Outcomes:** Achieved low-latency, glitch-free audio playback of standard and lossless audio files through AAudio.

#### Week 4: June 7 – June 13, 2026
- **Focus:** Storage Access Framework (SAF) & Differential Library Scanner.
- **Key Activities:**
  - Developed Android Storage Access Framework (SAF) URI helpers to index and read files from removable media (SD cards, external USB drives).
  - Designed a high-speed library scanning service in Dart using the **Isar Database**, implementing differential synchronization to only update modified files.
  - Integrated the `lofty` Rust metadata parsing package for lightning-fast parsing of track tags, writing edited tags back to physical files, and importing album art from external Web APIs (MusicBrainz, iTunes).
- **Outcomes:** Built a robust, fast database scanner capable of indexing large directories with minimal CPU overhead.

#### Week 5: June 14 – June 20, 2026
- **Focus:** Direct USB Direct (UAC 2.0) Transport & DSD Architecture.
- **Key Activities:**
  - Developed a direct USB driver in Rust utilizing `rusb` to claim UAC 2.0 interfaces, bypassing Android's entire HAL layer.
  - Programmed support for **Direct Stream Digital (DSD)** transport using **DSD-over-PCM (DoP)** encapsulation and Native DSD paths.
  - Built a Quirk Database system that dynamically maps hardware compatibility configurations (byte order, subslot configurations, and clock settings) to specific external DAC USB IDs.
- **Outcomes:** Achieved true, bit-perfect DSD and high-resolution output directly to external DACs.

#### Week 6: June 21 – June 27, 2026
- **Focus:** 31-Band Parametric Equalizer, Audio Convolver, and Listening Recaps.
- **Key Activities:**
  - Designed and coded a 31-band parametric equalizer in Rust using cascading biquad filters.
  - Created a fast convolution engine processing WAV Impulse Response (IR) files in the time domain to add professional convolution reverb.
  - Implemented continuous listening milestones, streak trackers (consecutive listening days), and **Intense Replay** (analytical recaps of listener stats exportable to images).
- **Outcomes:** Implemented a full, professional-grade DSP suite and gamified features to enhance user engagement.

#### Week 7: June 28 – July 4, 2026
- **Focus:** Bluetooth Codec Controller & UI/UX State Refactoring.
- **Key Activities:**
  - Developed a Bluetooth routing manager to control Android codec profiles, introducing a "Hi-Res Direct" toggle that forces high-quality paths (LDAC, aptX HD, AAC).
  - Migrated the application settings and library screens to **Riverpod** to enforce clean state separation.
  - Added home screen Glance cards control options (allowing users to show/hide quick-access elements) and implemented display refresh rate overrides (60Hz / 90Hz / 120Hz).
- **Outcomes:** Polish of the user-visible screens and improved Bluetooth high-resolution reliability.

#### Week 8: July 5 – July 11, 2026
- **Focus:** AutoEQ Catalog Integration, Native Logging System, and Stability Fixes.
- **Key Activities:**
  - Integrated the AutoEQ database containing frequency responses for over 3000 headphone models, allowing users to apply instant matching profiles.
  - Programmed a native logging sink via Rust FFI to capture low-level hardware debugging output and display it in an in-app developer console.
  - Patched critical bugs: fixed crash triggers on older Android 7 (minSdk 26 compatibility), resolved write-only USB clock readback loops, and optimized image caching keys.
- **Outcomes:** Greatly improved stability and diagnostic transparency in the application.

#### Week 9: July 12 – July 16, 2026 (Current Week)
- **Focus:** Performance Optimization & Project Submission Preparation.
- **Key Activities:**
  - Conducted extensive stress testing of direct USB transport and the resampler engine to verify memory usage.
  - Removed all legacy "Flick" nomenclature from documentation, code comments, and metadata, standardizing on the project title: **Intense**.
  - Documented design decisions, build setup guides, and architectural diagrams.
- **Outcomes:** The Intense Audio Player codebase is fully verified, optimized, and prepared for final project submission.

---

## Technical Summary of Contributions

| Area | Technologies Used | Description |
|---|---|---|
| **Core Architecture** | Flutter, Dart, Riverpod, Isar | Responsive UI state management, high-performance local database caching. |
| **Native Audio HAL** | Rust, Oboe C++, AAudio | Exclusive mode audio output routing, low-latency playback control. |
| **Direct USB Transport** | Rust, `rusb`, libusb | Bypassing OS mixer via custom driver, enabling UAC 2.0 bit-perfect paths. |
| **DSD Playback Engine** | DoP, Native DSD, Rust | Streaming of DSF/DFF formats with dynamic hardware subslot overrides. |
| **Digital Signal Processing** | Rust, Biquad Filters | 31-band EQ, Audio Convolver (Impulse Response), gapless fading curves. |
| **Diagnostics & Logging** | Rust FFI, AppLog, Log Viewer | Live synchronization of native logs to Flutter-based UI. |

---

## Key Learning Outcomes

1. **Bare-Metal Android Hardware Access:** Mastered using Android's USB Host API and raw USB transfers to write custom hardware drivers in Rust.
2. **High-Performance FFI Integrations:** Gained extensive experience utilizing `flutter_rust_bridge` to link asynchronous, safety-critical systems code with high-level user interface elements.
3. **Advanced Digital Audio DSP:** Learned how to process raw PCM streams, manage clock drift via isochronous feedback loop adjustments, and build DSP filters.
4. **Professional Project Organization:** Structured a hybrid Flutter/Rust project, maintaining modular architecture, extensive documentation, and unit test suites.

---
**Prepared By:**  
PATEL AUM SHIRISHKUMAR  
Enrollment No: 12302040601004  
Branch: CP (Computer Programming)  
Date: 16th July 2026  
