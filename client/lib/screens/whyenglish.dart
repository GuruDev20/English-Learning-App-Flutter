import 'package:flutter/material.dart';
class WhyEnglishScreen extends StatefulWidget {
  static const String id="whyenglish";
  const WhyEnglishScreen({super.key});

  @override
  State<WhyEnglishScreen> createState() => _WhyEnglishScreenState();
}

class _WhyEnglishScreenState extends State<WhyEnglishScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WhyEnglish')),
    );
  }
}