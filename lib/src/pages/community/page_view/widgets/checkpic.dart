import 'package:dart_mock/dart_mock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//广场
class checkPicPage extends StatelessWidget {
  checkPicPage(this.pageList, this.curIdx, {Key? key}) : super(key: key);
  //接收数据
  final List pageList;
  final curIdx;
  List<Widget> tmpLst = [];

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < pageList.length; i++) {
      tmpLst.add(Image.network(pageList[i]));
    }
    // print(tmpLst);
    print("yyyyyyyyyyyyyyyyy");
    print(tmpLst.length);
    print(curIdx);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
        body: DefaultTabController(
            length: tmpLst.length,
            child: Builder(builder: (BuildContext context) {
              //跳转到某一页
              final TabController controller =
                  DefaultTabController.of(context)!;
              if (!controller.indexIsChanging) {
                controller.animateTo(curIdx);
              }

              //返回容器
              return Container(
                  color: Colors.black,
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  child: Column(children: <Widget>[
                    Expanded(
                        child: TabBarView(children: tmpLst)
                        // child: IconTheme(
                        //   data: IconThemeData(
                        //     size: 128.0,
                        //     color: Theme.of(context).colorScheme.secondary,
                        //   ),
                        //   child: TabBarView(children: tmpLst)
                        // ),
                        ),
                    ///图片选中标识
                    const TabPageSelector(color: Colors.black38, selectedColor: Colors.white),
                  ]
                  )
              );
            }
            )
        )
    );
  }
}
