import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jeetogyanse/morepage.dart';
import 'package:jeetogyanse/startcontest.dart';
import 'package:jeetogyanse/winnerlist.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var screens = [
    const StartContestPage(),
    const WinnerListPage(),
    const MorePage()
  ];
  var _currentIndex = 0;
  DateTime? currentBackPressTime;

  Future<bool> onWillPopS(BuildContext context) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Press Again To Exit", // message
          toastLength: Toast.LENGTH_SHORT, // length
          gravity: ToastGravity.CENTER, // location
          timeInSecForIosWeb: 1 // duration
          );
      return Future.value(false);
    }
    return exit(0);
  }

  @override
  void initState() {
    hideNaviBar();
    setState(() {
      checkInternetConnection();
    });
  }

  checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      Fluttertoast.showToast(
          msg: "You are connected to a mobile network.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      Fluttertoast.showToast(
          msg: "You are connected to a wifi network.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
          msg: "You Are Not Connected To Internet!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPopS(context),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xff113162)),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            "Jeeto-Gyanse",
            style: TextStyle(
              fontSize: 30,
              color: Color(0xff113162),
              fontWeight: FontWeight.w900,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          return screens[_currentIndex];
        }),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wine_bar_rounded),
              label: 'Winner-List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_outlined),
              label: 'More',
            ),
          ],
          selectedItemColor: const Color(0xff113162),
          onTap: (index) => setState(
            () {
              _currentIndex = index;
            },
          ),
        ),
      ),
    );
  }

  hideNaviBar() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  }
}
