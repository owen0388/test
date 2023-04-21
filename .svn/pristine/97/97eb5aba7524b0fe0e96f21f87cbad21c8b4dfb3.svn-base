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

/// HACK: 社区-关注

class PageViewRecommend extends StatefulWidget {
  const PageViewRecommend({Key? key}) : super(key: key);

  @override
  State<PageViewRecommend> createState() => _PageViewRecommendState();
}

class _PageViewRecommendState extends State<PageViewRecommend> {
  List items = [];
  var pagsidx = 1;
  final comlogic = Get.find<communitylogic>();

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

    comlogic.getCommunityList();

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (items.length > 100) {
      _refreshController.loadNoData();
    }

    ///页数加1，然后获取下一页数据
    pagsidx = comlogic.friendCirclePages + 1;
    comlogic.updateCommunityList(pagsidx);

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      //items = comlogic.friendCircleList;
    });
  }


  ///热点帖子
  Container label(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Wrap(
        alignment: WrapAlignment.start,
        children: labelData
            .map((e) => Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          width: MediaQuery.of(context).size.width / 2,
          child: Text(
            '# $e',
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: WcaoTheme.fsL,
            ),
          ),
        )).toList(),
      ),
    );
  }



  ///热点标题
  Container topic() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      height: 76,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        children: list
            .map(
              (item) => Container(
            margin: const EdgeInsets.only(right: 12),
            alignment: Alignment.bottomLeft,
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(item['avatar']),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tag(
                  item['tag'],
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 4, right: 6),
                  backgroundColor: WcaoTheme.primary,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }


  ///搜索
  Padding search() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: WcaoTheme.bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        height: 36,
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: WcaoTheme.placeholder,
            ),
            Container(
              margin: const EdgeInsets.only(left: 4),
              child: Text(
                searchText,
                style: TextStyle(
                  color: WcaoTheme.secondary,
                ),
              ),
            )
          ],
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      child: GetBuilder<communitylogic>(builder: (controller) {
        return SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          enablePullDown: true,
          enablePullUp: true,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: comlogic.friendCircleList.length,
            itemBuilder: (context, index) {

              var item = comlogic.friendCircleList[index];
              items = comlogic.friendCircleList;
              if (index == 0) {
                return Column(
                    children:[
                      // search(),//搜索
                      // topic(),//图片
                      // label(context),//磁标
                      PublishCard(item),//朋友圈内容
                    ]
                );
              } else{
                if(index == comlogic.friendCircleList.length-1){
                  return Column(
                      children:[
                        PublishCard(item),
                        // labelDiXian(),
                      ]
                  );
                }else{
                  return PublishCard(item);
                }
              }
            },
          ),
        );
      },
    ));
  }
}
