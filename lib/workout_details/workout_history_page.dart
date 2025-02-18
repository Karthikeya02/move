import 'package:flutter/material.dart';
import 'package:move/workout_details/workout_details.dart';
import '../database/database.dart';
import '../models/workout_model.dart';
import '../score_widget.dart';


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
    final database = await getDatabase();
    return await database.workoutDao.getAllWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workout History")),
      body: Column(
        children: [
          ScoreWidget(), // Display ScoreWidget at the top
          Expanded(
            child: FutureBuilder<List<Workout>>(
              future: _workouts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final workouts = snapshot.data ?? [];
                if (workouts.isEmpty) {
                  return Center(child: Text("No workouts recorded yet!"));
                }

                return ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    return ListTile(
                      title: Text(workout.name),
                      subtitle: Text("Date: ${workout.date}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WorkoutDetailsPage(workout: workout),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
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
