import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/styles.dart';
import '../plaza/plaza_logic.dart';

//广场
class PlazaPage extends StatelessWidget {
  final logic = Get.find<PlazaLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(//官方给的固定一个布局方式
      //导航栏
      appBar:AppBar(
        elevation: 0.5,//顶部导航栏的阴影
        title: Text("广场",style: TextStyle(fontSize:16,color: Colors.lightBlue)),//标题
        centerTitle:true,
        backgroundColor: PageStyle.c_FFFFFF,
      ),

      //内容区域
      body: Container(
        height: 300,
        width: 300,
        color: Colors.lightBlueAccent,
        alignment:Alignment.center,
        child: Container(
          height: 100,
          width: 100,
          child: Image.asset("assets/1.jpg"),
          color: Colors.red,
        ),
      )
    );
  }
}


class PlazaContent extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: this._getData()
    );
  }

  List<Widget> _getData(){
    List<Widget> list = [];
    for(var i=0;i<1;i++){
      list.add(Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 4),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.network("https://c-ssl.duitang.com/uploads/blog/202107/09/20210709142454_dc8dc.jpeg",width: 60,),
              //Image.network("https://c-ssl.duitang.com/uploads/blog/202107/09/20210709142454_dc8dc.jpeg",width: 60,),
              //Image.network("https://c-ssl.duitang.com/uploads/blog/202107/09/20210709142454_dc8dc.jpeg",width: 60,),
            ],

          ),
        ),
      ),
      );
    }
    return list;
  }
}