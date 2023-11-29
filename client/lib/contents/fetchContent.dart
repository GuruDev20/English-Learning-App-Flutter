import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class FetchContent extends StatefulWidget {
  static const String id = "FetchContent";
  final String title;
  FetchContent({required this.title});

  @override
  State<FetchContent> createState() => _FetchContentState();
}

class _FetchContentState extends State<FetchContent> {
  String contentData = '';
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('');
    fetchData();
  }

  Future<void> fetchData() async {
    final apiUrl = 'http://192.168.110.79:3000/data/${widget.title}';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final content = responseData['content'];
        setState(() {
          contentData = content;
        });
        if (_isVideo(contentData)) {
          _controller = VideoPlayerController.network(contentData);
          _controller.initialize().then((_) {
            setState(() {});
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  bool _isVideo(String data) {
    return data.endsWith('.mp4');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu_book),
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: 'Quicksand'),
        ),
        backgroundColor: Color(0xFF042D29),
        toolbarHeight: 70,
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.grey,
                    elevation: 10.0,
                    child: contentData.isNotEmpty
                        ? _buildContentWidget()
                        : Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentWidget() {
    if (_isVideo(contentData)) {
      return _buildVideoPlayer();
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            contentData,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontFamily: 'Quicksand',
            ),
          ),
        ),
      );
    }
  }

  Widget _buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
