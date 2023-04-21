import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../community/page_view/like/mock.dart';
import '../../../community/page_view/widgets/publish_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:dart_mock/dart_mock.dart' as mock;

import '../../../wcao/ui/tag.dart';
import '../../../wcao/ui/theme.dart';
import '../../community_logic.dart';
import '../widgets/guanzhu_card.dart';

/// HACK: 社区-关注

class PageViewLike extends StatefulWidget {
  const PageViewLike({Key? key}) : super(key: key);

  @override
  State<PageViewLike> createState() => _PageViewLikeState();
}

class _PageViewLikeState extends State<PageViewLike> {
  List items = [];
  List TempList = [].obs;

  final comlogic = Get.find<communitylogic>();
  var GuanZhuNum = 0.obs;

  /// mockdata
  String searchText = mock.csentence(min: 3, max: 10);

  /// 热门话题
  List<Map> list = List.generate(mock.integer(min: 4, max: 12), (index) {
    return {
      "avatar":
          'https://cdn.wcao.cc/assets/avatar/profile/${mock.integer(min: 1, max: 19)}.jpg',
      "tag": mock.cword(min: 2, max: 4)
    };
  });

  /// 热门标签
  List<String> labelData = List.generate(
      mock.integer(min: 4, max: 10), (index) => mock.cword(min: 4, max: 12));

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      // MockLike.clear();
      // items = MockLike.get();
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (items.length > 60) {
      _refreshController.loadNoData();
    }

    setState(() {
      // items = MockLike.get();
    });
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      //items = MockLike.get();

    });
  }


  ///我是有底线的
  Container labelDiXian() {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 48, left: 48, right: 48),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
            height: .5,
            color: WcaoTheme.placeholder,
          )),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child:
                Text('我是有底线的', style: TextStyle(color: WcaoTheme.placeholder)),
          ),
          Expanded(
              child: Container(
            height: .25,
            color: WcaoTheme.placeholder,
          )),
        ],
      ),
    );
  }



  //界面显示
  @override
  Widget build(BuildContext context) {

    print("guanzhufjsldfjlskjfsd ---- ${comlogic.applicationList.length}");
    for (var i = 0; i <= comlogic.applicationList.length-1; i++) {
      for (var k = 0; k <= comlogic.friendCircleList.length-1; k++) {
        if(comlogic.applicationList[i].toUserID == comlogic.friendCircleList[k]["userID"]){
          TempList.add(comlogic.friendCircleList[k]);
          GuanZhuNum = GuanZhuNum + 1;
        }
      }
    }

    print("guanzhu: ${GuanZhuNum}");

    return Container(
      padding: const EdgeInsets.only(top: 12),
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        enablePullDown: true,
        enablePullUp: true,
        child: Obx(() =>ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: GuanZhuNum.toInt(),
          itemBuilder: (context, index) {

            print("关注列表 ---------  1111");
            print(GuanZhuNum);
            print(index);
            print("关注列表 ---------  2222");

            return GuanZhuCard(TempList[index]);
          }
        )),
      ),
    );
  }
}
