import 'package:flutter/material.dart';

import '../database/database.dart';
import '../models/workout_model.dart';
import 'customize_workout_page.dart';

class WorkoutPlansPage extends StatefulWidget {
  @override
  _WorkoutPlansPageState createState() => _WorkoutPlansPageState();
}

class _WorkoutPlansPageState extends State<WorkoutPlansPage> {
  late Future<List<WorkoutPlan>> workoutPlans;

  @override
  void initState() {
    super.initState();
    workoutPlans = loadWorkoutPlans();
  }

  Future<List<WorkoutPlan>> loadWorkoutPlans() async {
    final database = await getDatabase();
    return database.workoutPlanDao.getAllWorkoutPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved Workout Plans")),
      body: FutureBuilder<List<WorkoutPlan>>(
        future: workoutPlans,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final plans = snapshot.data!;

          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];

              return ListTile(
                title: Text(plan.name),
                subtitle: Text("Exercises: ${plan.exercises}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    final database = await getDatabase();
                    await database.workoutPlanDao.deleteWorkoutPlan(plan.id!);
                    setState(() {
                      workoutPlans = loadWorkoutPlans();
                    });
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomizeWorkoutPage(plan: plan),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
