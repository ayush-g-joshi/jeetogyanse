import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jeetogyanse/update-profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({Key? key}) : super(key: key);

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  List dataList = List.from([]);
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  TextEditingController dateinput = TextEditingController();

  final picker = ImagePicker();
  late Future<PickedFile?> pickedFile = Future.value(null);
  var profileData;

  String? user_id;

  var firstName;

  var lastName;

  var dateOfBirth;

  var mobile;

  var email;

  var image;

  String? jwt_token;

  @override
  void initState() {
    checkId();
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
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xff113162)),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "View Profile",
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
          return profileData == null || profileData.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                  color: Color(0xff113162),
                  strokeWidth: 5,
                ))
              : Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: ClipOval(
                          child: Container(
                            height: 200,
                            width: 200,
                            color: Color(0xff113162),
                            child: FittedBox(
                              child: Image.network('$image'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Name-$firstName $lastName",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "DOB-$dateOfBirth",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Mobile No-$mobile ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Email-$email",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          color: Colors.black,
                          thickness: 2,
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
                            "Edit Profile",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => UpdateProfilePage()));
                          },
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xff113162)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }

  Future<void> senduserid() async {
    print(
        '--------------------------------------Sending User Id-FOR VIEW PROFILE PAGE---------------------------------------------------');
    print(user_id);
    var apiUrl = "http://192.168.1.68:8080/v1/user/profile";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        "_id": int.parse(user_id!),
      }),
    );

    debugPrint("post response statuscode--------------${response.statusCode}");

    if (response.statusCode == 200) {
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
