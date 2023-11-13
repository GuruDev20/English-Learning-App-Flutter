import 'package:client/admin/content.dart';
import 'package:client/admin/photos.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  static const String id = "admiinscreen";

  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String contentName = '';
  String filePath = '';

  void addVideos() {}
  void addPhotos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PhotoScreen();
      },
    );
  }

  void addContent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AdminEdit();
      },
    );
  }

  void addTest() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AdminScreen'),
        backgroundColor: Color(0xFF042D29),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: addVideos,
                  child: Text('Add Videos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF042D29),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: addPhotos,
                  child: Text('Add Photos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF042D29),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: addContent,
                  child: Text('Add Content'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF042D29),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: addTest,
                  child: Text('Add Assessment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF042D29),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
