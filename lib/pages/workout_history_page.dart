import 'package:flutter/material.dart';
import '../data/fake_workouts.dart';
import '../models/workout.dart';
import 'workout_graph_page.dart';

class WorkoutHistoryPage extends StatefulWidget {
  @override
  _WorkoutHistoryPageState createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workout History',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.pink,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          final isExpanded = expandedIndex == index;
          final allSuccessful = workout.successfulResultsCount == workout.results.length;

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  expandedIndex = isExpanded ? null : index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with date and icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Workout on ${workout.date.toLocal().toString().split(' ')[0]}',
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (allSuccessful)
                              Icon(Icons.check_circle, color: Colors.green),
                            if (!allSuccessful)
                              Icon(Icons.close, color: Colors.red),
                            const SizedBox(width: 8),
                            Icon(
                              isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WorkoutGraphPage(workout: workout),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.arrow_forward,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Expanded section with workout details
                    if (isExpanded) ...[
                      const SizedBox(height: 12),
                      Text(
                        '${workout.results.length} exercises, ${workout.successfulResultsCount} successful',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      // List of exercises
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: workout.results.length,
                        itemBuilder: (context, resultIndex) {
                          final result = workout.results[resultIndex];
                          final isSuccess = result.actualOutput >= result.exercise.targetOutput;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        result.exercise.name,
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                      Text(
                                        'Target: ${result.exercise.targetOutput} ${result.exercise.unit}, Achieved: ${result.actualOutput} ${result.exercise.unit}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  isSuccess ? Icons.check_circle : Icons.error,
                                  color: isSuccess
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.error,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
