import 'package:flutter/material.dart';
import 'package:jeetogyanse/loginpage.dart';

class AfterRestPassLoginPage extends StatefulWidget {
  const AfterRestPassLoginPage({Key? key}) : super(key: key);

  @override
  State<AfterRestPassLoginPage> createState() => _AfterRestPassLoginPageState();
}

class _AfterRestPassLoginPageState extends State<AfterRestPassLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Woo hoo!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Your Password has been reset successfully!",
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  "Now login with your new password.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => LoginPage()));
                      }
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
}
