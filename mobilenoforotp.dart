import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jeetogyanse/otpverificationpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobilenoForOTPpage extends StatefulWidget {
  const MobilenoForOTPpage({Key? key}) : super(key: key);

  @override
  State<MobilenoForOTPpage> createState() => _MobilenoForOTPpageState();
}

class _MobilenoForOTPpageState extends State<MobilenoForOTPpage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? user_id;
  final TextEditingController _phoneNumberController = TextEditingController();
  final RegExp phoneRegex = new RegExp(r'^[6-9]\d{9}$');
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
    }}
  checkId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id');
      print(user_id);
      generateOtp();
    });
    print("user id is as above--------");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            "Generate OTP ",
            style: TextStyle(
              fontSize: 30,
              color: Color(0xff113162),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Form(
          child: Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Enter Your Phone Number",
                      style: TextStyle(
                          color: Color(0xff113162),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "We Will Send You A four Digit Verification Code",
                      style: TextStyle(
                          color: Color(0xff113162),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mobile_friendly),
                        hintText: "Mobile Number",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      controller: _phoneNumberController,
                      validator: (CurrentValue) {
                        var nonNullValue = CurrentValue ?? '';
                        if (nonNullValue.isEmpty) {
                          return ("Mobile Number is required");
                        }
                        if (!phoneRegex.hasMatch(nonNullValue)) {
                          return 'Please enter valid phone number';
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
                        checkInternetConnection();
                        checkId();

                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff113162)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
        ));
  }
  generateOtp() async {
    print('create user called');
    var apiUrl = "http://192.168.1.68:8080/v1/mobile";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        "mobile": _phoneNumberController.text.trim().toString(),
        '_id': user_id!,
      }),
    );

    if (response.statusCode == 200) {
      print('success');

      Fluttertoast.showToast(
        msg: json.decode(response.body)["message"], // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        timeInSecForIosWeb: 1, // duration
      );
       {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => OtpVerificationPage()));

      }
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
