import 'package:flutter/material.dart';
import '../models/workout.dart';

class WorkoutGraphPage extends StatelessWidget {
  final Workout workout;

  const WorkoutGraphPage({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workout on ${workout.date.toLocal().toString().split(' ')[0]}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: workout.results.length,
                itemBuilder: (context, index) {
                  final result = workout.results[index];
                  final progress = (result.actualOutput / result.exercise.targetOutput).clamp(0.0, 1.0);

                  return ListTile(
                    title: Text(result.exercise.name),
                    subtitle: Text(
                      'Target: ${result.exercise.targetOutput} ${result.exercise.unit}, Achieved: ${result.actualOutput} ${result.exercise.unit}',
                    ),
                    trailing: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
