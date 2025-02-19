import 'dart:convert';

import 'package:flutter/material.dart';

import '../database/database.dart';
import '../models/workout_model.dart';

class CustomizeWorkoutPage extends StatefulWidget {
  final WorkoutPlan plan;

  CustomizeWorkoutPage({required this.plan});

  @override
  _CustomizeWorkoutPageState createState() => _CustomizeWorkoutPageState();
}

class _CustomizeWorkoutPageState extends State<CustomizeWorkoutPage> {
  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    final List<Map<String, dynamic>> exercisesList =
        List<Map<String, dynamic>>.from(jsonDecode(widget.plan.exercises));

    for (var exercise in exercisesList) {
      controllers[exercise['name']] = TextEditingController();
    }
  }

  void saveToHistory() async {
    final database = await getDatabase();

    final List<Map<String, dynamic>> exercisesList =
        List<Map<String, dynamic>>.from(jsonDecode(widget.plan.exercises));

    final List<Exercise> customizedExercises = exercisesList.map((exercise) {
      return Exercise(
        name: exercise['name'],
        target: exercise['target'],
        actual: int.tryParse(controllers[exercise['name']]?.text ?? "0") ?? 0,
        unit: exercise['unit'],
        type: exercise['type'],
      );
    }).toList();

    final workout = Workout(
      name: widget.plan.name,
      date: DateTime.now().toIso8601String(),
      exercises:
          jsonEncode(customizedExercises.map((e) => e.toJson()).toList()),
    );

    await database.workoutDao.insertWorkout(workout);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Workout Saved to History!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> exercisesList =
        List<Map<String, dynamic>>.from(jsonDecode(widget.plan.exercises));

    return Scaffold(
      appBar: AppBar(title: Text("Customize ${widget.plan.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (var exercise in exercisesList) ...[
              Text(
                  "${exercise['name']} (Target: ${exercise['target']} ${exercise['unit']})"),
              TextField(
                controller: controllers[exercise['name']],
                decoration: InputDecoration(
                  labelText: "Enter ${exercise['name']} actual value",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
            ],
            ElevatedButton(
              onPressed: saveToHistory,
              child: const Text("Save to Workout History"),
            ),
          ],
        ),
      ),
    );
  }
}
