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
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * Created by lisen on 2019/10/16.
 *
 * @author lisen < 453354858@qq.com >
 */
@SuppressWarnings("all")
public class ImagePickersPlugin implements FlutterPlugin,MethodChannel.MethodCallHandler, ActivityAware {

  private MethodChannel channel;

  private static final int SELECT = 102;
  private static final int SAVE_IMAGE = 103;
  private static final int WRITE_SDCARD = 104;
  private static final int SAVE_IMAGE_DATA = 105;

  private Activity activity;
  private MethodChannel.Result result;

  private byte[] data;

  public ImagePickersPlugin() {
  }

  /**
   * pre-Flutter-1.12 Android projects.
   */
  public static void registerWith(PluginRegistry.Registrar registrar) {
    ImagePickersPlugin imagePickersPlugin = new ImagePickersPlugin();
    imagePickersPlugin.setup(registrar,null);
  }

  private void setup(PluginRegistry.Registrar registrar, ActivityPluginBinding activityBinding){
    if (registrar != null){
      activity = registrar.activity();
      channel = new MethodChannel(registrar.messenger(), "flutter/image_pickers");
      channel.setMethodCallHandler(this);
      registrar.addActivityResultListener(listener);
    }else{
      activity = activityBinding.getActivity();
      channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter/image_pickers");
      channel.setMethodCallHandler(this);
      activityBinding.addActivityResultListener(listener);
    }
  }

  private PluginRegistry.ActivityResultListener listener = new PluginRegistry.ActivityResultListener() {
    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent intent) {
      if (requestCode == SELECT ) {
        if (resultCode == Activity.RESULT_OK){
          List<Map<String,String>> paths = (List<Map<String,String>>) intent.getSerializableExtra(SelectPicsActivity.COMPRESS_PATHS);
          if (result != null){
            result.success(paths);
          }
        }
        return true;
      }else if (requestCode == SAVE_IMAGE){
        if (resultCode == Activity.RESULT_OK){
          String imageUrl = intent.getStringExtra("imageUrl");
          Saver imageSaver = new Saver(activity);
          imageSaver.saveImgToGallery(imageUrl, new Saver.IFinishListener() {
            @Override
            public void onSuccess(Saver.FileInfo fileInfo) {
              if (result != null){
                result.success(fileInfo.getPath());
              }
            }

            @Override
            public void onFailed(String errorMsg) {
              if (result != null){
                result.error("-1",errorMsg,errorMsg);
              }
            }
          });
        }
      }else if(requestCode == WRITE_SDCARD){
        if (resultCode == Activity.RESULT_OK){
          String videoUrl = intent.getStringExtra("videoUrl");
          Saver videoSaver = new Saver(activity);
          videoSaver.saveVideoToGallery(videoUrl, new Saver.IFinishListener() {
            @Override
            public void onSuccess(Saver.FileInfo fileInfo) {
              if (result != null){
                result.success(fileInfo.getPath());
              }
            }

            @Override
            public void onFailed(String errorMsg) {
              if (result != null){
                result.error("-1",errorMsg,errorMsg);
              }
            }
          });
        }
      }else if(requestCode == SAVE_IMAGE_DATA){
        if (resultCode == Activity.RESULT_OK && data != null){
          AppPath appPath = new AppPath(activity);
          Saver saver = new Saver(activity);
          saver.saveByteDataToGallery(data, new Saver.IFinishListener() {
            @Override
            public void onSuccess(Saver.FileInfo fileInfo) {
              if (result != null){
                result.success(fileInfo.getPath());
              }
              data = null;
            }

            @Override
            public void onFailed(String errorMsg) {
              if (result != null){
                result.error("-1",errorMsg,errorMsg);
              }
              data = null;
            }
          });

        }
      }
      return false;
    }
  };
  @Override
  public void onMethodCall(MethodCall methodCall, @NonNull MethodChannel.Result result) {

    this.result = result;
    if ("getPickerPaths".equals(methodCall.method)) {
      String galleryMode = methodCall.argument("galleryMode");
      Boolean showGif = methodCall.argument("showGif");
      Map<String,Number> uiColor = methodCall.argument("uiColor");
      Number selectCount = methodCall.argument("selectCount");
      Boolean showCamera = methodCall.argument("showCamera");
      Boolean enableCrop = methodCall.argument("enableCrop");
      Number width = methodCall.argument("width");
      Number height = methodCall.argument("height");
      Number compressSize = methodCall.argument("compressSize");
      String cameraMimeType = methodCall.argument("cameraMimeType");

      Intent intent = new Intent(activity, SelectPicsActivity.class);
      intent.putExtra(SelectPicsActivity.GALLERY_MODE,galleryMode);
      intent.putExtra(SelectPicsActivity.UI_COLOR, (Serializable) uiColor);
      intent.putExtra(SelectPicsActivity.SELECT_COUNT,selectCount);
      intent.putExtra(SelectPicsActivity.SHOW_GIF,showGif);
      intent.putExtra(SelectPicsActivity.SHOW_CAMERA,showCamera);
      intent.putExtra(SelectPicsActivity.ENABLE_CROP,enableCrop);
      intent.putExtra(SelectPicsActivity.WIDTH,width);
      intent.putExtra(SelectPicsActivity.HEIGHT,height);
      intent.putExtra(SelectPicsActivity.COMPRESS_SIZE,compressSize);
      //直接调用拍照或拍视频时有效
      intent.putExtra(SelectPicsActivity.CAMERA_MIME_TYPE,cameraMimeType);
      activity.startActivityForResult(intent, SELECT);

    } else if ("previewImage".equals(methodCall.method)) {
      Intent intent = new Intent(activity, PhotosActivity.class);
      List<String> images = new ArrayList<>();
      images.add(methodCall.argument("path").toString());
      intent.putExtra(PhotosActivity.IMAGES, (Serializable) images);
      activity.startActivity(intent);
    } else if ("previewImages".equals(methodCall.method)) {
      Intent intent = new Intent(activity, PhotosActivity.class);
      List<String> images = methodCall.argument("paths");
      Number initIndex = methodCall.argument("initIndex");
      intent.putExtra(PhotosActivity.IMAGES, (Serializable) images);
      intent.putExtra(PhotosActivity.CURRENT_POSITION, initIndex);
      activity.startActivity(intent);
    } else if ("previewVideo".equals(methodCall.method)) {
      Intent intent = new Intent(activity, VideoActivity.class);
      intent.putExtra(VideoActivity.VIDEO_PATH, methodCall.argument("path").toString());
      intent.putExtra(VideoActivity.THUMB_PATH, methodCall.argument("thumbPath").toString());
      activity.startActivity(intent);
    } else if("saveImageToGallery".equals(methodCall.method)) {
      Intent intent = new Intent(activity, PermissionActivity.class);
      intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE
              ,Manifest.permission.READ_EXTERNAL_STORAGE});
      intent.putExtra("imageUrl",methodCall.argument("path").toString());
      activity.startActivityForResult(intent,SAVE_IMAGE);
    } else if("saveVideoToGallery".equals(methodCall.method)) {
      Intent intent = new Intent(activity, PermissionActivity.class);
      intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE
              ,Manifest.permission.READ_EXTERNAL_STORAGE});
      intent.putExtra("videoUrl",methodCall.argument("path").toString());
      activity.startActivityForResult(intent, WRITE_SDCARD);
    } else if("saveByteDataImageToGallery".equals(methodCall.method)){
      Intent intent = new Intent(activity, PermissionActivity.class);
      intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE
              ,Manifest.permission.READ_EXTERNAL_STORAGE});
      data = (byte[])methodCall.argument("uint8List");
      activity.startActivityForResult(intent, SAVE_IMAGE_DATA);
    }else {
      result.notImplemented();
    }
  }

  private  FlutterPluginBinding flutterPluginBinding;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding;

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    setup(null,binding);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}
