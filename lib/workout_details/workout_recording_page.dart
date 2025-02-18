import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

import '../database/database.dart';
import '../models/workout_model.dart';
import '../widgets/meters_input_widget.dart';
import '../widgets/numeric_widget.dart';
import '../widgets/seconds_input_widget.dart';

class WorkoutRecordingPage extends StatefulWidget {
  const WorkoutRecordingPage({super.key});

  @override
  _WorkoutRecordingPageState createState() => _WorkoutRecordingPageState();
}

class _WorkoutRecordingPageState extends State<WorkoutRecordingPage> {
  final List<Exercise> exercises = [
    Exercise(
        name: 'Push-ups', target: 20, actual: 0, unit: 'Reps', type: 'Reps'),
    Exercise(name: 'Squats', target: 30, actual: 0, unit: 'Reps', type: 'Reps'),
    Exercise(
        name: 'Plank', target: 60, actual: 0, unit: 'Seconds', type: 'Seconds'),
    Exercise(
        name: 'Running',
        target: 1000,
        actual: 0,
        unit: 'Meters',
        type: 'Meters'),
    Exercise(
        name: 'Cycling',
        target: 5000,
        actual: 0,
        unit: 'Meters',
        type: 'Meters'),
    Exercise(
        name: 'Swimming',
        target: 500,
        actual: 0,
        unit: 'Meters',
        type: 'Meters'),
    Exercise(
        name: 'Surfing',
        target: 200,
        actual: 0,
        unit: 'Meters',
        type: 'Meters'),
  ];

  final Map<int, int> actualOutputs = {}; // Stores actual user inputs

  void _saveWorkout() async {
    final database = await getDatabase();

    final recordedExercises = exercises.map((exercise) {
      final actualValue = actualOutputs[exercises.indexOf(exercise)] ?? 0;
      return Exercise(
        name: exercise.name,
        target: exercise.target,
        actual: actualValue,
        unit: exercise.unit,
        type: exercise.type,
      );
    }).toList();

    final workout = Workout(
      name: "Recorded Workout",
      date: DateTime.now().toIso8601String(),
      exercises: jsonEncode(recordedExercises.map((e) => e.toJson()).toList()),
    );

    await database.workoutDao.insertWorkout(workout);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Workout Saved!")),
    );

    Navigator.pushReplacementNamed(context, '/'); // Redirect to history page
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveWorkout,
        icon: const Icon(Icons.save),
        label: const Text("Save"),
        backgroundColor: Colors.green,
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
