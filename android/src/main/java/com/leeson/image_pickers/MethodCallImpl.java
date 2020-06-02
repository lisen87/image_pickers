package com.leeson.image_pickers;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.leeson.image_pickers.activitys.PermissionActivity;
import com.leeson.image_pickers.activitys.PhotosActivity;
import com.leeson.image_pickers.activitys.SelectPicsActivity;
import com.leeson.image_pickers.activitys.VideoActivity;
import com.leeson.image_pickers.utils.Saver;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * Created by liSen on 2020/5/15 17:14.
 *
 * @author liSen < 453354858@qq.com >
 */

public class MethodCallImpl implements MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener {

    private ActivityPluginBinding activityPluginBinding;

    private static final int SELECT = 102;
    private static final int SAVE_IMAGE = 103;
    private static final int WRITE_SDCARD = 104;
    private static final int SAVE_IMAGE_DATA = 105;

    private MethodChannel.Result result;

    private byte[] data;

    public void setActivityPluginBinding(ActivityPluginBinding activityPluginBinding) {
        this.activityPluginBinding = activityPluginBinding;
        activityPluginBinding.addActivityResultListener(this);
    }

    public ActivityPluginBinding getActivityPluginBinding() {
        return activityPluginBinding;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
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

            Intent intent = new Intent(activityPluginBinding.getActivity(), SelectPicsActivity.class);
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
            activityPluginBinding.getActivity().startActivityForResult(intent, SELECT);

        } else if ("previewImage".equals(methodCall.method)) {
            Intent intent = new Intent(activityPluginBinding.getActivity(), PhotosActivity.class);
            List<String> images = new ArrayList<>();
            images.add(methodCall.argument("path").toString());
            intent.putExtra(PhotosActivity.IMAGES, (Serializable) images);
            activityPluginBinding.getActivity().startActivity(intent);
        } else if ("previewImages".equals(methodCall.method)) {
            Intent intent = new Intent(activityPluginBinding.getActivity(), PhotosActivity.class);
            List<String> images = methodCall.argument("paths");
            Number initIndex = methodCall.argument("initIndex");
            intent.putExtra(PhotosActivity.IMAGES, (Serializable) images);
            intent.putExtra(PhotosActivity.CURRENT_POSITION, initIndex);
            activityPluginBinding.getActivity().startActivity(intent);
        } else if ("previewVideo".equals(methodCall.method)) {
            Intent intent = new Intent(activityPluginBinding.getActivity(), VideoActivity.class);
            intent.putExtra(VideoActivity.VIDEO_PATH, methodCall.argument("path").toString());
            intent.putExtra(VideoActivity.THUMB_PATH, methodCall.argument("thumbPath").toString());
            activityPluginBinding.getActivity().startActivity(intent);
        } else if("saveImageToGallery".equals(methodCall.method)) {
            Intent intent = new Intent(activityPluginBinding.getActivity(), PermissionActivity.class);
            intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE
                    ,Manifest.permission.READ_EXTERNAL_STORAGE});
            intent.putExtra("imageUrl",methodCall.argument("path").toString());
            activityPluginBinding.getActivity().startActivityForResult(intent,SAVE_IMAGE);
        } else if("saveVideoToGallery".equals(methodCall.method)) {
            Intent intent = new Intent(activityPluginBinding.getActivity(), PermissionActivity.class);
            intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE
                    ,Manifest.permission.READ_EXTERNAL_STORAGE});
            intent.putExtra("videoUrl",methodCall.argument("path").toString());
            activityPluginBinding.getActivity().startActivityForResult(intent, WRITE_SDCARD);
        } else if("saveByteDataImageToGallery".equals(methodCall.method)){
            Intent intent = new Intent(activityPluginBinding.getActivity(), PermissionActivity.class);
            intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE
                    ,Manifest.permission.READ_EXTERNAL_STORAGE});
            data = (byte[])methodCall.argument("uint8List");
            activityPluginBinding.getActivity().startActivityForResult(intent, SAVE_IMAGE_DATA);
        }else {
            result.notImplemented();
        }
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode == SELECT ) {
            if (resultCode == Activity.RESULT_OK){
                List<Map<String,String>> paths = (List<Map<String,String>>) intent.getSerializableExtra(SelectPicsActivity.COMPRESS_PATHS);
                Log.e("onActivityResult", "onActivityResult: "+paths.size()+" == "+result);
                if (result != null){
                    result.success(paths);
                }
            }
            return true;
        }else if (requestCode == SAVE_IMAGE){
            if (resultCode == Activity.RESULT_OK){
                String imageUrl = intent.getStringExtra("imageUrl");
                Saver imageSaver = new Saver(activityPluginBinding.getActivity());
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
                Saver videoSaver = new Saver(activityPluginBinding.getActivity());
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
                Saver saver = new Saver(activityPluginBinding.getActivity());
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
}
