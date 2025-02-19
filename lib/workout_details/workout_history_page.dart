import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For Date Formatting
import '../database/database.dart';
import '../models/workout_model.dart';
import '../workout_details/workout_details.dart';

class WorkoutHistoryPage extends StatefulWidget {
  @override
  _WorkoutHistoryPageState createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  late Future<List<Workout>> _workouts;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  void _loadWorkouts() async {
    final database = await getDatabase();
    final fetchedWorkouts = await database.workoutDao.getAllWorkouts();

    setState(() {
      _workouts = Future.value(fetchedWorkouts);
    });

    print("DEBUG: Loaded Workouts: ${fetchedWorkouts.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout History"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder<List<Workout>>(
        future: _workouts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final workouts = snapshot.data ?? [];
          if (workouts.isEmpty) {
            return Center(
              child: Text(
                "No workouts recorded yet!",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.pinkAccent.withOpacity(0.2),
                    child: Icon(
                      Icons.fitness_center,
                      color: Colors.pinkAccent,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    workout.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Date: ${_formatDate(workout.date)}",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutDetailsPage(workout: workout),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          Navigator.pushNamed(context, '/add_workout');
        },
        child: Icon(Icons.add, size: 28),
      ),
    );
  }

  /// Formats the Date into a human-readable format (e.g., "Mar 10, 2024 - 2:30 PM")
  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat("MMM d, y - h:mm a").format(date);
  }
}
