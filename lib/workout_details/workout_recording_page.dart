import 'dart:convert';

import 'package:flutter/material.dart';

import '../database/database.dart';
import '../models/workout_model.dart';
import '../widgets/meters_input_widget.dart';
import '../widgets/numeric_widget.dart';
import '../widgets/seconds_input_widget.dart';

class WorkoutRecordingPage extends StatefulWidget {
  final WorkoutPlan workoutPlan;

  const WorkoutRecordingPage({required this.workoutPlan, super.key});

  @override
  _WorkoutRecordingPageState createState() => _WorkoutRecordingPageState();
}

class _WorkoutRecordingPageState extends State<WorkoutRecordingPage> {
  late List<Exercise> exercises;
  final Map<int, int> actualOutputs = {};

  @override
  void initState() {
    super.initState();
    exercises = (jsonDecode(widget.workoutPlan.exercises) as List)
        .map((e) => Exercise.fromJson(e))
        .toList();
  }

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
      name: widget.workoutPlan.name,
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
      appBar: AppBar(title: Text(widget.workoutPlan.name)),
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
                _buildInputWidget(index, exercise.unit),
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
    switch (type) {
      case 'meters':
        return MetersInputWidget(
          onInputChanged: (value) =>
              setState(() => actualOutputs[index] = value),
        );
      case 'seconds':
        return SecondsInputWidget(
          onInputChanged: (value) =>
              setState(() => actualOutputs[index] = value),
        );
      case 'reps':
      default:
        return NumericInputWidget(
          label: type,
          initialValue: 0,
          onInputChanged: (value) =>
              setState(() => actualOutputs[index] = value),
        );
    }
  }
}
