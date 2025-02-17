import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:move/workout_details/workout_recording_page.dart';
import '../main.dart';
import '../score_widget.dart';
import 'package:intl/intl.dart';
import 'package:move/workout_details/workout_details.dart';
import 'download_workout_page.dart';

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
                        builder: (context) => WorkoutDetails(workout),
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
          SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DownloadWorkoutPage(),
                ),
              );
            },
            icon: Icon(Icons.download),
            label: Text("Download Workout Plan"),
            backgroundColor: Colors.green,
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
