import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/workout_model.dart';
import 'workout_dao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Workout, WorkoutPlan]) // Add WorkoutPlan here
abstract class AppDatabase extends FloorDatabase {
  WorkoutDao get workoutDao;

  WorkoutPlanDao get workoutPlanDao; // Ensure DAO is defined
}

// Function to initialize and return the database instance
Future<AppDatabase> getDatabase() async {
  return await $FloorAppDatabase.databaseBuilder('workouts.db').build();
}
