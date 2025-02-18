import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'dart:convert';
import '../models/workout_model.dart';
import '../database/database.dart';

class DownloadWorkoutPage extends StatefulWidget {
  @override
  _DownloadWorkoutPageState createState() => _DownloadWorkoutPageState();
}

class _DownloadWorkoutPageState extends State<DownloadWorkoutPage> {
  final TextEditingController _urlController = TextEditingController();
  List<String> _jsonLinks = [];
  Workout? _selectedWorkout;

  Future<void> _fetchContent() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'] ?? "";

        if (contentType.contains("application/json")) {
          // If URL directly points to a JSON file, parse it immediately
          _parseWorkoutJson(response.body);
        } else if (contentType.contains("text/html")) {
          // If it's an HTML page, extract JSON links
          _extractJsonLinks(response.body, url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unsupported content type: $contentType")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to fetch content. Please check the URL.")),
        );
      }
    } catch (e) {
      print("Error fetching content: $e");
    }
  }

  void _parseWorkoutJson(String jsonStr) {
    try {
      final data = json.decode(jsonStr);
      setState(() {
        _selectedWorkout = Workout.fromJson(data);
        _jsonLinks.clear(); // Clear any previous JSON links
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid JSON format.")),
      );
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
          jsonUrls.add(Uri.parse(baseUrl).resolve(href).toString());
        }
      }

      setState(() {
        _jsonLinks = jsonUrls;
      });

      if (jsonUrls.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No JSON links found on the page.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error parsing HTML: $e")),
      );
    }
  }

  Future<void> _fetchWorkout(String jsonUrl) async {
    try {
      final response = await http.get(Uri.parse(jsonUrl));
      if (response.statusCode == 200) {
        _parseWorkoutJson(response.body);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch workout data.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching workout: $e")),
      );
    }
  }

  void _saveWorkout() async {
    if (_selectedWorkout == null) return;

    final database = await getDatabase();
    await database.workoutDao.insertWorkout(_selectedWorkout!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Workout saved!")),
    );

    // Redirect to selection page with workout details
    Navigator.pushReplacementNamed(
        context, '/add_workout', arguments: _selectedWorkout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Download Workout Plan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: "Enter URL",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchContent,
              child: Text("Fetch Workout"),
            ),
            if (_jsonLinks.isNotEmpty) ...[
              SizedBox(height: 20),
              Text("Select a JSON Workout Plan:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: _jsonLinks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_jsonLinks[index]),
                      onTap: () => _fetchWorkout(_jsonLinks[index]),
                    );
                  },
                ),
              ),
            ],
            if (_selectedWorkout != null) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedWorkout!.getExerciseList().length,
                  itemBuilder: (context, index) {
                    final exercise = _selectedWorkout!.getExerciseList()[index];
                    return ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(
                          "Target: ${exercise.target} ${exercise.unit}"),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _saveWorkout,
                child: Text("Save Workout"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
