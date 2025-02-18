import 'package:flutter/material.dart';
import 'dart:convert';
import '../database/database.dart';
import '../models/workout_model.dart';
import 'package:intl/intl.dart';


class WorkoutHistoryPage extends StatefulWidget {
  @override
  _WorkoutHistoryPageState createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  late Future<List<Workout>> _workouts;

  @override
  void initState() {
    super.initState();
    _workouts = _fetchSavedWorkouts();
  }

  Future<List<Workout>> _fetchSavedWorkouts() async {
    try {
      final database = await getDatabase();
      final workoutDao = database.workoutDao;
      return await workoutDao.getAllWorkouts();
    } catch (e) {
      print("Error fetching workouts: $e");
      return []; // Return an empty list if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workout History")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Workout>>(
          future: _workouts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Show loading indicator
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error loading workouts")); // Show error message
            }

            final workouts = snapshot.data ?? [];

            if (workouts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No workouts recorded yet!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/download_workout'); // Ensure route is correct
                      },
                      child: Text("Download Workout Plan"),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(workout.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Date: ${DateFormat('dd MMM yyyy, hh:mma').format(DateTime.parse(workout.date).toLocal())}"),
                    onTap: () {
                      _showWorkoutDetails(workout);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, '/download_workout');
            },
            icon: Icon(Icons.download),
            label: Text("Download Workout"),
            backgroundColor: Colors.green,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/record_workout');
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _showWorkoutDetails(Workout workout) {
    final List<dynamic> exercises = jsonDecode(workout.exercises);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(workout.name),
          content: exercises.isNotEmpty
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: exercises.map((exerciseJson) {
              final exercise = Exercise.fromJson(exerciseJson);
              return ListTile(
                title: Text(exercise.name),
                subtitle: Text("Target: ${exercise.target} ${exercise.unit}"),
              );
            }).toList(),
          )
              : Text("No exercises recorded."),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
