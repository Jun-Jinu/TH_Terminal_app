import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turnhouse/Item_data.dart';

class TownInfoWidget extends StatefulWidget {
  const TownInfoWidget({Key? key}) : super(key: key);

  @override
  _TownInfoWidgetState createState() => _TownInfoWidgetState();
}

class _TownInfoWidgetState extends State<TownInfoWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _new_Terminal = <new_Terminal>[];

  void _add_Terminal(new_Terminal terminal){
    setState(() {
      _new_Terminal.add(terminal);

      terminal.date = DateTime.now();
      terminal.name = '전진우';
      terminal.ph = '010-1998-2022';
      terminal.address = '서울특별시 광진구 능동 어딘가';
      terminal.protector_name = '나를 집켜줘';
      terminal.protector_ph = '010-0000-0000';
      terminal.answer_check = false;

    });
  }

  void _delete_Terminal(new_Terminal terminal){
    setState(() {
      _new_Terminal.remove(terminal);
    });
  }
  Widget _buildItemWidget(new_Terminal terminal) {
    String a_check;
    return ListTile(
      onTap: () {
        showDialog(
            context: context,
            //barrierDismissible: false,
            builder: (BuildContext context){
              return AlertDialog(
                backgroundColor: Color(0xFF252735),
                title:Text(
                  terminal.name + '의 단말기 정보',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        ' •  단말기 추가 신청일자: ' + terminal.date.month.toString() + '월 '
                            + terminal.date.day.toString() + '일 ' + '\n\n' +
                            ' •  사용자 전화번호: ' + terminal.ph + '\n\n' +
                            ' •  사용자 주소: ' + terminal.address + '\n\n' +
                            ' •  보호자 이름: ' + terminal.protector_name + '\n\n' +
                            ' •  보호자 전화번호: ' + terminal.protector_ph + '\n\n' ,
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
        Icons.home_filled,
        color: Colors.white,
        size: 24.0,
      ),
      title: Text(
        terminal.name,
        //+ ' ( ' + terminal.ph + ' ) ',
      ),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white24,
            width: 0.5,
          )
      ),
      subtitle: Text(
        '보호자 : ' + terminal.protector_name,
        //+ ' ( ' + terminal.protector_ph + ' ) ',

        style: GoogleFonts.lato(
          color: Colors.white38,
        ),
      ),
      trailing: Text(
          '주소: ' + terminal.address
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
              _add_Terminal(new_Terminal(DateTime.now(), '2', '3', '4', '5', '6', false));
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
                      '사용자 정보',
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
                  children: _new_Terminal.map((new_Terminal) => _buildItemWidget(new_Terminal)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}