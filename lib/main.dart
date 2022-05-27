import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:turnhouse/Home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:turnhouse/http_get.dart';
import 'package:turnhouse/Item_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '집켜줘 마을방송 시스템',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const LoginWidget(),
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  Future<User> get_user_info() async {
    final String url = "http://3.39.183.150:8080/api/auth/signin";
    Map data = {"userId": idController?.text, "password": passwordController?.text};
    var body = json.encode(data);
    User user;

    Http_post post_data = Http_post(url, body);

    var login_data = await post_data.getJsonData();

    user = User(//성공 실패 코드 나눌 필요 있을듯
        login_data['status'].toString(),
        "EX"
        //login_data['data']['userId'].toString()
    );

    print("수신정보 1: ${user.status}, 2: ${user.userId}");
    return user;
  }

  TextEditingController? idController;
  TextEditingController? passwordController;
  //비밀번호 창 안보이게
  bool passwordVisibility = false;
  bool certification = true;
  String status = "";

  @override
  void initState() {
    super.initState();
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {});

    idController = TextEditingController();
    passwordController = TextEditingController();
    passwordVisibility = false;
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
                    controller: idController,
                    //autovalidateMode: AutovalidateMode.always,
                    //onSaved: (value),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return '아이디를 확인해 주세요';
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
                      labelText: '아이디',
                      hintText: '관리자에게 제공받은 아이디를 입력하세요.',
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
                      suffixIcon: idController!.text.isNotEmpty
                          ? InkWell(
                        onTap: () => setState(
                              () => idController?.clear(),
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

                //비밀번호 입력창 패딩
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 16),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return '비밀번호를 확인해 주세요';
                      }
                      
                      return null;
                    },
                    obscureText: !passwordVisibility,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      hintText: '비밀번호를 입력하세요.',
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

                      //비밀번호 숨김 버튼
                      suffixIcon: InkWell(
                        onTap: () => setState(
                              () => passwordVisibility = !passwordVisibility,
                        ),
                        child: Icon(
                          passwordVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Color(0xFF757575),
                          size: 22,
                        ),
                      ),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MainWidget()),
                              );
                            }
                            else{
                              print("로그인 실패...");
                              //아이디 비번 창 초기화 및 알림
                              idController?.text = "";
                              passwordController?.text = "";

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

                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(60, 10, 60, 50),
                  child: Container(
                    width: 130,
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        print('signup pressed ...');

                        launch('https://www.google.com/search?q=%EC%BA%A1%EC%8A%A4%ED%86%A4%EB%94%94%EC%9E%90%EC%9D%B8+%EC%9D%B4%EA%B1%B0+%EB%AD%94%EA%B0%80%EC%9A%94&sxsrf=ALiCzsbS_MMJHGdSSP79VlJv6Tt5z-Ib6w%3A1651854340085&ei=BEx1Yr7lBITy-QbntZwg&oq=%EC%BA%A1%EC%8A%A4%ED%86%A4%EB%94%94%EC%9E%90%EC%9D%B8+%EC%9D%B4%EA%B1%B0+&gs_lcp=Cgdnd3Mtd2l6EAEYAjIFCCEQoAEyBQghEKABMgUIIRCgAToHCAAQRxCwAzoECCMQJzoFCAAQgARKBAhBGABKBAhGGABQ5gNY3Alg8BxoAXABeACAAZoBiAGVBpIBAzAuNpgBAKABAcgBCsABAQ&sclient=gws-wiz');
                      },
                      child: Text('회원가입'),
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