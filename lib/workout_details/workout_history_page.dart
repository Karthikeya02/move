import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:move/workout_details/workout_recording_page.dart';
import '../main.dart';
import '../models/workout_model.dart';
import '../score_widget.dart';
import 'package:intl/intl.dart';

class WorkoutHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<WorkoutProvider>(context).workouts;

    return Scaffold(
      appBar: AppBar(title: Text('Workout History')),
      body: Column(
        children: [
          Expanded(
            child: workouts.isEmpty
                ? Center(child: Text('No workouts recorded yet.'))
                : ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return ListTile(
                  title: Text(
                      DateFormat('yyyy-MM-dd h:mm a').format(DateTime.parse(workout.date)), // Format DateTime
                  ),
                  subtitle: Text('Exercises: ${workout.exercises.length}'),
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
          ),
          SizedBox(height: 10), // Spacing
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () => _showScore(context),
            icon: Icon(Icons.bar_chart),
            label: Text("View Score"),
            backgroundColor: Colors.blueAccent,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
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
        ],
      ),
    );
  }

  /// **Displays the ScoreWidget in a bottom sheet**
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
