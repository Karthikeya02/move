class Workout {
  final String name;
  final String date; // Always stores the present date
  final List<Exercise> exercises;
  final List<ExerciseResult> exerciseResults; // Added missing field

  Workout({
    required this.name,
    required this.date,
    required this.exercises,
    this.exerciseResults = const [], // Default to empty list
  });

  /// Factory method to create a Workout from JSON
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      name: json['name'] ?? "Unnamed Workout",
      date: DateTime.now().toIso8601String(), // Auto-set present date
      exercises: (json['exercises'] as List?)?.map((exercise) => Exercise.fromJson(exercise)).toList() ?? [],
      exerciseResults: (json['exerciseResults'] as List?)?.map((result) => ExerciseResult.fromJson(result)).toList() ?? [], // Parse exerciseResults if available
    );
  }
}

class Exercise {
  final String name;
  final int target;
  final String unit;
  final String type; // Added missing field

  Exercise({required this.name, required this.target, required this.unit, this.type = ""});

  /// Factory method to create Exercise from JSON
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? "Unknown",
      target: json['target'] ?? 0,
      unit: json['unit'] ?? "",
      type: json.containsKey('type') ? json['type'] : json['unit'], // Default to unit if type is missing
    );
  }
}

class ExerciseResult {
  final String name;
  final String unit;
  final int output;
  final String type; // Keeping type for compatibility

  ExerciseResult({required this.name, required this.unit, required this.output, this.type = ""});

  /// Factory method to create ExerciseResult from JSON
  factory ExerciseResult.fromJson(Map<String, dynamic> json) {
    return ExerciseResult(
      name: json['name'] ?? "Unknown",
      unit: json['unit'] ?? "Unknown",
      output: json['output'] ?? 0,
      type: json.containsKey('type') ? json['type'] : json['unit'],
    );
  }
}
