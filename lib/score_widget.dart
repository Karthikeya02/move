import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../database/database.dart';
import '../models/workout_model.dart';

class ScoreWidget extends StatefulWidget {
  @override
  _ScoreWidgetState createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  List<Workout> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkoutsFromDB();
  }

  Future<void> _loadWorkoutsFromDB() async {
    final database = await getDatabase();
    List<Workout> fetchedWorkouts = await database.workoutDao.getAllWorkouts();

    setState(() {
      _workouts = fetchedWorkouts;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_workouts.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            "No workouts recorded yet.",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      );
    }

    DateTime today = DateTime.now();
    DateTime sevenDaysAgo = today.subtract(Duration(days: 7));

    double overallScore = 0.0;
    int totalExercisesOverall = 0;

    double todayScore = 0.0;
    int totalExercisesToday = 0;

    for (var workout in _workouts) {
      DateTime workoutDate = DateTime.parse(workout.date);
      List<Exercise> exercises = workout.getExerciseList();

      for (var exercise in exercises) {
        double exerciseScore = _calculateExerciseScore(exercise);

        // Include in overall score
        overallScore += exerciseScore;
        totalExercisesOverall++;

        // Check if the workout is from today
        if (_isSameDay(workoutDate, today)) {
          todayScore += exerciseScore;
          totalExercisesToday++;
        }
      }
    }

    double finalOverallScore = totalExercisesOverall > 0
        ? (overallScore / totalExercisesOverall)
        : 0.0;
    double finalTodayScore =
        totalExercisesToday > 0 ? (todayScore / totalExercisesToday) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16.0),
      constraints: BoxConstraints(
        maxHeight: 250, // Restrict the height of the modal
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent extra space
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Workout Performance",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCircularScoreCard("Overall Score", finalOverallScore),
              _buildCircularScoreCard("Today's Score", finalTodayScore),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateExerciseScore(Exercise exercise) {
    if (exercise.actual >= exercise.target) {
      return 1.0;
    }
    return exercise.actual / exercise.target;
  }

  Widget _buildCircularScoreCard(String title, double score) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 65.0,
          lineWidth: 10.0,
          percent: score.clamp(0.0, 1.0),
          // Ensure within 0-100%
          center: Text(
            "${(score * 100).toStringAsFixed(1)}%",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          progressColor: score > 0.5 ? Colors.green : Colors.red,
          backgroundColor: Colors.grey.shade300,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        SizedBox(height: 6), // Slightly reduced spacing
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
