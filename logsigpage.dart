import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:jeetogyanse/exit-popup.dart';
import 'package:jeetogyanse/loginpage.dart';
import 'package:jeetogyanse/signuppage.dart';
import 'package:jeetogyanse/termsandconditionpage.dart';
import 'package:location/location.dart';

class LogSigPage extends StatefulWidget {
  const LogSigPage({Key? key}) : super(key: key);

  @override
  State<LogSigPage> createState() => _LogSigPageState();
}

class _LogSigPageState extends State<LogSigPage> {
  //Method To GET LOCATION from user
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;

  var _platformVersion;

  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final _locationData = await location.getLocation();
    setState(() {
      _userLocation = _locationData;
      print('lattitude-${_userLocation?.longitude}');
      print("longitude-${_userLocation?.longitude}");
    });
  }

  ///creating Username and Password Controller.
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xff113162)),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Jeeto-Gyanse",
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Color(0xff113162),
        body: WillPopScope(
          onWillPop: () => showExitPopup(context),
          child: Builder(builder: (context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "JEETO-GYANSE",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "GYAN DIKHAO PAISA KAMAO",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      child: Text(
                        "SignUp",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        {
                          devicetype();
                          devicedetails();
                          _getUserLocation();
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => SignUpPage()));
                        }
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        {
                          devicetype();
                          devicedetails();
                          _getUserLocation();
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => LoginPage()));
                        }
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      child: Text(
                        "Terms And Conditions",
                        style: TextStyle(fontSize: 15, color: Colors.lightBlue),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => TermsAndConditionPage()));
                      })
                ],
              ),
            );
          }),
        ));
  }

  void devicetype() {
//Get the physical device size
    print("Physical Device -${Device.size}");
//Quick methods to access the physical device width and height
    print("Device Width: ${Device.width}, Device Height: ${Device.height}");

//To get the actual screen size (Which is same as what MediaQuery gives)
    print("Actual Screen Size-${Device.screenSize}");
//Quick methods to access the screen width and height
    print(
        "Device Width: ${Device.screenWidth}, Device Height: ${Device.screenHeight}");

    if (Device.get().isPhone) {
      print("DEVICE TYPE-Phone-${Device.get().isPhone}");
    }
    if (Device.get().isTablet) {
      print("DEVICE TYPE-Tablet-${Device.get().isTablet}");
    }

    if (Device.get().isIphoneX) {
      print("Operating System-Iphone-${Device.get().isIos}");
    }
    if (Device.get().isAndroid) {
      print("Operating System-Android-${Device.get().isAndroid}");
    }
  }

  void devicedetails() {
    print(Platform.operatingSystem);

    // The OS version
    print("operatingSystemVersion-${Platform.operatingSystemVersion}");
    print("localeName-${Platform.localeName}");
    print("numberOfProcessors-${Platform.numberOfProcessors}");
  }
}
