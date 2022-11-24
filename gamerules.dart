import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuRulesPage extends StatefulWidget {
  const MenuRulesPage({Key? key}) : super(key: key);

  @override
  State<MenuRulesPage> createState() => _MenuRulesPageState();
}

class _MenuRulesPageState extends State<MenuRulesPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xff113162)),
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              "Game Rules",
              style: TextStyle(
                fontSize: 30,
                color: Color(0xff113162),
                fontWeight: FontWeight.w900,
              ),
            ),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: Colors.white,
          body: Builder(builder: (context) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Read All The Game-Rules Carefully Before Starting The Contest-",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        "1.Our Terms and Conditions Generator makes it easy to create a Terms and Conditions agreement for your business. Just follow these steps:",
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "2.Our Terms and Conditions Generator makes it easy to create a Terms and Conditions agreement for your business. Just follow these steps:",
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "3.Our Terms and Conditions Generator makes it easy to create a Terms and Conditions agreement for your business. Just follow these steps:",
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "4.Our Terms and Conditions Generator makes it easy to create a Terms and Conditions agreement for your business. Just follow these steps:",
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "5.Our Terms and Conditions Generator makes it easy to create a Terms and Conditions agreement for your business. Just follow these steps:",
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            );
          })),
    );
  }
}
