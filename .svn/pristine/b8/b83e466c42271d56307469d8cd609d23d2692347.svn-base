import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

///时间戳
int getTimeStamp() {
  return DateTime.now().millisecondsSinceEpoch ~/ 1000;
}


///时间戳格式化成时间
String formatTime(dynamic time){
  print("时间戳：");
  print(time);
  if (time !=null) {
    var curTime = (time+8*60*60)*1000;
    var date = DateTime.fromMillisecondsSinceEpoch(curTime).toString();
    print(date.substring(0,19));
    return date.substring(0,19);
  }
  return "date.substring(0,19)";
}


///  压缩图片
Future<File?> compressAndGetPic(File file) async {
  var path = file.path;
  var name = path.substring(path.lastIndexOf("/"));
  var targetPath = await createTempFile(fileName: name, dir: 'pic');
  CompressFormat format = CompressFormat.jpeg;
  if (name.endsWith(".jpg") || name.endsWith(".jpeg")) {
    format = CompressFormat.jpeg;
  } else if (name.endsWith(".png")) {
    format = CompressFormat.png;
  } else if (name.endsWith(".heic")) {
    format = CompressFormat.heic;
  } else if (name.endsWith(".webp")) {
    format = CompressFormat.webp;
  }

  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 100,
    minWidth: 480,
    minHeight: 800,
    format: format,
  );
  return result;
}

Future<String> createTempFile({
  required String dir,
  required String fileName,
}) async {
  var path = (Platform.isIOS
          ? await getTemporaryDirectory()
          : await getExternalStorageDirectory())
      ?.path;
  File file = File('$path/$dir/$fileName');
  if (!(await file.exists())) {
    file.create(recursive: true);
  }
  return '$path/$dir/$fileName';
}
