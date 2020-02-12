import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:quiver/async.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';

import '../views/eachProperty.dart';
import '../components/propertyList.dart';
import '../components/pills.dart';
import '../login.dart';
import '../classes/message.dart';
import '../components/notificationPill.dart';

class MessagesTab extends StatefulWidget {
  final String dataKind;

  MessagesTab({this.dataKind});

  @override
  State<StatefulWidget> createState() => _MessagesTabState(dataKind: dataKind);
}

class _MessagesTabState extends State<MessagesTab> {
  Map data;
  List userData;
  static List updatedData;

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  final String dataKind;

  bool isAuth = false;

  _MessagesTabState({this.dataKind});

  Future isAuthValid() async{
    SharedPreferences shared_User = await SharedPreferences.getInstance();
    bool isAuthenticated = shared_User.getBool("isAuth");
    setState(() {
      isAuth = isAuthenticated;
    });
  }

  getData() async {
    return this._memoizer.runOnce(() async {
    SharedPreferences shared_User = await SharedPreferences.getInstance();
    bool isAuthenticated = shared_User.getBool("isAuth");
    List user = shared_User.getStringList("user");
    setState(() {
      isAuth = isAuthenticated;
    });
    var response;

    if (isAuthenticated) {
      response = await http.get(
          Uri.encodeFull(
              "http://www.gohome.ng/get_message.php?receiver_id=" + user[0]),
          headers: {"Accept": "application/json"});
      List userData;
      print(userData);
      userData = json.decode(response.body);

      // Message messages =Message.fromJson(response.body);

      // userData = [messages.title, messages.body, messages.senderName];

      if (userData.isEmpty) {
        return null;
      } else {
        setState(() {
          updatedData = [for (var i = 0; i < 1; i += 1) userData[i]];
        });

        debugPrint(userData.toString());
        return userData;
      }
    } else {
      print("Not auth");
    }
    });
  }
  int _start = 10;
  int _current = 10;

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    isAuthValid();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     //   body: Container(
  //     //       child: SingleChildScrollView(
  //     //     child: Column(
  //     //       children: <Widget>[
  //     //         isAuth
  //     //             ? updatedData[0] == null && _current > 0
  //     //                 ? SafeArea(
  //     //                     child: Center(
  //     //                       child: Container(
  //     //                         padding: EdgeInsets.all(10),
  //     //                         child: Column(
  //     //                           children: <Widget>[
  //     //                             Container(
  //     //                               width: MediaQuery.of(context).size.width,
  //     //                               height: 110,
  //     //                               margin: EdgeInsets.all(10),
  //     //                               child: Shimmer.fromColors(
  //     //                                 baseColor: Colors.grey,
  //     //                                 highlightColor: Colors.white60,
  //     //                                 child: Card(),
  //     //                               ),
  //     //                             ),
  //     //                             Container(
  //     //                               height: 110,
  //     //                               width:
  //     //                                   MediaQuery.of(context).size.width * 0.8,
  //     //                               margin: EdgeInsets.all(10),
  //     //                               child: Shimmer.fromColors(
  //     //                                 baseColor: Colors.grey,
  //     //                                 highlightColor: Colors.white60,
  //     //                                 child: Card(),
  //     //                               ),
  //     //                             ),
  //     //                             Container(
  //     //                               height: 110,
  //     //                               width:
  //     //                                   MediaQuery.of(context).size.width * 0.8,
  //     //                               margin: EdgeInsets.all(10),
  //     //                               child: Shimmer.fromColors(
  //     //                                 baseColor: Colors.grey,
  //     //                                 highlightColor: Colors.white60,
  //     //                                 child: Card(),
  //     //                               ),
  //     //                             )
  //     //                           ],
  //     //                         ),
  //     //                       ),
  //     //                     ),
  //     //                   )
  //     //                 : _current <= 0 && updatedData[0] == null
  //     //                     ? Container(
  //     //                         child: Center(
  //     //                           child: Container(
  //     //                             padding: EdgeInsets.all(30),
  //     //                             margin: EdgeInsets.only(top: 170),
  //     //                             child: Column(
  //     //                               children: <Widget>[
  //     //                                 Icon(
  //     //                                   Icons.notification_important,
  //     //                                   size: 80,
  //     //                                 ),
  //     //                                 Text(
  //     //                                   "No Messages found for this user",
  //     //                                   textAlign: TextAlign.center,
  //     //                                   style: TextStyle(
  //     //                                     fontSize: 30,
  //     //                                     color: Colors.grey,
  //     //                                   ),
  //     //                                 ),
  //     //                               ],
  //     //                             ),
  //     //                           ),
  //     //                         ),
  //     //                       )
  //     //                     : ListView.builder(
  //     //                         shrinkWrap: true,
  //     //                         physics: ClampingScrollPhysics(),
  //     //                         itemCount:
  //     //                             updatedData == null ? 0 : updatedData.length,
  //     //                         itemBuilder: (context, index) {
  //     //                           final item = updatedData[index];
  //     //                           return GestureDetector(
  //     //                             onTap: () {
  //     //                               Navigator.push(
  //     //                                 context,
  //     //                                 MaterialPageRoute(
  //     //                                   builder: (context) =>
  //     //                                       EachProperty(items: item),
  //     //                                 ),
  //     //                               );
  //     //                             },
  //     //                             child: PropertyList(
  //     // id: item["id"],
  //     // amount: item["title"],
  //     // location: item["message"],
  //     //                             ),
  //     //                           );
  //     //                         },
  //     //                       )
  //     //             : Center(
  //     //   child: Column(
  //     //   children: <Widget>[
  //     //     Container(
  //     //       margin: EdgeInsets.only(top: 250),
  //     //       child: Icon(
  //     //         Icons.priority_high,
  //     //         size: 40,
  //     //         color: Colors.red,
  //     //       ),
  //     //     ),
  //     //     Container(
  //     //       child: Text("You are not logged in!!!", style: TextStyle(fontSize: 20),),
  //     //     )
  //     //   ],
  //     // ))
  //     //       ],
  //     //     ),
  //     //   )),
  //     // );
  //     body: SingleChildScrollView(
  //       child: Column(
  //         children: <Widget>[
  //           Container(
  //             width: double.infinity,
  //             padding: EdgeInsets.all(10),
  //             child: Center(
  //               child: Row(
  //                 children: <Widget>[
  //                   Text(
  //                     "Showing all Messages for this user",
  //                     style: TextStyle(fontSize: 15.0),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           isAuth
  //               ?
  //               Container(
  //                   margin: EdgeInsets.only(top: 20),
  //                   child: new FutureBuilder(
  //                     future: getData(),
  //                     builder: (context, snapshot) {
  //                       if (snapshot.hasData && _current > 0) {
  //                         var myData = snapshot.data;
  //                         print("Noll " + myData);
  //                         return ListView.builder(
  //                           shrinkWrap: true,
  //                           physics: ClampingScrollPhysics(),
  //                           itemBuilder: (context, index) {
  //                             final item = myData[index];
  //                             print(item["id"]);
  //                             return PropertyList(
  //                               id: item["id"],
  //                               amount: item["title"],
  //                               location: item["message"],
  //                             );
  //                           },
  //                           itemCount: myData.length,
  //                         );
  //                       } else if (!snapshot.hasData && _current > 0) {
  //                         return Center(
  //                           child: CircularProgressIndicator(),
  //                         );
  //                       } else {
  //                         return Column(
  //                           children: <Widget>[
  //                             Container(
  //                               margin: EdgeInsets.only(top: 250),
  //                               child: Icon(
  //                                 Icons.priority_high,
  //                                 size: 40,
  //                                 color: Colors.red,
  //                               ),
  //                             ),
  //                             Container(
  //                               child: Text(
  //                                 "You don't have any message!!!",
  //                                 style: TextStyle(fontSize: 20),
  //                               ),
  //                             )
  //                           ],
  //                         );
  //                       }
  //                     },
  //                   ),
  //                 )
  //               : Container(
  //                   margin: EdgeInsets.only(top: 200),
  //                   child: Column(
  //                     children: <Widget>[
  //                       Text(
  //                         "You are not logged in!!!",
  //                         style: TextStyle(fontSize: 20),
  //                       ),
  //                       Container(
  //                         child: MaterialButton(
  //                           child: Text(
  //                             "Login",
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                           color: Color(0xFF79c942),
  //                           onPressed: () {
  //                             Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                 builder: (context) => Login(),
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          NotificationPill(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF79c942),
        child: Icon(Icons.add),
        onPressed: null,
      ),
    );
  }
}