import 'package:flutter/material.dart';
import 'package:move/widgets/seconds_input_widget.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/workout_model.dart';
import '../score_widget.dart';
import '../widgets/meters_input_widget.dart';
import '../widgets/numeric_widget.dart';
import 'dart:core';
import 'dart:convert';

class WorkoutRecordingPage extends StatefulWidget {
  const WorkoutRecordingPage({super.key});

  @override
  _WorkoutRecordingPageState createState() => _WorkoutRecordingPageState();
}

class _WorkoutRecordingPageState extends State<WorkoutRecordingPage> {
  final List<Exercise> exercises = [
    Exercise(name: 'Push-ups', target: 20, actual: 0, unit: 'Reps', type: 'Reps'),
    Exercise(name: 'Squats', target: 30, actual: 0, unit: 'Reps', type: 'Reps'),
    Exercise(name: 'Plank', target: 60, actual: 0, unit: 'Seconds', type: 'Seconds'),
    Exercise(name: 'Running', target: 1000, actual: 0, unit: 'Meters', type: 'Meters'),
    Exercise(name: 'Cycling', target: 5000, actual: 0, unit: 'Meters', type: 'Meters'),
    Exercise(name: 'Swimming', target: 500, actual: 0, unit: 'Meters', type: 'Meters'),
    Exercise(name: 'Surfing', target: 200, actual: 0, unit: 'Meters', type: 'Meters'),
  ];

  final Map<int, int> actualOutputs = {}; // Stores actual user inputs

  /// **Saves the recorded workout and updates the global state**
  void _saveWorkout() {
    final recordedExercises = exercises.map((exercise) {
      final actualValue = actualOutputs[exercises.indexOf(exercise)] ?? 0;
      return Exercise(
        name: exercise.name,
        target: exercise.target, // Keep original target
        actual: actualValue, // Store the actual user input
        unit: exercise.unit,
        type: exercise.type,
      );
    }).toList();

    final workout = Workout(
      name: "Recorded Workout", // Default name for recorded workouts
      date: DateTime.now().toIso8601String(),
      exercises: jsonEncode(recordedExercises.map((e) => e.toJson()).toList()), // Store as JSON string
    );

    // Save workout to state
    Provider.of<WorkoutProvider>(context, listen: false).addWorkout(workout);

    // Navigate back
    Navigator.pop(context);
  }

  /// **Displays the ScoreWidget in a bottom sheet**
  void _showScore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(10),
        child: ScoreWidget(), // Removed 'const' because ScoreWidget might have non-constant values
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Workout')),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  "Target: ${exercise.target} ${exercise.unit}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                _buildInputWidget(index, exercise.type),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () => _showScore(context),
            icon: const Icon(Icons.bar_chart),
            label: const Text("View Score"),
            backgroundColor: Colors.blueAccent,
          ),
          const SizedBox(height: 10), // Spacing between buttons
          FloatingActionButton(
            onPressed: _saveWorkout,
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  /// **Returns the appropriate input widget based on exercise type**
  Widget _buildInputWidget(int index, String type) {
    if (type == 'Meters') {
      return MetersInputWidget(
        onInputChanged: (value) => setState(() => actualOutputs[index] = value),
      );
    } else if (type == 'Seconds') {
      return SecondsInputWidget(
        onInputChanged: (value) => setState(() => actualOutputs[index] = value),
      );
    }
    return NumericInputWidget(
      label: type,
      initialValue: 0,
      onInputChanged: (value) => setState(() => actualOutputs[index] = value),
    );
  }
}
