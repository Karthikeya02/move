import 'package:flutter/material.dart';
import 'package:move/workout_details/add_workout_page.dart';
import 'package:move/workout_details/download_workout_page.dart';
import 'package:move/workout_details/workout_recording_page.dart';
import 'package:provider/provider.dart';

import 'models/workout_model.dart'; // Import workout model
import 'workout_details/workout_history_page.dart'; // Import the workout history page

void main() => runApp(MyApp());

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
        // Define initial route
        routes: {
          '/': (context) => WorkoutHistoryPage(),
          '/add_workout': (context) => AddWorkoutPage(),
          '/download_workout': (context) => DownloadWorkoutPage(),
          '/workout_history': (context) => WorkoutHistoryPage(),
          '/workout_recording': (context) => WorkoutRecordingPage(),


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
