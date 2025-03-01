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
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Total Exercises: $totalExercises",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
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
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      title: Text(
                        exercise.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Target: ${exercise.target} ${exercise.unit}, Completed: ${exercise.actual} ${exercise.unit}',
                      ),
                      trailing: exercise.actual >= exercise.target
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.cancel, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            _buildGradientButton(context),
          ],
        ),
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

  Widget _buildGradientButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: InkWell(
        onTap: () => _showScore(context),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.orangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'View Score',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
