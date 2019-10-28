package com.leeson.image_pickers.utils;

import android.content.Context;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Handler;
import android.text.TextUtils;

import com.leeson.image_pickers.AppPath;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import io.flutter.plugin.common.MethodChannel;

/**
 * Created by lisen on 2019/10/28.
 *
 * @author lisen < 453354858@qq.com >
 */
public class VideoSaver {
    private String videoUrl;
    private Context context;
    private MethodChannel.Result result;

    private MediaScannerConnection mediaScannerConnection;

    public VideoSaver(Context context, String videoUrl, MethodChannel.Result result) {
        this.videoUrl = videoUrl;
        this.context = context;
        this.result = result;
    }
    public void download(){
        if (TextUtils.isEmpty(videoUrl)){
            return;
        }

        AppPath appPath = new AppPath(context);
        String videoDirPath = appPath.getVideoPath();
        File dir = new File(videoDirPath);
        if (!dir.exists()){
            dir.mkdirs();
        }
        String fileName = videoUrl.substring(videoUrl.lastIndexOf("/")+1);
        final File videoFile = new File(dir,fileName);

        new Thread(new Runnable() {
            InputStream inputStream = null;
            FileOutputStream fileOutputStream = null;
            @Override
            public void run() {
                try {
                    URL url = new URL(videoUrl);
                    final HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                    connection.setRequestMethod("GET");
                    connection.connect();
                    int responseCode = connection.getResponseCode();
                    if(responseCode == HttpURLConnection.HTTP_OK){
                        inputStream = connection.getInputStream();
                        fileOutputStream = new FileOutputStream(videoFile);
                        int len ;
                        byte[] b = new byte[1024];
                        while ((len = inputStream.read(b)) != -1){
                            fileOutputStream.write(b,0,len);
                        }
                        fileOutputStream.close();
                        inputStream.close();

                        new Handler(context.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                MediaScannerConnection.MediaScannerConnectionClient client = new MediaScannerConnection.MediaScannerConnectionClient() {
                                    @Override
                                    public void onMediaScannerConnected() {
                                        mediaScannerConnection.scanFile(videoFile.getAbsolutePath(),null);
                                    }

                                    @Override
                                    public void onScanCompleted(String path, Uri uri) {
                                        mediaScannerConnection.disconnect();
                                    }
                                };
                                mediaScannerConnection = new MediaScannerConnection(context,client);
                                mediaScannerConnection.connect();
                                result.success(videoFile.getAbsolutePath());
                            }
                        });
                    }else {
                        new Handler(context.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                try {
                                    result.error(connection.getResponseMessage()+"",connection.getResponseCode()+"",null);
                                } catch (IOException e) {
                                    e.printStackTrace();
                                }
                            }
                        });
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    try {
                        if (fileOutputStream != null){
                            fileOutputStream.close();
                        }
                        if (inputStream != null){
                            inputStream.close();
                        }
                    } catch (IOException ex) {
                        ex.printStackTrace();
                    }
                }
            }
        }).start();
    }
}
