// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:openim_demo/main.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() async{
//  var pub = PublishSubject<int>();
//  pub.sink.add(1);
//  pub.stream.listen((event) {
//    print('1-------$event');
//   });
//  pub.stream.listen((event) {
//    print('2-------$event');
//  });
//  pub.sink.add(2);
// }


//动态listview
// class PlazaContent extends StatelessWidget{
//
//   List<Widget> _getData(){
//     List<Widget> list = [];
//     for(var i=0;i<20;i++){
//       list.add(ListTile(
//         title: Text("我是$i列表"),
//       ));
//     }
//     return list;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //
//     return ListView(
//         children: this._getData()
//     );
//   }
// }


//圆角
// ClipOval(
// child: Image.network(
// "https://desk-fd.zol-img.com.cn/t_s960x600c5/g6/M00/03/0E/ChMkKWDZLXSICljFAC1U9uUHfekAARQfgG_oL0ALVUO515.jpg",
// width: 50,
// height: 50,
// fit: BoxFit.cover,
// ),
// ),

//容器圆角
// decoration: new BoxDecoration(
// //color: Colors.white,
// //设置四周圆角 角度
// borderRadius: BorderRadius.all(Radius.circular(50.0)),
// //设置四周边框
// border: new Border.all(width: 50, color: Colors.red),
// )


//内边距 外边距
// Container(
// child: Image.network(
// "https://c-ssl.duitang.com/uploads/blog/202107/09/20210709142454_dc8dc.jpeg",
// width: 60,
// // height: 400,
// ),
// alignment: Alignment.topLeft,
// padding: EdgeInsets.all(15.0),//内边距 容器和子件的距离
// margin: EdgeInsets.all(5.0),//外边距 容器和外边的距离
// color: Colors.green,
// ),);

//HTTP请求
// TextButton(
// onPressed: () async {
// print("11111");
// final Dio _dio = Dio();
// var res = await _dio.get("http://www.baidu.com/");
// print(res);
//
// },
// child: Text("TextButton按钮"),
// ),
// );


// 卡片
// child: Card(
//     child:InkWell(
//         //splashColor: Colors.deepOrangeAccent,
//         onTap: () => print("sdfsdafdsafasdf"),
//         child:Image.asset('assets/images/ceh.png'),
//
//     )
// )



/*
* 可以让子控件自动换行的控件
*
* */
// class WrapWidget extends StatelessWidget {
//   const WrapWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 2, //主轴上子控件的间距
//       runSpacing: 5, //交叉轴上子控件之间的间距
//       children: Boxs(), //要显示的子控件集合
//     );
//   }
//
//   /*一个渐变颜色的正方形集合*/
//   // ignore: non_constant_identifier_names
//   List<Widget> Boxs() => List.generate(10, (index) {
//     return Container(
//       width: 100,
//       height: 100,
//       alignment: Alignment.center,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(colors: [
//           Colors.orangeAccent,
//           Colors.orange,
//           Colors.deepOrange
//         ]),
//       ),
//       child: const Text(
//         "23333",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   });
// }


//监听需要改变的值， 一但改变，就可以会发生界面变化
//Expanded 超出边距 显示处理
// wrap 是自动换行，和row 一样的效果，row不能换行，wrap就可以换行
// Obx(() => Expanded(
// child: Wrap(
// spacing: 10.0,
// alignment: WrapAlignment.start,
// runSpacing: 10.0,
// children: PublishPicFun(),
// ),
// )),



//设置圆角
// shape: RoundedRectangleBorder(
// //这里是modal的边框样式
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(20),
// topRight: Radius.circular(20),
// ),
// ),


//修饰边框
// decoration: BoxDecoration(
// border: Border(
// bottom: BorderSide(color: Colors.grey, width: 1),
// //bottom: BorderSide(color: Colors.grey, width: 1),
// ) // 上边边框
// ),


//时间戳
// static int currentTimeMillis() {
// return new DateTime.now().millisecondsSinceEpoch;
// }


//返回
// IconButton(
// icon: Icon(Icons.arrow_back_sharp),
// onPressed: (){
// Get.back();
// },
// ),

// import 'dart:convert';
//
// void main() async{
//  var sss = {"188":233, "sss":"ddd"};
//  int time = 1646728287921;
//  var date = DateTime.fromMillisecondsSinceEpoch(time).toString();
//  print(date.substring(0,19));
// }


//字符串拼接
// Text("123123---${index}"),