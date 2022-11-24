import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jeetogyanse/exit-popup.dart';

class WrongggPage extends StatefulWidget {
  const WrongggPage({Key? key}) : super(key: key);

  @override
  State<WrongggPage> createState() => _WrongggPageState();
}

class _WrongggPageState extends State<WrongggPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Color(0xff113162),
          body: Builder(builder: (context) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text("Wallet Account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white)),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          }));
  }
}
