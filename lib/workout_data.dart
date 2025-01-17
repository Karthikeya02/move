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

// WorkoutHistoryPage widget
class WorkoutHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout History')),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return ListTile(
            title: Text('Workout on ${workout.date.toLocal().toString().split(' ')[0]}'),
            subtitle: Text('${workout.results.length} exercises, ${workout.successfulResultsCount} successful'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutDetailsPage(workout: workout),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// WorkoutDetailsPage widget
class WorkoutDetailsPage extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailsPage({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout Details')),
      body: ListView.builder(
        itemCount: workout.results.length,
        itemBuilder: (context, index) {
          final result = workout.results[index];
          final isSuccess = result.actualOutput >= result.exercise.targetOutput;
          return ListTile(
            title: Text(result.exercise.name),
            subtitle: Text(
              'Target: ${result.exercise.targetOutput} ${result.exercise.unit}, Achieved: ${result.actualOutput} ${result.exercise.unit}',
            ),
            trailing: Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WorkoutHistoryPage(),
  ));
}
