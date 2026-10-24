import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/workout_state.dart';

class CircularTimer extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final TimerStatus status;
  final VoidCallback onAdd15s;
  final VoidCallback onMinus15s;

  const CircularTimer({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.status,
    required this.onAdd15s,
    required this.onMinus15s,
  });

  Color _getPrimaryColor() {
    switch (status) {
      case TimerStatus.idle:
        return AppColors.border;
      case TimerStatus.resting:
      case TimerStatus.paused:
        if (remainingSeconds <= 3) {
          return AppColors.urgentRed;
        } else if (remainingSeconds <= 10) {
          return AppColors.neonOrange;
        }
        return AppColors.electricCyan;
      case TimerStatus.completed:
        return AppColors.neonGreen;
    }
  }

  String _formatTime(int seconds) {
    if (seconds < 0) seconds = 0;
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _getStatusText() {
    switch (status) {
      case TimerStatus.idle:
        return 'LIFTING / READY';
      case TimerStatus.resting:
        if (remainingSeconds <= 3) return 'GET READY!';
        return 'RESTING';
      case TimerStatus.paused:
        return 'PAUSED';
      case TimerStatus.completed:
        return 'TIME TO LIFT!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _getPrimaryColor();
    final double progress = totalSeconds > 0
        ? ((totalSeconds - remainingSeconds) / totalSeconds).clamp(0.0, 1.0)
        : 0.0;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow for intensity
          if (status == TimerStatus.resting && remainingSeconds <= 3)
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.urgentRed.withOpacity(0.35),
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
              ),
            )
          else if (status == TimerStatus.completed)
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGreen.withOpacity(0.35),
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),

          // Custom Circular Progress Ring
          SizedBox(
            width: 260,
            height: 260,
            child: CustomPaint(
              painter: _TimerRingPainter(
                progress: status == TimerStatus.idle ? 0.0 : progress,
                trackColor: AppColors.surfaceLight,
                progressColor: activeColor,
                isCompleted: status == TimerStatus.completed,
              ),
            ),
          ),

          // Inner Content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: activeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: activeColor.withOpacity(0.3)),
                ),
                child: Text(
                  _getStatusText(),
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Giant Countdown Text
              Text(
                status == TimerStatus.idle
                    ? _formatTime(totalSeconds)
                    : _formatTime(remainingSeconds),
                style: TextStyle(
                  fontSize: 58,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: (status == TimerStatus.resting && remainingSeconds <= 3)
                      ? AppColors.urgentRed
                      : (status == TimerStatus.completed
                          ? AppColors.neonGreen
                          : AppColors.textPrimary),
                ),
              ),

              const SizedBox(height: 8),

              // Quick Adjust +/- 15s during rest
              if (status == TimerStatus.resting || status == TimerStatus.paused)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MiniAdjustButton(
                      label: '-15s',
                      onPressed: onMinus15s,
                    ),
                    const SizedBox(width: 14),
                    _MiniAdjustButton(
                      label: '+15s',
                      onPressed: onAdd15s,
                    ),
                  ],
                )
              else
                Text(
                  'Default Rest: ${totalSeconds}s',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniAdjustButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _MiniAdjustButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final bool isCompleted;

  _TimerRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.isCompleted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;
    const strokeWidth = 14.0;

    // Background Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Active Progress Arc
    final activePaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (isCompleted) {
      canvas.drawCircle(center, radius, activePaint);
      return;
    }

    if (progress > 0) {
      const startAngle = -pi / 2;
      final sweepAngle = 2 * pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.isCompleted != isCompleted;
  }
}
