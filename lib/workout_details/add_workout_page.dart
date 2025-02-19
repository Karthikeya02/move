import 'package:flutter/material.dart';
import '../database/database.dart';
import '../models/workout_model.dart';
import 'hardcode_workout_plan.dart';
import 'workout_recording_page.dart';

class AddWorkoutPage extends StatefulWidget {
  @override
  _AddWorkoutPageState createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  late Future<List<WorkoutPlan>> _workoutPlans;

  @override
  void initState() {
    super.initState();
    _loadWorkoutPlans();
  }

  void _loadWorkoutPlans() {
    setState(() {
      _workoutPlans = _fetchWorkoutPlans();
    });
  }

  Future<List<WorkoutPlan>> _fetchWorkoutPlans() async {
    final database = await getDatabase();
    return await database.workoutPlanDao.getAllWorkoutPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Workout Plan")),
      body: Column(
        children: [
          ListTile(
            title: Text("Manual Workout Plan"),
            subtitle: Text("Enter custom values for predefined exercises"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HardcodedWorkoutPage(),
                ),
              );
            },
          ),
          Expanded(
            child: FutureBuilder<List<WorkoutPlan>>(
              future: _workoutPlans,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final plans = snapshot.data!;
                if (plans.isEmpty) {
                  return Center(child: Text("No workouts available."));
                }

                return ListView.builder(
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(plan.name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkoutRecordingPage(
                                workoutPlan: plan,
                              ),
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/download_workout');
        },
        backgroundColor: Colors.green,
        icon: Icon(Icons.download, color: Colors.white),
        label: Text(
          "Download Workout",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
