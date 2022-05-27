import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turnhouse/Item_data.dart';
import 'package:turnhouse/Adding/add_Broadcast.dart';

class BroadcastWidget extends StatefulWidget {
  const BroadcastWidget({Key? key}) : super(key: key);

  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<BroadcastWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _Broadcast = <Broadcast>[];

  void _addBroadcast(Broadcast broadcast){
    setState(() {
      _Broadcast.add(broadcast);

      broadcast.date = DateTime.now();
      broadcast.receiver = '전진우';
      broadcast.content = '내용123';

    });
  }

  void _deleteBroadcast(Broadcast broadcast){
    setState(() {
      _Broadcast.remove(broadcast);
    });
  }
  Widget _buildItemWidget(Broadcast broadcast){
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            //barrierDismissible: false,
            builder: (BuildContext context){
              return AlertDialog(
                backgroundColor: Color(0xFF252735),
                title: Text(
                  broadcast.date.month.toString() + '/' + broadcast.date.day.toString() +
                      ' - ' + broadcast.receiver + '에게 방송한 내역',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        ' •  내용: ' + broadcast.content,
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
      leading: Text(
          broadcast.date.month.toString() + '/' + broadcast.date.day.toString()
      ),
      title: Text(
          broadcast.receiver + '에게 방송한 내역'
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
                        Text('선택한 행사 기록을 삭제합니다.'),
                        Text('정말로 해당 기록을 삭제하시겠습니까?'),
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
                        _deleteBroadcast(broadcast);
                        Navigator.of(context).pop();
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
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF252735),
        automaticallyImplyLeading: false,
        leading: IconButton(
          //borderColor: Colors.transparent,
          //borderRadius: 30,
          //borderWidth: 1,
          //buttonSize: 60,
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
        actions: [
          IconButton(//위치조정 & 모양 기능 변경 필요
            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 40, 0),
            icon: Icon(
              Icons.plus_one_outlined,
              color: Color(0xFF4391F1),
              size: 30,
            ),
            onPressed: () {
              print('IconButton pressed ...');

              //테스트용 코드!!!
              _addBroadcast(Broadcast(DateTime.now(), '2', '3'));
            },
          ),
        ],
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
                      '마을 방송 내역',
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
                  children: _Broadcast.map((broadcast) => _buildItemWidget(broadcast)).toList(),
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
                            print('방송하기 버튼 pressed ...');

                            //_addEvent(Event(DateTime.now(), '2', '3'));
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => add_Broadcast()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xFF4391F1)),
                            //textStyle: GoogleFonts.lato(color: Colors.white),
                          ),
                          child: Text(
                            '방 송 하 기',
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