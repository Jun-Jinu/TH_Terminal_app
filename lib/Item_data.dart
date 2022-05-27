class Customer_Service {
  DateTime date;//자동저장_요청일
  String title;
  String sender;
  String category;
  String content;
  bool answer_check = false;

  Customer_Service(
      this.date,
      this.title,
      this.sender,
      this.category,
      this.content,
      this.answer_check
  );
}

class new_Terminal {//이름 번호 주소 보호자번호 보호자이름
  DateTime date;//요청일_now로 자동저장 ++
  String name;
  String ph;
  String address;
  String protector_name;
  String protector_ph;
  bool answer_check = false;//답변유무

  new_Terminal(
      this.date,
      this.name,
      this.ph,
      this.address,
      this.protector_name,
      this.protector_ph,
      this.answer_check
      );
}

class Broadcast {
  DateTime date;
  String receiver;
  String content;//음성 Speech To Text

  Broadcast(
      this.date,
      this.receiver,
      this.content
  );
}

class Message {//클리어
  String id;
  String townId;
  String target;//수신자 설정(전체_a, 마을관리자_m, 보호자_p)
  String content;//내용
  bool success;
  String date;

  Message(
      this.id,
      this.townId,
      this.target,
      this.content,
      this.success,
      this.date
  );
}

class Event {
  String townId;
  String title;
  String content;
  String fromEventDate;
  String toEventDate;

  Event(this.townId, this.title, this.content, this.fromEventDate,
      this.toEventDate);
}

class Weather {
  String temp;//현재 온도
  String tempMin;//최저 온도
  String tempMax;//최고 온도
  String weatherMain;//흐림정도
  int code;//흐림정도의 id(icon 작업시 필요)

  Weather(
    this.temp,
    this.tempMin,
    this.tempMax,
    this.weatherMain,
    this.code,
  );
}

class User {
  String status;
  String userId;

  User(this.status, this.userId);
}