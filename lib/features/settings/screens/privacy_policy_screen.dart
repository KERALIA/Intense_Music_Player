import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intense_audio_player/core/theme/adaptive_color_provider.dart';
import 'package:intense_audio_player/core/theme/app_colors.dart';
import 'package:intense_audio_player/core/constants/app_constants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMd,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Section(
                          title: 'Data Collection',
                          content:
                              'Flick Player does not collect, store, or transmit any personal data. No personal information, usage analytics, crash reports, or advertising identifiers are gathered. No data is shared with third parties.',
                        ),
                        _Section(
                          title: 'Local Data',
                          content:
                              'All data is stored locally on your device only: music library metadata, play history, playlists, equalizer presets, and app preferences. Last.fm credentials are stored securely on-device. This data never leaves your device unless you explicitly use an integration.',
                        ),
                        _Section(
                          title: 'Camera and Photos',
                          content:
                              'Camera and photo library access is used solely for the Flick Replay feature to create custom poster backgrounds for listening recap posters. Photos are only used at your explicit request and remain entirely on your device. No images are uploaded or transmitted.',
                        ),
                        _Section(
                          title: 'Storage Permissions',
                          content:
                              'Storage access is required to scan and read music files, extract metadata, import/export EQ presets, and save recap images. All processing happens on-device.',
                        ),
                        _Section(
                          title: 'USB Device Access',
                          content:
                              'USB Audio Class 2.0 devices (external DACs/AMPs) are accessed locally for bit-perfect audio playback. No USB device information is transmitted externally.',
                        ),
                        _Section(
                          title: 'Last.fm Scrobbling',
                          content:
                              'If you connect your Last.fm account, credentials are stored securely on-device. Play data is sent only to Last.fm. We do not receive or process this data.',
                        ),
                        _Section(
                          title: 'Album Art Import',
                          content:
                              'The app queries public APIs (MusicBrainz/Cover Art Archive, iTunes, Deezer) to find matching album art. Search queries use local music metadata. Downloaded images are cached locally.',
                        ),
                        _Section(
                          title: 'Moss Ecosystem',
                          content:
                              'Flick can receive playback handoffs from Locker (another Moss app). Playback intents contain only song file paths/metadata. No personal data is exchanged. The integration is entirely local.',
                        ),
                        _Section(
                          title: 'In-App Updates',
                          content:
                              'Play Store updates use Google Play In-App Update API (governed by Google\'s privacy policies). Patch notes are fetched from GitHub Releases API without sending personal data.',
                        ),
                        _Section(
                          title: 'Children\'s Privacy',
                          content:
                              'The app does not knowingly collect any information from anyone, regardless of age.',
                        ),
                        const SizedBox(height: AppConstants.spacingLg),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppConstants.spacingMd),
                          decoration: BoxDecoration(
                            color: AppColors.glassBackground,
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusMd,
                            ),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Last Updated',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.copyWith(
                                  color: context.adaptiveTextPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'May 4, 2026',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: context.adaptiveTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingLg),
                        const SizedBox(
                          height: AppConstants.navBarHeight + 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: AppConstants.spacingMd,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              LucideIcons.chevronLeft,
              color: context.adaptiveTextPrimary,
            ),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Text(
            'Privacy Policy',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.adaptiveTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: context.adaptiveTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.adaptiveTextSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
