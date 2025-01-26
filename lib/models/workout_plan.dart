// Define the WorkoutPlan class
import 'exercise.dart';

class WorkoutPlan {
  final String name;
  final List<Exercise> exercises;

  const WorkoutPlan({
    required this.name,
    required this.exercises,
  });

  @override
  String toString() {
    return 'WorkoutPlan: $name, Exercises: ${exercises.length}';
  }
}

// Example WorkoutPlan
final WorkoutPlan examplePlan = WorkoutPlan(
  name: 'Weekly Full Body Plan',
  exercises: [
    Exercise(name: 'Push-Ups', targetOutput: 30, unit: 'repetitions'),
    Exercise(name: 'Plank', targetOutput: 60, unit: 'seconds'),
    Exercise(name: 'Running', targetOutput: 1000, unit: 'meters'),
    Exercise(name: 'Squats', targetOutput: 40, unit: 'repetitions'),
    Exercise(name: 'Bicep Curls', targetOutput: 15, unit: 'repetitions'),
    Exercise(name: 'Cycling', targetOutput: 5, unit: 'kilometers'),
    Exercise(name: 'Jump Rope', targetOutput: 120, unit: 'seconds'),
  ],
);
