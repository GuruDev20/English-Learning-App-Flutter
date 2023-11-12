import 'package:flutter/material.dart';
class AdminEdit extends StatefulWidget {
  @override
  _AdminEditState createState() => _AdminEditState();
}

class _AdminEditState extends State<AdminEdit> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentsController = TextEditingController();

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
                Navigator.of(context).pop();
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
