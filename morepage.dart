import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jeetogyanse/change-password.dart';
import 'package:jeetogyanse/gamerules.dart';
import 'package:jeetogyanse/loginpage.dart';
import 'package:jeetogyanse/notification-page.dart';
import 'package:jeetogyanse/termsandconditionpage.dart';
import 'package:jeetogyanse/update-profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logout-popup.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  String? user_id;
  var firstName;
  var lastName;
  var dateOfBirth;
  var mobile;
  var email;
  var image;
  var profileData;

  String? jwt_token;


  @override
  void initState() {
    checkId();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 750,
              child: ListView(
                physics: BouncingScrollPhysics(),
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,

                children: [
                  SizedBox(
                    height: 10,
                  ),
                  profileData == null || profileData.isEmpty
                      ? Column(
                          children: [
                            Center(
                                child: CircularProgressIndicator(
                              color: Color(0xff113162),
                              strokeWidth: 5,
                            )),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Please Wait"),
                            Text("Something Went Wrong!")
                          ],
                        )
                      : Container(
                          color: Colors.white,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 15,
                                height: 20,
                              ),
                              image == null || image.isEmpty
                                  ? Center(
                                      child: ClipOval(
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: ClipOval(
                                        child: Container(
                                          height: 60,
                                          width: 60,

                                          child: FittedBox(
                                            child: Image.network('$image'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("$firstName $lastName"),
                                  Text("$email"),
                                ],
                              )
                            ],
                          )),

                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(
                        Icons.notification_add,
                      ),
                      title: const Text('Notification'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => NotificationePage()));
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                    color: Colors.white,
                    child: Builder(builder: (context) {
                      return ListTile(
                        leading: Icon(
                          Icons.image_search_sharp,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                        title: const Text('Edit Profile'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => UpdateProfilePage(imageurl:image ,dob:dateOfBirth ,firstname: firstName,lastname: lastName,)));
                        },
                      );
                    }),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                    color: Colors.white,
                    child: Builder(builder: (context) {
                      return ListTile(
                        leading: Icon(
                          Icons.integration_instructions_outlined,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                        title: const Text('Game Rules'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => MenuRulesPage()));
                        },
                      );
                    }),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                    color: Colors.white,
                    child: Builder(builder: (context) {
                      return ListTile(
                        leading: Icon(Icons.watch_later_outlined),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                        title: const Text('Timing'),
                        onTap: () {
                          AlertDialog alert = AlertDialog(

                            actions: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text('Timing Of Live Contest?',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("\u2022 10:00-10:30 AM",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("\u2022 12:00-12:30 PM",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("\u2022 02:00-02:30 PM",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("\u2022 04.00-04.30 PM",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("\u2022 07:00-07:30 PM",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        },
                      );
                    }),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                    color: Colors.white,
                    child: Builder(builder: (context) {
                      return ListTile(
                        leading: Icon(
                          Icons.password_outlined,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                        title: const Text('Change Password'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ChangePasswordPage()));
                        },
                      );
                    }),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                    color: Colors.white,
                    child: Builder(builder: (context) {
                      return ListTile(
                        leading: Icon(
                          Icons.integration_instructions,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                        title: const Text('Terms And Condition'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => TermsAndConditionPage()));
                        },
                      );
                    }),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(
                        Icons.share,
                      ),
                      title: const Text('Shareapp'),
                      onTap: () {},
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black38,
                  ),
                  Container(
                    color: Colors.white,
                    child: Builder(builder: (context) {
                      return ListTile(
                        leading: Icon(
                          Icons.logout,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                        title: const Text('Logout'),
                        onTap: () {
                          showAlertDialog(context);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt_token = prefs.getString('jwt_token');
      print("jwt_token is as follows----");
      print(jwt_token);
      user_id = prefs.getString('user_id');
      print(user_id);
      senduserid();
    });
    print("user id is as above--------");
  }

  Future<void> senduserid() async {
    print(
        '--------------------------------------Sending User Id-FOR VIEW PROFILE PAGE---------------------------------------------------');
    print(user_id);
    var apiUrl = "http://192.168.1.68:8080/v1/user/profile";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json',"Authorization":" Bearer ${jwt_token.toString()}"},
      body: json.encode({
        "_id": int.parse(user_id!),
      }),
    );

    debugPrint("post response statuscode--------------${response.statusCode}");

    if (response.statusCode == 200) {
      checkSessionExpire();
      debugPrint("post response body=======>${jsonDecode(response.body)}");
      profileData = json.decode(response.body);
      print(profileData);
      setState(() {
        firstName = profileData["data"]["firstName"];
        lastName = profileData["data"]["lastName"];
        dateOfBirth = profileData["data"]["dateOfBirth"];
        mobile = profileData["data"]["mobile"];
        email = profileData["data"]["email"];
        image = profileData["data"]["image"];
      });
      print(firstName);
      print(lastName);
      print(dateOfBirth);
      print(mobile);
      print(email);
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
  showAlertDialog(BuildContext context) {

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Do you want to logout?"),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      print('yes selected');
                      logoutUser();
                    },
                    child: Text("Yes"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade800),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print('no selected');
                        Navigator.of(context).pop();
                      },
                      child: Text("No", style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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

