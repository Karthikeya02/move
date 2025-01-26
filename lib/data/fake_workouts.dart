import '../models/exercise.dart';
import '../models/exercise_result.dart';
import '../models/workout.dart';

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
