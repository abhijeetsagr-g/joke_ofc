import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String joke = "Your Life";
  String type = "Any?safe-mode";
  List<String> options = ["Any?safe-mode", "Dark"];

  Future<void> fetchJoke() async {
    final url = Uri.parse("https://v2.jokeapi.dev/joke/$type");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        if (data['type'] == 'single') {
          joke = data['joke'];
        } else if (data['type'] == 'twopart') {
          joke = "${data['setup']}\n\n${data['delivery']}";
        } else {
          joke = "Unexpected response format.";
        }
      });
    } else {
      setState(() {
        joke = "Failed to fetch joke.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yo Jokes"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade200,
      ),

      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.purple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.purple[200]!, Colors.pink[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  joke,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Radio(
                      value: options[0],
                      activeColor: Colors.blue,
                      groupValue: type,
                      onChanged: (value) {
                        setState(() {
                          type = value.toString();
                        });
                      },
                    ),
                    Text("Jokes for kids"),
                  ],
                ),
                Column(
                  children: [
                    Radio(
                      value: options[1],
                      activeColor: Colors.blue,
                      groupValue: type,
                      onChanged: (value) {
                        setState(() {
                          type = value.toString();
                        });
                      },
                    ),
                    Text(
                      "Jokes for kids who knows \n how to make kids",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[200],
                foregroundColor: Colors.white,
              ),
              onPressed: () => fetchJoke(),
              child: Text("Get new joke"),
            ),
          ],
        ),
      ),
    );
  }
}
