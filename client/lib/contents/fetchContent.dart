import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
import 'package:client/utils/url.dart';
class FetchContent extends StatefulWidget {
  static const String id = "FetchContent";
  final String title;

  FetchContent({required this.title});

  @override
  State<FetchContent> createState() => _FetchContentState();
}

class _FetchContentState extends State<FetchContent> {
  List<dynamic> contentArray = [];
  // late VideoPlayerController _videoPlayerController;
  // late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final apiUrl = 'http://${URL}:3000/data/${widget.title}';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final content = responseData['content'];
        setState(() {
          contentArray = content;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
    }
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
    if (content is String &&
        (content.endsWith('.jpg') || content.endsWith('.png'))) {
      return _buildImage(content);
        }
    // } else if (content is String && content.endsWith('.mp4')) {
    //   //return _buildVideo(content);
    // } 
    else {
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

  Widget _buildImage(String imagePath) {
    imagePath = 'http://192.168.254.79:3000/Images/$imagePath';
    print(imagePath);
    return Image.network(
      imagePath,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
    );
  }

  // Future<void> _initializeVideoPlayer(String videoPath) async {
  //   try {
  //     _videoPlayerController = VideoPlayerController.network(videoPath);
  //     await _videoPlayerController.initialize();
  //   } catch (e) {
  //     print('Error initializing video player: $e');
  //   }
  // }

  // Widget _buildVideo(String videoPath) {
  //   videoPath = 'http://192.168.19.79:3000/Videos/$videoPath';
  //   print(videoPath);

  //   _initializeVideoPlayer(videoPath);

  //   if (_videoPlayerController.value.isInitialized) {
  //     _chewieController = ChewieController(
  //       videoPlayerController: _videoPlayerController,
  //       aspectRatio: 16 / 9,
  //       autoInitialize: true,
  //       looping: false,
  //       autoPlay: false,
  //     );
  //     return Chewie(controller: _chewieController);
  //   } else {
  //     return Center(
  //       child: Text('Error loading video'),
  //     );
  //   }
  // }

  // @override
  // void dispose() {
  //   _videoPlayerController.dispose();
  //   _chewieController.dispose();
  //   super.dispose();
  // }

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
      body: PageView.builder(
        itemCount: contentArray.length,
        itemBuilder: (context, index) {
          return _buildContentCard(contentArray[index]);
        },
      ),
    );
  }
}
