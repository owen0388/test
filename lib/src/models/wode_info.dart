/// 我的个人信息
class woDeInfo {
  var currentPage;
  var showNumber;
  List woDeInfoList = [];
  List woDeInfoListone = [];


  ///构造函数 如果不用一开始就赋值，可以省略构造，需要手动赋值之后，在用这个类
  woDeInfo(
    this.currentPage,
    this.showNumber,
  );

  woDeInfo.fromJson(Map<String, dynamic> jsonDate) {
    print("我的个人信息");
    currentPage = jsonDate["data"]["currentPage"];
    showNumber = jsonDate["data"]["showNumber"];
    woDeInfoList = jsonDate["data"]["workMoments"];
    print(currentPage);
    print(showNumber);
  }

  woDeInfo.fromJson_1(Map<String, dynamic> jsonDate) {
    print("我的个人信息1");
    print(jsonDate);
    woDeInfoListone[0] = jsonDate["data"]["workMoments"];
  }
}
