import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../common/mytools.dart';
import '../../../../widgets/avatar_view.dart';
import '../../../community/page_view/like/mock.dart';
import '../../../wcao/kit/index.dart';
import '../../../wcao/ui/tag.dart';
import '../../../wcao/ui/theme.dart';
import '../../community_logic.dart';
import 'checkpic.dart';
import 'comment_card.dart';
import 'package:like_button/like_button.dart';

class GuanZhuCard extends StatelessWidget {
  GuanZhuCard(this.item, {Key? key}) : super(key: key);

  final TextEditingController controller = TextEditingController();
  final comlogic = Get.find<communitylogic>();


  //接收数据
  final Map<String, dynamic> item;
  String commentText = "";
  bool _isMyselfID = false;


  @override
  Widget build(BuildContext context) {

    // print(item);
    print("33333333333333");
    //将content数据 转换成 map
    var jsonContent = item["content"];
    var info = jsonDecode(jsonContent);

    if (item["userID"] == comlogic.imLogic.userInfo.value.userID){
      _isMyselfID = false;
    }else{
      _isMyselfID = true;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 4),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: ClipOval(
                child: AvatarView(
                  size: 40.h,
                  url: item["faceURL"],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["userName"],
                      style: TextStyle(
                        color: WcaoTheme.base,
                        fontWeight: FontWeight.bold,
                        fontSize: WcaoTheme.fsL,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Text(
                        formatTime(item["createTime"]),
                        style: TextStyle(color: WcaoTheme.secondary,fontSize: 12),
                      ),
                    ),
                    // buildMedia(item.mediaType, item.media),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: Text(
                        info["text"],
                        style: TextStyle(
                          color: WcaoTheme.base,
                          fontSize: WcaoTheme.fsL,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          children: addPicture(context),
                          // children: item.tag.map((e) {
                          //   return Tag(
                          //     e,
                          //     borderRadius: BorderRadius.circular(24),
                          //     fontSize: WcaoTheme.fsBase,
                          //     padding: const EdgeInsets.symmetric(
                          //       vertical: 2,
                          //       horizontal: 8,
                          //     ),
                          //     color: WcaoTheme.primary,
                          //   );
                          // }).toList()
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 分享
                          //iconText(Icons.offline_share, item.share.toString()),
                          Row(
                            children: [
                              // 点赞
                              Container(
                                margin: const EdgeInsets.only(left: 24),
                                // child: TextButton(
                                //   onPressed: () => print("关注"),
                                //   child: iconText(
                                //     Icons.favorite_border_outlined,
                                //     item["likeUsers"].length.toString(),
                                //   ),
                                // ),
                                child: LikeButton(
                                  size: 18,
                                  circleColor:
                                  CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                  bubblesColor: BubblesColor(
                                    dotPrimaryColor: Color(0xff33b5e5),
                                    dotSecondaryColor: Color(0xff0099cc),
                                  ),
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.thumb_up_off_alt_rounded,
                                      color: isLiked ? Colors.red : Colors.grey,
                                      size: 18,
                                    );
                                  },
                                  likeCount: item["likeUsers"].length,
                                  onTap: onLikeButtonTapped,
                                ),
                              ),

                              // 评论
                              Container(
                                margin: const EdgeInsets.only(left: 24),
                                child: TextButton(
                                  onPressed: () {
                                    commentNode(context);
                                    // showModalBottomSheet(
                                    //     isScrollControlled:true,
                                    //     context: context,
                                    //     //设置圆角
                                    //     shape: RoundedRectangleBorder(
                                    //       //这里是modal的边框样式
                                    //       borderRadius: BorderRadius.only(
                                    //         topLeft: Radius.circular(10),
                                    //         topRight: Radius.circular(10),
                                    //       ),
                                    //     ),
                                    //     builder: (BuildContext context) {
                                    //       return SizedBox(
                                    //         height: 500,
                                    //         child: ListView.builder(
                                    //             itemCount: 30,
                                    //             itemBuilder: (context, index){
                                    //               return Column(
                                    //                   children:<Widget>[
                                    //                     CommentCard(),
                                    //                   ]
                                    //               );
                                    //             }),
                                    //
                                    //       );
                                    //     });
                                  },
                                  child: iconText(
                                  Icons.add_comment_outlined,
                                  item["comments"].length.toString()),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            //关注列表
            GuanZhuWidge()
          ],
        ),
      ),
    );
  }

  //关注
  Container GuanZhuWidge(){
    return Container(
        width: 50,
        height: 20,
        margin: const EdgeInsets.only(top: 15,right:2),
        child: TextButton(
            onPressed: () {
              //发送请求 关注谁了
              // print(item);
              // comlogic.careOneCommentReq(item["userID"]);
              comlogic.CancelCareOneCommentReq(item["userID"]);
            },
            style: ButtonStyle(
              //背景颜色
              backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
              //设置形状、圆角
              shape: MaterialStateProperty.all(const StadiumBorder()),
              //内边距
              padding: MaterialStateProperty.all(EdgeInsets.only(left: 0,top: 0,right: 0,bottom: 3)),
            ),
            child: Text(
              '已关注',
              style: TextStyle(color: Colors.white,fontSize: 11),
            )),
      );
  }



  Container GuanZhuWidge_1(){
    return Container();
  }


  /// 显示多媒体
  Widget buildMedia(bool type, List<String> media) {
    if (media.isEmpty) {
      return Container();
    }

    if (type) {
      // 视频
      return Container(
        margin: const EdgeInsets.only(top: 8),
        width: 172,
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(media[0]),
          ),
        ),
        child: Icon(
          Icons.play_circle_fill,
          color: WcaoTheme.primary,
          size: WcaoTheme.fsBase * 4,
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: media
              .map((e) => SizedBox(
                    width: 124,
                    height: 124,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: WcaoUtils.imageCache(e),
                    ),
                  ))
              .toList(),
        ),
      );
    }
  }

  Row iconText(IconData icondata, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(
          icondata,
          color: WcaoTheme.secondary,
          size: WcaoTheme.fsXl,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            text,
            style: TextStyle(color: WcaoTheme.secondary),
          ),
        )
      ],
    );
  }


  ///图片添加
  List<Widget> addPicture(BuildContext context){
    List<Container> picList = [];
    var jsonContent = item["content"];
    var info = jsonDecode(jsonContent);
    List picList1 = info["picDate1"];
    List picList2 = info["picDate2"];

    // print(picList1.length);
    if(picList1.length > 0){
      if(picList1.length == 1){
        picList.add(
          Container(
            width: 180,
            height: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(image: NetworkImage(picList1[0]), fit: BoxFit.cover),
              //border: Border.all(color: Colors.cyan, width: 1), // 设置边框
              borderRadius: BorderRadius.all(Radius.circular(5)),// 设置正圆角 0为直角
            ),
            child: GestureDetector(
                onTap:(){
                  showBottomSheet(
                      context: context,
                      builder: (ctx) => checkPicPage(picList2,0)
                  );
                }
            ),
          ),
        );
      }else{
        // print("ttttttttttttttttttttttt");
        picList.add(
          Container(
            width: 260,
            color: Colors.white,
            child: Wrap(
              spacing: 5.0,//横向 图片间距
              runSpacing: 5.0,//纵向 图片间距
              alignment: WrapAlignment.start,//最左边开始
              children: addPictureForWarp(picList1,picList2,context),//图片相片插入
            ),
          ),

        );
      }
    }
    return picList;
  }


  ///添加图片
  List<Widget> addPictureForWarp(List temList,List temList2,BuildContext context){
    List<Container> picListForWarp = [];
    // print("RRRRRRRRRRRRRRRRRRRR");
    //print(temList);

    for(var i = 0; i < temList.length ; i++){
      picListForWarp.add(
        Container(
          child:GestureDetector(
            onTap:(){
              // print("11111");
              showBottomSheet(
                context: context,
                builder: (ctx) => checkPicPage(temList2,i)
              );
            }
          ),
          width: 80,//容器的宽高
          height: 80,//容器的宽高
          decoration: BoxDecoration(//给容器 设置属性
            color: Colors.white,
            image: DecorationImage(image: NetworkImage(temList[i]), fit: BoxFit.cover),//图片fit 适应容器大小
            //border: Border.all(color: Colors.cyan, width: 1), // 设置边框
            borderRadius: BorderRadius.all(Radius.circular(5)),// 设置正圆角 0为直角
        ),
      )
      );
    }

    return picListForWarp;
  }



  ///评论节点处理
  Future commentNode(BuildContext context){
    return showModalBottomSheet(
      isScrollControlled:true,
      context: context,
      //设置圆角
      // shape: RoundedRectangleBorder(
      //   //这里是modal的边框样式
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(10),
      //     topRight: Radius.circular(10),
      //   ),
      // ),
      builder: (BuildContext context) {
        return Container(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(child: commentList()),
        );

        // return AnimatedPadding(
        //   padding: MediaQuery.of(context).viewInsets,
        //   duration: const Duration(milliseconds: 100),
        //   child: Container(
        //     height: 500,
        //     child: SingleChildScrollView(child: aaaaaa())
        //   ),
        // );
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



  Column commentList() {
    return Column(
        children: [
          Container(height: 5),
          Container(
            child: Text("${item["comments"].length.toString()}条评论",style:TextStyle(
                fontSize: 16.0,
                color: Colors.black54,)
            ),
          ),
          Container(height: 5),
          Container(
            child: Container(
              height: 385,
              child: ListView.builder(
                  itemCount: item["comments"].length+1,
                  itemBuilder: (context, index){
                    if(index < item["comments"].length){
                      return Column(
                          children:<Widget>[
                            CommentCard(item["comments"][index]),
                          ]
                      );
                    }else{
                      return labelDiXian();
                    }
                  }),
            ),
          ),
          Container(height: 5),
          Container(
            height: 60,
            padding: EdgeInsets.all(5),
            child: TextField(
              controller: commentControllerText(),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                  hintText: "友爱评论，说点好听的",
                  // suffixIcon: Icon(Icons.send),
                  filled: true,//filled == true 时，fillColor 生效。
                  fillColor:Colors.white,
                  isDense: true,
                  contentPadding: EdgeInsets.all(5),
                  border: OutlineInputBorder(
                    /*边角*/
                    borderRadius: BorderRadius.all(
                      Radius.circular(10), //边角为30
                    ),
                    borderSide: BorderSide(
                      color: Colors.grey, //边线颜色为黄色
                      width: 2, //边线宽度为2
                    ),
                  )
              ),
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                  textBaseline: TextBaseline.alphabetic
              ),
              onEditingComplete: (){
                if (commentText.length == 0) {
                  print('消息不能为空');
                  return;
                }

                comlogic.publistOneComment(commentText,item["workMomentID"]);

                Get.back();///返回到之前界面

                // comlogic.getDateByMomentsID(item["workMomentID"]);
              },
              onTap: (){
                print("开始编辑");
              },
            ),
          ),
        ],
      );
  }


  //输入框监听
  TextEditingController commentControllerText() {
    TextEditingController _controller = TextEditingController(
      text: "",
    );

    _controller.addListener(() {
      print(_controller.text);
      commentText = _controller.text;
      print("输入内容："+commentText);
    });

    return _controller;
  }


  Future<bool> onLikeButtonTapped(bool isLiked) async{
    /// send your request here
    // final bool success= await sendRequest();
    comlogic.praiseOneComment(commentText,item["workMomentID"]);

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;
    print("object");

    return !isLiked;
  }

}

