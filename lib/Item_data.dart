import 'package:flutter/material.dart';

class Broadcast {
  DateTime date;
  String receiver;
  String content;

  Broadcast(this.date, this.receiver, this.content);
}

class Notifications {
  DateTime date;
  String title;
  String content;

  Notifications(this.date, this.title, this.content);
}

class Login_info{
  String status;
  String id;
  String townId;
  String name;

  Login_info(this.status, this.id, this.townId, this.name);
}

class User_info with ChangeNotifier{
  String _user_id = "";//유저 고유번호
  String _town_id = "";//마을 고유번호
  String _user_name = "";

  void set_user_id(String id){
    _user_id = id;
    notifyListeners();
  }

  void set_town_id(String id){
    _town_id = id;
    notifyListeners();
  }

  void set_user_name(String name){
    _user_name = name;
    notifyListeners();
  }

  String get user_id => _user_id;
  String get town_id => _town_id;
  String get user_name => _user_name;
}



class Notice with ChangeNotifier {
  //알람 기능에 들어갈 객체
  final List<Notifications> _notice = [];

  void add(Notifications new_noti) {
    _notice.add(new_noti);
    notifyListeners();
  }

  void delete(Notifications new_noti) {
    _notice.remove(new_noti);
    notifyListeners();
  }

  List<Notifications> get notice => _notice;
}