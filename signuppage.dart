import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jeetogyanse/mobilenoforotp.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var SigninData;
  var id;
  var jwttoken;
  var lattitude;
  var longgitude;
  var dtype;
  var ftoken;
  var models;
  var oss;
  var token;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final RegExp phoneRegex = new RegExp(r'^[6-9]\d{9}$');


  ///creating Username and Password and date Controller.
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController dateinput = TextEditingController();

  bool agree = false;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;

  String? _noDataText;

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
      lattitude = _userLocation?.latitude.toString();
      longgitude = _userLocation?.longitude.toString();
      print('lattitude-${_userLocation?.latitude}');
      print("longitude-${_userLocation?.longitude}");
    });
  }

  @override
  void initState() {
    setState(() {
      checkInternetConnection();
    });
    dateinput.text = ""; //set the initial value of text field
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) {
      token = value;
      print("fcm token===>$token");
    });
    _getUserLocation();
    deviceType();
    //_saveDeviceToken();
    getModel();
    os();
    if (mounted) {
      setState(() => _noDataText = 'No Data');
    }
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

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xff113162)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: IconThemeData(color: Color(0xff113162)),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "SignUp ",
            style: TextStyle(
              fontSize: 30,
              color: Color(0xff113162),
            ),
          ),
        ),
        body: Form(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Builder(builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Create your Account",
                          style: TextStyle(
                            color: Color(
                              0xff113162,
                            ),
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'First name',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: _firstNameController,
                        validator: (CurrentValue) {
                          var nonNullValue = CurrentValue ?? '';
                          if (nonNullValue.isEmpty) {
                            return ('Enter your first name');
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Last name',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: _lastNameController,
                        validator: (CurrentValue) {
                          var nonNullValue = CurrentValue ?? '';
                          if (nonNullValue.isEmpty) {
                            return ('Enter your last name');
                          }
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
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
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.password_outlined),
                        
                        filled: true,
                        fillColor: Colors.white,
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
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("Passwords must have upper and lower case letters,at least 1 number and special character,not match or contain email and be at least 5 characters long.")),

                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: dateinput,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        prefixIcon: Icon(Icons.date_range_outlined),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          setState(() {
                            dateinput.text = formattedDate;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date of Birth is required';
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        child: Text(
                          "SignUp",
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          checkInternetConnection();
                          if (Form.of(context)?.validate() ?? false) {
                            createUser();
                          }
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Color(
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
                  ],
                );
              }),
            ),
          ),
        ));
  }

  createUser() async {
    checkInternetConnection();
    print('----------------Signup API user called----------------');
    var apiUrl = "http://192.168.1.68:8080/v1/user/signup";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        "firstName": _firstNameController.text.trim().toString(),
        "lastName": _lastNameController.text.trim().toString(),
        "email": username.text.trim().toString(),
        "password": password.text.trim().toString(),
        "dateOfBirth": dateinput.text.trim().toString(),
        // "mobile": _phoneNumberController.text.trim().toString(),
        "latitude": lattitude.toString(),
        "longitude": longgitude.toString(),
        "deviceType": dtype.toString(),
        "fcmToken": token.toString(),
        "model": models.trim().toString(),
        "os": oss.toString()
      }),
    );

    if (response.statusCode == 200) {
      print('success');

      SigninData = json.decode(response.body);
      id = SigninData['data']['_id'].toString();
      jwttoken=SigninData['data']['token'].toString();
      print(SigninData);
      print(id);
      print('JWT TOKEN IS AS FOLLOWS-');
      print(jwttoken);
      loadId();
      loadJWTToken();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => MobilenoForOTPpage()));
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

  void deviceType() {
    dtype = Platform.operatingSystem;
    print("device type=====>$dtype");
  }

  getModel() async {
    WidgetsFlutterBinding.ensureInitialized();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      //print(info.toMap());
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      print(info.toMap());
    }
    final info = await deviceInfo.deviceInfo;
    final deviceinfo = info.toMap();
    print(info.toMap());
    models = deviceinfo['model'];
    print("model type=====>$models");
  }

  void os() {
    oss = Platform.operatingSystemVersion;
    print("operatingSystemVersion-${Platform.operatingSystemVersion}");
  }

}
