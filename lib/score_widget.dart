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

    // Get the date 7 days ago and today
    DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));
    DateTime today = DateTime.now();

    // Initialize counters for the overall last 7 days performance
    int totalExercisesLast7Days = 0,
        exercisesMeetingTargetLast7Days = 0,
        totalExercisesToday = 0,
        exercisesMeetingTargetToday = 0;

    // Calculate performance for the last 7 days and today's performance
    for (var workout in workouts) {
      DateTime workoutDate = DateTime.parse(workout.date);

      // Only consider workouts from the last 7 days
      if (workoutDate.isAfter(sevenDaysAgo)) {
        for (var exerciseResult in workout.exerciseResults) {
          int target =
          getTargetForExercise(exerciseResult.name, exerciseResult.type);

          // If it's within the last 7 days
          totalExercisesLast7Days++;

          // Check if the exercise meets the target for last 7 days
          if (exerciseResult.output >= target) {
            exercisesMeetingTargetLast7Days++;
          }

          // If it's today
          if (isSameDay(workoutDate, today)) {
            totalExercisesToday++;

            // Check if the exercise meets the target for today
            if (exerciseResult.output >= target) {
              exercisesMeetingTargetToday++;
            }
          }
        }
      }
    }

    // DEBUGGING: Print values for validation
    print('Total Exercises Last 7 Days: $totalExercisesLast7Days');
    print('Exercises Meeting Target Last 7 Days: $exercisesMeetingTargetLast7Days');
    print('Total Exercises Today: $totalExercisesToday');
    print('Exercises Meeting Target Today: $exercisesMeetingTargetToday');

    // Declare performance scores
    double performanceScore = 0;
    double todayPerformanceScore = 0;

// Only calculate the performance score for the last 7 days if there are exercises that meet the target
    if (totalExercisesLast7Days > 0) {
      // If exercises meeting target > 0, calculate the score
      if (exercisesMeetingTargetLast7Days > 0) {
        performanceScore = exercisesMeetingTargetLast7Days / totalExercisesLast7Days;
      } else {
        performanceScore = 0; // If no exercises met the target, set to 0
      }
    }

// Only calculate today's performance score if there are exercises that meet the target
    if (totalExercisesToday > 0) {
      // If exercises meeting target > 0, calculate the score
      if (exercisesMeetingTargetToday > 0) {
        todayPerformanceScore = exercisesMeetingTargetToday / totalExercisesToday;
      } else {
        todayPerformanceScore = 0; // If no exercises met the target, set to 0
      }
    }

// Format the scores to be more user-friendly
    String displayPerformanceScore = performanceScore == 0 ? '0' : performanceScore.toStringAsFixed(2);
    String displayTodayPerformanceScore = todayPerformanceScore == 0 ? '0' : todayPerformanceScore.toStringAsFixed(2);


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

  // Helper function to check if two dates are the same day
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
    }
    else if (exerciseName == 'Running') {
      return 120;
    } else if (exerciseName == 'Cycling') {
      return 250;
    }
  }
  return 0;
}
