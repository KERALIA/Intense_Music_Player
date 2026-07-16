import 'package:flutter/material.dart';

enum ShareTemplate {
  lyric(
    label: 'Lyric',
    icon: Icons.music_note_rounded,
  ),
  solidColor(
    label: 'Color',
    icon: Icons.palette_rounded,
  ),
  minimal(
    label: 'Minimal',
    icon: Icons.crop_square_rounded,
  ),
  albumArt(
    label: 'Album',
    icon: Icons.album_rounded,
  );

  final String label;
  final IconData icon;

  const ShareTemplate({required this.label, required this.icon});
}