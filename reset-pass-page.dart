import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jeetogyanse/afterResetPageLoginPage.dart';

class ForgotOTPverificationPage extends StatefulWidget {
  var email;

  ForgotOTPverificationPage({Key? key, this.email}) : super(key: key);

  @override
  State<ForgotOTPverificationPage> createState() =>
      _ForgotOTPverificationPageState();
}

class _ForgotOTPverificationPageState extends State<ForgotOTPverificationPage> {
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  final RegExp phoneRegex = new RegExp(r'^[6-9]\d{9}$');
  var _email;

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    print(_email);
    setState(() {
      checkInternetConnection();
    });
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
  bool _obscureTextone = true;
  bool _obscureTexttwo = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          "Reset Your Password",
          style: TextStyle(
            fontSize: 30,
            color: Color(0xff113162),
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Builder(builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "We Have Send  A Four Digit Verification Code",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 20),
                  prefixIcon: Icon(Icons.pin),
                  labelText: "OTP",
                  fillColor: Colors.white,
                ),
                controller: _phoneNumberController,
                validator: (CurrentValue) {
                  var nonNullValue = CurrentValue ?? '';
                  if (nonNullValue.isEmpty) {
                    return ("OTP is required");
                  } else if (nonNullValue.length != 4) {
                    return "Please enter valid OTP number";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: _obscureTextone,
                decoration: InputDecoration(
                  suffixIcon: new GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureTextone = !_obscureTextone;
                      });
                    },
                    child: new Icon(_obscureTextone
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                  prefixIcon: Icon(Icons.password_outlined),
                  labelStyle: TextStyle(fontSize: 20),
                  labelText: "New Password",
                  filled: true,
                  fillColor: Colors.white,
                ),
                controller: newpassword,
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
                obscureText: _obscureTexttwo,
                decoration: InputDecoration(
                  suffixIcon: new GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureTexttwo = !_obscureTexttwo;
                      });
                    },
                    child: new Icon(_obscureTexttwo
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                  prefixIcon: Icon(Icons.password_outlined),
                  labelStyle: TextStyle(fontSize: 20),
                  labelText: "Confirm Password",
                  filled: true,
                  fillColor: Colors.white,
                ),
                controller: confirmpassword,
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
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    if (Form.of(context)?.validate() ?? true) {
                      verifyOTP();
                    }
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xff113162)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                width: 200,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    "RESEND",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    sendOTP();
                  },
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xff113162)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
    );
  }

  verifyOTP() async {
    checkInternetConnection();
    print(
        'Verify OTP__________________________________________________ called');
    var apiUrl = "http://192.168.1.68:8080/v1/user/forgot/otp";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        "email": _email.trim().toString(),
        "otp": _phoneNumberController.text.trim().toString(),
        "password": confirmpassword.text.trim().toString(),
      }),
    );
    print(response.body);
    debugPrint("post response statuscode=======>${response.statusCode}");
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: json.decode(response.body)["message"], // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        timeInSecForIosWeb: 1, // duration
      );
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => AfterRestPassLoginPage()));

      print('success');
      debugPrint(
          "post response body=======>${json.decode(response.body)["data"]}");
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

  sendOTP() async {
    checkInternetConnection();
    print('SEND OTP__________________________________________________ called');
    var apiUrl = "http://192.168.1.68:8080/v1/user/forgot";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        "email": _email.trim().toString(),
      }),
    );
    print(response.body);
    debugPrint("post response statuscode=======>${response.statusCode}");
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: json.decode(response.body)["message"], // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        timeInSecForIosWeb: 1, // duration
      );
      print('emailllll===>${_email.text.toString()}');
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
