import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jeetogyanse/loginpage.dart';
import 'package:jeetogyanse/menupage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  List dataList = List.from([]);
  final TextEditingController oldpassword = TextEditingController();
  final TextEditingController newpassword = TextEditingController();

  String? user_id;

  var ChangePassData;

  String? jwt_token;

  @override
  void initState() {
    super.initState();
    setState(() {
      checkInternetConnection();
    });
  }

  checkId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id');
      print(user_id);
      ChangePassword();
    });
    print("user id is as above--------");
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
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Color(0xff113162)),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Change Password",
          style: TextStyle(
            fontSize: 30,
            color: Color(0xff113162),
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  labelText: "Old Password",
                  filled: true,
                  fillColor: Colors.white,
                ),
                controller: oldpassword,
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
                height: 30,
              ),
              SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    "Change Password",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      checkId();
                    });
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
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
      }),
    );
  }

  ChangePassword() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    jwt_token = prefs.getString('jwt_token');
    print("jwt_token is as follows----");
    print(jwt_token);

    

    print('Api For Changing Password Is Called...............................');
    var apiUrl = "http://192.168.1.68:8080/v1/user/change-password";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json',"Authorization":" Bearer ${jwt_token.toString()}"},
      body: json.encode({
        '_id': user_id!,
        'oldPassword': oldpassword.text.trim().toString(),
        'newPassword': newpassword.text.trim().toString(),
      }),
    );

    if (response.statusCode == 200) {
      checkSessionExpire();
      print('success');
      Fluttertoast.showToast(
        msg: json.decode(response.body)["message"], // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        timeInSecForIosWeb: 1, // duration
      );
      ChangePassData = json.decode(response.body);
      print(ChangePassData);

      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MenuPage()));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return MenuPage();
        },
      ), (route) => false);
    } else {
      checkSessionExpire();
      Fluttertoast.showToast(
        msg: json.decode(response.body)["message"], // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        timeInSecForIosWeb: 1, // duration
      );
      print('error');
    }
  }
  logoutUser() async {
    checkInternetConnection();
    print(
        '---------------------------------LOGOUT API IS CALLED---------------------------------');
    var apiUrl = "http://192.168.1.68:8080/v1/user/logout";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id;
    user_id = prefs.getString('user_id');
    print(user_id);
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        "_id": int.parse(user_id!),
      }),
    );
    print(response.body);
    debugPrint("post response statuscode=======>${response.statusCode}");
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var status = prefs?.setBool("isLoggedIn", false);

      print(status);
      print('success');
      debugPrint(
          "post response body=======>${json.decode(response.body)["data"]}");

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => LoginPage()));
    }
    else {
      Fluttertoast.showToast(
        msg: json.decode(response.body)["message"], // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        timeInSecForIosWeb: 1, // duration
      );
      print('error');
    }
  }
  checkSessionExpire() async {
    print(
        '-------------------------------------------------API INTEGRATION For Subject ListSTARTED---------------------------------------------------------');
    final response = await http.get(
        Uri.parse('https://jeetogyanse-api.herokuapp.com/v1/home'),
        headers: {"Authorization": " Bearer ${jwt_token.toString()}"});

    if (response.statusCode == 200) {
      print("-----------------SESSION IS NOT EXPIRED---------------------");
    } else {
      logoutUser();
      Fluttertoast.showToast(
        msg: json.decode(response.body)["message"], // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        timeInSecForIosWeb: 1, // duration
      );
      print(
          '-------------------------------------------------Failed-----------------------------------------------------------');
    }
  }
}
