package com.leeson.image_pickers.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Handler;

import java.io.File;
import java.io.FileOutputStream;

import io.flutter.plugin.common.MethodChannel;

/**
 * Created by liSen on 2019/12/13 15:52.
 *
 * @author liSen < 453354858@qq.com >
 */

public class ImageByteDataSaver {
    private byte[] data;
    private Context context;
    private MethodChannel.Result result;
    private String saveDir;

    private MediaScannerConnection mediaScannerConnection;

    public ImageByteDataSaver(Context context, byte[] data, String saveDir, MethodChannel.Result result) {
        this.data = data;
        this.context = context;
        this.result = result;
        this.saveDir = saveDir;
    }

    public void save(){

        new Thread(new Runnable() {
            @Override
            public void run() {
                Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
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
                    if(bitmap.compress(bitmap.hasAlpha() ? Bitmap.CompressFormat.PNG : Bitmap.CompressFormat.JPEG, 100, out)){
                        out.flush();
                        out.close();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                new Handler(context.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        MediaScannerConnection.MediaScannerConnectionClient client = new MediaScannerConnection.MediaScannerConnectionClient() {
                            @Override
                            public void onMediaScannerConnected() {
                                mediaScannerConnection.scanFile(imageFile.getAbsolutePath(),null);
                            }

                            @Override
                            public void onScanCompleted(String path, Uri uri) {
                                mediaScannerConnection.disconnect();
                            }
                        };
                        mediaScannerConnection = new MediaScannerConnection(context,client);
                        mediaScannerConnection.connect();

                        result.success(imageFile.getAbsolutePath());
                    }
                });

            }
        }).start();

    }
}
