import 'package:flutter/material.dart';

import '../models/workout_model.dart';
import '../score_widget.dart';

class WorkoutDetailsPage extends StatelessWidget {
  final Workout workout;

  WorkoutDetailsPage({required this.workout});

  @override
  Widget build(BuildContext context) {
    List<Exercise> exercises = workout.getExerciseList();

    int totalExercises = exercises.length;
    int completedExercises = exercises
        .where((exercise) => exercise.actual >= exercise.target)
        .length;
    int incompleteExercises = totalExercises - completedExercises;

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Details'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Total Workouts: $totalExercises",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Completed: $completedExercises",
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
                Text(
                  "Incomplete: $incompleteExercises",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return ListTile(
                  title: Text(exercise.name),
                  subtitle: Text(
                      'Target: ${exercise.target} ${exercise.unit}, Completed: ${exercise.actual} ${exercise.unit}'),
                  trailing: exercise.actual >= exercise.target
                      ? Icon(Icons.check_circle, color: Colors.green)
                      : Icon(Icons.cancel, color: Colors.red),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _showScore(context),
              child: Text('View Score'),
            ),
          ),
        ],
      ),
    );
  }

  void _showScore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(10),
        child: ScoreWidget(),
      ),
    );
  }
}
