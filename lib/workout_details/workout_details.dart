import 'package:flutter/material.dart';
import 'package:move/score_widget.dart';
import '../models/workout_model.dart'; // Import your workout model to access Workout and ExerciseResult classes

class WorkoutDetails extends StatelessWidget {
  final Workout workout;

  // Constructor to receive the workout from the previous page
  WorkoutDetails(this.workout);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Details'),
      ),
      body: Column(
        children: [
          // ListView.builder to display the exercises
          Expanded(
            child: ListView.builder(
              itemCount: workout.exercises.length,
              itemBuilder: (context, index) {
                final exercise = workout.exercises[index];
                return ListTile(
                  title: Text(exercise.name),
                  subtitle: Text('Output: ${workout.exerciseResults[index].output} ${exercise.type}'),
                );
              },
            ),
          ),
          // Button to show the performance score in a modal
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _showScore(context), // Show bottom sheet when pressed
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
