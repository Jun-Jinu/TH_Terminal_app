import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:th_iot/Item_data.dart';
import 'package:th_iot/Home.dart';
import 'package:th_iot/function/http_func.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<User_info>(create: (_) => User_info()),
        ChangeNotifierProvider<Notice>(create: (_) => Notice()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '집켜줘 단말기 APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: const LoginWidget(title: '집켜줘 단말기 APP'),
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  Future<Login_info> get_user_info() async {
    final String url = "http://3.39.144.176:8080/api/terminal?phone=${phController?.text}";

    Login_info info;

    Http_get get_data = Http_get(url);

    var login_data = await get_data.getJsonData();

    info = Login_info(
        login_data['status'],
        login_data['data'][0]['id'].toString(),
        login_data['data'][0]['townId'].toString(),
      login_data['data'][0]['name'].toString()

    );

    print("수신정보 이름: ${info.status}, 마을id: ${info.townId}");
    return info;
  }

  TextEditingController? phController;
  bool certification = true;
  String status = "";

  @override
  void initState() {
    super.initState();
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {});

    phController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF1A1925),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                //로고 패딩
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 150,
                    height: 150,
                    //fit: BoxFit.fill,
                  ),
                ),

                //아이디 입력창 패딩
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 16, 30, 16),
                  child: TextFormField(
                    controller: phController,
                    //autovalidateMode: AutovalidateMode.always,
                    //onSaved: (value),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return '전화번호를 확인해 주세요';
                      }
                      return null;
                    },
                    onChanged: (_) => EasyDebounce.debounce(
                      'idController',
                      Duration(milliseconds: 2000),
                          () => setState(() {}),
                    ),
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: '전화번호',
                      hintText: '010********',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF4291F2),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: phController!.text.isNotEmpty
                          ? InkWell(
                        onTap: () => setState(
                              () => phController?.clear(),
                        ),
                        child: Icon(
                          Icons.clear,
                          color: Color(0xFF757575),
                          size: 22,
                        ),
                      )
                          : null,
                    ),
                    style: GoogleFonts.lato(
                      color: Colors.black87,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(60, 20, 60, 10),
                  child: Container(
                    width: 130,
                    height: 40,
                    child:ElevatedButton(
                      onPressed: () {
                        print('summit pressed ...');

                        get_user_info().then((result) {//가입 JSON post받음
                          //print(result.status);
                          setState(() {
                            status = result.status;
                            print("상태: " + status);

                            if(_formKey.currentState!.validate() && status == "OK"){
                              context.read<User_info>().set_user_id(result.id);
                              context.read<User_info>().set_town_id(result.townId);
                              context.read<User_info>().set_user_name(result.name);
                              //유져 id, 마을 id, 유져 name 데이터 프로바이더로 저장

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyHomePage()),
                              );
                            }
                            else{
                              print("로그인 실패");
                              //아이디 비번 창 초기화 및 알림
                              phController?.text = "";

                              _formKey.currentState!.validate();
                            }
                          });
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFF4291F2)),
                      ),
                      child: Text('로그인'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
