import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turnhouse/Item_data.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class add_Event extends StatefulWidget {
  const add_Event({Key? key}) : super(key: key);

  @override
  _add_EventWidgetState createState() => _add_EventWidgetState();
}

class _add_EventWidgetState extends State<add_Event> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  //카테고리 드롭 버튼 설정
  final _valueList = ['행사 종류를 선택하세요.','일반 행사', '긴급 행사'];
  var _selectedValue = '행사 종류를 선택하세요.';
  
  //날짜 설정
  final format = DateFormat("yyyy-MM-dd HH:mm");

  var _title = TextEditingController();
  var _content = TextEditingController();

  @override
  void dispose(){
    _title.dispose();
    _content.dispose();
    super.dispose();
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
            size: 40,
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
            fontSize: 28,
          ),
        ),
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: Color(0xFF1A1925),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(30, 10, 0, 10),
                      child: Text(
                        '마을 행사 추가',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DateTimeField(
                    format: format,
                    validator: (value){
                      if(value == null){
                        return '행사 시작 일자와 시간을 입력해주세요';
                      }
                      return null;
                    },
                    style: GoogleFonts.lato(
                      color: Colors.black87,
                      fontSize: 24,
                    ),
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime:
                          TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: '행사 시작',
                      hintText: '행사 시작 날과 시간을 입력해주세요.',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1.5,
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
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _title,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return '행사 이름을 입력해주세요';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: '제목',
                      hintText: '행사 이름을 입력해주세요.',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1.5,
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
                    ),
                    style: GoogleFonts.lato(
                      color: Colors.black87,
                      fontSize: 24,
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blue,
                        width: 1.5,
                    ),
                      borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton(
                    value: _selectedValue,
                    items: _valueList.map(
                        (value){
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        },
                    ).toList(),
                    onChanged: (value){
                      setState(() {
                        _selectedValue = value.toString();
                      });
                    },
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                    ),
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _content,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return '행사 설명을 입력해주세요';
                      }
                      return null;
                    },
                    minLines: 6,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: '내용',
                      hintText: '행사 설명을 입력해주세요.',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1.5,
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
                    ),
                    style: GoogleFonts.lato(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            print('취소 버튼 pressed ...');

                            Navigator.pop(context, '이전 화면');
                          },
                          child: Text(
                              '취  소',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            print('확인 버튼 pressed ...');


                            //_addEvent(Event(DateTime.now(), '2', '3', '4', '5'));

                            if(_formKey.currentState!.validate()){
                              Navigator.pop(context, '이전 화면');
                            }
                          },
                          child: Text(
                              '확  인',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
