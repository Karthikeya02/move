import 'package:flutter/material.dart';
import 'dart:math';

// Exercise class
class Exercise {
  final String name;
  final double targetOutput;
  final String unit;

  const Exercise({
    required this.name,
    required this.targetOutput,
    required this.unit,
  });

  @override
  String toString() {
    return '$name (Target: $targetOutput $unit)';
  }
}

// ExerciseResult class
class ExerciseResult {
  final Exercise exercise;
  final double actualOutput;

  const ExerciseResult({
    required this.exercise,
    required this.actualOutput,
  });

  @override
  String toString() {
    return '${exercise.name}: $actualOutput/${exercise.targetOutput} ${exercise.unit}';
  }
}

// Define the Workout class
class Workout {
  final DateTime date;
  final List<ExerciseResult> results;

  Workout({
    required this.date,
    required this.results,
  });

  int get successfulResultsCount =>
      results.where((r) => r.actualOutput >= r.exercise.targetOutput).length;

  @override
  String toString() {
    final resultsString = results.map((r) => '\n$r').join();
    return 'Workout on ${date.toLocal()}$resultsString';
  }
}

// Fake data
final List<Workout> workouts = [
  Workout(
    date: DateTime(2025, 1, 15),
    results: [
      ExerciseResult(
        exercise: Exercise(name: 'Push-Ups', targetOutput: 30, unit: 'repetitions'),
        actualOutput: 28,
      ),
      ExerciseResult(
        exercise: Exercise(name: 'Plank', targetOutput: 60, unit: 'seconds'),
        actualOutput: 65,
      ),
    ],
  ),
  Workout(
    date: DateTime(2025, 1, 16),
    results: [
      ExerciseResult(
        exercise: Exercise(name: 'Running', targetOutput: 1000, unit: 'meters'),
        actualOutput: 979,
      ),
      ExerciseResult(
        exercise: Exercise(name: 'Push-Ups', targetOutput: 30, unit: 'repetitions'),
        actualOutput: 32,
      ),
    ],
  ),
  Workout(
    date: DateTime(2025, 1, 17),
    results: [
      ExerciseResult(
        exercise: Exercise(name: 'Squats', targetOutput: 40, unit: 'repetitions'),
        actualOutput: 42,
      ),
      ExerciseResult(
        exercise: Exercise(name: 'Plank', targetOutput: 60, unit: 'seconds'),
        actualOutput: 60,
      ),
    ],
  ),
];

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
            shadowColor: Theme.of(context).colorScheme.shadow,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  expandedIndex = isExpanded ? null : index;
                });
              },
              splashColor: Theme.of(context).colorScheme.primary.withAlpha((0.2 * 255).toInt()),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            else
                              Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            const SizedBox(width: 8),
                            Icon(
                              isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                    if (isExpanded) ...[
                      const SizedBox(height: 12),
                      Text(
                        '${workout.results.length} exercises, ${workout.successfulResultsCount} successful',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Divider(),
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
