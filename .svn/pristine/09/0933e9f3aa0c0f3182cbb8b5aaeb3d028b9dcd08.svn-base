import 'package:flutter/material.dart';
import '../../res/styles.dart';
import '../community/page_view/recommend/index.dart';
import '../wcao/ui/theme.dart';
import 'package:get/get.dart';
import 'page_view/found/index.dart';
import 'page_view/like/index.dart';
import 'community_logic.dart';

/// HACK: 社区

class PageViewCommunity extends StatefulWidget {


  const PageViewCommunity({Key? key}) : super(key: key);

  @override
  State<PageViewCommunity> createState() => _PageViewCommunityState();
}

class _PageViewCommunityState extends State<PageViewCommunity>
    with TickerProviderStateMixin {
  int curPage = 0;

  final List<Tab> _tabs = const [
    Tab(text: "推荐"),
    Tab(text: "关注"),
    //Tab(text: "发现"),
  ];

  late PageController _pageController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabs.length, vsync: this);
    _pageController = PageController(initialPage: curPage);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: curPage,
      length: _tabs.length,
      child: Column(
        children: [
          setAppbar(),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: const [
                PageViewRecommend(),
                PageViewLike(),
                //PageViewFound()
              ],
            ),
          )
        ],
      ),
    );
  }

  /// appbar
  AppBar setAppbar() {
    return AppBar(
      // elevation: 3.0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: PageStyle.c_FFFFFF,
      title: TabBar(
        controller: _tabController,
        indicatorColor: WcaoTheme.primary,
        unselectedLabelColor: WcaoTheme.secondary,
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        labelColor: WcaoTheme.base,
        labelStyle: TextStyle(
          fontSize: WcaoTheme.fsXl,
          fontWeight: FontWeight.bold,
        ),
        indicatorWeight: 4.0,
        //indicatorPadding: const EdgeInsets.symmetric(horizontal: 24),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: _tabs,
        onTap: (int page) {
          setState(() {
            curPage = page;
            _pageController.jumpToPage(curPage);
          });
        },
      ),
      //导航栏最右边是否添加 邮件按钮
      // actions: [
      //   IconButton(
      //     onPressed: () {},
      //     icon: Icon(
      //       Icons.email_outlined,
      //       size: WcaoTheme.fsXl * 1.5,
      //       color: WcaoTheme.base.withOpacity(.75),
      //     ),
      //   )
      // ],
    );
  }
}
