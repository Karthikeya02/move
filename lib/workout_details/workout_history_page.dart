import 'package:flutter/material.dart';
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

  void _loadWorkouts() {
    setState(() {
      _workouts = _fetchSavedWorkouts();
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadWorkouts(); // Reload workouts when returning to the history page
  }


  Future<List<Workout>> _fetchSavedWorkouts() async {
    final database = await getDatabase();
    List<Workout> workouts = await database.workoutDao.getAllWorkouts();

    if (workouts.isEmpty) {
      print("No workouts found in DB.");
    }

    return workouts;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workout History")),
      body: FutureBuilder<List<Workout>>(
        future: _workouts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final workouts = snapshot.data ?? [];
          if (workouts.isEmpty) {
            return Center(
              child: Text("No workouts recorded yet!", style: TextStyle(fontSize: 18)),
            );
          }

          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(workout.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text("Date: ${workout.date}"),
                  trailing: Icon(Icons.arrow_forward_ios),
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
        onPressed: () {
          Navigator.pushNamed(context, '/add_workout');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
