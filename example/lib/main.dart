import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:image_pickers/CorpConfig.dart';
import 'package:image_pickers/Media.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GalleryMode _galleryMode = GalleryMode.image;

  @override
  void initState() {
    super.initState();
  }

  List<Media> _listImagePaths = List();
  List<Media> _listVideoPaths = List();

  Future<void> selectImages() async {
    try {
      _galleryMode = GalleryMode.image;
      _listImagePaths = await ImagePickers.pickerPaths(
          galleryMode: _galleryMode,
          selectCount: 5,
          showCamera: true,
          compressSize: 300,
//          corpConfig: CorpConfig(enableCrop: true, width: 4, height: 3)
      );
      print(_listImagePaths.toString());
      setState(() {

      });
    } on PlatformException {}
  }

  Future<void> selectVideos() async {
    try {
      _galleryMode = GalleryMode.video;
      _listVideoPaths = await ImagePickers.pickerPaths(
        galleryMode: _galleryMode,
        selectCount: 5,
        showCamera: true,
      );
      setState(() {

      });
      print(_listVideoPaths);
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                        ImagePickers.previewImage(_listImagePaths[index].path);
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
                child: Text("保存图片"),
              ),

              RaisedButton(
                onPressed: () {
                  Future<String> future = ImagePickers.saveVideoToGallery("https://cloud.video.taobao.com/play/u/2200646347659/p/2/e/6/t/1/226017030674.mp4");
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
    );
  }
}
