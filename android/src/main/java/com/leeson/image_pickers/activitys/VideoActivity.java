package com.leeson.image_pickers.activitys;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.VideoView;

import com.bumptech.glide.Glide;
import com.leeson.image_pickers.R;

import androidx.annotation.Nullable;

/**
 * Created by lisen on 2018-09-14.
 * 播放视频
 *
 * @author lisen < 453354858@qq.com >
 */

public class VideoActivity extends BaseActivity{
    private static final int READ_SDCARD = 101;
    public static final String VIDEO_PATH = "VIDEO_PATH";
    public static final String THUMB_PATH = "THUMB_PATH";
    VideoView videoView;
    LinearLayout layout_root;
    RelativeLayout videoParent;

    ImageView iv_src;
    ProgressBar progressBar;

    private String videoPath;
    private String thumbPath;

    private DisplayMetrics outMetrics;
    private int videoHeight,videoWidth;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_video);
        videoView = findViewById(R.id.videoView);
        layout_root = findViewById(R.id.layout_root);
        videoParent = findViewById(R.id.videoParent);
        iv_src = findViewById(R.id.iv_src);
        progressBar = findViewById(R.id.progressBar);

        videoPath = getIntent().getStringExtra(VIDEO_PATH);
        thumbPath = getIntent().getStringExtra(THUMB_PATH);

        WindowManager wm = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
        outMetrics = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(outMetrics);

        Intent intent = new Intent(this, PermissionActivity.class);
        intent.putExtra(PermissionActivity.PERMISSIONS, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE,Manifest.permission.READ_EXTERNAL_STORAGE});
        startActivityForResult(intent, READ_SDCARD);

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK){
            if (requestCode == READ_SDCARD){
                if (!TextUtils.isEmpty(thumbPath)){
                    Glide.with(this).asBitmap().load(thumbPath).into(iv_src);
                    iv_src.setVisibility(View.VISIBLE);
                }
                //网络视频url或本地视频路径
                Uri uri = Uri.parse(videoPath);

                videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
                    @Override
                    public void onPrepared(MediaPlayer mediaPlayer) {
                        videoHeight = mediaPlayer.getVideoHeight();
                        videoWidth = mediaPlayer.getVideoWidth();
                        updateVideoViewSize();
                        mediaPlayer.setVideoScalingMode(MediaPlayer.VIDEO_SCALING_MODE_SCALE_TO_FIT);
                        mediaPlayer.setOnInfoListener(new MediaPlayer.OnInfoListener() {
                            @Override
                            public boolean onInfo(MediaPlayer mp, int what, int extra) {
                                if (what == MediaPlayer.MEDIA_INFO_VIDEO_RENDERING_START){
                                    iv_src.setVisibility(View.GONE);
                                    progressBar.setVisibility(View.GONE);
                                }
                                return true;
                            }
                        });
                    }
                });

                //设置视频路径
                videoView.setVideoURI(uri);

                //开始播放视频
                videoView.start();

                layout_root.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        finish();
                    }
                });
                //播放完成回调
                videoView.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                    @Override
                    public void onCompletion(MediaPlayer mediaPlayer) {
                        finish();
                    }
                });
            }
        }else{
            finish();
        }
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT){
            updateVideoViewSize();
        }else if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE){
            updateVideoViewSize();
        }
    }

    private void updateVideoViewSize() {
        if (videoHeight == 0 || videoWidth == 0){
            return;
        }
        Configuration mConfiguration = getResources().getConfiguration(); //获取设置的配置信息
        if (mConfiguration.orientation == Configuration.ORIENTATION_PORTRAIT){
            RelativeLayout.LayoutParams videoViewParam;
            float height = ((videoHeight*1f / videoWidth) * outMetrics.widthPixels);
            videoViewParam = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, (int) height);
            videoView.setLayoutParams(videoViewParam);
        }else{
            RelativeLayout.LayoutParams videoViewParam;
            float width = ((videoWidth*1f / videoHeight) * outMetrics.widthPixels);
            videoViewParam = new RelativeLayout.LayoutParams((int) width,RelativeLayout.LayoutParams.MATCH_PARENT);
            videoView.setLayoutParams(videoViewParam);
        }
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (videoView != null) {
            videoView.suspend();
        }
    }
}
