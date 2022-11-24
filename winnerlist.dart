import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jeetogyanse/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WinnerListPage extends StatefulWidget {
  const WinnerListPage({Key? key}) : super(key: key);

  @override
  State<WinnerListPage> createState() => _WinnerListPageState();
}

class _WinnerListPageState extends State<WinnerListPage> {
  var homePageData;

  String? jwt_token;
  bool checkIndi=true;
  @override
  void initState() {
    super.initState();
    checkJwtToken();
    setState(() {
      checkInternetConnection();
    });
  }
  checkJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt_token = prefs.getString('jwt_token');
      print("jwt_token is as follows----");
      print(jwt_token);
      getWinnerList();
    });
    print("user id is as above--------");
  }
  checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult==ConnectivityResult.none){
      checkIndi = false;
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
    return checkIndi==false
        ?

    Center(child: Text("Something Went Wrong !",style: TextStyle(fontSize: 20,),))
        : homePageData == null || homePageData.isEmpty
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
                    leading: ClipOval(
                      child: Container(
                          height: 50,
                          width: 50,
                          child: Image.network(
                            "${homePageData["data"][index]['image']}",
                            fit: BoxFit.fill,
                          )),
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Name-${homePageData["data"][index]['firstName']}",
                                style: TextStyle(color: Colors.black)),
                            SizedBox(width: 5,),
                            Text("${homePageData["data"][index]['lastName']}",
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                        Text("ContestTimeNo-${homePageData["data"][index]['contestId']}",
                            style: TextStyle(color: Colors.black)),
                        Text("AnswerTime-${homePageData["data"][index]['answerTime']} Sec",
                            style: TextStyle(color: Colors.black)),
                        Text("DateOfContest-${homePageData["data"][index]['date']}",
                            style: TextStyle(color: Colors.black)),
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

  getWinnerList() async {
    print(
        '-------------------------------------------------API INTEGRATION Winner List Is Started---------------------------------------------------------');

    final response = await http.get(Uri.parse('http://192.168.1.68:8080/v1/winnerlist'),headers: {"Authorization":" Bearer ${jwt_token.toString()}" });


    if (response.statusCode == 200) {
      checkIndi=true;
      checkSessionExpire();
      debugPrint("Show Responce=${json.decode(response.body)}");
      setState(() {
        homePageData = json.decode(response.body);
      });
    }
    else {
      checkIndi==false;
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
