/// 朋友圈信息
class communityInfo {
  var currentPage;
  var showNumber;
  List communityList = [];
  List communityListone = [];


  ///构造函数 如果不用一开始就赋值，可以省略构造，需要手动赋值之后，在用这个类
  communityInfo(
    this.currentPage,
    this.showNumber,
  );

  communityInfo.fromJson(Map<String, dynamic> jsonDate) {
    print("朋友圈信息数据处理");
    currentPage = jsonDate["data"]["currentPage"];
    showNumber = jsonDate["data"]["showNumber"];
    communityList = jsonDate["data"]["workMoments"];
    print(currentPage);
    print(showNumber);
  }

  communityInfo.fromJson_1(Map<String, dynamic> jsonDate) {
    print("单个朋友圈处理");
    print(jsonDate);
    communityListone[0] = jsonDate["data"]["workMoments"];

  }
}
