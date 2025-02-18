import 'package:floor/floor.dart';

import '../models/workout_model.dart';

@dao
abstract class WorkoutDao {
  @insert
  Future<void> insertWorkout(Workout workout);

  @Query('SELECT * FROM Workout')
  Future<List<Workout>> getAllWorkouts();

  @Query('DELETE FROM Workout WHERE id = :id')
  Future<void> deleteWorkout(int id);
}

@dao
abstract class WorkoutPlanDao {
  @insert
  Future<void> insertWorkoutPlan(WorkoutPlan plan);

  @Query('SELECT * FROM workout_plans')
  Future<List<WorkoutPlan>> getAllWorkoutPlans();

  @Query('DELETE FROM workout_plans WHERE id = :id')
  Future<void> deleteWorkoutPlan(int id);
}
