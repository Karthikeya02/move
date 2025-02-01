import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/workout_model.dart'; // Import workout model
import 'workout_details/workout_history_page.dart'; // Import the workout history page // Import the workout recording page

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
          primarySwatch: Colors.deepPurple,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.deepOrangeAccent, //AppBar teal color
            titleTextStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        home: WorkoutHistoryPage(),
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
