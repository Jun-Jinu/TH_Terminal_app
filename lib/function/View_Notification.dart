import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:th_iot/Item_data.dart';
import 'package:th_iot/function/Add_Notification.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //임시로 값을 저장받을 변수 생성
  Notifications temp_noti = Notifications(DateTime.now(), "", "");

  Widget _buildItemWidget(Notifications notification){
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            //barrierDismissible: false,
            builder: (BuildContext context){
              return AlertDialog(
                backgroundColor: Color(0xFF252735),
                title: Text(
                  "[ ${notification.date.month.toString()}월${notification.date.day.toString()}일 "
                      " ${notification.date.hour.toString()}:${notification.date.minute.toString()} ]"
                      " ${notification.title}",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        ' •  내용: ' + notification.content,
                        style: GoogleFonts.lato(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('확인'),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
        );
      },
      leading: Icon(
        Icons.notifications,
        color: Colors.white,
        size: 24.0,
      ),
      title: Text(
        "[ ${notification.date.month.toString()}월${notification.date.day.toString()}일 "
            " ${notification.date.hour.toString()}:${notification.date.minute.toString()} ]"
            " ${notification.title}"
      ),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white24,
            width: 0.5,
          )
      ),
      trailing: OutlinedButton(
        onPressed: () {
          print('삭제 버튼 pressed ...');

          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Row(
                    children: <Widget>[
                      Icon(
                        Icons.dangerous_outlined,
                        color: Colors.red,
                        size: 22,
                      ),
                      Text(
                        ' 경고',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('선택한 알람을 삭제합니다.'),
                        Text('정말로 해당 알람을 삭제하시겠습니까?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('취소'),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('확인'),
                      onPressed: (){
                        context.read<Notice>().delete(notification);

                        Navigator.pop(context, '이전 화면');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NotificationWidget()),
                        );
                      },
                    ),
                  ],
                );
              }
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 1.0, color: Color(0xFF4291F2)),
        ),
        child: Text(
          '삭제',
          style: GoogleFonts.lato(
            color: Color(0xFF4291F2),
          ),
        ),
      ),

    );

  }
  @override
  Widget build(BuildContext context) {
    List<Notifications> info =  context.watch<Notice>().notice;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF252735),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF4391F1),
            size: 30,
          ),
          onPressed: () {
            print('IconButton pressed ...');

            Navigator.pop(context, '이전 화면');
          },
        ),
        title: Text(
          '홈 화면',
          style: GoogleFonts.lato(
            color: Color(0xFF4391F1),
            fontSize: 22,
          ),
        ),
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: Color(0xFF1A1925),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(40, 10, 10, 10),
                    child: Text(
                      '개인 알람',
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,

                  //여기 데이터 수정*******************8
                  children: info.map((Notifications) =>
                      _buildItemWidget(Notifications)).toList(),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 40),

                      child:Container(
                        width: 350,
                        height: 80,
                        child:ElevatedButton(
                          onPressed: () {
                            print('기능 버튼 pressed ...');

                            //_addEvent(Event(DateTime.now(), '2', '3'));
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => add_Notification()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xFF4391F1)),
                            //textStyle: GoogleFonts.lato(color: Colors.white),
                          ),
                          child: Text(
                            '개인 알람 추가',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}