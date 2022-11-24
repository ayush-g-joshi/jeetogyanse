import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsAndConditionPage extends StatefulWidget {
  const TermsAndConditionPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xff113162)),
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Text(
              "TERMS AND CONDITIONS",
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
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        '1. The Participants must be adults having attained the age of eighteen (18) years to participate in the Activity as on the date of the Activity.',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        '2. The manner, day and the basis of choosing the winner (defined below) shall be specified in the T&Cs of the ActivityThe manner, day and the basis of choosing the winner (defined below) shall be specified in the T&Cs of the Activity',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        '3. The announcement about the Winners and the Prize(s) (defined below) shall be as per the T&Cs of the Activity. ',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        '4. Participation is open to adult only i.e. only those who have completed 18 years of age',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        '5. The Contestant(s) shall undertake, warrant and guarantee to the Company that the Contestant has the full legal capacity to participate in the Show in accordance with these Terms and Conditions.',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        '6. The specific requirements for the Activity shall be outlined in the T&Cs of the Activity.',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        '7. The distribution time and mode of distribution of the Prize(s) shall be at the sole discretion of SPN.',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        '8. The Participant can win only once in this Activity. Any subsequent wins of the Participant (if declared) will beautomatically',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        '9. By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages, or make derivative versions. The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, still belong to Insta-It-Technologies.',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        '10. Insta-It-Technologies is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                        '11.With respect to Insta-It-Technologies’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavour to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Sanjeev Mehta accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app. ',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          })),
    );
  }
}
