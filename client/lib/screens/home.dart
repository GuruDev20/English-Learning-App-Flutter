import 'package:client/screens/viewcontent.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  static const String id = "homescreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textController = TextEditingController();
  int myIndex = 0;
  List<Widget> widgetList = [];
  List<String> collectionNames = [];

  Future<void> fetchCollectionNames() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.19.79:3000/collectionNames'));
      if (response.statusCode == 200) {
        setState(() {
          collectionNames = List<String>.from(json.decode(response.body));
          widgetList = collectionNames.map((name) => buildCard(name)).toList();
        });
      } else {
        print(
            'Failed to fetch collection names. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching collection names: $error');
    }
  }

  Widget buildCard(String name) {
    String capitalized =
        name.isEmpty ? '' : name[0].toUpperCase() + name.substring(1);

    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: () {
          print('pressed');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewContent(title: name),
            ),
          );
        },
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  'assets/card.jpg',
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Text(
                    capitalized,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCollectionNames();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.transparent,
          title: Text(
            'Assess Mentor',
            style: TextStyle(fontFamily: 'Quicksand', color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0, right: 10, left: 10),
          child: Container(
            height: 300,
            child: PageView(
              scrollDirection: Axis.horizontal,
              children: widgetList,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: false,
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          currentIndex: myIndex,
          items: [
            BottomNavigationBarItem(
              icon: GradientIcon(
                Icons.explore,
                [Color(0xFF4CA9DF), Color(0xFF292E91)],
              ),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: GradientIcon(
                Icons.library_books,
                [Color(0xFF4CA9DF), Color(0xFF292E91)],
              ),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: GradientIcon(
                Icons.person,
                [Color(0xFF4CA9DF), Color(0xFF292E91)],
              ),
              label: 'Profile',
            ),
          ],
          selectedLabelStyle: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final List<Color> gradientColors;

  GradientIcon(this.icon, this.gradientColors);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: gradientColors,
        ).createShader(bounds);
      },
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
