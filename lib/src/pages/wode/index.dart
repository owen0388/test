import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_demo/src/pages/wode/wode_logic.dart';
import '../../core/controller/im_controller.dart';
import '../../routes/app_navigator.dart';
import '../../widgets/avatar_view.dart';
import '../community/page_view/like/mock.dart';
import '../community/page_view/widgets/publish_card.dart';
import '../wode/mock.dart';
import '../wcao/ui/theme.dart';
import 'package:get/get.dart';

class PageViewMine extends StatefulWidget {
  const PageViewMine({Key? key}) : super(key: key);

  @override
  State<PageViewMine> createState() => _PageViewMineState();
}

/// TODO: NestedScrollView 如何实现上拉加载，下拉刷新

class _PageViewMineState extends State<PageViewMine> {
  final imLogic = Get.find<IMController>();
  MockMine mine = MockMine.get();
  // final comlogic = Get.find<communitylogic>();
  final wodelogic = Get.find<wodeLogicdate>();

  @override
  void initState() {
    super.initState();
    MockLike.clear();

    setState(() {
      // items = MockLike.get(num: 4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: ((context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: Colors.cyan,
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: 200,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  size: WcaoTheme.fsBase * 1.6,
                  color: WcaoTheme.base,
                ),
                onPressed: () {
                  // Get.toNamed('/settings');
                  //MinePage();
                  AppNavigator.startMineSeting();
                },
              )
            ],
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                double top = constraints.biggest.height;
                bool isOpacity =
                    top == MediaQuery.of(context).padding.top + kToolbarHeight;
                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: AnimatedOpacity(
                    duration: const Duration(microseconds: 300),
                    opacity: isOpacity ? 1 : 0,
                    child: Text(
                      imLogic.userInfo.value.getShowName(),
                      style: TextStyle(
                        color: WcaoTheme.base,
                        fontSize: WcaoTheme.fsXl,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  background: Stack(
                    children: [
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: WcaoUtils.imageCache(
                      //     mine.bg,
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      Positioned(
                        child: Container(
                          color: Colors.black.withOpacity(.33),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        width: MediaQuery.of(context).size.width,
                        child: profile(),
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          /// 数据信息
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: adapterItem(mine.visits, '访客'),
                    onTap: (){print("访客");},
                  ),
                  adapterDrive(),
                  InkWell(
                    child: adapterItem(mine.friends, '好友'),
                    onTap: (){print("好友");},
                  ),
                  adapterDrive(),
                  InkWell(
                    child: adapterItem(mine.fans, '粉丝'),
                    onTap: (){print("粉丝");},
                  )
                ],
              ),
            ),
          ),
        ];
      }),
      body: ListView.builder(
        physics: const ClampingScrollPhysics(), // 重要
        padding: const EdgeInsets.all(0),
        itemCount: wodelogic.woDeList.length,
        itemBuilder: (context, index) {
          var items = wodelogic.woDeList;
          return dynamicItem(items[index], wodelogic.woDeList.length - 1 > index);
        },
      ),
    );
  }

  /// 我的动态 item
  Container dynamicItem(var item, bool bottomBorder) {
    print(item);
    return Container(
        padding: const EdgeInsets.only(bottom: 24, top: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: .5,
              color: bottomBorder ? WcaoTheme.outline : Colors.transparent,
            ),
          ),
        ),
        child: Column(
            children:[
              PublishCard(item),
            ]
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


  Column adapterItem(int num, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "$num",
          style: TextStyle(
            fontSize: WcaoTheme.fsXl,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: WcaoTheme.secondary,
          ),
        )
      ],
    );
  }

  Container adapterDrive() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      height: 12,
      width: .5,
      color: WcaoTheme.placeholder,
    );
  }

  /// 个人信息
  Widget profile() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            ClipOval(
            child: AvatarView(
              size: 110.h,
              url: imLogic.userInfo.value.faceURL,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  imLogic.userInfo.value.getShowName(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: WcaoTheme.fsXl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Icon(
                //   Icons.edit_note,
                //   color: Colors.white,
                //   size: WcaoTheme.fsBase * 2,
                // ),
              ],
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(top: 12),
          //   child: Text(
          //     '${mine.createDay}天 ${mine.tags.length}动态',
          //     style: TextStyle(
          //       color: WcaoTheme.placeholder,
          //     ),
          //   ),
          // ),
          // Container(
          //   margin: const EdgeInsets.only(top: 6),
          //   child: Wrap(
          //     alignment: WrapAlignment.center,
          //     spacing: 12,
          //     runSpacing: 6,
          //     children: List.generate(
          //       mine.tags.length,
          //       (index) {
          //         if (index >= mine.tags.length - 1) {
          //           // 添加标签
          //           return InkWell(
          //             onTap: () => Get.toNamed('/mine/add-tag'),
          //             child: Tag(
          //               '+',
          //               padding: const EdgeInsets.symmetric(
          //                   horizontal: 24, vertical: 4),
          //               backgroundColor: Colors.black.withOpacity(.4),
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(24),
          //               fontSize: WcaoTheme.fsBase,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           );
          //         } else {
          //           return Tag(
          //             mine.tags[index],
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 12, vertical: 4),
          //             backgroundColor: Colors.black.withOpacity(.4),
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(24),
          //             fontSize: WcaoTheme.fsBase,
          //             fontWeight: FontWeight.bold,
          //           );
          //         }
          //       },
          //     ).toList(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
