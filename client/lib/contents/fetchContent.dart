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
  List<dynamic> contentArray = [];
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
          contentArray = content;
        });
        if (contentArray.isNotEmpty && _isVideo(contentArray[0])) {
          _controller = VideoPlayerController.network(contentArray[0]);
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

  bool _isVideo(dynamic data) {
    return data is String && data.endsWith('.mp4');
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
            children: contentArray.map((content) {
              return _buildContentCard(content);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(dynamic content) {
    return SizedBox(
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
          child: _buildContentWidget(content),
        ),
      ),
    );
  }

  Widget _buildContentWidget(dynamic content) {
    if (_isVideo(content)) {
      return _buildVideoPlayer();
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            content.toString(),
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
