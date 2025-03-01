import 'dart:convert';

import 'package:flutter/material.dart';

import '../database/database.dart';
import '../models/workout_model.dart';
import '../widgets/meters_input_widget.dart';
import '../widgets/numeric_widget.dart';
import '../widgets/seconds_input_widget.dart';

class HardcodedWorkoutPage extends StatefulWidget {
  @override
  _HardcodedWorkoutPageState createState() => _HardcodedWorkoutPageState();
}

class _HardcodedWorkoutPageState extends State<HardcodedWorkoutPage> {
  final List<Exercise> exercises = [
    Exercise(
        name: 'Jumping Jacks',
        target: 50,
        actual: 0,
        unit: 'Reps',
        type: 'Reps'),
    Exercise(name: 'Lunges', target: 30, actual: 0, unit: 'Reps', type: 'Reps'),
    Exercise(
        name: 'Burpees', target: 20, actual: 0, unit: 'Reps', type: 'Reps'),
    Exercise(
        name: 'Wall Sit',
        target: 45,
        actual: 0,
        unit: 'Seconds',
        type: 'Seconds'),
    Exercise(
        name: 'Running',
        target: 800,
        actual: 0,
        unit: 'Meters',
        type: 'Meters'),
  ];

  final Map<int, int> actualOutputs = {}; // Stores user inputs

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
      name: "Hardcoded Workout",
      date: DateTime.now().toIso8601String(),
      exercises: jsonEncode(recordedExercises.map((e) => e.toJson()).toList()),
    );

    await database.workoutDao.insertWorkout(workout);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Workout Saved!")),
    );

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hardcoded Workout")),
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
