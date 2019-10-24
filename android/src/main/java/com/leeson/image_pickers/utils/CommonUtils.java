package com.leeson.image_pickers.utils;

import android.content.Context;
import android.graphics.Bitmap;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * Created by lisen on 2019/10/18.
 *
 * @author lisen < 453354858@qq.com >
 */
@SuppressWarnings("all")
public class CommonUtils {
    public static String saveBitmap(Context context,String sdPath,Bitmap bitmap){
        try {
            File file = new File(sdPath);
            if (!file.exists()){
                file.mkdirs();
            }
            File tempBitmap = new File(file,System.currentTimeMillis()+".png");
            if (tempBitmap.exists()){
                tempBitmap.delete();
                tempBitmap.createNewFile();
            }
            FileOutputStream out = new FileOutputStream(tempBitmap,false);
            if(bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)){
                out.flush();
                out.close();
            }
            return tempBitmap.getAbsolutePath();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "";
    }
}
