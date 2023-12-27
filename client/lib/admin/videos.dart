import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class VideoScreen extends StatefulWidget {
  static const String id = "VideoScreen";
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  TextEditingController titleController = TextEditingController();
  XFile? _video;
  final ImagePicker _picker = ImagePicker();
  Future<void> _showSnackbar(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
  Future<void> addoldVideo() async {
    if (_video == null || titleController.text.isEmpty) {
      return;
    }

    var url = Uri.parse("http://192.168.137.1:3000/oldVideo");
    String title = titleController.text;
    var request = http.MultipartRequest('POST', url);
    request.fields['title'] = title;
    request.files.add(
      await http.MultipartFile.fromPath(
        'video',
        _video!.path,
      ),
    );

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Video uploaded successfully');
        _showSnackbar('Video uploaded successfully');
        titleController.clear();
        Navigator.pop(context);
      } else {
        print(
            'Failed to upload video. Server responded with status code: ${response.statusCode}');
        _showSnackbar('Failed to upload video');
      }
    } catch (error) {
      print('Error uploading video: $error');
      _showSnackbar('Error uploading video');
    }
  }
  Future<void> addVideo() async {
    if (_video == null || titleController.text.isEmpty) {
      return;
    }

    var url = Uri.parse("http://192.168.137.1:3000/newVideo");
    String title = titleController.text;
    var request = http.MultipartRequest('POST', url);
    request.fields['title'] = title;
    request.files.add(
      await http.MultipartFile.fromPath(
        'video',
        _video!.path,
      ),
    );

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Video uploaded successfully');
        _showSnackbar('Video uploaded successfully');
        titleController.clear();
        Navigator.pop(context);
      } else {
        print(
            'Failed to upload video. Server responded with status code: ${response.statusCode}');
            _showSnackbar('Failed to upload video');
      }
    } catch (error) {
      print('Error uploading video: $error');
      _showSnackbar('Error uploading video');
    }
  }

  Future<void> _pickVideoFromGallery() async {
    try {
      XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _video = pickedFile;
        });
      }
    } catch (e) {
      print("Error picking video: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Content",style: TextStyle(fontFamily: 'Quicksand'),),
      content: Container(
        height: 300,
        child: Column(
          children: [
            const Text(
                "Would you like to add content to the previous section?",style: TextStyle(fontFamily: 'Quicksand'),),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _showAddVideoDialog(context);
              },
              child: const Text('Add',style: TextStyle(fontFamily: 'Quicksand'),),
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
            const Text("Create a new one?",style: TextStyle(fontFamily: 'Quicksand'),),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _showNewVideoDialog(context);
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

  void _showNewVideoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Content",style: TextStyle(fontFamily: 'Quicksand'),),
          content: Container(
            width: 270,
            height: 400,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _pickVideoFromGallery();
                  },
                  child: const Text('Select Videos from Gallery',style: TextStyle(fontFamily: 'Quicksand'),),
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
                _video != null
                    ? Text(
                        'Picked Video: ${_video!.path}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
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
              child: const Text('Cancel',style: TextStyle(fontFamily: 'Quicksand'),),
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
                addVideo();
              },
              child: const Text('Add',style: TextStyle(fontFamily: 'Quicksand'),),
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

  void _showAddVideoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Content",style: TextStyle(fontFamily: 'Quicksand'),),
          content: Container(
            width: 270,
            height: 400,
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Existing Title'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _pickVideoFromGallery();
                  },
                  child: const Text('Select Videos from Gallery',style: TextStyle(fontFamily: 'Quicksand'),),
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
                _video != null
                    ? Text(
                        'Picked Video: ${_video!.path}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
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
              child: const Text('Cancel',style: TextStyle(fontFamily: 'Quicksand'),),
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
                addoldVideo();
              },
              child: const Text('Add',style: TextStyle(fontFamily: 'Quicksand'),),
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
