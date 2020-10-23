import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_pickers/image_pickers.dart';
import 'dart:ui' as ui;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GalleryMode _galleryMode = GalleryMode.image;
  GlobalKey globalKey;
  @override
  void initState() {
    super.initState();
    globalKey = GlobalKey();
  }

  List<Media> _listImagePaths = List();
  List<Media> _listVideoPaths = List();
  String dataImagePath = "";

  Future<void> selectImages() async {
    try {
      _galleryMode = GalleryMode.image;
      _listImagePaths = await ImagePickers.pickerPaths(
          galleryMode: _galleryMode,
          showGif: true,
          selectCount: 5,
          showCamera: true,
          cropConfig :CropConfig(enableCrop: true,height: 1,width: 1),
          compressSize: 500,
          uiConfig: UIConfig(uiThemeColor: Color(0xffff0000),
          ),

      );
      _listImagePaths.forEach((media){
        print(media.path.toString());
      });
      setState(() {

      });
    } on PlatformException {}
  }

  Future<void> selectVideos() async {
    try {
      _galleryMode = GalleryMode.video;
      _listVideoPaths = await ImagePickers.pickerPaths(
        galleryMode: _galleryMode,
        selectCount: 2,
        showCamera: true,
      );
      setState(() {

      });
      print(_listVideoPaths);
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: MaterialApp(
        theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColor: Colors.white,
        ),

        home: Scaffold(
          appBar: AppBar(
            title: const Text('多图选择'),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _listImagePaths == null ? 0 : _listImagePaths.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1.0),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (){
//                        ImagePickers.previewImage(_listImagePaths[index].path);

//                      List<String> paths = [];
//                        _listImagePaths.forEach((media){
//                          paths.add(media.path);
//                        });
//
//                        ImagePickers.previewImages(paths,index);

                          ImagePickers.previewImagesByMedia(_listImagePaths,index);
                        },
                        child: Image.file(
                          File(
                            _listImagePaths[index].path,
                          ),
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                RaisedButton(
                  onPressed: () {
                    selectImages();
                  },
                  child: Text("选择图片"),
                ),
                RaisedButton(
                  onPressed: () {

                    ImagePickers.openCamera(cropConfig: CropConfig(enableCrop: false, width: 2, height: 3)).then((Media media){
                      _listImagePaths.clear();
                      _listImagePaths.add(media);
                      setState(() {

                      });
                    });
                  },
                  child: Text("拍照"),
                ),
                RaisedButton(
                  onPressed: () {
                    ImagePickers.openCamera(cameraMimeType: CameraMimeType.video).then((media){
                      _listVideoPaths.clear();
                      _listVideoPaths.add(media);
                      setState(() {

                      });
                    });
                  },
                  child: Text("拍视频"),
                ),
                GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _listVideoPaths == null ? 0 : _listVideoPaths.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 20.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1.0),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (){
                          ImagePickers.previewVideo(_listVideoPaths[index].path,);
                        },
                        child: Image.file(
                          File(
                            _listVideoPaths[index].thumbPath,
                          ),
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                RaisedButton(
                  onPressed: () {
                    selectVideos();
                  },
                  child: Text("选择视频"),
                ),

                InkWell(
                  onTap: (){
                    ImagePickers.previewImage("http://i1.sinaimg.cn/ent/d/2008-06-04/U105P28T3D2048907F326DT20080604225106.jpg");
                  },
                    child: Image.network("http://i1.sinaimg.cn/ent/d/2008-06-04/U105P28T3D2048907F326DT20080604225106.jpg",fit: BoxFit.cover,width: 100,height: 100,)),
                RaisedButton(
                  onPressed: () {
                    Future<String> future = ImagePickers.saveImageToGallery("http://i1.sinaimg.cn/ent/d/2008-06-04/U105P28T3D2048907F326DT20080604225106.jpg");
                    future.then((path){
                      print("保存图片路径："+ path);
                    });
                  },
                  child: Text("保存网络图片"),
                ),
                dataImagePath == "" ? Container():GestureDetector(onTap: (){
                  ImagePickers.previewImage(dataImagePath);
                },child: Image.file(File(dataImagePath),fit: BoxFit.cover,width: 100,height: 100,)),
                RaisedButton(
                  onPressed: () async {

                    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
                    ui.Image image = await boundary.toImage(pixelRatio: 3);
                    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                    Uint8List data = byteData.buffer.asUint8List();

                    dataImagePath = await ImagePickers.saveByteDataImageToGallery(data,);

                    print("保存截屏图片 = "+ dataImagePath);
                    setState(() {

                    });
                  },
                  child: Text("保存截屏图片"),
                ),

                RaisedButton(
                  onPressed: () {
                      Future<String> future = ImagePickers.saveVideoToGallery("http://vd4.bdstatic.com/mda-jbmn50510sid5yx5/sc/mda-jbmn50510sid5yx5.mp4");
                      future.then((path){
                        print("视频保存成功");
                      });
                  },
                  child: Text("保存视频"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
