import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SetCounterCard extends StatelessWidget {
  final int currentSet;
  final int targetSets;
  final int totalSessionSets;
  final VoidCallback onIncrementSet;
  final VoidCallback onDecrementSet;
  final VoidCallback onChangeTarget;

  const SetCounterCard({
    super.key,
    required this.currentSet,
    required this.targetSets,
    required this.totalSessionSets,
    required this.onIncrementSet,
    required this.onDecrementSet,
    required this.onChangeTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Current Set details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'CURRENT SET',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: onChangeTarget,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Target: ${targetSets > 0 ? targetSets : "∞"}',
                        style: const TextStyle(
                          color: AppColors.electricCyan,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$currentSet',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (targetSets > 0)
                    Text(
                      ' / $targetSets',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Right: Manual Step Adjuster & Total
          Row(
            children: [
              // Decrement Set
              _ActionButton(
                icon: Icons.remove,
                onPressed: onDecrementSet,
                enabled: currentSet > 1,
              ),
              const SizedBox(width: 8),
              // Increment Set
              _ActionButton(
                icon: Icons.add,
                onPressed: onIncrementSet,
                enabled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool enabled;

  const _ActionButton({
    required this.icon,
    required this.onPressed,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColors.surfaceLight : AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled ? AppColors.border : AppColors.surfaceLight,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: enabled ? AppColors.textPrimary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
