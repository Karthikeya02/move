import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:move/main.dart'; // Ensure the widget is imported
import '../models/workout_model.dart';
import '../widgets/meters_input_widget.dart';
import '../widgets/numeric_widget.dart';

class WorkoutRecordingPage extends StatefulWidget {
  @override
  _WorkoutRecordingPageState createState() => _WorkoutRecordingPageState();
}

class _WorkoutRecordingPageState extends State<WorkoutRecordingPage> {
  final List<Exercise> exercises = [
    Exercise('Push-ups', 'Reps'),
    Exercise('Running', 'Meters'),
    Exercise('Plank', 'Seconds'),
    Exercise('Squats', 'Reps'),
    Exercise('Cycling', 'Meters'),
    Exercise('Cardio', 'Seconds'),
  ];

  final Map<int, int> exerciseOutputs = {}; // Map to store inputs for each exercise

  void _saveWorkout() {
    final workout = Workout(
      date: DateTime.now().toString(),
      exercises: exercises
          .map((exercise) => ExerciseResult(
        exercise.name,
        exercise.type,
        exerciseOutputs[exercises.indexOf(exercise)] ?? 0,
      ))
          .toList(),
    );

    // Add workout to shared state using Provider
    Provider.of<WorkoutProvider>(context, listen: false).addWorkout(workout);

    // Navigate back to WorkoutHistoryPage after saving
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record Workout')),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the exercise name
                Text(exercise.name, style: TextStyle(fontSize: 18)),
                if (exercise.type == 'Meters')
                  MetersInputWidget(
                    onInputChanged: (value) {
                      exerciseOutputs[index] = value;
                    },
                  ),
                // Use NumericInputWidget for all types of input (seconds, meters, reps)
                if (exercise.type == 'Reps' || exercise.type == 'Seconds')
                  NumericInputWidget(
                    label: exercise.type,
                    initialValue: 0,
                    onInputChanged: (value) {
                      exerciseOutputs[index] = value;
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveWorkout,
        child: Icon(Icons.save),
      ),
    );
  }
}
