import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jeetogyanse/exit-popup.dart';
import 'package:jeetogyanse/loginpage.dart';
import 'package:jeetogyanse/menupage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourScoreListPage extends StatefulWidget {
  var result_id;
  var answer1;
  var answer2;
  var answer3;
  var answer4;
  var answer5;
  var start_test_time;
  var end_test_time;
  var anstime;
  var contest_time;
  var subId;
  var ans_in_seconds;
  var score;
  var finalContestId;

  YourScoreListPage(
      {Key? key,
      this.finalContestId,
      this.subId,
      this.answer1,
      this.answer2,
      this.answer3,
      this.answer4,
      this.answer5,
      this.contest_time,
      this.ans_in_seconds})
      : super(key: key);

  @override
  State<YourScoreListPage> createState() => _YourScoreListPageState();
}

class _YourScoreListPageState extends State<YourScoreListPage> {
  var ResultData;
  var result_id;
  var user_id;
  var finaluserid;

  var lastContestId;

  String? jwt_token;

  @override
  void initState() {
    checkId();
    super.initState();
    lastContestId = widget.finalContestId;
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
  checkId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print("user id is as Below--------");
      user_id = prefs.getString('user_id');
      print(user_id);
      submitQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () => showExitPopup(context),
        child: Builder(builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Your Quiz-Test Was Successfully Submitted!",
                  style: TextStyle(

                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text("YOUR RESULT IS-",
                  style: TextStyle(

                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  height: 50,
                  width: 50,
                  child: result_id == null || result_id.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Color(0xff113162),
                          strokeWidth: 5,
                        ))
                      : Center(
                          child: Text(
                            "${result_id}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 250,
                height: 40,
                child: ElevatedButton(
                  child: Text(
                    "Back To Menu",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => MenuPage()));
                    }
                  },
                  style: ButtonStyle(
                    shadowColor: MaterialStatePropertyAll(Colors.black,),
                    side: MaterialStatePropertyAll(BorderSide(color: Colors.black)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
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

  submitQuiz() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    jwt_token = prefs.getString('jwt_token');
    print("jwt_token is as follows----");
    print(jwt_token);
    
    print(
        '--------------------------------------Sending Question And Answer Of Test And Calculating Result----------------------------------------------------');
    var apiUrl = "http://192.168.1.68:8080/v1/question/result";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json',"Authorization":" Bearer ${jwt_token.toString()}"},
      body: jsonEncode({
        "user_id": int.parse(user_id!),
        "sub_id": widget.subId,
        "question1": 1,
        "answer1": widget.answer1.toString(),
        "question2": 2,
        "answer2": widget.answer2.toString(),
        "question3": 3,
        "answer3": widget.answer3.toString(),
        "question4": 4,
        "answer4": widget.answer4.toString(),
        "question5": 5,
        "answer5": widget.answer5.toString(),
        "contestTime": widget.contest_time,
        "answerTime": widget.ans_in_seconds,
        "contestId": lastContestId,
      }),
    );

    debugPrint("post response statuscode=======>${response.statusCode}");
    if (response.statusCode == 200) {

      checkSessionExpire();
      print('success');
      print("contest id is as below");
      print("Subject  id is as below");
      print(widget.subId);
      print(lastContestId);
      print(response.body);

      showData();

      setState(() {
        ResultData = json.decode(response.body);
        result_id = ResultData['data'].toString();
      });
      print(result_id);
      print(ResultData);
    } else {
      checkSessionExpire();
      print(
          '-------------------------------------------------Failed-----------------------------------------------------------');
    }
  }

  Future<void> showData() async {
    setState(() {
      print("WE ARE SAVING OUR DATA AS FOLLOWS-----------------------------");
      print(user_id);
      print(widget.subId);
      print(widget.answer1);
      print(widget.answer2);
      print(widget.answer3);
      print(widget.answer4);
      print(widget.answer5);
      print(widget.contest_time);
      print(widget.ans_in_seconds);
    });
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
