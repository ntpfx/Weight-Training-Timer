import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ExerciseSelectorModal extends StatefulWidget {
  final String currentExercise;
  final ValueChanged<String> onSelected;

  const ExerciseSelectorModal({
    super.key,
    required this.currentExercise,
    required this.onSelected,
  });

  static const List<String> commonExercises = [
    'Bench Press',
    'Incline Dumbbell Press',
    'Barbell Squat',
    'Deadlift',
    'Barbell Row',
    'Lat Pulldown',
    'Overhead Shoulder Press',
    'Dumbbell Lateral Raise',
    'Bicep Curl',
    'Tricep Pushdown',
    'Leg Press',
    'Romanian Deadlift',
    'Cable Fly',
    'Pull-Ups',
  ];

  @override
  State<ExerciseSelectorModal> createState() => _ExerciseSelectorModalState();
}

class _ExerciseSelectorModalState extends State<ExerciseSelectorModal> {
  late TextEditingController _customController;

  @override
  void initState() {
    super.initState();
    _customController = TextEditingController();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _submitCustom() {
    final text = _customController.text.trim();
    if (text.isNotEmpty) {
      widget.onSelected(text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Exercise (เลือกท่าฝึก)',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Custom Input Box
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Or enter custom exercise name...',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.surfaceCard,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.electricCyan),
                    ),
                  ),
                  onSubmitted: (_) => _submitCustom(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _submitCustom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.electricCyan,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                child: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // List of common exercises
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: ExerciseSelectorModal.commonExercises.length,
              separatorBuilder: (_, __) => const Divider(color: AppColors.border, height: 1),
              itemBuilder: (context, index) {
                final exercise = ExerciseSelectorModal.commonExercises[index];
                final isSelected = exercise == widget.currentExercise;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  title: Text(
                    exercise,
                    style: TextStyle(
                      color: isSelected ? AppColors.electricCyan : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.electricCyan)
                      : null,
                  onTap: () {
                    widget.onSelected(exercise);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
