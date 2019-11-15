package com.leeson.image_pickers;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;

import com.leeson.image_pickers.activitys.PermissionActivity;
import com.leeson.image_pickers.activitys.PhotosActivity;
import com.leeson.image_pickers.activitys.SaveImageToGalleryActivity;
import com.leeson.image_pickers.activitys.SelectPicsActivity;
import com.leeson.image_pickers.activitys.VideoActivity;
import com.leeson.image_pickers.utils.VideoSaver;

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

  private PluginRegistry.Registrar registrar;
  private MethodChannel.Result result;

  public ImagePickersPlugin(final PluginRegistry.Registrar registrar) {
    this.registrar = registrar;
    this.registrar.addActivityResultListener(new PluginRegistry.ActivityResultListener() {
      @Override
      public boolean onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == SELECT ) {
          if (resultCode == Activity.RESULT_OK){
            List<Map<String,String>> paths = (List<Map<String,String>>) intent.getSerializableExtra(SelectPicsActivity.COMPRESS_PATHS);
            result.success(paths);
          }
          return true;
        }else if (requestCode == SAVE_IMAGE){
          if (resultCode == Activity.RESULT_OK){
            String path = intent.getStringExtra(SaveImageToGalleryActivity.PATH);
            result.success(path);
          }
        }else if(requestCode == WRITE_SDCARD){
          if (resultCode == Activity.RESULT_OK){
            String videoUrl = intent.getStringExtra("videoUrl");
            VideoSaver videoSaver = new VideoSaver(registrar.context(),videoUrl,result);
            videoSaver.download();
          }
        }else{
          result.notImplemented();
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
      String uiColor = methodCall.argument("uiColor");
      Number selectCount = methodCall.argument("selectCount");
      Boolean showCamera = methodCall.argument("showCamera");
      Boolean enableCrop = methodCall.argument("enableCrop");
      Number width = methodCall.argument("width");
      Number height = methodCall.argument("height");
      Number compressSize = methodCall.argument("compressSize");

      Intent intent = new Intent(registrar.context(), SelectPicsActivity.class);
      intent.putExtra(SelectPicsActivity.GALLERY_MODE,galleryMode);
      intent.putExtra(SelectPicsActivity.UI_COLOR,uiColor);
      intent.putExtra(SelectPicsActivity.SELECT_COUNT,selectCount);
      intent.putExtra(SelectPicsActivity.SHOW_CAMERA,showCamera);
      intent.putExtra(SelectPicsActivity.ENABLE_CROP,enableCrop);
      intent.putExtra(SelectPicsActivity.WIDTH,width);
      intent.putExtra(SelectPicsActivity.HEIGHT,height);
      intent.putExtra(SelectPicsActivity.COMPRESS_SIZE,compressSize);
      (registrar.activity()).startActivityForResult(intent, SELECT);

    } else if ("previewImage".equals(methodCall.method)) {
      Intent intent = new Intent(registrar.context(), PhotosActivity.class);
      List<String> images = new ArrayList<>();
      images.add(String.valueOf(methodCall.argument("path")));
      intent.putExtra(PhotosActivity.IMAGES, (Serializable) images);
      (registrar.activity()).startActivity(intent);
    }else if ("previewVideo".equals(methodCall.method)) {
      Intent intent = new Intent(registrar.context(), VideoActivity.class);
      intent.putExtra(VideoActivity.VIDEO_PATH, String.valueOf(methodCall.argument("path")));
      intent.putExtra(VideoActivity.THUMB_PATH, String.valueOf(methodCall.argument("thumbPath")));
      (registrar.activity()).startActivity(intent);
    }else if("saveImageToGallery".equals(methodCall.method)){
      Intent intent = new Intent(registrar.context(), SaveImageToGalleryActivity.class);
      intent.putExtra(SaveImageToGalleryActivity.PATH, String.valueOf(methodCall.argument("path")));
      (registrar.activity()).startActivityForResult(intent,SAVE_IMAGE);
    }else if("saveVideoToGallery".equals(methodCall.method)){
      Intent intent = new Intent(registrar.context(), PermissionActivity.class);
      intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE
              ,Manifest.permission.READ_EXTERNAL_STORAGE});
      intent.putExtra("videoUrl",String.valueOf(methodCall.argument("path")));
      (registrar.activity()).startActivityForResult(intent, WRITE_SDCARD);
    }else{
      result.notImplemented();
    }
  }
}
