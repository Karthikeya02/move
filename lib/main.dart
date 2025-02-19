import 'package:flutter/material.dart';
import 'package:move/workout_details/hardcode_workout_plan.dart';
import 'package:provider/provider.dart';
import 'models/workout_model.dart'; // Import workout model
import 'database/database.dart';
import 'workout_details/add_workout_page.dart';
import 'workout_details/download_workout_page.dart';
import 'workout_details/workout_history_page.dart';
import 'workout_details/workout_recording_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkoutProvider(),
      child: MaterialApp(
        title: 'Move',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.pinkAccent, // AppBar color
            titleTextStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => WorkoutHistoryPage(),
          '/add_workout': (context) => AddWorkoutPage(),
          '/download_workout': (context) => DownloadWorkoutPage(),
          '/workout_history': (context) => WorkoutHistoryPage(),
          '/hardcoded_workout': (context) => HardcodedWorkoutPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/workout_recording') {
            final args = settings.arguments as WorkoutPlan;
            return MaterialPageRoute(
              builder: (context) => WorkoutRecordingPage(workoutPlan: args),
            );
          }
          return null;
        },
      ),
    );
  }
}

class WorkoutProvider with ChangeNotifier {
  final List<Workout> _workouts = [];

  List<Workout> get workouts => _workouts;

  void addWorkout(Workout workout) {
    _workouts.add(workout);
    notifyListeners();
  }
}
