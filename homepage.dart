import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jeetogyanse/exit-popup.dart';
import 'package:jeetogyanse/startcontest.dart';

class HomeoPage extends StatefulWidget {
  const HomeoPage({Key? key}) : super(key: key);

  @override
  State<HomeoPage> createState() => _HomeoPageState();
}

class _HomeoPageState extends State<HomeoPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color(0xff113162),
          body: WillPopScope(
            onWillPop: () => showExitPopup(context),
            child: Builder(builder: (context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 300,
                      ),
                      Center(
                        child: SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                            child: Text(
                              "Start Live Contest",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => StartContestPage()));
                              }
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          )),
    );
  }
}
