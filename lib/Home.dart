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
                      '개인알람',
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
                        '${context.read<User_info>().user_name}님 환영합니다.\n',
                        style: GoogleFonts.gothicA1(
                          color: Colors.green,
                          fontSize: 16  ,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    StreamBuilder(//웹소켓 수신
                      // 채널의 스트림을 stream 항목에 설정. widget을 통해 MyHomePage의 필드에 접근 가능
                      stream: channel.stream,
                      // 채널 stream에 변화가 발생하면 빌더 호출
                      builder: (context, snapshot) {
                        var r_data;
                        //글자 content['content']
                        if(snapshot.hasData){
                          r_data = snapshot.data;
                          var content = jsonDecode(r_data);
                          tts.speak(content['content']);
                          return Text("도착한 방송이 있습니다.",
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
                            '방송이 도착했습니다.',
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
                              child: Text('확인',
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
                                '긴급호출을 합니다',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 50,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('취소',
                                    style: GoogleFonts.lato(
                                      fontSize: 30,
                                    ),
                                  ),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('확인',
                                    style: GoogleFonts.lato(
                                      fontSize: 30,
                                    ),
                                  ),
                                  onPressed: (){
                                    emergency().then((result) {//가입 JSON post받음
                                      setState(() {
                                        Navigator.pop(context, '이전 화면');
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
                      '긴급호출',
                      style: GoogleFonts.gothicA1(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),


            //아래 버튼 2개
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

                      //tts.speak("김성욱님 별풍선 100개 감사합니다.");
                    },
                    child: Text(
                      '행사조회',
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
                      '방송조회',
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
                      '환경설정',
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

