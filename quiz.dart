import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jeetogyanse/loginpage.dart';
import 'package:jeetogyanse/quiz-exit-popup.dart';
import 'package:jeetogyanse/your-score-list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:wakelock/wakelock.dart';

class QuizPage extends StatefulWidget {
  var subId;
  var contestId;

  QuizPage({Key? key, this.subId, this.contestId}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  var finalContestId;
  var QuestionData;

  var ResultData;
  var index = 0;
  var count = 1;
  Color _colorContainerone = Colors.white;
  Color _colorContainertwo = Colors.white;
  Color _colorContainerthree = Colors.white;
  Color _colorContainerfour = Colors.white;
  var _selectedIndex = 0;
  var answerone = "";
  var answertwo = "";
  var answerthree = "";
  var answerfour = "";
  var answerfive = "";

  var value;

  bool _loading = true;

  var question1_id;
  var question2_id;
  var question3_id;
  var question4_id;
  var question5_id;
  var answer1;
  var answer2;
  var answer3;
  var answer4;
  var answer5;

  var start_test_time;
  var end_test_time;
  var anstime;
  var contest_time;

  var ans_in_seconds;
  var score;
  var result_id;

  String? jwt_token;

  @override
  void initState() {
    Wakelock.enable();
    start_test_time = DateTime.now().millisecondsSinceEpoch;
    contest_time = DateTime.now().millisecondsSinceEpoch;
    value = "";
    super.initState();
    sendsubjectid();
    setState(() {
      checkInternetConnection();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () => showQuizExitPopup(context),
        child: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: QuestionData == null || QuestionData.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                    color: Color(0xff113162),
                    strokeWidth: 5,
                  ))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(blurRadius: 5.0, color: Colors.grey)
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.white,
                          ),
                          height: 50,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Countdown(
                                  seconds: 100,
                                  build: (BuildContext context, double time) =>
                                      Center(
                                          child: Text(time.toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                  interval: Duration(milliseconds: 100),
                                  onFinished: () {
                                    setState(() {
                                      setState(() {
                                        end_test_time = DateTime.now()
                                            .millisecondsSinceEpoch;
                                        calculateTime();
                                        print(start_test_time);
                                        print(end_test_time);
                                        print(
                                            "Contest id is as mentioned below");
                                        print(widget.contestId);
                                        print(
                                            "FINAL ----Contest id is as mentioned below");
                                        finalContestId = widget.contestId;
                                        print(finalContestId);
                                        print(
                                            "Timer is over-ANSWER IS AS FOLLOWS");

                                        if (index == 4) {
                                          question5_id =
                                              QuestionData["data"][4]['_id'];
                                          answer5 = value;
                                          print(
                                              "Question id==>${question5_id}");
                                          print("answerr===>$answer5");
                                        }
                                        print("First Answer is-${answer1}");
                                        print("Second Answer is-${answer2}");
                                        print("Third Answer is-${answer3}");
                                        print("Forth Answer is-${answer4}");
                                        print("Five Answer is-${answer5}");
                                      });
                                    });
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => YourScoreListPage(
                                                  subId: widget.subId,
                                                  answer1: answer1,
                                                  answer2: answer2,
                                                  answer3: answer3,
                                                  answer4: answer4,
                                                  answer5: answer5,
                                                  contest_time: contest_time,
                                                  ans_in_seconds:
                                                      ans_in_seconds,
                                                  finalContestId:
                                                      finalContestId,
                                                )));
                                    print('Timer is done!');
                                  },
                                ),
                                Center(
                                    child: Text("Sec",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(blurRadius: 5.0, color: Colors.grey)
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(22),
                              child: Center(
                                child: Text(
                                    "${QuestionData["data"][index]['questions']}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                    )),
                              ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          children: [
                            Ink(
                              child: InkWell(
                                child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5.0, color: Colors.grey)
                                      ],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      color: _colorContainerone,
                                    ),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("(A) ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20)),
                                          Flexible(
                                            child: Text(
                                                overflow: TextOverflow.visible,
                                                "${QuestionData["data"][index]['option1']}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20)),
                                          ),
                                        ],
                                      ),
                                    )),
                                onTap: () {
                                  setState(() {
                                    _colorContainerone == Colors.tealAccent
                                        ? _colorContainerone = Colors.white
                                        : _colorContainerone =
                                            Colors.tealAccent;
                                    _colorContainertwo = Colors.white;
                                    _colorContainerthree = Colors.white;
                                    _colorContainerfour = Colors.white;
                                  });
                                  value =
                                      QuestionData["data"][index]['option1'];
                                  print(value);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Ink(
                              child: InkWell(
                                child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5.0, color: Colors.grey)
                                      ],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      color: _colorContainertwo,
                                    ),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("(B) ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20)),
                                          Flexible(
                                            child: Text(
                                                overflow: TextOverflow.visible,
                                                "${QuestionData["data"][index]['option2']}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20)),
                                          ),
                                        ],
                                      ),
                                    )),
                                onTap: () {
                                  setState(() {
                                    _colorContainertwo == Colors.tealAccent
                                        ? _colorContainertwo = Colors.white
                                        : _colorContainertwo =
                                            Colors.tealAccent;
                                    _colorContainerone = Colors.white;
                                    _colorContainerthree = Colors.white;
                                    _colorContainerfour = Colors.white;
                                  });
                                  value =
                                      QuestionData["data"][index]['option2'];
                                  print(value);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Ink(
                              child: InkWell(
                                child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5.0, color: Colors.grey)
                                      ],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      color: _colorContainerthree,
                                    ),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("(C) ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20)),
                                          Flexible(
                                            child: Text(
                                                overflow: TextOverflow.visible,
                                                "${QuestionData["data"][index]['option3']}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20)),
                                          ),
                                        ],
                                      ),
                                    )),
                                onTap: () {
                                  setState(() {
                                    _colorContainerthree == Colors.tealAccent
                                        ? _colorContainerthree = Colors.white
                                        : _colorContainerthree =
                                            Colors.tealAccent;
                                    _colorContainerone = Colors.white;
                                    _colorContainertwo = Colors.white;
                                    _colorContainerfour = Colors.white;
                                  });
                                  value =
                                      QuestionData["data"][index]['option3'];
                                  print(value);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Ink(
                              child: InkWell(
                                child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5.0, color: Colors.grey)
                                      ],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: _colorContainerfour,
                                    ),
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("(D) ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20)),
                                        Flexible(
                                          child: Text(
                                              overflow: TextOverflow.visible,
                                              "${QuestionData["data"][index]['option4']}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20)),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                  setState(() {
                                    _colorContainerfour == Colors.tealAccent
                                        ? _colorContainerfour = Colors.white
                                        : _colorContainerfour =
                                            Colors.tealAccent;

                                    _colorContainerone = Colors.white;
                                    _colorContainertwo = Colors.white;
                                    _colorContainerthree = Colors.white;
                                  });
                                  value =
                                      QuestionData["data"][index]['option4'];
                                  print(value);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: Text(
                                "Skip",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                _colorContainerone = Colors.white;
                                _colorContainertwo = Colors.white;
                                _colorContainerthree = Colors.white;
                                _colorContainerfour = Colors.white;
                                print("Skip button called");
                                if (count < 5 && index < QuestionData.length) {
                                  skipQuestion();
                                  setState(() {
                                    index++;
                                    count++;
                                  });
                                  print(index);
                                  initState();
                                } else if (count == 5 ||
                                    index == QuestionData.length) {
                                  print("FLUTTERTOAST CALLED");
                                  Fluttertoast.showToast(
                                    msg: "No More Questions", // message
                                    toastLength: Toast.LENGTH_SHORT, // length
                                    gravity: ToastGravity.CENTER, // location
                                    timeInSecForIosWeb: 3, // duration
                                  );
                                }
                              },
                              style: ButtonStyle(
                                side: MaterialStatePropertyAll(
                                    BorderSide(color: Colors.grey)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                )),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              child: Text(
                                "Next",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                _colorContainerone = Colors.white;
                                _colorContainertwo = Colors.white;
                                _colorContainerthree = Colors.white;
                                _colorContainerfour = Colors.white;
                                print("nextbutton called");
                                if (count < 5 && index < QuestionData.length) {
                                  nextQuestion();
                                  setState(() {
                                    index++;
                                    count++;
                                  });
                                  print(index);
                                  initState();
                                } else if (count == 5 ||
                                    index == QuestionData.length) {
                                  print("FLUTTERTOAST CALLED");
                                  Fluttertoast.showToast(
                                    msg: "No More Questions", // message
                                    toastLength: Toast.LENGTH_SHORT, // length
                                    gravity: ToastGravity.CENTER, // location
                                    timeInSecForIosWeb: 3, // duration
                                  );
                                }
                              },
                              style: ButtonStyle(
                                shadowColor: MaterialStatePropertyAll(
                                  Colors.grey,
                                ),
                                side: MaterialStatePropertyAll(
                                    BorderSide(color: Colors.grey)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                )),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              child: Text(
                                "Submit",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                setState(() {
                                  end_test_time =
                                      DateTime.now().millisecondsSinceEpoch;
                                  calculateTime();
                                  print(start_test_time);
                                  print(end_test_time);
                                  print("Contest id is as mentioned below");
                                  print(widget.contestId);
                                  print(
                                      "FINAL ----Contest id is as mentioned below");
                                  finalContestId = widget.contestId;
                                  print(finalContestId);
                                  print(
                                      "SUBMIT BUTTON IS CALLED -ANSWER IS AS FOLLOWS");

                                  if (index == 4) {
                                    question5_id =
                                        QuestionData["data"][4]['_id'];
                                    answer5 = value;
                                    print("Question id==>${question5_id}");
                                    print("answerr===>$answer5");
                                  }
                                  print("First Answer is-${answer1}");
                                  print("Second Answer is-${answer2}");
                                  print("Third Answer is-${answer3}");
                                  print("Forth Answer is-${answer4}");
                                  print("Five Answer is-${answer5}");
                                });

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => YourScoreListPage(
                                          subId: widget.subId,
                                          answer1: answer1,
                                          answer2: answer2,
                                          answer3: answer3,
                                          answer4: answer4,
                                          answer5: answer5,
                                          contest_time: contest_time,
                                          ans_in_seconds: ans_in_seconds,
                                          finalContestId: finalContestId,
                                        )));
                              },
                              style: ButtonStyle(
                                side: MaterialStatePropertyAll(
                                    BorderSide(color: Colors.grey)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
          );
        }),
      ),
    );
  }

  Future<void> sendsubjectid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    jwt_token = prefs.getString('jwt_token');
    print("jwt_token is as follows----");
    print(jwt_token);

    print(
        '--------------------------------------Sending Subject Id----------------------------------------------------');
    var apiUrl = "http://192.168.1.68:8080/v1/question";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Authorization": " Bearer ${jwt_token.toString()}"
      },
      body: json.encode({
        "sub_id": widget.subId,
      }),
    );

    debugPrint("post response statuscode=======>${response.statusCode}");
    if (response.statusCode == 200) {
      checkSessionExpire();
      print('success');
      print('Subject id is as follows');
      print(widget.subId);
      print(response.body);
      setState(() {
        QuestionData = json.decode(response.body);
      });
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

  nextQuestion() {
    print('------------nextQuestion is called by flutter----------');
    if (count < 5 && index < QuestionData.length) {
      if (index == 0) {
        question1_id = QuestionData["data"][0]['_id'];
        answer1 = value;
        print("Question id==>${question1_id}");
        print("answerr===>$answer1");
      } else if (index == 1) {
        question2_id = QuestionData["data"][1]['_id'];
        answer2 = value;
        print("Question id==>${question2_id}");
        print("answerr===>$answer2");
      } else if (index == 2) {
        question3_id = QuestionData["data"][2]['_id'];
        answer3 = value;
        print("Question id==>${question3_id}");
        print("answerr===>$answer3");
      } else if (index == 3) {
        question4_id = QuestionData["data"][3]['_id'];
        answer4 = value;
        print("Question id==>${question4_id}");
        print("answerr===>$answer4");
      } else if (index == 4) {
        question5_id = QuestionData["data"][4]['_id'];
        answer5 = value;
        print("Question id==>${question5_id}");
        print("answerr===>$answer5");
      }
      setState(() {
        //question_id$index=question[index]['_id'];
        index++;
        count++;
      });
      initState();
    }
  }

  skipQuestion() {
    print('------------SKIP---Question is called by flutter----------');
    if (count < 5 && index < QuestionData.length) {
      if (index == 0) {
        question1_id = QuestionData["data"][0]['_id'];
        answer1 = "NOT ANS";
        print("Question id==>${question1_id}");
        print("answerr===>$answer1");
      } else if (index == 1) {
        question2_id = QuestionData["data"][1]['_id'];
        answer2 = "NOT ANS";
        print("Question id==>${question2_id}");
        print("answerr===>$answer2");
      } else if (index == 2) {
        question3_id = QuestionData["data"][2]['_id'];
        answer3 = "NOT ANS";
        print("Question id==>${question3_id}");
        print("answerr===>$answer3");
      } else if (index == 3) {
        question4_id = QuestionData["data"][3]['_id'];
        answer4 = "NOT ANS";
        print("Question id==>${question4_id}");
        print("answerr===>$answer4");
      } else if (index == 4) {
        question5_id = QuestionData["data"][4]['_id'];
        answer5 = "NOT ANS";
        print("Question id==>${question5_id}");
        print("answerr===>$answer5");
      }
      setState(() {
        //question_id$index=question[index]['_id'];
        index++;
        count++;
      });
      initState();
    }
  }

  calculateTime() {
    anstime = end_test_time - start_test_time;
    ans_in_seconds = (anstime / 1000) % 60;
    print("CONTEST TEST TIME IS=${contest_time}");
    print(
        "TIME TAKEN TO ANSWER THE TEST IS IN MILISECOND FORMAT IS=${anstime}");
    print(
        "TIME TAKEN TO ANSWER THE TEST IS IN-SECOND FORMAT IS=${ans_in_seconds}");
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
        '-------------------------------------------------API INTEGRATION For SESSION is started--------------------------------------------------------');
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
