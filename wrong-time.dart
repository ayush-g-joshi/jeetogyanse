import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jeetogyanse/menupage.dart';
import 'package:jeetogyanse/quiz-exit-popup.dart';

class WrongTimePage extends StatefulWidget {
  WrongTimePage({Key? key}) : super(key: key);

  @override
  State<WrongTimePage> createState() => _WrongTimePageState();
}

class _WrongTimePageState extends State<WrongTimePage> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff113162),
      body: WillPopScope(
        onWillPop: () => showQuizExitPopup(context),
        child: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 200,
                    width: 300,
                    color: Colors.white,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Please Check Quiz-Test Timings!",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "According to that timing only-",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "You Can Start The Test",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: ElevatedButton(
                    child: Text(
                      "Back To Menu",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => MenuPage()));
                      }
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
