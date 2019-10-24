package com.leeson.image_pickers;

import android.content.Context;
import android.os.Environment;

/**
 * Created by lisen on 2019/5/16.
 *
 * @author lisen < 453354858@qq.com >
 */
public class AppPath {
    private Context context;

    private String packageName;
    public AppPath(Context context) {
        this.context = context;
        packageName = context.getPackageName();
        packageName = packageName.replaceAll("\\.","-");
    }

    public String getAppPath(){
        return Environment.getExternalStorageDirectory()+"/"+ packageName;
    }

    /**
     * 保存的图片 不展示
     * @return
     */
    public String getImgPath(){
        return Environment.getExternalStorageDirectory()+"/"+ packageName + "/image/";
    }

    /**
     * 保存的图片 可以展示到相册
     * @return
     */
    public String getShowedImgPath(){
        return Environment.getExternalStorageDirectory()+"/"+ packageName + "/showedImage/";
    }

    /**
     * 保存的视频文件
     * @return
     */
    public String getVideoPath(){
        return Environment.getExternalStorageDirectory()+"/"+ packageName + "/video/";
    }

    /**
     * 保存的录音文件
     * @return
     */
    public String getRocordPath(){
        return Environment.getExternalStorageDirectory()+"/"+ packageName + "/rocord/";
    }
    public String getLogPath(){
        return Environment.getExternalStorageDirectory()+"/"+ packageName + "/log/";
    }
}
