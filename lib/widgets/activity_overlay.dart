import 'package:flutter/material.dart';

class ActivityOverlay {
  bool _isVisible = false;

  BuildContext context;
  Widget child;

  OverlayState overlayState;
  OverlayEntry overlayEntry;

  ActivityOverlay(BuildContext context, Widget child) {
    this.context = context;
    this.overlayState = Overlay.of(this.context);
    this.overlayEntry = OverlayEntry(
      builder: (context) => child,
    );
  }

  void show() async {
    if (_isVisible) return;

    _isVisible = true;

    this.overlayState.insert(overlayEntry);
  }

  bool isVisible() => this._isVisible;

  void remove() async {
    if (!_isVisible) return;

    _isVisible = false;

    this.overlayEntry.remove();
  }
}
