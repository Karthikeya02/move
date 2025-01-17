import 'package:flutter/material.dart';

// Define the Exercise class
class Exercise {
  final String name;
  final double targetOutput;
  final String unit; // Either 'seconds', 'repetitions', or 'meters'

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

// Define the ExerciseResult class
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

// Create fake data
final List<Workout> workouts = [
  Workout(
    date: DateTime(2025, 1, 1),
    results: [
      ExerciseResult(
        exercise: Exercise(name: 'Push-Ups', targetOutput: 30, unit: 'repetitions'),
        actualOutput: 25,
      ),
      ExerciseResult(
        exercise: Exercise(name: 'Plank', targetOutput: 60, unit: 'seconds'),
        actualOutput: 50,
      ),
    ],
  ),
  Workout(
    date: DateTime(2025, 1, 2),
    results: [
      ExerciseResult(
        exercise: Exercise(name: 'Running', targetOutput: 1000, unit: 'meters'),
        actualOutput: 950,
      ),
      ExerciseResult(
        exercise: Exercise(name: 'Push-Ups', targetOutput: 30, unit: 'repetitions'),
        actualOutput: 28,
      ),
    ],
  ),
  Workout(
    date: DateTime(2025, 1, 3),
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
        backgroundColor: Colors.purple, // Static purple background color
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
              splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Workout on ${workout.date.toLocal().toString().split(' ')[0]}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Row(
                          children: [
                            if (allSuccessful)
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            const SizedBox(width: 8),
                            Icon(
                              isExpanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: Theme.of(context).colorScheme.primary,
                            ),
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
                                Column(
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

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
    home: WorkoutHistoryPage(),
  ));
}
