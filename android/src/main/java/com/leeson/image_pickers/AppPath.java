package com.leeson.image_pickers;

import android.content.Context;
import android.os.Build;
import android.os.Environment;

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
    /**
     *
     * @return Q : sd/->/android/data/packageName/files/
     */
    public String getAppDirPath() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){
            File privatePicDir = context.getExternalFilesDir(null);
            if (privatePicDir != null) {
                return privatePicDir.getAbsolutePath();
            }
            return "";
        }else{
            String path = Environment.getExternalStorageDirectory()+"/"+ packageName+"/";
            File dir = new File(path);
            if (!dir.exists()){
                dir.mkdirs();
            }
            return dir.getAbsolutePath();
        }
    }
    /**
     *
     * @return Q : sd/->/android/data/packageName/files/Download
     */
    public String getAppDownloadDirPath() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){
            File privatePicDir = context.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS);
            if (privatePicDir != null) {
                return privatePicDir.getAbsolutePath();
            }
            return "";
        }else{
            String path = Environment.getExternalStorageDirectory()+"/"+ packageName+"/"+Environment.DIRECTORY_DOWNLOADS;
            File dir = new File(path);
            if (!dir.exists()){
                dir.mkdirs();
            }
            return dir.getAbsolutePath();
        }
    }

    /**
     * 保存的相机图片
     *
     * @return  sd/->/android/data/packageName/files/DCIM
     */
    public String getAppDCIMDirPath() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){
            File picDir = context.getExternalFilesDir(Environment.DIRECTORY_DCIM);
            if (picDir != null) {
                return picDir.getAbsolutePath();
            }
            return "";
        }else{
            String path = Environment.getExternalStorageDirectory()+"/"+ packageName+"/"+Environment.DIRECTORY_DCIM;
            File dir = new File(path);
            if (!dir.exists()){
                dir.mkdirs();
            }
            return dir.getAbsolutePath();
        }

    }
    /**
     * 保存的图片
     *
     * notQIsShowInGallery : false 非AndroidQ 保存在沙盒中，true : 非AndroidQ 保存在sd卡并且显示在图库中
     * @return  sd/->/android/data/packageName/files/Pictures
     */
    public String getAppImgDirPath(boolean notQIsShowInGallery) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){
            File picDir = context.getExternalFilesDir(Environment.DIRECTORY_PICTURES);
            if (picDir != null) {
                return picDir.getAbsolutePath();
            }
            return "";
        }else{
            if (notQIsShowInGallery){
                String path = Environment.getExternalStorageDirectory()+"/"+ packageName+"/"+Environment.DIRECTORY_PICTURES;
                File dir = new File(path);
                if (!dir.exists()){
                    dir.mkdirs();
                }
                return dir.getAbsolutePath();
            }else{
                String path = Environment.getExternalStorageDirectory()+"/"+ packageName+"/"+Environment.DIRECTORY_PICTURES + "/cache";
                File dir = new File(path);
                if (!dir.exists()){
                    dir.mkdirs();
                }
                createNomedia(path);
                return path;
            }
        }
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
     * notQIsShowInGallery : true 非AndroidQ 保存在沙盒中，false : 非AndroidQ 保存在sd卡并且显示在图库中
     * @return sd/->/android/data/packageName/files/Movies
     */
    public String getAppVideoDirPath(boolean notQIsShowInGallery) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){
            File videoDir = context.getExternalFilesDir(Environment.DIRECTORY_MOVIES);
            if (videoDir != null) {
                return videoDir.getAbsolutePath();
            }
            return "";
        }else{
            if (notQIsShowInGallery){
                String path = Environment.getExternalStorageDirectory()+"/"+ packageName+"/"+Environment.DIRECTORY_MOVIES;
                File dir = new File(path);
                if (!dir.exists()){
                    dir.mkdirs();
                }
                return dir.getAbsolutePath();
            }else{
                String path = Environment.getExternalStorageDirectory()+"/"+ packageName+"/"+Environment.DIRECTORY_MOVIES + "/cache";
                File dir = new File(path);
                if (!dir.exists()){
                    dir.mkdirs();
                }
                createNomedia(path);
                return path;
            }
        }
    }

    /**
     * 保存的录音文件
     *只有29 才有 Environment.DIRECTORY_AUDIOBOOKS
     * @return sd/->/android/data/packageName/files/Audiobooks
     */
    public String getAppAudioDirPath() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){
            File audioDir = context.getExternalFilesDir(Environment.DIRECTORY_AUDIOBOOKS);
            if (audioDir != null) {
                return audioDir.getAbsolutePath();
            }
            return "";
        }else{
            String path = Environment.getExternalStorageDirectory()+"/"+ packageName+"/Audiobooks";
            File dir = new File(path);
            if (!dir.exists()){
                dir.mkdirs();
            }
            return dir.getAbsolutePath();
        }
    }
    /**
     * 保存的音乐文件
     *
     * @return sd/->/android/data/packageName/files/Music
     */
    public String getAppMusicDirPath() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){
            File audioDir = context.getExternalFilesDir(Environment.DIRECTORY_MUSIC);
            if (audioDir != null) {
                return audioDir.getAbsolutePath();
            }
            return "";
        }else{
            String path = Environment.getExternalStorageDirectory()+"/"+ packageName+"/"+Environment.DIRECTORY_MUSIC;
            File dir = new File(path);
            if (!dir.exists()){
                dir.mkdirs();
            }
            return dir.getAbsolutePath();
        }

    }

    /**
     * 保存的text文件
     * @return sd/->/android/data/packageName/files/Documents
     */
    public String getAppDocumentsDirPath() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q){
            File audioDir = context.getExternalFilesDir(Environment.DIRECTORY_DOCUMENTS);
            if (audioDir != null) {
                return audioDir.getAbsolutePath();
            }
            return "";
        }else{
            String path = Environment.getExternalStorageDirectory()+"/"+ packageName+"/"+Environment.DIRECTORY_DOCUMENTS;
            File dir = new File(path);
            if (!dir.exists()){
                dir.mkdirs();
            }
            return dir.getAbsolutePath();
        }
    }
    /**
     * 保存的日志文件
     * @return sd/->/android/data/packageName/files/Documents/logs
     */
    public String getAppLogDirPath() {
        return getAppDocumentsDirPath() + "/logs/";
    }
}
