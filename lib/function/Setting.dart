import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:settings_ui/settings_ui.dart';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:th_iot/bluetooth/MainPage.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class SettingWidget extends StatefulWidget {
  const SettingWidget({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<SettingWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSwitched = false;
  bool isAlarm = false;

  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

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
        centerTitle: false,
        elevation: 2,
      ),
      body: SettingsList(//
        lightTheme: const SettingsThemeData(
          settingsListBackground: Color(0xFF1A1925),
          settingsSectionBackground: Color(0xFF252735),

          titleTextColor: Color(0xFF4391F1),
          
          leadingIconsColor: Colors.white,//아이콘
          settingsTileTextColor: Colors.white,//제목
          tileDescriptionTextColor: Colors.white70,//부제
          trailingTextColor: Colors.white,//우측 텍스트

          dividerColor: Colors.white70,//구분선
          inactiveSubtitleColor: Colors.white,

          //Color(0xFF252735)
        ),
        sections: [
          SettingsSection(
            title: Text('단말기 상태'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.online_prediction),
                title: Text('인터넷 연결 상태'),
                value: Text('양호'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.camera),
                title: Text('카메라 연결'),
                value: Text('양호'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.sensors),
                title: Text('카메라 센서 작동'),
                value: Text('양호'),
                //trailing: Text('굿'), 이거 앱에 시도해보기
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.info_outline),
                title: Text('단말기 어플 버전'),
                value: Text('현재 버전 0.0.3'),
              ),
            ],
          ),



          SettingsSection(
            title: Text('기본 설정'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('언어'),
                value: Text('한국어'),
                onPressed: (context){},
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.bluetooth),
                title: Text('블루투스 설정'),
                value: Text('한국어'),
                onPressed: (context){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
              ),
              SettingsTile.switchTile(
                initialValue: isAlarm,
                onToggle: (value) {
                  setState(() {
                    isAlarm = value;
                  });
                },
                leading: Icon(Icons.alarm_on),
                title: Text('소리 알림'),

              ),//이거 데이터 적용?
              SettingsTile.switchTile(
                title: Text('휴대전화 메시지 사용'),
                leading: Icon(Icons.phone_android),
                initialValue: isSwitched,
                onToggle: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
            ],
          ),

          SettingsSection(
            margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
            title: Text('기타'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.question_answer),
                title: Text('고객센터/도움말'),
                onPressed: (context){},
              ),

            ],
          ),
        ],
      ),
    );
  }
}
