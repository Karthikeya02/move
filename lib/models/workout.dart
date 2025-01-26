import 'exercise_result.dart';

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
