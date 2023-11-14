import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoScreen extends StatefulWidget {
  static const String id = "PhotoScreen";
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  TextEditingController titleController = TextEditingController();
  File? selectedImage;
  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> storeImage() async {
    if (selectedImage == null) {
      return;
    }

    var url = Uri.parse("http://192.168.18.79:3000/upload");
    String title = titleController.text;
    var request = http.MultipartRequest('POST', url);
    request.fields['title'] = title;
    request.files.add(
      await http.MultipartFile.fromPath('image',selectedImage!.path,
      ),
    );

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print(
            'Failed to upload image. Server responded with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image: $error');
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
            const Text(
                "Would you like to add content to the previous section?"),
            const SizedBox(
              height: 20,
            ),
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
            const SizedBox(
              height: 30,
            ),
            const Text("Create a new one?"),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _showNewContentDialog(context);
              },
              child: const Text('New'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF042D29),
                textStyle: TextStyle(
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

  void _showNewContentDialog(BuildContext context) {}
  void _showAddContentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Content"),
          content: Container(
            width: 270,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Existing Title'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _selectImage();
                  },
                  child: const Text('Select Images from Gallery'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF042D29),
                    textStyle: TextStyle(
                      fontFamily: 'Quicksand',
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(200, 50),
                  ),
                ),
                const SizedBox(height: 20),
                selectedImage != null
                    ? Image.file(
                        selectedImage!,
                        height: 100,
                      )
                    : Container(),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF042D29),
                textStyle: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                storeImage();
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
              ),
            ),
          ],
        );
      },
    );
  }
}
