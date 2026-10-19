import 'dart:async';

import 'package:flutter/material.dart';

class ResultToast {
  OverlayEntry? _entry;
  Timer? _timer;
  void show(BuildContext context, String message) {
    clear();
    final media = MediaQuery.of(context);
    final colours = Theme.of(context).colorScheme;
    _entry = OverlayEntry(
      builder: (_) => Positioned(
        right: 16,
        bottom: media.padding.bottom + media.viewInsets.bottom + 88,
        child: IgnorePointer(
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            color: colours.inverseSurface,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: (media.size.width - 32).clamp(0, 300).toDouble(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  message,
                  style: TextStyle(
                    color: colours.onInverseSurface,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_entry!);
    _timer = Timer(const Duration(seconds: 2), clear);
  }

  void clear() {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
  }
}
