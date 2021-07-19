package com.leeson.image_pickers;

import android.content.Context;

import java.io.File;
import java.io.IOException;

/**
 * Created by lisen on 2019/5/16.
 *
 * @author lisen < 453354858@qq.com >
 */
@SuppressWarnings("all")
public class AppPath {
    private Context context;
    private String packageName;
    public AppPath(Context context) {
        this.context = context;
        packageName = context.getPackageName();
        packageName = packageName.substring(packageName.lastIndexOf(".")+1);
    }

    public String getPackageName() {
        return packageName;
    }

    /**
     *
     * @return  sd/->/android/data/packageName/files/
     */
    public String getAppDirPath() {
        File privatePicDir = context.getExternalFilesDir(null);
        if (privatePicDir != null) {
            return privatePicDir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }
    /**
     *
     * @return Q : sd/->/android/data/packageName/files/Download
     */
    public String getAppDownloadDirPath() {
        File privatePicDir = context.getExternalFilesDir("Download");
        if (privatePicDir != null) {
            return privatePicDir.getAbsolutePath();
        }
        return context.getFilesDir().getPath();
    }

    /**
     * 保存的相机图片
     *
     * @return  sd/->/android/data/packageName/files/DCIM
     */
    public String getAppDCIMDirPath() {
        File picDir = context.getExternalFilesDir("DCIM");
        if (picDir != null) {
            return picDir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }
    /**
     * 保存的图片
     *
     * @return  sd/->/android/data/packageName/files/Pictures
     */
    public String getAppImgDirPath() {
        File picDir = context.getExternalFilesDir("Pictures");
        if (picDir != null) {
            createNomedia(picDir.getAbsolutePath());
            return picDir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }

    private void createNomedia(String path) {
        File nomedia = new File(path,".nomedia");
        if (!nomedia.exists()){
            try {
                nomedia.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 保存的视频文件
     *
     * @return sd/->/android/data/packageName/files/Movies
     */
    public String getAppVideoDirPath() {

        File videoDir = context.getExternalFilesDir("Movies");
        if (videoDir != null) {
            createNomedia(videoDir.getAbsolutePath());
            return videoDir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }

    /**
     * 保存的录音文件
     *只有29 才有 Environment.DIRECTORY_AUDIOBOOKS
     * @return sd/->/android/data/packageName/files/Audiobooks
     */
    public String getAppAudioDirPath() {
        File audioDir = context.getExternalFilesDir("Audiobooks");
        if (audioDir != null) {
            return audioDir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }
    /**
     * 保存的音乐文件
     *
     * @return sd/->/android/data/packageName/files/Music
     */
    public String getAppMusicDirPath() {
        File dir = context.getExternalFilesDir("Music");
        if (dir != null) {
            return dir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }

    /**
     * 保存的text文件
     * @return sd/->/android/data/packageName/files/Documents
     */
    public String getAppDocumentsDirPath() {
        File dir = context.getExternalFilesDir("Documents");
        if (dir != null) {
            return dir.getAbsolutePath();
        }
        return context.getFilesDir().getAbsolutePath();
    }
    /**
     * 保存的日志文件
     * @return sd/->/android/data/packageName/files/Documents/logs
     */
    public String getAppLogDirPath() {
        return getAppDocumentsDirPath() + "/logs/";
    }
}
