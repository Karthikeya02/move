import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class ScoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<WorkoutProvider>(context).workouts;

    // If no workouts are available, display a default message
    if (workouts.isEmpty) {
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'No workouts in the past 7 days.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));
    DateTime today = DateTime.now();

    int totalExercisesLast7Days = 0,
        exercisesMeetingTargetLast7Days = 0,
        totalExercisesToday = 0,
        exercisesMeetingTargetToday = 0;

    for (var workout in workouts) {
      DateTime workoutDate = DateTime.parse(workout.date);

      if (workoutDate.isAfter(sevenDaysAgo)) {
        for (var exercise in workout.getExerciseList()) {
          int target = getTargetForExercise(exercise.name, exercise.type);

          totalExercisesLast7Days++;

          if (exercise.target >= target) {
            // Compare target instead of output
            exercisesMeetingTargetLast7Days++;
          }

          if (isSameDay(workoutDate, today)) {
            totalExercisesToday++;

            if (exercise.target >= target) {
              exercisesMeetingTargetToday++;
            }
          }
        }
      }
    }

    double performanceScore = 0;
    double todayPerformanceScore = 0;

    if (totalExercisesLast7Days > 0) {
      if (exercisesMeetingTargetLast7Days > 0) {
        performanceScore =
            exercisesMeetingTargetLast7Days / totalExercisesLast7Days;
      } else {
        performanceScore = 0; // If no exercises met the target, set to 0
      }
    }

    if (totalExercisesToday > 0) {
      if (exercisesMeetingTargetToday > 0) {
        todayPerformanceScore =
            exercisesMeetingTargetToday / totalExercisesToday;
      } else {
        todayPerformanceScore = 0;
      }
    }

    String displayPerformanceScore =
        performanceScore == 0 ? '0' : performanceScore.toStringAsFixed(2);
    String displayTodayPerformanceScore = todayPerformanceScore == 0
        ? '0'
        : todayPerformanceScore.toStringAsFixed(2);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Overall Score: $displayPerformanceScore'),
            Divider(), // Add a divider to separate the two scores
            Text('Today\'s Score: $displayTodayPerformanceScore'),
          ],
        ),
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

int getTargetForExercise(String exerciseName, String exerciseType) {
  // Define target values based on exercise type or name
  if (exerciseType == 'Reps') {
    if (exerciseName == 'Push-ups') {
      return 12;
    } else if (exerciseName == 'Squats') {
      return 12;
    }
  } else if (exerciseType == 'Seconds') {
    if (exerciseName == 'Plank') {
      return 12;
    }
  } else if (exerciseType == 'Meters') {
    if (exerciseName == 'Surfing') {
      return 60;
    } else if (exerciseName == 'Running') {
      return 120;
    } else if (exerciseName == 'Cycling') {
      return 250;
    }
  }
  return 0;
}
