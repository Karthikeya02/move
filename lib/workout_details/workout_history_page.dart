import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/database.dart';
import '../models/workout_model.dart';
import '../score_widget.dart';
import '../workout_details/workout_details.dart';

class WorkoutHistoryPage extends StatefulWidget {
  @override
  _WorkoutHistoryPageState createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  Future<List<Workout>>? _workouts;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final db = await getDatabase();
    final workouts = await db.workoutDao.getAllWorkouts();
    setState(() {
      _workouts = Future.value(workouts);
    });
  }

  Future<void> _refreshWorkouts() async {
    await _loadWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout History"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshWorkouts,
              child: FutureBuilder<List<Workout>>(
                future: _workouts,
                builder: (context, snapshot) {
                  if (_workouts == null) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error loading workouts",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    );
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
                    padding: EdgeInsets.only(bottom: 100),
                    itemBuilder: (context, index) {
                      final workout = workouts[index];

                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Date: ${_formatDate(workout.date)}",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                          ),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: Colors.grey),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WorkoutDetailsPage(workout: workout),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          _buildGradientButton(context),
          SizedBox(height: 20),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 90),
        child: FloatingActionButton(
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            Navigator.pushNamed(context, '/add_workout').then((_) {
              _refreshWorkouts();
            });
          },
          child: Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  Widget _buildGradientButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      width: double.infinity,
      child: InkWell(
        onTap: () => _showScore(context),
        borderRadius: BorderRadius.circular(30),
        child: Container(
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

  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat("MMM d, y - h:mm a").format(date);
  }
}
