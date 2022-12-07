package com.leeson.image_pickers.activitys;

import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Bitmap;
import android.media.ThumbnailUtils;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;

import com.leeson.image_pickers.AppPath;
import com.leeson.image_pickers.R;
import com.leeson.image_pickers.utils.CommonUtils;
import com.leeson.image_pickers.utils.GlideEngine;
import com.leeson.image_pickers.utils.ImageCompressEngine;
import com.leeson.image_pickers.utils.ImageCropEngine;
import com.leeson.image_pickers.utils.MeSandboxFileEngine;
import com.leeson.image_pickers.utils.PictureStyleUtil;
import com.luck.picture.lib.basic.PictureSelector;
import com.luck.picture.lib.config.PictureMimeType;
import com.luck.picture.lib.config.SelectMimeType;
import com.luck.picture.lib.config.SelectModeConfig;
import com.luck.picture.lib.entity.LocalMedia;
import com.luck.picture.lib.interfaces.OnResultCallbackListener;
import com.luck.picture.lib.style.PictureSelectorStyle;
import com.luck.picture.lib.style.SelectMainStyle;
import com.luck.picture.lib.style.TitleBarStyle;
import com.luck.picture.lib.utils.StyleUtils;
import com.yalantis.ucrop.UCrop;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * Created by lisen on 2018-09-11.
 * 只选择多张图片，
 *
 * @author lisen < 453354858@qq.com >
 */
@SuppressWarnings("all")
public class SelectPicsActivity extends BaseActivity {

    private static final int WRITE_SDCARD = 101;

    public static final String GALLERY_MODE = "GALLERY_MODE";
    public static final String UI_COLOR = "UI_COLOR";
    public static final String SHOW_GIF = "SHOW_GIF";
    public static final String SHOW_CAMERA = "SHOW_CAMERA";
    public static final String ENABLE_CROP = "ENABLE_CROP";
    public static final String WIDTH = "WIDTH";
    public static final String HEIGHT = "HEIGHT";
    public static final String COMPRESS_SIZE = "COMPRESS_SIZE";

    public static final String SELECT_COUNT = "SELECT_COUNT";//可选择的数量

    public static final String COMPRESS_PATHS = "COMPRESS_PATHS";//压缩的画
    public static final String CAMERA_MIME_TYPE = "CAMERA_MIME_TYPE";//直接调用拍照或拍视频时有效
    private Number compressSize;
    private String mode;
    private Map<String, Number> uiColor;
    private Number selectCount;
    private boolean showGif;
    private boolean showCamera;
    private boolean enableCrop;
    private Number width;
    private Number height;
    private String mimeType;

    @Override
    public void onCreate(@androidx.annotation.Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_select_pics);
        mode = getIntent().getStringExtra(GALLERY_MODE);
        uiColor = (Map<String, Number>) getIntent().getSerializableExtra(UI_COLOR);

        selectCount = getIntent().getIntExtra(SELECT_COUNT, 9);
        showGif = getIntent().getBooleanExtra(SHOW_GIF, true);
        showCamera = getIntent().getBooleanExtra(SHOW_CAMERA, false);
        enableCrop = getIntent().getBooleanExtra(ENABLE_CROP, false);
        width = getIntent().getIntExtra(WIDTH, 1);
        height = getIntent().getIntExtra(HEIGHT, 1);
        compressSize = getIntent().getIntExtra(COMPRESS_SIZE, 500);
        mimeType = getIntent().getStringExtra(CAMERA_MIME_TYPE);

        startSel();
    }

    private UCrop.Options buildOptions(PictureSelectorStyle selectorStyle) {
        UCrop.Options options = new UCrop.Options();
        if (selectorStyle != null && selectorStyle.getSelectMainStyle().getStatusBarColor() != 0) {
            SelectMainStyle mainStyle = selectorStyle.getSelectMainStyle();
            boolean isDarkStatusBarBlack = mainStyle.isDarkStatusBarBlack();
            int statusBarColor = mainStyle.getStatusBarColor();
            options.isDarkStatusBarBlack(isDarkStatusBarBlack);
            options.setSkipCropMimeType(new String[]{PictureMimeType.ofGIF(), PictureMimeType.ofWEBP()});
            if (StyleUtils.checkStyleValidity(statusBarColor)) {
                options.setStatusBarColor(statusBarColor);
                options.setToolbarColor(statusBarColor);
            }
            TitleBarStyle titleBarStyle = selectorStyle.getTitleBarStyle();
            if (StyleUtils.checkStyleValidity(titleBarStyle.getTitleTextColor())) {
                options.setToolbarWidgetColor(titleBarStyle.getTitleTextColor());
            }
        }
        return options;
    }

    private void startSel() {
        PictureStyleUtil pictureStyleUtil = new PictureStyleUtil(this);
        pictureStyleUtil.setStyle(uiColor);
        PictureSelectorStyle selectorStyle = pictureStyleUtil.getSelectorStyle();
        //添加图片
        PictureSelector pictureSelector = PictureSelector.create(this);
        if (mimeType != null) {
            //直接调用拍照或拍视频时
            PictureSelector.create(this).openCamera("photo".equals(mimeType) ? SelectMimeType.ofImage() : SelectMimeType.ofVideo())
                    .setRecordVideoMaxSecond(60)
                    .setRecordVideoMinSecond(1)
                    .setOutputCameraDir(new AppPath(this).getAppVideoDirPath())
                    .setCropEngine((selectCount.intValue() == 1 && enableCrop) ?
                            new ImageCropEngine(this, buildOptions(selectorStyle), width.intValue(), height.intValue()) : null)
                    .setCompressEngine(new ImageCompressEngine(compressSize.intValue()))
                    ./*setCameraInterceptListener(new OnCameraInterceptListener() {
                @Override
                public void openCamera(Fragment fragment, int cameraMode, int requestCode) {
                    //自定义相机
                    Log.e("TAG", "openCamera: 自定义相机" );
                }
            }).*/setSandboxFileEngine(new MeSandboxFileEngine()).forResult(new OnResultCallbackListener<LocalMedia>() {
                @Override
                public void onResult(ArrayList<LocalMedia> result) {
                    handlerResult(result);
                }

                @Override
                public void onCancel() {
                    Intent intent = new Intent();
                    intent.putExtra(COMPRESS_PATHS, new ArrayList<>());
                    setResult(RESULT_OK, intent);
                    finish();
                }
            });
        } else {

            PictureSelector.create(this).openGallery("image".equals(mode) ? SelectMimeType.ofImage() : SelectMimeType.ofVideo())
                    .setImageEngine(GlideEngine.createGlideEngine())
                    .setSelectorUIStyle(pictureStyleUtil.getSelectorStyle())
                    .setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)
                    .setRecordVideoMaxSecond(60)
                    .setRecordVideoMinSecond(1)
                    .setOutputCameraDir(new AppPath(this).getAppVideoDirPath())
                    .setCropEngine((selectCount.intValue() == 1 && enableCrop) ?
                            new ImageCropEngine(this, buildOptions(selectorStyle), width.intValue(), height.intValue()) : null)
                    .setCompressEngine(new ImageCompressEngine(compressSize.intValue()))
                    .setSandboxFileEngine(new MeSandboxFileEngine())
                    .isDisplayCamera(showCamera)
                    .isGif(showGif)
                    .setMaxSelectNum(selectCount.intValue())
                    .setImageSpanCount(4)// 每行显示个数 int
                    .setSelectionMode(selectCount.intValue() == 1 ? SelectModeConfig.SINGLE : SelectModeConfig.MULTIPLE)// 多选 or 单选 PictureConfig.MULTIPLE or PictureConfig.SINGLE
                    .isDirectReturnSingle(true)
                    .setSkipCropMimeType(new String[]{PictureMimeType.ofGIF(), PictureMimeType.ofWEBP()})
                    .isPreviewImage(true)
                    .isPreviewVideo(true)
                    .forResult(new OnResultCallbackListener<LocalMedia>() {
                        @Override
                        public void onResult(ArrayList<LocalMedia> result) {
                            handlerResult(result);
                        }

                        @Override
                        public void onCancel() {
                            Intent intent = new Intent();
                            intent.putExtra(COMPRESS_PATHS, new ArrayList<>());
                            setResult(RESULT_OK, intent);
                            finish();
                        }
                    });
        }

    }


    private void handlerResult(ArrayList<LocalMedia> selectList) {
        List<String> paths = new ArrayList<>();
        for (int i = 0; i < selectList.size(); i++) {
            LocalMedia localMedia = selectList.get(i);
            if (localMedia.isCut()) {
                paths.add(localMedia.getCutPath());
            } else {
                paths.add(localMedia.getAvailablePath());
            }
        }


        if (mimeType != null) {
            //直接调用拍照或拍视频时
            if ("photo".equals(mimeType)) {
                compressFinish(paths);
            } else {
                resolveVideoPath(selectList);
            }
        } else {
            if ("image".equals(mode)) {
                //如果选择的是图片就压缩
                compressFinish(paths);
            } else {
                resolveVideoPath(selectList);
            }
        }
    }

    private void resolveVideoPath(ArrayList<LocalMedia> selectList) {

        List<Map<String, String>> thumbPaths = new ArrayList<>();
        for (int i = 0; i < selectList.size(); i++) {
            LocalMedia localMedia = selectList.get(i);
            if (localMedia.getAvailablePath() == null) {
                break;
            }
            Bitmap bitmap = ThumbnailUtils.createVideoThumbnail(localMedia.getAvailablePath(), MediaStore.Video.Thumbnails.FULL_SCREEN_KIND);
            Log.e("TAG", "resolveVideoPath: "+localMedia.getPath() +" == "+localMedia.getSandboxPath()+" == "+localMedia.getAvailablePath());
            String thumbPath = CommonUtils.saveBitmap(this, new AppPath(this).getAppImgDirPath(), bitmap);
            Map<String, String> map = new HashMap<>();
            map.put("thumbPath", thumbPath);
            map.put("path", localMedia.getAvailablePath());
            thumbPaths.add(map);
        }
        Intent intent = new Intent();
        intent.putExtra(COMPRESS_PATHS, (Serializable) thumbPaths);
        setResult(RESULT_OK, intent);
        finish();
    }


    private void compressFinish(List<String> paths) {
        final List<Map<String, String>> compressPaths = new ArrayList<>();
        for (int i = 0; i < paths.size(); i++) {
            String path = paths.get(i);
            Map<String, String> map = new HashMap<>();
            map.put("thumbPath", path);
            map.put("path", path);
            compressPaths.add(map);
        }

        Intent intent = new Intent();
        intent.putExtra(COMPRESS_PATHS, (Serializable) compressPaths);
        setResult(RESULT_OK, intent);
        finish();
    }
}
