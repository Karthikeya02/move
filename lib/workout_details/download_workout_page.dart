import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import '../models/workout_model.dart';
import '../database/database.dart';

class DownloadWorkoutPage extends StatefulWidget {
  @override
  _DownloadWorkoutPageState createState() => _DownloadWorkoutPageState();
}

class _DownloadWorkoutPageState extends State<DownloadWorkoutPage> {
  final TextEditingController _urlController = TextEditingController();
  Workout? _workoutPlan;
  String? _errorMessage;
  List<String> _jsonLinks = [];

  Future<void> _fetchContent() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _errorMessage = "Please enter a valid URL.";
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'] ?? "";

        if (contentType.contains("application/json")) {
          // Direct JSON response
          _parseWorkoutJson(response.body);
        } else if (contentType.contains("text/html")) {
          // HTML response, extract JSON links
          _extractJsonLinks(response.body, url);
        } else {
          setState(() {
            _errorMessage = "Unsupported content type: $contentType";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Failed to fetch content. Please check the URL.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching content: $e";
      });
    }
  }

  void _parseWorkoutJson(String jsonStr) {
    try {
      final data = json.decode(jsonStr);
      if (data != null && data.containsKey('name') && data.containsKey('exercises')) {
        setState(() {
          _workoutPlan = Workout.fromJson(data);
          _errorMessage = null;
        });
      } else {
        setState(() {
          _errorMessage = "Invalid workout plan data.";
          _workoutPlan = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Invalid JSON format.";
      });
    }
  }

  void _extractJsonLinks(String htmlContent, String baseUrl) {
    try {
      final document = htmlParser.parse(htmlContent);
      final links = document.querySelectorAll('a');
      List<String> jsonUrls = [];

      for (var link in links) {
        final href = link.attributes['href'];
        if (href != null && href.endsWith('.json')) {
          // Convert relative URLs to absolute
          final absoluteUrl = Uri.parse(baseUrl).resolve(href).toString();
          jsonUrls.add(absoluteUrl);
        }
      }

      setState(() {
        if (jsonUrls.isEmpty) {
          _errorMessage = "No JSON links found on the page.";
          _jsonLinks = [];
        } else {
          _jsonLinks = jsonUrls;
          _errorMessage = null;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error parsing HTML: $e";
      });
    }
  }

  Future<void> _fetchSelectedWorkout(String jsonUrl) async {
    try {
      final response = await http.get(Uri.parse(jsonUrl));
      if (response.statusCode == 200) {
        _parseWorkoutJson(response.body);
      } else {
        setState(() {
          _errorMessage = "Failed to fetch selected workout plan.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching workout plan: $e";
      });
    }
  }

  void _saveWorkout() async {
    if (_workoutPlan == null) return;

    final database = await getDatabase();
    final workoutDao = database.workoutDao;


    List<dynamic> decodedExercises = jsonDecode(_workoutPlan!.exercises);
    String exercisesJson = jsonEncode(decodedExercises.map((e) => Exercise.fromJson(e).toJson()).toList());


    Workout workout = Workout(
      name: _workoutPlan!.name,
      date: _workoutPlan!.date,
      exercises: exercisesJson,
    );

    await workoutDao.insertWorkout(workout);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Workout plan saved to database!")),
    );
  }


  void _discardWorkout() {
    setState(() {
      _workoutPlan = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Download Workout Plan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: "Workout Plan URL",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchContent,
              child: Text("Download Plan"),
            ),
            if (_errorMessage != null) ...[
              SizedBox(height: 10),
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            ],
            if (_jsonLinks.isNotEmpty) ...[
              SizedBox(height: 20),
              Text("Select a JSON Workout Plan:", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: _jsonLinks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_jsonLinks[index]),
                      trailing: ElevatedButton(
                        onPressed: () => _fetchSelectedWorkout(_jsonLinks[index]),
                        child: Text("Load"),
                      ),
                    );
                  },
                ),
              ),
            ],
            if (_workoutPlan != null) ...[
              SizedBox(height: 20),
              Text("Workout Date: ${_workoutPlan!.date}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: _workoutPlan != null && _workoutPlan!.exercises.isNotEmpty
                    ? ListView.builder(
                  itemCount: _workoutPlan!.getExerciseList().length,
                  itemBuilder: (context, index) {
                    final exercise = _workoutPlan!.getExerciseList()[index];
                    return ListTile(
                      title: Text(exercise.name),
                      subtitle: Text("Target: ${exercise.target} ${exercise.unit}"),
                    );
                  },
                )
                    : Center(child: Text("No exercises found in the workout plan.")),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveWorkout,
                    child: Text("Save Plan"),
                  ),
                  ElevatedButton(
                    onPressed: _discardWorkout,
                    child: Text("Discard"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
