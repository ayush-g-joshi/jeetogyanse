import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jeetogyanse/menupage.dart';
import 'package:jeetogyanse/otpforgotpassword.page.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewLoginPage extends StatefulWidget {
  const NewLoginPage({Key? key}) : super(key: key);

  @override
  State<NewLoginPage> createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {
  var LoginData;
  var id;
  var token;

  ///creating Username and Password Controller.
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;

  var saveid;

  var user_id;

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

  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((value) {
      token = value;
      print("fcm token===>$token");
    });
    _getUserLocation();
    deviceType();
    getModel();
    os();
  }

  loadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('user_id', id.toString());
    });
    print("user id is as mentioned above--------");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color(0xff113162),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            iconTheme: IconThemeData(color: Color(0xff113162)),
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              "Login",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          body: Form(
            child: Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      Center(
                        child: Text(
                          "Enter your E-mail and Password",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Email",
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: username,
                        validator: (CurrentValue) {
                          var nonNullValue = CurrentValue ?? '';
                          if (nonNullValue.isEmpty) {
                            return ("username is required");
                          }
                          if (!nonNullValue.contains("@")) {
                            return ("username should contains @");
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "password",
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: password,
                        validator: (PassCurrentValue) {
                          RegExp regex = RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                          var passNonNullValue = PassCurrentValue ?? "";
                          if (passNonNullValue.isEmpty) {
                            return ("Password is required");
                          } else if (passNonNullValue.length < 6) {
                            return ("Password Must be more than 5 characters");
                          } else if (!regex.hasMatch(passNonNullValue)) {
                            return ("Password should contain upper,lower,digit and Special character ");
                          }
                          return null;
                        },
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
                            if (Form.of(context)?.validate() ?? false) {
                              LoginUser();
                            }
                          },
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                                fontSize: 15, color: Colors.lightBlue),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => OTPForgotPasswordPage()));
                          })
                    ],
                  ),
                ),
              );
            }),
          )),
    );
  }

  void deviceType() {
    print(Platform.operatingSystem);
  }

  getModel() async {
    WidgetsFlutterBinding.ensureInitialized();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      print(info.toMap());
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      print(info.toMap());
    }
    final info = await deviceInfo.deviceInfo;
    final deviceinfo = info.toMap();
    print(deviceinfo['model']);
  }

  void os() {
    print("operatingSystemVersion-${Platform.operatingSystemVersion}");
  }

  LoginUser() async {
    print('Login user called');
    var apiUrl = "http://192.168.1.68:8080/user/login";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        "email": username.text.trim().toString(),
        "password": password.text.trim().toString(),
        "fcmToken": token.toString(),
      }),
    );

    if (response.statusCode == 200) {
      print('success');

      LoginData = json.decode(response.body);
      id = LoginData['data']['_id'].toString();

      print(LoginData);
      print(id);
      loadId();
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => MenuPage()));
    } else {
      Fluttertoast.showToast(
        msg: json.decode(response.body)["message"], // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        timeInSecForIosWeb: 1, // duration
      );
      print('error');
    }
  }
}
