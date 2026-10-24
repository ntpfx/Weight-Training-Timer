import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../constants/app_colors.dart';
import '../models/workout_state.dart';
import '../services/audio_service.dart';
import '../services/haptic_service.dart';
import '../widgets/circular_timer.dart';
import '../widgets/preset_chips.dart';
import '../widgets/set_counter_card.dart';
import '../widgets/exercise_selector_modal.dart';

class WorkoutTimerScreen extends StatefulWidget {
  const WorkoutTimerScreen({super.key});

  @override
  State<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
  final AudioService _audioService = AudioService();
  late WorkoutState _state;

  Timer? _restTimer;
  Timer? _sessionTimer;
  Duration _sessionDuration = Duration.zero;
  bool _screenWakeLockEnabled = true;

  @override
  void initState() {
    super.initState();
    _state = WorkoutState();
    _initWakeLock();
    _startSessionTimer();
  }

  void _initWakeLock() async {
    try {
      await WakelockPlus.enable();
      setState(() => _screenWakeLockEnabled = true);
    } catch (_) {}
  }

  void _toggleWakeLock() async {
    try {
      if (_screenWakeLockEnabled) {
        await WakelockPlus.disable();
        setState(() => _screenWakeLockEnabled = false);
      } else {
        await WakelockPlus.enable();
        setState(() => _screenWakeLockEnabled = true);
      }
    } catch (_) {}
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _sessionDuration = DateTime.now().difference(_state.sessionStartTime);
        });
      }
    });
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    _sessionTimer?.cancel();
    try {
      WakelockPlus.disable();
    } catch (_) {}
    super.dispose();
  }

  // Timer Control
  void _startRestTimer() {
    _restTimer?.cancel();
    setState(() {
      _state.remainingSeconds = _state.restDurationSeconds;
      _state.status = TimerStatus.resting;
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_state.remainingSeconds > 1) {
        setState(() {
          _state.remainingSeconds--;
        });

        // Countdown alert at 3, 2, 1
        if (_state.remainingSeconds <= 3) {
          _audioService.playCountdownBeep();
          HapticService.countdownTick();
        }
      } else {
        // Rest complete!
        timer.cancel();
        setState(() {
          _state.remainingSeconds = 0;
          _state.status = TimerStatus.completed;
        });
        _audioService.playFinishBeep();
        HapticService.timerFinished();
      }
    });
  }

  void _pauseRestTimer() {
    _restTimer?.cancel();
    setState(() {
      _state.status = TimerStatus.paused;
    });
    HapticService.light();
  }

  void _resumeRestTimer() {
    if (_state.remainingSeconds <= 0) return;
    setState(() {
      _state.status = TimerStatus.resting;
    });
    HapticService.light();

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_state.remainingSeconds > 1) {
        setState(() {
          _state.remainingSeconds--;
        });

        if (_state.remainingSeconds <= 3) {
          _audioService.playCountdownBeep();
          HapticService.countdownTick();
        }
      } else {
        timer.cancel();
        setState(() {
          _state.remainingSeconds = 0;
          _state.status = TimerStatus.completed;
        });
        _audioService.playFinishBeep();
        HapticService.timerFinished();
      }
    });
  }

  void _skipRestTimer() {
    _restTimer?.cancel();
    setState(() {
      _state.remainingSeconds = 0;
      _state.status = TimerStatus.idle;
    });
    HapticService.medium();
  }

  void _onCompleteSetAndRest() {
    HapticService.heavy();
    setState(() {
      _state.totalCompletedSets++;
      _state.currentSet++;
    });
    _startRestTimer();
  }

  void _add15s() {
    HapticService.light();
    setState(() {
      _state.remainingSeconds += 15;
    });
  }

  void _minus15s() {
    HapticService.light();
    setState(() {
      if (_state.remainingSeconds > 15) {
        _state.remainingSeconds -= 15;
      } else {
        _state.remainingSeconds = 1;
      }
    });
  }

  void _onSelectPreset(int seconds) {
    HapticService.light();
    setState(() {
      _state.restDurationSeconds = seconds;
      if (_state.isIdle) {
        _state.remainingSeconds = seconds;
      }
    });
  }

  void _openExerciseSelector() {
    HapticService.light();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExerciseSelectorModal(
        currentExercise: _state.exerciseName,
        onSelected: (name) {
          setState(() {
            _state.exerciseName = name;
            _state.currentSet = 1;
            _restTimer?.cancel();
            _state.status = TimerStatus.idle;
            _state.remainingSeconds = _state.restDurationSeconds;
          });
        },
      ),
    );
  }

  void _changeTargetSets() {
    HapticService.light();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text(
          'Target Sets',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [3, 4, 5, 6, 0].map((num) {
            final label = num == 0 ? 'No Target (∞)' : '$num Sets';
            return ListTile(
              title: Text(label, style: const TextStyle(color: AppColors.textPrimary)),
              trailing: _state.targetSets == num
                  ? const Icon(Icons.check, color: AppColors.electricCyan)
                  : null,
              onTap: () {
                setState(() => _state.targetSets = num);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _resetWorkoutSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text(
          'Reset Workout?',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'This will reset your current set count and total session stats.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.urgentRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _restTimer?.cancel();
              setState(() {
                _state = WorkoutState(
                  exerciseName: _state.exerciseName,
                  restDurationSeconds: _state.restDurationSeconds,
                  targetSets: _state.targetSets,
                );
                _sessionDuration = Duration.zero;
              });
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  String _formatSessionDuration(Duration d) {
    final hours = d.inHours;
    final mins = d.inMinutes % 60;
    final secs = d.inSeconds % 60;
    if (hours > 0) {
      return '${hours}h ${mins.toString().padLeft(2, '0')}m';
    }
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isTargetReached = _state.targetSets > 0 && _state.currentSet > _state.targetSets;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: InkWell(
          onTap: _openExerciseSelector,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.fitness_center, size: 16, color: AppColors.electricCyan),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 160),
                  child: Text(
                    _state.exerciseName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary, size: 20),
              ],
            ),
          ),
        ),
        actions: [
          // Screen WakeLock Button
          IconButton(
            tooltip: _screenWakeLockEnabled ? 'Screen Stays On' : 'Screen Timeout Normal',
            icon: Icon(
              _screenWakeLockEnabled ? Icons.wb_incandescent : Icons.wb_incandescent_outlined,
              color: _screenWakeLockEnabled ? AppColors.neonOrange : AppColors.textMuted,
            ),
            onPressed: _toggleWakeLock,
          ),
          // Audio Mute/Unmute
          IconButton(
            tooltip: _audioService.isMuted ? 'Unmute Sound' : 'Mute Sound',
            icon: Icon(
              _audioService.isMuted ? Icons.volume_off : Icons.volume_up,
              color: _audioService.isMuted ? AppColors.textMuted : AppColors.electricCyan,
            ),
            onPressed: () {
              setState(() {
                _audioService.toggleMute();
              });
            },
          ),
          // Reset Session
          IconButton(
            tooltip: 'Reset Workout',
            icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
            onPressed: _resetWorkoutSession,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Top Set Counter Card
            SetCounterCard(
              currentSet: _state.currentSet,
              targetSets: _state.targetSets,
              totalSessionSets: _state.totalCompletedSets,
              onIncrementSet: () {
                HapticService.light();
                setState(() => _state.currentSet++);
              },
              onDecrementSet: () {
                HapticService.light();
                setState(() {
                  if (_state.currentSet > 1) _state.currentSet--;
                });
              },
              onChangeTarget: _changeTargetSets,
            ),

            if (isTargetReached)
              Container(
                margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.neonGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: AppColors.neonGreen, size: 18),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Target sets completed! Ready for next exercise.',
                        style: TextStyle(
                          color: AppColors.neonGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _openExerciseSelector,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 24),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Next ➜', style: TextStyle(color: AppColors.neonGreen)),
                    ),
                  ],
                ),
              ),

            // Center Circular Timer
            Expanded(
              child: Center(
                child: CircularTimer(
                  remainingSeconds: _state.remainingSeconds,
                  totalSeconds: _state.restDurationSeconds,
                  status: _state.status,
                  onAdd15s: _add15s,
                  onMinus15s: _minus15s,
                ),
              ),
            ),

            // Rest Presets Selector (30s, 60s, 90s, 120s...)
            PresetChips(
              currentRestSeconds: _state.restDurationSeconds,
              onSelectPreset: _onSelectPreset,
            ),

            const SizedBox(height: 16),

            // Primary Bottom Action Bar (Massive Tappable Gym Buttons)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildActionButtons(),
            ),

            const SizedBox(height: 12),

            // Bottom Session Summary Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: AppColors.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        'Session: ${_formatSessionDuration(_sessionDuration)}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.done_all, size: 16, color: AppColors.electricCyan),
                      const SizedBox(width: 6),
                      Text(
                        'Total: ${_state.totalCompletedSets} sets',
                        style: const TextStyle(
                          color: AppColors.electricCyan,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (_state.status == TimerStatus.resting) {
      return Row(
        children: [
          // Pause / Resume
          Expanded(
            child: SizedBox(
              height: 64,
              child: OutlinedButton.icon(
                onPressed: _pauseRestTimer,
                icon: const Icon(Icons.pause, size: 24),
                label: const Text(
                  'PAUSE',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Skip Rest (Lift Now)
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 64,
              child: ElevatedButton.icon(
                onPressed: _skipRestTimer,
                icon: const Icon(Icons.fast_forward, size: 24),
                label: const Text(
                  'LIFT NOW (SKIP)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceLight,
                  foregroundColor: AppColors.electricCyan,
                  elevation: 0,
                  side: const BorderSide(color: AppColors.electricCyan, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (_state.status == TimerStatus.paused) {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 64,
              child: ElevatedButton.icon(
                onPressed: _resumeRestTimer,
                icon: const Icon(Icons.play_arrow, size: 26),
                label: const Text(
                  'RESUME',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonOrange,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 64,
              child: OutlinedButton.icon(
                onPressed: _skipRestTimer,
                icon: const Icon(Icons.skip_next, size: 24),
                label: const Text(
                  'SKIP REST',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // IDLE or COMPLETED: Giant "COMPLETE SET & REST" button
    return SizedBox(
      width: double.infinity,
      height: 68,
      child: ElevatedButton(
        onPressed: _onCompleteSetAndRest,
        style: ElevatedButton.styleFrom(
          backgroundColor: _state.status == TimerStatus.completed
              ? AppColors.neonGreen
              : AppColors.electricCyan,
          foregroundColor: Colors.black,
          elevation: 8,
          shadowColor: (_state.status == TimerStatus.completed
                  ? AppColors.neonGreen
                  : AppColors.electricCyan)
              .withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, size: 28),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _state.status == TimerStatus.completed
                      ? 'FINISH SET & REST AGAIN'
                      : 'COMPLETE SET & REST',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Log Set ${_state.currentSet} ➔ Rest ${_state.restDurationSeconds}s',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xCC000000),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
