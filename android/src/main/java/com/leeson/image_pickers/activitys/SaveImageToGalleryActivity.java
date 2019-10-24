package com.leeson.image_pickers.activitys;

import android.Manifest;
import android.content.Intent;
import android.graphics.Bitmap;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.SimpleTarget;
import com.bumptech.glide.request.target.Target;
import com.bumptech.glide.request.transition.Transition;
import com.leeson.image_pickers.AppPath;
import com.leeson.image_pickers.R;
import com.leeson.image_pickers.utils.CommonUtils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

/**
 * Created by lisen on 2019/10/18.
 *
 * @author lisen < 453354858@qq.com >
 */
public class SaveImageToGalleryActivity extends BaseActivity {

    private static final int WRITE_SDCARD = 101;
    public static final String PATH = "PATH";

    private String imageUrl ;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_select_pics);
        imageUrl = getIntent().getStringExtra(PATH);
        Intent intent = new Intent(this, PermissionActivity.class);
        intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE
                ,Manifest.permission.READ_EXTERNAL_STORAGE});
        startActivityForResult(intent, WRITE_SDCARD);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK){
            if (requestCode == WRITE_SDCARD){
                Glide.with(this).asBitmap().load(imageUrl).listener(new RequestListener<Bitmap>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Bitmap> target, boolean isFirstResource) {
                        Toast.makeText(SaveImageToGalleryActivity.this,"保存失败",Toast.LENGTH_SHORT).show();
                        setResult(RESULT_CANCELED);
                        finish();
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(Bitmap resource, Object model, Target<Bitmap> target, DataSource dataSource, boolean isFirstResource) {
                        return false;
                    }
                }).into(new SimpleTarget<Bitmap>() {
                    @Override
                    public void onResourceReady(@NonNull Bitmap resource, Transition<? super Bitmap> transition) {
                        String path = CommonUtils.saveBitmap(SaveImageToGalleryActivity.this, new AppPath(SaveImageToGalleryActivity.this).getShowedImgPath(), resource);
                        notifyImages(path);

                    }
                });
            }
        }else{
            finish();
        }
    }

    private MediaScannerConnection mediaScannerConnection;

    private void notifyImages(final String path){
        //通知图库刷新
        MediaScannerConnection.MediaScannerConnectionClient client = new MediaScannerConnection.MediaScannerConnectionClient() {
            @Override
            public void onMediaScannerConnected() {
                mediaScannerConnection.scanFile(path, null);
            }
            @Override
            public void onScanCompleted(String s, Uri uri) {
                mediaScannerConnection.disconnect();
                Intent intent = new Intent();
                intent.putExtra(PATH,path);
                setResult(RESULT_OK,intent);
                finish();
            }
        };
        mediaScannerConnection = new MediaScannerConnection(this,client);
        mediaScannerConnection.connect();
    }

    @Override
    protected void onDestroy() {
        if (mediaScannerConnection != null && mediaScannerConnection.isConnected()){
            mediaScannerConnection.disconnect();
        }
        super.onDestroy();
    }
}
