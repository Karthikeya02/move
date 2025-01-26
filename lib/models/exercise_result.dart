import 'exercise.dart';

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
