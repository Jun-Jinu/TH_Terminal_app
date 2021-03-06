import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:th_iot/function/Setting.dart';
import 'package:th_iot/function/View_Broadcast.dart';
import 'package:th_iot/function/View_Event.dart';
import 'package:th_iot/function/View_Notification.dart';
import 'package:th_iot/Item_data.dart';
import 'package:th_iot/function/http_func.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:web_socket_channel/status.dart' as status;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    Future <dynamic> emergency () async {
      final String url = "http://3.39.183.150:8080/api/emergency/${context.read<User_info>().town_id}";

      Http_get get_data = Http_get(url);
      var event_data = await get_data.getJsonData();

      print(event_data);
      return event_data;
    }

    final FlutterTts tts = FlutterTts();
    tts.setLanguage('ko');
    tts.setSpeechRate(0.4);

    final WebSocketChannel channel =
    IOWebSocketChannel.connect('ws://3.39.144.176:8080/ws/announce');

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF1A1925),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.3,
                  height: height * 0.4,
                  child:ElevatedButton(
                    onPressed: () {
                      print('summit pressed ...');

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotificationWidget()),
                      );
                    },
                    style: ButtonStyle(
                      //backgroundColor: MaterialStateProperty.all(Color(0xFF252735)),
                      //textStyle: GoogleFonts.lato(color: Colors.white),
                    ),
                    child: Text(
                      '????????????',
                      style: GoogleFonts.gothicA1(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),

                Column(
                  children: [
                    Container(
                      width: width * 0.3,
                      height: height * 0.3,
                      //padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                      child: Image.asset(
                        'assets/logo.png',
                      ),
                    ),
                    Container(
                      width: width * 0.3,
                      height: height * 0.1,
                      child: Text(
                        '${context.read<User_info>().user_name}??? ???????????????.\n',
                        style: GoogleFonts.gothicA1(
                          color: Colors.green,
                          fontSize: 16  ,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    StreamBuilder(//????????? ??????
                      // ????????? ???????????? stream ????????? ??????. widget??? ?????? MyHomePage??? ????????? ?????? ??????
                      stream: channel.stream,
                      // ?????? stream??? ????????? ???????????? ?????? ??????
                      builder: (context, snapshot) {
                        var r_data;
                        //?????? content['content']
                        if(snapshot.hasData){
                          r_data = snapshot.data;
                          var content = jsonDecode(r_data);
                          tts.speak(content['content']);
                          return Text("????????? ????????? ????????????.",
                              style: GoogleFonts.gothicA1(
                                color: Colors.blue,
                                fontSize: 12 ),
                          );
                        }
                        else
                          return Text("");
                        /*return AlertDialog(
                          buttonPadding: EdgeInsets.all(25.0),
                          titlePadding: EdgeInsets.fromLTRB(30.0, 20.0, 40.0, 40.0),
                          backgroundColor: Color(0xFF252735),
                          title:Text(
                            '????????? ??????????????????.',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 50,
                            ),
                          ),
                          content: Text(
                            content['content'],
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('??????',
                                style: GoogleFonts.lato(
                                  fontSize: 30,
                                ),
                              ),
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );*/
                      },
                    ),
                  ],
                ),

                Container(
                  width: width * 0.3,
                  height: height * 0.4,
                  child:ElevatedButton(
                    onPressed: () {
                      print('summit pressed ...');

                      showDialog(
                          context: context,
                          //barrierDismissible: false,
                          builder: (BuildContext context){
                            return AlertDialog(
                              buttonPadding: EdgeInsets.all(25.0),
                              titlePadding: EdgeInsets.fromLTRB(30.0, 20.0, 40.0, 40.0),
                              backgroundColor: Color(0xFF252735),
                              title:Text(
                                '??????????????? ?????????',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 50,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('??????',
                                    style: GoogleFonts.lato(
                                      fontSize: 30,
                                    ),
                                  ),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('??????',
                                    style: GoogleFonts.lato(
                                      fontSize: 30,
                                    ),
                                  ),
                                  onPressed: (){
                                    emergency().then((result) {//?????? JSON post??????
                                      setState(() {
                                        Navigator.pop(context, '?????? ??????');
                                      });
                                    });

                                  },
                                ),
                              ],
                            );
                          }
                      );
                    },
                    style: ButtonStyle(
                      //backgroundColor: MaterialStateProperty.all(Color(0xFF252735)),
                      //textStyle: GoogleFonts.lato(color: Colors.white),
                    ),
                    child: Text(
                      '????????????',
                      style: GoogleFonts.gothicA1(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),


            //?????? ?????? 2???
            Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.3,
                  height: height * 0.4,
                  child:ElevatedButton(
                    onPressed: () {
                      print('summit pressed ...');

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventWidget()),
                      );

                      //tts.speak("???????????? ????????? 100??? ???????????????.");
                    },
                    child: Text(
                      '????????????',
                      style: GoogleFonts.gothicA1(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),

                Container(
                  width: width * 0.3,
                  height: height * 0.4,
                  child:ElevatedButton(
                    onPressed: () {
                      print('summit pressed ...');

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BroadcastWidget()),
                      );
                    },
                    child: Text(
                      '????????????',
                      style: GoogleFonts.gothicA1(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),

                Container(
                  width: width * 0.3,
                  height: height * 0.4,
                  child:ElevatedButton(
                    onPressed: () {
                      print('summit pressed ...');

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingWidget()),
                      );
                    },
                    child: Text(
                      '????????????',
                      style: GoogleFonts.gothicA1(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

