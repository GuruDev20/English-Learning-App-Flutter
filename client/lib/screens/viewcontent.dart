import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewContent extends StatefulWidget {
  static const String id = "viewcontent";
  final String title;

  ViewContent({required this.title});

  @override
  State<ViewContent> createState() => _ViewContentState();
}

class _ViewContentState extends State<ViewContent> {
  List<dynamic> contentArray = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final apiUrl = 'http://192.168.19.79:3000/data/${widget.title}';
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

  Widget _buildImage(String imagePath) {
    imagePath = 'http://192.168.19.79:3000/Images/$imagePath';
    print(imagePath);
    return Image.network(
      imagePath,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
    );
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
      body: PageView.builder(
        itemCount: contentArray.length,
        itemBuilder: (context, index) {
          return _buildContentCard(contentArray[index]);
        },
      ),
    );
  }
}
