import 'dart:convert';

import 'package:client/admin/content.dart';
import 'package:client/admin/photos.dart';
import 'package:client/admin/videos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminScreen extends StatefulWidget {
  static const String id = "admiinscreen";

  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    fetchCollectionNames();
  }

  String contentName = '';
  String filePath = '';
  List<String> collectionNames = [];
  Future<void> fetchCollectionNames() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.110.79:3000/collectionNames'));
      if (response.statusCode == 200) {
        setState(() {
          collectionNames = List<String>.from(json.decode(response.body));
        });
      } else {
        print(
            'Failed to fetch collection names. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching collection names: $error');
    }
  }

  void addVideos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return VideoScreen();
      },
    );
  }

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
  Future<void> collectionNameEdit() async{
    
  }
  Future<void> collectionNameDelete() async{

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AdminScreen'),
        backgroundColor: Color(0xFF042D29),
      ),
      body: Column(
        children: [
          Container(
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
          Expanded(
            child: ListView(
              children: [
                for (int i = 0; i < collectionNames.length; i++)
                  buildCard(collectionNames[i], i % 2 == 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(String collectionName, bool isEven) {
    String formattedName ='${collectionName[0].toUpperCase()}${collectionName.substring(1)}';

    return SizedBox(
      width: 500,
      height: 130,
      child: Card(
        color: isEven ? Color(0xFF042D29) : Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Text(
                formattedName,
                style: TextStyle(
                  color: isEven ? Colors.white : Colors.black,
                  fontSize: 22,
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    collectionNameEdit;
                  },
                  icon: Icon(Icons.edit),
                  color: isEven ? Colors.white : Colors.black,
                ),
                IconButton(
                  onPressed: () {
                    collectionNameDelete;
                  },
                  icon: Icon(Icons.delete),
                  color: isEven ? Colors.white : Colors.black,
                ),
              ],
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: Colors.grey,
        elevation: 10,
      ),
    );
  }
}
