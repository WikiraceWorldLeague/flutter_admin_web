import 'package:flutter/material.dart';

/// 글로벌 룰에 따른 표준 에러 표시 위젯
/// SnackBar 대신 SelectableText.rich를 사용하여 에러 메시지를 표시
class ErrorDisplayWidget extends StatelessWidget {
  const ErrorDisplayWidget({
    super.key,
    required this.message,
    this.padding = const EdgeInsets.all(12.0),
    this.backgroundColor = const Color(0xFFFEF2F2),
    this.borderColor = const Color(0xFFFECACA),
    this.textColor = const Color(0xFFDC2626),
    this.fontSize = 14.0,
    this.showIcon = true,
  });

  final String message;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double fontSize;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon) ...[
            Icon(Icons.error_outline, color: textColor, size: fontSize + 2),
            const SizedBox(width: 8.0),
          ],
          Expanded(
            child: SelectableText.rich(
              TextSpan(
                text: message,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 성공 메시지용 위젯
class SuccessDisplayWidget extends StatelessWidget {
  const SuccessDisplayWidget({
    super.key,
    required this.message,
    this.padding = const EdgeInsets.all(12.0),
    this.backgroundColor = const Color(0xFFF0FDF4),
    this.borderColor = const Color(0xFFBBF7D0),
    this.textColor = const Color(0xFF16A34A),
    this.fontSize = 14.0,
    this.showIcon = true,
  });

  final String message;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double fontSize;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon) ...[
            Icon(
              Icons.check_circle_outline,
              color: textColor,
              size: fontSize + 2,
            ),
            const SizedBox(width: 8.0),
          ],
          Expanded(
            child: SelectableText.rich(
              TextSpan(
                text: message,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 인라인 에러 표시 위젯 (폼 필드용)
class InlineErrorWidget extends StatelessWidget {
  const InlineErrorWidget({
    super.key,
    required this.message,
    this.padding = const EdgeInsets.only(top: 4.0),
  });

  final String message;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: padding,
      child: SelectableText.rich(
        TextSpan(
          text: message,
          style: const TextStyle(
            color: Color(0xFFDC2626),
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

/// 임시 알림 위젯 (기존 SnackBar 대체용)
class NotificationOverlay extends StatefulWidget {
  const NotificationOverlay({
    super.key,
    required this.message,
    required this.isError,
    this.duration = const Duration(seconds: 3),
    this.onDismissed,
  });

  final String message;
  final bool isError;
  final Duration duration;
  final VoidCallback? onDismissed;

  @override
  State<NotificationOverlay> createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<NotificationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    // 자동 사라지기
    Future.delayed(widget.duration, () {
      if (mounted) _dismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget.onDismissed?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    widget.isError
                        ? const Color(0xFFFEF2F2)
                        : const Color(0xFFF0FDF4),
                border: Border.all(
                  color:
                      widget.isError
                          ? const Color(0xFFFECACA)
                          : const Color(0xFFBBF7D0),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.isError
                        ? Icons.error_outline
                        : Icons.check_circle_outline,
                    color:
                        widget.isError
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF16A34A),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SelectableText.rich(
                      TextSpan(
                        text: widget.message,
                        style: TextStyle(
                          color:
                              widget.isError
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF16A34A),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _dismiss,
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color:
                          widget.isError
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// SnackBar 대체 헬퍼 클래스
class NotificationHelper {
  static OverlayEntry? _currentOverlay;

  static void showError(BuildContext context, String message) {
    _showNotification(context, message, isError: true);
  }

  static void showSuccess(BuildContext context, String message) {
    _showNotification(context, message, isError: false);
  }

  static void _showNotification(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    // 기존 알림 제거
    _currentOverlay?.remove();

    _currentOverlay = OverlayEntry(
      builder:
          (context) => NotificationOverlay(
            message: message,
            isError: isError,
            onDismissed: () {
              _currentOverlay?.remove();
              _currentOverlay = null;
            },
          ),
    );

    Overlay.of(context).insert(_currentOverlay!);
  }

  static void dismiss() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}
