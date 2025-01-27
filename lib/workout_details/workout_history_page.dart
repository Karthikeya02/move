import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:move/workout_details/workout_recording_page.dart';
import '../main.dart';
import '../models/workout_model.dart'; // Workout model class


class WorkoutHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<WorkoutProvider>(context).workouts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
      ),
      body: workouts.isEmpty
          ? Center(child: Text('No workouts recorded yet.'))
          : ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return ListTile(
            title: Text(workout.date),
            subtitle: Text('Total Exercises: ${workout.exercises.length}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutDetailsPage(workout),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutRecordingPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class WorkoutDetailsPage extends StatelessWidget {
  final Workout workout;

  WorkoutDetailsPage(this.workout);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout Details')),
      body: ListView.builder(
        itemCount: workout.exercises.length,
        itemBuilder: (context, index) {
          final exercise = workout.exercises[index];
          return ListTile(
            title: Text(exercise.name),
            subtitle: Text('Output: ${exercise.output} ${exercise.type}'),
          );
        },
      ),
    );
  }
}
