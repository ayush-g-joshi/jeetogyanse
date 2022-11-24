import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jeetogyanse/loginpage.dart';
import 'package:jeetogyanse/quiz.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class StartContestPage extends StatefulWidget {
  const StartContestPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StartContestPage> createState() => _StartContestPageState();
}

class _StartContestPageState extends State<StartContestPage> {
  var homePageData;

  var subId;
  var contestId;

  String? jwt_token;

  var circularIndicator;
  String? user_id;

  @override
  void initState() {

    checkJwtToken();
    setState(() {
      checkInternetConnection();
    });
  }

  splashScreen() async {
    Timer(
        Duration(seconds: 3),
            () => Text("ERROR"));
  }
  checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
          msg: "You Are Not Connected To Internet!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  checkJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print("user id is as Below--------");
      user_id = prefs.getString('user_id');
      print(user_id);

      jwt_token = prefs.getString('jwt_token');
      print("jwt_token is as follows----");
      print(jwt_token);
      getSubject();
    });
    print("user id is as above--------");
  }


  @override
  Widget build(BuildContext context) {
    return homePageData == null || homePageData.isEmpty
        ? Center(
        child: CircularProgressIndicator(
          color: Color(0xff113162),
          strokeWidth: 5,
        ))
        : Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: homePageData["data"].length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: Container(
                        height: 60,
                        width: 60,
                        child: Image.network(
                          "${homePageData["data"][index]["image"]}",
                          fit: BoxFit.fill,
                        )),
                    title: Text("${homePageData["data"][index]["sub"]}",
                        style: TextStyle(color: Colors.black)),
                    onTap: () {
                      final subId = homePageData["data"][index]["_id"];
                      print("Subject id number is---------${subId}");
                      startContestone(subId);
                      startContestwo(subId);
                      startContesthree(subId);
                      startContestfour(subId);
                      startContestfive(subId);
                      noContest();
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
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

  getSubject() async {
    print(
        '-------------------------------------------------API INTEGRATION For Subject ListSTARTED---------------------------------------------------------');
    final response = await http.get(
        Uri.parse('https://jeetogyanse-api.herokuapp.com/v1/home'),
        headers: {"Authorization": " Bearer ${jwt_token.toString()}"});

    if (response.statusCode == 200) {
      checkSessionExpire();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs?.setBool("isLoggedIn", true);

      setState(() {
        homePageData = json.decode(response.body);
      });
      print(homePageData);
      print('Success code is as follows');
      print("${homePageData["success"]};");
    } else {
      checkSessionExpire();
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

  startContestone(subId) async {
    //Tocalculate current date

    var currentTime = DateTime.now();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String todayDate = formatter.format(now);

    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    print("WE ARE CALLING STARTCONTEST_ONE METHOD");
    formattedDate = formatter.format(now);
    print(formattedDate);

    var startTime = "$formattedDate 17:00:00";
    var format1 = DateFormat('yyyy-MM-dd HH:mm:ss');
    var startTimeWithDate = format1.parse(startTime);
    print(startTimeWithDate);

    var endTime = "$formattedDate 18:30:00";
    var endTimeWithDate = format1.parse(endTime);
    print(endTimeWithDate);
    contestId = 10;
    print(currentTime);

    if (currentTime.isAfter(startTimeWithDate) &&
        currentTime.isBefore(endTimeWithDate)) {
      checkQuizTiming(subId, contestId);
    }
  }

  startContestwo(subId) async {
    //Tocalculate current date
    print("WE ARE CALLING Current Date");
    var currentTime = DateTime.now();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String todayDate = formatter.format(now);

    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    print("WE ARE CALLING STARTCONTEST_ONE METHOD");
    formattedDate = formatter.format(now);
    print(formattedDate);

    var startTime = "$formattedDate 12:00:00";
    var format1 = DateFormat('yyyy-MM-dd HH:mm:ss');
    var startTimeWithDate = format1.parse(startTime);
    print(startTimeWithDate);

    var endTime = "$formattedDate 12:30:00";
    var endTimeWithDate = format1.parse(endTime);
    print(endTimeWithDate);

    print(currentTime);
    contestId = 12;

    if (currentTime.isAfter(startTimeWithDate) &&
        currentTime.isBefore(endTimeWithDate)) {
      checkQuizTiming(subId, contestId);
    }
    ;
  }

  startContesthree(subId) async {
    //Tocalculate current date
    print("WE ARE CALLING Current Date");
    var currentTime = DateTime.now();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String todayDate = formatter.format(now);

    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    print("WE ARE CALLING STARTCONTEST_ONE METHOD");
    formattedDate = formatter.format(now);
    print(formattedDate);

    var startTime = "$formattedDate 14:00:00";
    var format1 = DateFormat('yyyy-MM-dd HH:mm:ss');
    var startTimeWithDate = format1.parse(startTime);
    print(startTimeWithDate);

    var endTime = "$formattedDate 14:30:00";
    var endTimeWithDate = format1.parse(endTime);
    print(endTimeWithDate);

    print(currentTime);
    contestId = 2;

    if (currentTime.isAfter(startTimeWithDate) &&
        currentTime.isBefore(endTimeWithDate)) {
      checkQuizTiming(subId, contestId);
    }
  }

  startContestfour(subId) async {
    //Tocalculate current date
    print("WE ARE CALLING Current Date");
    var currentTime = DateTime.now();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String todayDate = formatter.format(now);

    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    print("WE ARE CALLING STARTCONTEST_ONE METHOD");
    formattedDate = formatter.format(now);
    print(formattedDate);

    var startTime = "$formattedDate 16:00:00";
    var format1 = DateFormat('yyyy-MM-dd HH:mm:ss');
    var startTimeWithDate = format1.parse(startTime);
    print(startTimeWithDate);

    var endTime = "$formattedDate 16:30:00";
    var endTimeWithDate = format1.parse(endTime);
    print(endTimeWithDate);

    print(currentTime);
    contestId = 4;

    if (currentTime.isAfter(startTimeWithDate) &&
        currentTime.isBefore(endTimeWithDate)) {
      checkQuizTiming(subId, contestId);
    }
  }

  startContestfive(subId) async {
    //Tocalculate current date
    print("WE ARE CALLING Current Date");
    var currentTime = DateTime.now();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String todayDate = formatter.format(now);

    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    print("WE ARE CALLING STARTCONTEST_ONE METHOD");
    formattedDate = formatter.format(now);
    print(formattedDate);

    var startTime = "$formattedDate 19:00:00";
    var format1 = DateFormat('yyyy-MM-dd HH:mm:ss');
    var startTimeWithDate = format1.parse(startTime);
    print(startTimeWithDate);

    var endTime = "$formattedDate 19:30:00";
    var endTimeWithDate = format1.parse(endTime);
    print(endTimeWithDate);

    print(currentTime);
    contestId = 7;

    if (currentTime.isAfter(startTimeWithDate) &&
        currentTime.isBefore(endTimeWithDate)) {
      checkQuizTiming(subId, contestId);
    }
  }

  noContest() {
    Fluttertoast.showToast(
        msg: "You Can Play The Game Only At Once As Per Time Slot ", // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        timeInSecForIosWeb: 1 // duration
    );
  }

  checkQuizTiming(subId, contestId) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    print(formatted);

    print(
        '--------------------------------------Checking Quiz Test Timing---------------------------------------------------');
    var apiUrl = "http://192.168.1.68:8080/v1/recheck";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Authorization": " Bearer ${jwt_token.toString()}"
      },
      body: jsonEncode({
        "_id": int.parse(user_id!),
        "contestSlot": contestId,
        "contestDate": formatted.toString(),
      }),
    );

    debugPrint("post response statuscode=======>${response.statusCode}");
    if (response.statusCode == 200) {
      checkSessionExpire();
      Fluttertoast.showToast(
        msg: json.decode(response.body)["message"], // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.CENTER, // location
        timeInSecForIosWeb: 1, // duration
      );

      Navigator.of(context).push(MaterialPageRoute(

          builder: (_) => QuizPage(
            subId: subId,
            contestId: contestId,
          )));
    } else {
      checkSessionExpire();
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
        '-------------------------------------------------API INTEGRATION For checkSessionExpire   STARTED---------------------------------------------------------');
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
