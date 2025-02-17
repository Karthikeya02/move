import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'workout_dao.dart';
import '../models/workout_model.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Workout])
abstract class AppDatabase extends FloorDatabase {
  WorkoutDao get workoutDao;
}

// Function to initialize and return the database instance
Future<AppDatabase> getDatabase() async {
  return await $FloorAppDatabase.databaseBuilder('workouts.db').build();
}
