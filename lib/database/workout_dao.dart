import 'package:floor/floor.dart';
import '../models/workout_model.dart';

@dao
abstract class WorkoutDao {
  @Insert()
  Future<void> insertWorkout(Workout workout);

  @Query('SELECT * FROM Workout ORDER BY date DESC')
  Future<List<Workout>> getAllWorkouts();
}
