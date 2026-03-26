import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ManaPoolMode { normal, lock, convert }

/// A tile widget for displaying and adjusting a single mana color's count
class ManaTile extends StatefulWidget {
  final String colorSymbol;
  final String colorName;
  final Color backgroundColor;
  final int value;
  final bool isLocked;
  final ManaPoolMode mode;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onIncrementLarge;
  final VoidCallback onDecrementLarge;
  final VoidCallback onToggleLock;
  final VoidCallback onConvert;

  const ManaTile({
    super.key,
    required this.colorSymbol,
    required this.colorName,
    required this.backgroundColor,
    required this.value,
    required this.isLocked,
    required this.mode,
    required this.onIncrement,
    required this.onDecrement,
    required this.onIncrementLarge,
    required this.onDecrementLarge,
    required this.onToggleLock,
    required this.onConvert,
  });

  @override
  State<ManaTile> createState() => _ManaTileState();
}

class _ManaTileState extends State<ManaTile> {
  Timer? _repeatTimer;

  @override
  void dispose() {
    _repeatTimer?.cancel();
    super.dispose();
  }

  Color get _textColor {
    return widget.backgroundColor.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;
  }

  Color get _secondaryTextColor {
    return widget.backgroundColor.computeLuminance() > 0.5
        ? Colors.black54
        : Colors.white70;
  }

  String _formatCount(int value) {
    if (value < 10000) return value.toString();
    if (value < 1000000) return '${value ~/ 1000}k';
    return '${(value / 1000000).toStringAsFixed(1)}m';
  }

  void _startLongPress(VoidCallback action) {
    action();
    HapticFeedback.mediumImpact();
    // First repeat after 1 second, then every 500ms after that
    _repeatTimer = Timer(const Duration(seconds: 1), () {
      action();
      HapticFeedback.mediumImpact();
      _repeatTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
        action();
        HapticFeedback.mediumImpact();
      });
    });
  }

  void _stopLongPress() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  BoxDecoration get _tileDecoration {
    return BoxDecoration(
      color: widget.backgroundColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: widget.isLocked
            ? Colors.amber
            : Colors.black26,
        width: widget.isLocked ? 2.5 : 1,
      ),
      boxShadow: [
        // Base drop shadow for raised feel
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
        // Locked glow
        if (widget.isLocked)
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.6),
            blurRadius: 10,
            spreadRadius: 1,
          ),
      ],
    );
  }

  Widget _buildNormalMode() {
    return Stack(
      children: [
        // Left and right tap zones
        Row(
          children: [
            // Left tap zone (decrement)
            Expanded(
              child: GestureDetector(
                onLongPressStart: (_) =>
                    _startLongPress(widget.onDecrementLarge),
                onLongPressEnd: (_) => _stopLongPress(),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.value > 0 ? widget.onDecrement : null,
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
            // Right tap zone (increment)
            Expanded(
              child: GestureDetector(
                onLongPressStart: (_) =>
                    _startLongPress(widget.onIncrementLarge),
                onLongPressEnd: (_) => _stopLongPress(),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onIncrement,
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Visual overlay
        Positioned.fill(
          child: IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mana symbol top-left
                  Text(
                    widget.colorSymbol,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _secondaryTextColor,
                    ),
                  ),
                  // Big centered number
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _formatCount(widget.value),
                          style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLockMode() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onToggleLock,
        child: Center(
          child: Icon(
            widget.isLocked ? Icons.lock : Icons.lock_open,
            size: 48,
            color: _textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildConvertMode() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onConvert,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Convert to\n${widget.colorName}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _tileDecoration,
      clipBehavior: Clip.antiAlias,
      child: switch (widget.mode) {
        ManaPoolMode.normal => _buildNormalMode(),
        ManaPoolMode.lock => _buildLockMode(),
        ManaPoolMode.convert => _buildConvertMode(),
      },
    );
  }
}
