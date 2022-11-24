import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jeetogyanse/reset-pass-page.dart';

class OTPForgotPasswordPage extends StatefulWidget {
  const OTPForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<OTPForgotPasswordPage> createState() => _OTPForgotPasswordPageState();
}

class _OTPForgotPasswordPageState extends State<OTPForgotPasswordPage> {

  @override
  void initState() {
    super.initState();
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController useremail = TextEditingController();
  final RegExp phoneRegex = new RegExp(r'^[6-9]\d{9}$');

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
            "Forgot Password",
            style: TextStyle(
              fontSize: 30,
              color: Color(0xff113162),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff113162),
                  ),
                  height: 100,
                  width: 100,
                  child: Icon(
                    Icons.lock,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 20),
                      prefixIcon: Icon(Icons.email),
                      hintText: "Email",
                      labelText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    controller: useremail,
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
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    child: Text(
                      "Generate OTP",
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
            ),
          );
        }));
  }

  sendOTP() async {
    checkInternetConnection();
    print('SEND OTP__________________________________________________ called');
    var apiUrl = "http://192.168.1.68:8080/v1/user/forgot";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        "email": useremail.text.trim().toString(),
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

      setState(() {
        if (Form.of(context)?.validate() ?? true)
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  ForgotOTPverificationPage(email: useremail.text.toString())));
      });

      print('emailllll===>${useremail.text.toString()}');

      Fluttertoast.showToast(
        msg: json.decode(response.body)["message"], // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        timeInSecForIosWeb: 1, // duration
      );
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
