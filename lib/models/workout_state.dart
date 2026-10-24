enum TimerStatus {
  idle,       // Lifting / Preparing for set
  resting,    // Rest timer countdown active
  paused,     // Rest timer paused
  completed,  // Rest finished, ready for next set
}

class WorkoutState {
  String exerciseName;
  int currentSet;
  int targetSets;
  int totalCompletedSets;
  int restDurationSeconds;
  int remainingSeconds;
  TimerStatus status;
  DateTime sessionStartTime;

  WorkoutState({
    this.exerciseName = 'Bench Press',
    this.currentSet = 1,
    this.targetSets = 4,
    this.totalCompletedSets = 0,
    this.restDurationSeconds = 90,
    this.remainingSeconds = 90,
    this.status = TimerStatus.idle,
    DateTime? sessionStartTime,
  }) : sessionStartTime = sessionStartTime ?? DateTime.now();

  bool get isResting => status == TimerStatus.resting;
  bool get isPaused => status == TimerStatus.paused;
  bool get isCompleted => status == TimerStatus.completed;
  bool get isIdle => status == TimerStatus.idle;

  double get progress {
    if (restDurationSeconds <= 0) return 0.0;
    return (restDurationSeconds - remainingSeconds) / restDurationSeconds;
  }
}
