import 'package:client/contents/fetchContent.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client/admin/content.dart';
import 'package:client/admin/photos.dart';
import 'package:client/admin/videos.dart';

class AdminScreen extends StatefulWidget {
  static const String id = "adminscreen";

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
      final response = await http.get(Uri.parse('http://192.168.110.79:3000/collectionNames'));
      if (response.statusCode == 200) {
        setState(() {
          collectionNames = List<String>.from(json.decode(response.body));
        });
      } else {
        print('Failed to fetch collection names. Status code: ${response.statusCode}');
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
    ).then((value) {
      if (value != null && value) {
        fetchCollectionNames();
      }
    });
  }

  void addPhotos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PhotoScreen();
      },
    ).then((value) {
      if (value != null && value) {
        fetchCollectionNames();
      }
    });
  }

  void addContent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AdminEdit();
      },
    ).then((value) {
      if (value != null && value) {
        fetchCollectionNames();
      }
    });
  }

  void addTest() {}

  Future<void> collectionNameEdit(String oldName) async {
    TextEditingController newNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Collection Name"),
          content: TextField(
            controller: newNameController,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String newName = newNameController.text.trim();
                print(newName);
                print(oldName);
                if (newName.isNotEmpty) {
                  await updateCollectionName(oldName, newName);
                  Navigator.of(context).pop();
                  fetchCollectionNames();
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateCollectionName(String oldName, String newName) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.110.79:3000/updateCollectionName'),
        body: jsonEncode({'oldName': oldName, 'newName': newName}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        print('Failed to update collection name. Status code: ${response.statusCode}');
      } else {
        print('Updated collection name');
      }
    } catch (error) {
      print('Error updating collection name: $error');
    }
  }

  Future<void> collectionNameDelete(String name) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.110.79:3000/deleteCollectionName'),
        body: jsonEncode({'collectionName': name}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Deleted collection');
        fetchCollectionNames();
      } else {
        print('Failed to delete collection. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting collection: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu_book),
        title: Text('AdminScreen',style: TextStyle(fontFamily: 'Quicksand'),),
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
                      child: Text('Add Videos',style: TextStyle(fontFamily: 'Quicksand'),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF042D29),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: addPhotos,
                      child: Text('Add Photos',style: TextStyle(fontFamily: 'Quicksand'),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF042D29),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: addContent,
                      child: Text('Add Content',style: TextStyle(fontFamily: 'Quicksand'),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF042D29),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: addTest,
                      child: Text('Add Assessment',style: TextStyle(fontFamily: 'Quicksand'),),
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
    return TextButton(
      child: SizedBox(
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
                    fontFamily: 'Quicksand'
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      collectionNameEdit(collectionName);
                    },
                    icon: Icon(Icons.edit),
                    color: isEven ? Colors.white : Colors.black,
                  ),
                  IconButton(
                    onPressed: () {
                      collectionNameDelete(collectionName);
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
      ),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FetchContent(title: collectionName),
          ),
        );
      },
    );
  }
}