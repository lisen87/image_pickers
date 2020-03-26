package com.leeson.image_pickers;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;

import com.leeson.image_pickers.activitys.PermissionActivity;
import com.leeson.image_pickers.activitys.PhotosActivity;
import com.leeson.image_pickers.activitys.SelectPicsActivity;
import com.leeson.image_pickers.activitys.VideoActivity;
import com.leeson.image_pickers.utils.Saver;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * Created by lisen on 2019/10/16.
 *
 * @author lisen < 453354858@qq.com >
 */
@SuppressWarnings("all")
public class ImagePickersPlugin implements MethodChannel.MethodCallHandler {

  private static final int SELECT = 102;
  private static final int SAVE_IMAGE = 103;
  private static final int WRITE_SDCARD = 104;
  private static final int SAVE_IMAGE_DATA = 105;

  private PluginRegistry.Registrar registrar;
  private MethodChannel.Result result;

  private byte[] data;

  public ImagePickersPlugin(final PluginRegistry.Registrar registrar) {
    this.registrar = registrar;
    this.registrar.addActivityResultListener(new PluginRegistry.ActivityResultListener() {
      @Override
      public boolean onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == SELECT ) {
          if (resultCode == Activity.RESULT_OK && result != null){
            List<Map<String,String>> paths = (List<Map<String,String>>) intent.getSerializableExtra(SelectPicsActivity.COMPRESS_PATHS);
            result.success(paths);
          }
          return true;
        }else if (requestCode == SAVE_IMAGE){
          if (resultCode == Activity.RESULT_OK){
            String imageUrl = intent.getStringExtra("imageUrl");
            AppPath appPath = new AppPath(registrar.context());
            String imageDirPath = appPath.getShowedImgPath();
            Saver imageSaver = new Saver(registrar.context(),imageDirPath,result);
            imageSaver.download(imageUrl);
          }
        }else if(requestCode == WRITE_SDCARD){
          if (resultCode == Activity.RESULT_OK){
            String videoUrl = intent.getStringExtra("videoUrl");
            AppPath appPath = new AppPath(registrar.context());
            String videoDirPath = appPath.getVideoPath();
            Saver videoSaver = new Saver(registrar.context(),videoDirPath,result);
            videoSaver.download(videoUrl);
          }
        }else if(requestCode == SAVE_IMAGE_DATA){
          if (resultCode == Activity.RESULT_OK && data != null){
            AppPath appPath = new AppPath(registrar.context());
            Saver saver = new Saver(registrar.context(),appPath.getShowedImgPath(),result);
            saver.saveByteData(data);
            data = null;
          }
        }
        return false;
      }
    });
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(PluginRegistry.Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter/image_pickers");
    channel.setMethodCallHandler(new ImagePickersPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall methodCall, @NonNull MethodChannel.Result result) {

    this.result = result;
    if ("getPickerPaths".equals(methodCall.method)) {
      String galleryMode = methodCall.argument("galleryMode");
      Map<String,Number> uiColor = methodCall.argument("uiColor");
      Number selectCount = methodCall.argument("selectCount");
      Boolean showCamera = methodCall.argument("showCamera");
      Boolean enableCrop = methodCall.argument("enableCrop");
      Number width = methodCall.argument("width");
      Number height = methodCall.argument("height");
      Number compressSize = methodCall.argument("compressSize");
      String cameraMimeType = methodCall.argument("cameraMimeType");

      Intent intent = new Intent(registrar.context(), SelectPicsActivity.class);
      intent.putExtra(SelectPicsActivity.GALLERY_MODE,galleryMode);
      intent.putExtra(SelectPicsActivity.UI_COLOR, (Serializable) uiColor);
      intent.putExtra(SelectPicsActivity.SELECT_COUNT,selectCount);
      intent.putExtra(SelectPicsActivity.SHOW_CAMERA,showCamera);
      intent.putExtra(SelectPicsActivity.ENABLE_CROP,enableCrop);
      intent.putExtra(SelectPicsActivity.WIDTH,width);
      intent.putExtra(SelectPicsActivity.HEIGHT,height);
      intent.putExtra(SelectPicsActivity.COMPRESS_SIZE,compressSize);
      //直接调用拍照或拍视频时有效
      intent.putExtra(SelectPicsActivity.CAMERA_MIME_TYPE,cameraMimeType);
      (registrar.activity()).startActivityForResult(intent, SELECT);

    } else if ("previewImage".equals(methodCall.method)) {
      Intent intent = new Intent(registrar.context(), PhotosActivity.class);
      List<String> images = new ArrayList<>();
      images.add(String.valueOf(methodCall.argument("path")));
      intent.putExtra(PhotosActivity.IMAGES, (Serializable) images);
      (registrar.activity()).startActivity(intent);
    } else if ("previewImages".equals(methodCall.method)) {
      Intent intent = new Intent(registrar.context(), PhotosActivity.class);
      List<String> images = methodCall.argument("paths");
      Number initIndex = methodCall.argument("initIndex");
      intent.putExtra(PhotosActivity.IMAGES, (Serializable) images);
      intent.putExtra(PhotosActivity.CURRENT_POSITION, initIndex);
      (registrar.activity()).startActivity(intent);
    } else if ("previewVideo".equals(methodCall.method)) {
      Intent intent = new Intent(registrar.context(), VideoActivity.class);
      intent.putExtra(VideoActivity.VIDEO_PATH, String.valueOf(methodCall.argument("path")));
      intent.putExtra(VideoActivity.THUMB_PATH, String.valueOf(methodCall.argument("thumbPath")));
      (registrar.activity()).startActivity(intent);
    } else if("saveImageToGallery".equals(methodCall.method)) {
      Intent intent = new Intent(registrar.context(), PermissionActivity.class);
      intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE
              ,Manifest.permission.READ_EXTERNAL_STORAGE});
      intent.putExtra("imageUrl",String.valueOf(methodCall.argument("path")));
      (registrar.activity()).startActivityForResult(intent,SAVE_IMAGE);
    } else if("saveVideoToGallery".equals(methodCall.method)) {
      Intent intent = new Intent(registrar.context(), PermissionActivity.class);
      intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE
              ,Manifest.permission.READ_EXTERNAL_STORAGE});
      intent.putExtra("videoUrl",String.valueOf(methodCall.argument("path")));
      (registrar.activity()).startActivityForResult(intent, WRITE_SDCARD);
    } else if("saveByteDataImageToGallery".equals(methodCall.method)){
      Intent intent = new Intent(registrar.context(), PermissionActivity.class);
      intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE
              ,Manifest.permission.READ_EXTERNAL_STORAGE});
      data = (byte[])methodCall.argument("uint8List");
      (registrar.activity()).startActivityForResult(intent, SAVE_IMAGE_DATA);
    }else {
      result.notImplemented();
    }
  }
}
