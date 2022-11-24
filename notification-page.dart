import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jeetogyanse/loginpage.dart';
import 'package:jeetogyanse/menupage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationePage extends StatefulWidget {
  const NotificationePage({Key? key}) : super(key: key);

  @override
  State<NotificationePage> createState() => _NotificationePageState();
}

class _NotificationePageState extends State<NotificationePage> {
  var homePageData;

  var date;

  String? jwt_token;

  @override
  void initState() {
    super.initState();
    getNotification();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff113162)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(color: Color(0xff113162)),
        centerTitle: true,
        title: Text(
          "Notification",
          style: TextStyle(
            fontSize: 30,
            color: Color(0xff113162),
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: homePageData == null || homePageData.isEmpty
          ? Center(
              child: CircularProgressIndicator(
              color: Color(0xff113162),
              strokeWidth: 5,
            ))
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: homePageData.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: ListTile(
                          leading: Icon(Icons.notification_add),
                          title: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${homePageData["data"][index]['title']}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,)),
                                  Text("${homePageData["data"][index]['body']}",
                                      style: TextStyle(color: Colors.black)),
                                  Text("${homePageData["data"][index]['formatDate']}",
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ],
                          ),

                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black38,
                    ),
                  ],
                );
              },
            ),
    );
  }

  getNotification() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    jwt_token = prefs.getString('jwt_token');
    print("jwt_token is as follows----");
    print(jwt_token);
    
    
    print(
        '-------------------------------------------------API INTEGRATION For Subject ListSTARTED---------------------------------------------------------');
    final response =
        await http.get(Uri.parse('http://192.168.1.68:8080/v1/notifications'),headers: {"Authorization":" Bearer ${jwt_token.toString()}" });
    if (response.statusCode == 200) {
      checkSessionExpire();
      debugPrint("Show Responce=${json.decode(response.body)}");
      setState(() {
        homePageData = json.decode(response.body);
        /*   date = DateTime.fromMillisecondsSinceEpoch(homePageData[0]['date']);
        print(date);*/
      });
    } else {
      checkSessionExpire();
      print(
          '-------------------------------------------------Failed-----------------------------------------------------------');
    }
  }

  dateConverter(String value) {
    var finalvalue = "";
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
