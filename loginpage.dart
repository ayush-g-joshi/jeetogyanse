import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jeetogyanse/exit-popup.dart';
import 'package:jeetogyanse/menupage.dart';
import 'package:jeetogyanse/otpforgotpassword.page.dart';
import 'package:jeetogyanse/signuppage.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
  var jwttoken;
  var user_id;

  bool _obscureText = true;

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
    setState(() {
      checkInternetConnection();
    });
  }

  loadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('user_id', id.toString());
    });
    print("user id is as mentioned above--------");
  }
  loadJWTToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('jwt_token', jwttoken.toString());
    });
    print("user id is as mentioned above--------");
  }
  checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult==ConnectivityResult.none){
      Fluttertoast.showToast(
          msg: "You Are Not Connected To Internet!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: WillPopScope(
            onWillPop: () => showExitPopup(context),
            child: Builder(builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Jeeto Gyan Se",
                    style: TextStyle(
                        color: Color(
                          0xff113162,
                        ),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      labelStyle: TextStyle(fontSize: 20),
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
                  SizedBox(height: 10,),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text('Your email address is your username.')),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffixIcon: new GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: new Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                      prefixIcon: Icon(Icons.password_outlined),
                      labelStyle: TextStyle(fontSize: 20),
                      labelText: "password",
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
                  SizedBox(height: 10,),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text("Passwords must have upper and lower case letters,at least 1 number and special character,not match or contain email and be at least 5 characters long.")),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) =>
                                OTPForgotPasswordPage())); //signup screen
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 200,
                    height: 40,
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
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Color(
                          0xff113162,
                        )),
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
                  Row(
                    children: <Widget>[
                      const Text('Does not have account?'),
                      TextButton(
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          devicetype();
                          devicedetails();
                          _getUserLocation();
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => SignUpPage()));
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
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
    checkInternetConnection();
    print('Login user called');
    var apiUrl = "http://192.168.1.68:8080/v1/user/login";
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
      jwttoken = LoginData['data']['token'].toString();
      print(LoginData);
      print(id);
      loadId();
      print('JWT TOKEN IS AS FOLLOWS-');
      print(jwttoken);
      loadId();
      loadJWTToken();
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MenuPage()));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return MenuPage();
        },
      ), (route) => false);
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
