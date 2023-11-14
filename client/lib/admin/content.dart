import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
class AdminEdit extends StatefulWidget {
  static const String id="admin-edit";
  @override
  _AdminEditState createState() => _AdminEditState();
}

class _AdminEditState extends State<AdminEdit> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentsController = TextEditingController();
  Future<void> createContent() async{
    final response = await http.post(
      Uri.parse('http://192.168.18.79:3000/createContent'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title':titleController.text,
        'content':contentsController.text
      }),
    );
    if (response.statusCode == 200) {
      print("Content created successfully.");
      titleController.clear();
      contentsController.clear();
    } else if (response.statusCode == 400) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error in creating content"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      print("Failed to create user. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }
  Future<void> addContent() async{
    final response = await http.post(
      Uri.parse('http://192.168.18.79:3000/addContent'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title':titleController.text,
        'content':contentsController.text
      }),
    );
    if (response.statusCode == 201) {
      print("Content added successfully.");
      titleController.clear();
      contentsController.clear();
    } else if (response.statusCode == 400) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error in creating content"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      print("Failed to create user. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    }
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Content"),
      content: Container(
        height: 300,
        child: Column(
          children: [
            const Text("Would you like to add content to the previous section?"),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                _showAddContentDialog(context);
              },
              child: const Text('Add'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF042D29),
                textStyle: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(150, 50),
              ),
            ),
            const SizedBox(height: 30,),
            const Text("Create a new one?"),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                _showNewContentDialog(context);
              },
              child: const Text('New'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF042D29),
                textStyle: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(100, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewContentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("New Content"),
          content: Container(
            height: 220,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 20,),
                TextField(
                  controller: contentsController,
                  decoration: InputDecoration(labelText: 'Contents'),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    createContent();
                    print('Title: ${titleController.text}');
                    print('Contents: ${contentsController.text}');
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF042D29),
                    textStyle: TextStyle(
                      fontFamily: 'Quicksand',
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(100, 50),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _showAddContentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Content"),
          content: Container(
            height: 220,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Existing Title'),
                ),
                const SizedBox(height: 20,),
                TextField(
                  controller: contentsController,
                  decoration: InputDecoration(labelText: 'Contents'),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    addContent();
                    print('Title: ${titleController.text}');
                    print('Contents: ${contentsController.text}');
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF042D29),
                    textStyle: TextStyle(
                      fontFamily: 'Quicksand',
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(100, 50),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}