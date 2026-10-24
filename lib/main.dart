import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/app_colors.dart';
import 'screens/workout_timer_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Gym apps are best locked in portrait for one-handed thumb use
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Make system navigation & status bar seamlessly dark
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const IronPaceApp());
}

class IronPaceApp extends StatelessWidget {
  const IronPaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IronPace Gym Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.electricCyan,
          secondary: AppColors.neonGreen,
          surface: AppColors.surface,
          error: AppColors.urgentRed,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const WorkoutTimerScreen(),
    );
  }
}
