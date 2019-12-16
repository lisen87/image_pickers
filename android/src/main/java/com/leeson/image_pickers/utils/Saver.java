package com.leeson.image_pickers.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Handler;
import android.text.TextUtils;

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
public class Saver {
    private String saveDir;
    private Context context;
    private MethodChannel.Result result;

    private MediaScannerConnection mediaScannerConnection;

    public Saver(Context context, String saveDir, MethodChannel.Result result) {
        this.context = context;
        this.saveDir = saveDir;
        this.result = result;
    }

    private void notifyGallery(final String path){
        MediaScannerConnection.MediaScannerConnectionClient client = new MediaScannerConnection.MediaScannerConnectionClient() {
            @Override
            public void onMediaScannerConnected() {
                mediaScannerConnection.scanFile(path,null);
            }

            @Override
            public void onScanCompleted(String path, Uri uri) {
                mediaScannerConnection.disconnect();
            }
        };
        mediaScannerConnection = new MediaScannerConnection(context,client);
        mediaScannerConnection.connect();
    }


    public void saveByteData(final byte[] data){

        new Thread(new Runnable() {
            @Override
            public void run() {
                BitmapFactory.Options options = new BitmapFactory.Options();
                options.inSampleSize = 10;
                Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length,options);
                File dir = new File(saveDir);
                if (!dir.exists()){
                    dir.mkdirs();
                }

                String suffix = bitmap.hasAlpha() ? ".png" : ".jpg";
                String fileName = System.currentTimeMillis() + suffix;
                final File imageFile = new File(saveDir,fileName);

                FileOutputStream out = null;
                try {
                    out = new FileOutputStream(imageFile,false);
                    out.write(data, 0, data.length);
                    out.flush();
                    out.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }

                new Handler(context.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        notifyGallery(imageFile.getAbsolutePath());

                        result.success(imageFile.getAbsolutePath());
                    }
                });

            }
        }).start();

    }

    public void download(final String saveUrl){
        if (TextUtils.isEmpty(saveUrl)){
            return;
        }
        File dir = new File(saveDir);
        if (!dir.exists()){
            dir.mkdirs();
        }

        String fileName = saveUrl.substring(saveUrl.lastIndexOf("/")+1);
        final File videoFile = new File(saveDir,fileName);

        new Thread(new Runnable() {
            InputStream inputStream = null;
            FileOutputStream fileOutputStream = null;
            @Override
            public void run() {
                try {
                    URL url = new URL(saveUrl);
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

                                notifyGallery(videoFile.getAbsolutePath());
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

                } catch (final Exception e) {
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
