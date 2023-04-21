import 'dart:io';

/// 发布朋友圈
class WechatMomentsInfo {
  int ? errCode;
  String?  errMsg;
  dynamic data;
  String? userID;


  WechatMomentsInfo({
    this.errCode,
    this.errMsg,
    this.data,
    this.userID,
  });

  WechatMomentsInfo.fromJson(Map<String, dynamic> json) {
    print("json##############");
    print(json);
    errCode = json['errCode'];
    errMsg = json['errMsg'];
    data = json['data'];
    print(errCode);
    print(errMsg);
    print(data);
  }

  Map<String, dynamic> toJson(String text,List<File> PicDate) {
    print("@@@@@@@@@@@@@@@");
    print(text);
    print(PicDate);
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = text;
    data['PicDate'] = PicDate;

    return data;
  }
}


/// 发布一跳评论
class commentInfo {
  int ? errCode;
  String?  errMsg;
  dynamic data;


  commentInfo({
    this.errCode,
    this.errMsg,
    this.data,
  });

  commentInfo.fromJson(Map<String, dynamic> json) {
    print("json##############");
    print(json);
    errCode = json['errCode'];
    errMsg = json['errMsg'];
    data = json['data'];
    print(errCode);
    print(errMsg);
    print(data);
  }

  Map<String, dynamic> toJson(String text,List<File> PicDate) {
    print("@@@@@@@@@@@@@@@");
    print(text);
    print(PicDate);
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = text;
    data['PicDate'] = PicDate;

    return data;
  }
}
