import 'dart:convert';

import 'package:floor/floor.dart';

@Entity(tableName: 'Workout')
class Workout {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String date;
  final String exercises; // Store exercises as JSON string

  Workout({
    this.id,
    required this.name,
    required this.date,
    required this.exercises,
  });

  // Convert Workout to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'exercises': exercises,
    };
  }

  // Convert JSON to Workout
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'] ?? "Unnamed Workout",
      date: json['date'] ?? DateTime.now().toIso8601String(),
      exercises: json.containsKey('exercises')
          ? jsonEncode(json['exercises']) // Store as JSON string
          : "[]",
    );
  }

  // Decode stored JSON string into a List of Exercise objects
  List<Exercise> getExerciseList() {
    List<dynamic> decodedList = jsonDecode(exercises);
    return decodedList.map((e) => Exercise.fromJson(e)).toList();
  }

  // Encode List of Exercises into JSON string for storage
  String encodeExerciseList(List<Exercise> exerciseList) {
    return jsonEncode(exerciseList.map((e) => e.toJson()).toList());
  }
}

class Exercise {
  final String name;
  final int target;
  final int actual; // New field to store actual user performance
  final String unit;
  final String type;

  Exercise({
    required this.name,
    required this.target,
    required this.actual, // User-entered data
    required this.unit,
    required this.type,
  });

  // Convert Exercise to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'target': target,
      'actual': actual, // Include actual in JSON
      'unit': unit,
      'type': type,
    };
  }

  // Convert JSON to Exercise
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? "Unknown",
      target: (json['target'] is int)
          ? json['target']
          : int.tryParse(json['target'].toString()) ?? 0,
      actual: (json['actual'] is int)
          ? json['actual']
          : int.tryParse(json['actual'].toString()) ?? 0,
      unit: json['unit'] ?? "",
      type: json['type'] ?? "Unknown",
    );
  }
}

@Entity(tableName: 'workout_plans')
class WorkoutPlan {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name; // Plan name
  final String exercises; // Store as a comma-separated string
  final String duration; // Duration of the workout plan

  WorkoutPlan({
    this.id,
    required this.name,
    required this.exercises,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'exercises': exercises,
      'duration': duration,
    };
  }

  factory WorkoutPlan.fromMap(Map<String, dynamic> map) {
    return WorkoutPlan(
      id: map['id'],
      name: map['name'],
      exercises: map['exercises'],
      duration: map['duration'],
    );
  }
}
