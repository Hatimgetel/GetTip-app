import 'dart:async';

import 'package:flutter/material.dart';

OverlayEntry? _activeEntry;
Timer? _activeTimer;

void showTopMessage(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(seconds: 2),
  String? actionLabel,
  Future<void> Function()? onAction,
}) {
  final OverlayState? overlay = Overlay.of(context, rootOverlay: true);
  if (overlay == null) return;

  _activeTimer?.cancel();
  _activeTimer = null;
  _activeEntry?.remove();
  _activeEntry = null;

  final ThemeData theme = Theme.of(context);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (BuildContext overlayContext) {
      final double topInset = MediaQuery.of(overlayContext).viewPadding.top;
      return Positioned(
        top: topInset + 8,
        left: 12,
        right: 12,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.inverseSurface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: theme.colorScheme.onInverseSurface),
                  ),
                ),
                if (actionLabel != null && onAction != null)
                  TextButton(
                    onPressed: () async {
                      _activeTimer?.cancel();
                      _activeTimer = null;
                      _activeEntry?.remove();
                      _activeEntry = null;
                      await onAction();
                    },
                    child: Text(
                      actionLabel,
                      style: TextStyle(
                        color: theme.colorScheme.onInverseSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(entry);
  _activeEntry = entry;
  _activeTimer = Timer(duration, () {
    _activeEntry?.remove();
    _activeEntry = null;
    _activeTimer = null;
  });
}
