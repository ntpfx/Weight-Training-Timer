import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class PresetChips extends StatelessWidget {
  final int currentRestSeconds;
  final ValueChanged<int> onSelectPreset;

  const PresetChips({
    super.key,
    required this.currentRestSeconds,
    required this.onSelectPreset,
  });

  static const List<int> presets = [30, 45, 60, 90, 120, 180];

  String _formatLabel(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final mins = seconds ~/ 60;
    final remaining = seconds % 60;
    if (remaining == 0) return '${mins}m';
    return '${mins}m ${remaining}s';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: presets.map((seconds) {
          final isSelected = seconds == currentRestSeconds;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_formatLabel(seconds)),
              selected: isSelected,
              onSelected: (_) => onSelectPreset(seconds),
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 14,
              ),
              selectedColor: AppColors.electricCyan,
              backgroundColor: AppColors.surfaceCard,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? AppColors.electricCyan : AppColors.border,
                  width: 1.5,
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}
