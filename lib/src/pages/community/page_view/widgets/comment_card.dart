import 'dart:convert';

import 'package:flutter/material.dart';
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

class CommentCard extends StatelessWidget {
  const CommentCard(this.comentitem,{Key? key}) : super(key: key);

  //接收数据
  final Map<String, dynamic> comentitem;

  @override
  Widget build(BuildContext context) {

    // print(comentitem);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 4),
      child: Container(
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
                    url: "https://c-ssl.duitang.com/uploads/blog/202106/09/20210609081952_51ef5.jpg",
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
                        comentitem["replyUserName"],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        child: Text(
                          formatTime(comentitem["createTime"]),
                          style: TextStyle(
                            color: WcaoTheme.secondary,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(comentitem["content"],
                          style: TextStyle(
                            color: WcaoTheme.base,
                            fontSize: WcaoTheme.fsL,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

