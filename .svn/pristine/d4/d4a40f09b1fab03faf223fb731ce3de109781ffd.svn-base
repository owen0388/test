import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openim_demo/src/pages/contacts/contacts_view.dart';
import 'package:openim_demo/src/pages/conversation/conversation_view.dart';
import 'package:openim_demo/src/pages/mine/mine_view.dart';
import 'package:openim_demo/src/pages/workbench/workbench_view.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/bottombar.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';
import '../../widgets/im_widget.dart';
import '../publish/publish_logic.dart';
import '../wcao/ui/theme.dart';

class PublishPage extends StatelessWidget {
  final logic = Get.find<PublishLogic>();
  List<Container> picLayer = [];
  File? _imageFile;
  final _picker = ImagePicker();
  List<File> picPath = [];
  String textFixdeDesc = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: EnterpriseTitleBar.leftTitle(
        //   title: StrRes.publish,
        // ),
        // backgroundColor: PageStyle.c_FFFFFF,
        appBar: AppBar(
          elevation: 3,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_sharp),
            onPressed: () {
              Get.back();
            },
            color: Colors.black,
          ),
          title: Text("发布",
              style: TextStyle(
                color: WcaoTheme.base,
                fontSize: WcaoTheme.fsXl,
                fontWeight: FontWeight.bold,
              )),
          actions: [
            Container(
              width: 50,
              margin: EdgeInsets.all(10),
              //padding: EdgeInsets.all(5),
              child: TextButton(
                  onPressed: () {
                    print("发表");
                    logic.pubListFunc(textFixdeDesc, picPath);
                  },
                  child: Text(
                    "发表",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                  )),
            ),
          ],
          centerTitle: true,
          backgroundColor: PageStyle.c_FFFFFF,
        ),
        body: Column(
          //列，开始位置，最左边
          crossAxisAlignment: CrossAxisAlignment.start,
          //子组件
          children: [
            //容器
            Container(
              padding: EdgeInsets.all(12),
              //输入框
              child: TextField(
                //控制大小写
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.none,
                textAlign: TextAlign.start,
                //粘贴 剪切 粘贴 选中是否显示
                toolbarOptions: ToolbarOptions(
                    copy: true, cut: true, paste: true, selectAll: true),
                //最大10行
                maxLines: 5,
                //输入内容监听
                controller: _controller(),
                //输入框的装饰
                decoration: InputDecoration(
                    //输入文字的内边距 true 无内边距
                    isCollapsed: true,
                    // //提示语
                    // labelText:"开心每一天",
                    // //提示语样式
                    // labelStyle: TextStyle(color: Colors.grey),

                    //占位提示textfield占位语，类似于iOS中的placeholder
                    hintText: "记录这一刻，晒给懂你的人...",
                    //占位语颜色
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),

                    //辅助语
                    helperText: "开心每一天，记录这瞬间",
                    //辅助语样式
                    helperStyle: TextStyle(fontSize: 10, color: Colors.grey),

                    //默认边框为红色，边框宽度为2
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    //获取焦点后（选中输入框时），边框为黑色，宽度为2
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2))),
              ),
            ),
            //监听 图片插入变化
            Obx(() => Expanded(
                  //Expanded 超出边界处理
                  child: Wrap(
                    spacing: 10.0,
                    alignment: WrapAlignment.start, //最左边开始
                    runSpacing: 10.0,
                    children: PublishPicFun(context), //图片相片插入
                  ),
                )),
          ],
        ));
  }

  //-------图片，相片，插入处理---------//
  List<Container> PublishPicFun(context) {
    //先清空列表
    picLayer.clear();
    print("#################################################");
    print(picPath.length);
    print(logic.picNumber.value);
    if (picPath.length > 0) {
      print(picPath[0]);
    }
    //添加到列表
    for (var i = 0; i < logic.picNumber.value; i++) {
      //最多9个
      if (i < picPath.length) {
        print("走if");
        //添加
        picLayer.add(Container(
            width: 80,
            height: 80,
            //容器边距

            margin: EdgeInsets.all(7),
            //容器边框
            decoration: BoxDecoration(
              border: Border.all(
                width: 5.0,
                color: Colors.grey,
              ),
            ),
            child: IconButton(
              icon: Image.file(
                picPath[i],
                fit: BoxFit.cover,
              ), //注意，不能加载本地图片，把这个单成一个文件来看待，是一个图片文件
              tooltip: "点击插入图片", //按住提示语
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    //设置圆角
                    shape: RoundedRectangleBorder(
                      //这里是modal的边框样式
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return Column(mainAxisSize: MainAxisSize.min, // 设置最小的弹出
                          children: <Widget>[
                            TextButton(
                              child: Text("拍摄"),
                              onPressed: () {
                                _pickImageFromCamera();
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text("相册"),
                              onPressed: () {
                                _pickImageFromGallery();
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text("取消"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ]);
                    });
              },
            )));
      } else {
        print("走else");
        //添加
        picLayer.add(Container(
            width: 80,
            height: 80,
            //容器边距
            margin: EdgeInsets.all(7),
            //容器边框
            decoration: BoxDecoration(
              border: Border.all(
                width: 5.0,
                color: Colors.grey,
              ),
            ),
            child: IconButton(
              icon: Image.asset('assets/images/ceh.png'),
              tooltip: "点击插入图片", //按住提示语
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    //设置圆角
                    shape: RoundedRectangleBorder(
                      //这里是modal的边框样式
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return Column(mainAxisSize: MainAxisSize.min, // 设置最小的弹出
                          children: <Widget>[
                            TextButton(
                              child: Text("拍摄"),
                              onPressed: () {
                                _pickImageFromCamera();
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text("相册"),
                              onPressed: () {
                                _pickImageFromGallery();
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text("取消"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ]);
                    });
              },
            )));
      }
    }

    // //位置信息
    // picLayer.add(Container(
    //   child: Card(
    //     child: ListTile(
    //       title: Text("位置信息"),
    //       leading: Icon(Icons.location_on_outlined),
    //       trailing: Icon(Icons.navigate_next),
    //       onTap: () {
    //         print('位置信息');
    //       },
    //     ),
    //   ),
    // ));

    // //谁可以看
    // picLayer.add(Container(
    //   child: Card(
    //     child: ListTile(
    //       title: Text("谁可以看"),
    //       leading: Icon(Icons.person),
    //       trailing: Icon(Icons.navigate_next),
    //       onTap: () {
    //         print('谁可以看');
    //       },
    //     ),
    //   ),
    // ));

    return picLayer;
  }

  //输入框监听
  TextEditingController _controller() {
    TextEditingController _controller = TextEditingController(
      text: "",
    );

    _controller.addListener(() {
      print(_controller.text);
      textFixdeDesc = _controller.text;
    });

    return _controller;
  }

  Future<void> _pickImageFromGallery() async {
    if (logic.picNumber.value <= 9) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        this._imageFile = File(pickedFile.path);
        picPath.add(File(pickedFile.path));
        logic.picNumber.value += 1;
        print(picPath[0]);
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    if (logic.picNumber.value <= 9) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        this._imageFile = File(pickedFile.path);
        picPath.add(File(pickedFile.path));
        logic.picNumber.value += 1;
        print(picPath[0]);
      }
    }
  }
}
