package com.leeson.image_pickers.utils;

import android.content.Context;
import android.graphics.Color;

import com.leeson.image_pickers.R;
import com.luck.picture.lib.style.PictureCropParameterStyle;
import com.luck.picture.lib.style.PictureParameterStyle;

import java.util.Map;

import androidx.core.content.ContextCompat;

/**
 * Created by liSen on 2019/11/25 17:45.
 *
 * @author liSen < 453354858@qq.com >
 */

public class PictureStyleUtil {

    private Context context;

    public PictureStyleUtil(Context context) {
        this.context = context;
    }

    /**
     * 相册主题
     *
     * @param uiColor
     * @return
     */
    public PictureParameterStyle getStyle(Map<String, Number> uiColor) {

        int a = 255;
        int r = 255;
        int g = 255;
        int b = 255;
        int l = 255;
        Number aNumber = uiColor.get("a");
        if (aNumber != null) {
            a = aNumber.intValue();
        }
        Number rNumber = uiColor.get("r");
        if (rNumber != null) {
            r = rNumber.intValue();
        }
        Number gNumber = uiColor.get("g");
        if (gNumber != null) {
            g = gNumber.intValue();
        }
        Number bNumber = uiColor.get("b");
        if (bNumber != null) {
            b = bNumber.intValue();
        }
        Number lNumber = uiColor.get("l");
        if (lNumber != null) {
            l = lNumber.intValue();
        }

        int argb = Color.argb(a, r, g, b);

        PictureParameterStyle parameterStyle = new PictureParameterStyle();
        // 是否改变状态栏字体颜色(黑白切换)
        parameterStyle.isChangeStatusBarFontColor = true;
        // 是否开启右下角已完成(0/9)风格
        parameterStyle.isOpenCompletedNumStyle = true;
        // 是否开启类似QQ相册带数字选择风格
        parameterStyle.isOpenCheckNumStyle = true;
        // 相册列表底部背景色
        parameterStyle.pictureBottomBgColor = ContextCompat.getColor(context, R.color.white);
        // 预览界面底部背景色
        parameterStyle.picturePreviewBottomBgColor = ContextCompat.getColor(context, R.color.white);
        // 相册状态栏背景色
        parameterStyle.pictureStatusBarColor = argb;
        // 相册列表标题栏背景色
        parameterStyle.pictureTitleBarBackgroundColor = argb;


        // 相册列表勾选图片样式
        parameterStyle.pictureCheckedStyle = R.drawable.checkbox_num_white_selector;
        // 已选数量圆点背景样式
        parameterStyle.pictureCheckNumBgStyle = R.drawable.num_oval_white;

        // 相册列表未完成色值(请选择 不可点击色值)
        parameterStyle.pictureUnCompleteTextColor = ContextCompat.getColor(context, R.color.disableColor);

        // 相册列表底下不可预览文字色值(预览按钮不可点击时的色值)
        parameterStyle.pictureUnPreviewTextColor = ContextCompat.getColor(context, R.color.disableColor);

        // 相册文件夹列表选中圆点
        parameterStyle.pictureFolderCheckedDotStyle = R.drawable.num_oval_black_def;
        if (l > (int) (255 * 0.7)) {

            // 相册列表标题栏右侧上拉箭头
            parameterStyle.pictureTitleUpResId = R.drawable.black_arrow_up;
            // 相册列表标题栏右侧下拉箭头
            parameterStyle.pictureTitleDownResId = R.drawable.black_arrow_down;

            // 相册返回箭头
            parameterStyle.pictureLeftBackIcon = R.drawable.black_back;
            // 标题栏字体颜色
            parameterStyle.pictureTitleTextColor = ContextCompat.getColor(context, R.color.bar_grey);
            // 相册右侧取消按钮字体颜色
            parameterStyle.pictureCancelTextColor = ContextCompat.getColor(context, R.color.bar_grey);
            parameterStyle.pictureRightDefaultTextColor = ContextCompat.getColor(context, R.color.bar_grey);
            // 相册列表底下预览文字色值(预览按钮可点击时的色值)
            parameterStyle.picturePreviewTextColor = R.color.bar_grey;
            // 相册列表已完成色值(已完成 可点击色值)
            parameterStyle.pictureCompleteTextColor = R.color.bar_grey;
        }else{
            // 相册列表标题栏右侧上拉箭头
            parameterStyle.pictureTitleUpResId = R.drawable.picture_icon_arrow_up;
            // 相册列表标题栏右侧下拉箭头
            parameterStyle.pictureTitleDownResId = R.drawable.picture_icon_arrow_down;
            // 相册返回箭头
            parameterStyle.pictureLeftBackIcon = R.drawable.picture_icon_back;
            // 标题栏字体颜色
            parameterStyle.pictureTitleTextColor = ContextCompat.getColor(context, R.color.white);
            // 相册右侧取消按钮字体颜色
            parameterStyle.pictureCancelTextColor = ContextCompat.getColor(context, R.color.white);
            parameterStyle.pictureRightDefaultTextColor = ContextCompat.getColor(context, R.color.white);
            // 相册列表底下预览文字色值(预览按钮可点击时的色值)
            parameterStyle.picturePreviewTextColor = argb;
            // 相册列表已完成色值(已完成 可点击色值)
            parameterStyle.pictureCompleteTextColor = argb;
        }
        return parameterStyle;
    }

    /**
     * 裁剪主题
     *
     * @param uiColor
     * @return
     */
    public PictureCropParameterStyle getCropStyle(Map<String, Number> uiColor) {
        int a = 255;
        int r = 255;
        int g = 255;
        int b = 255;
        int l = 255;
        Number aNumber = uiColor.get("a");
        if (aNumber != null) {
            a = aNumber.intValue();
        }
        Number rNumber = uiColor.get("r");
        if (rNumber != null) {
            r = rNumber.intValue();
        }
        Number gNumber = uiColor.get("g");
        if (gNumber != null) {
            g = gNumber.intValue();
        }
        Number bNumber = uiColor.get("b");
        if (bNumber != null) {
            b = bNumber.intValue();
        }
        Number lNumber = uiColor.get("l");
        if (lNumber != null) {
            l = lNumber.intValue();
        }

        PictureCropParameterStyle cropParameterStyle = new PictureCropParameterStyle();
        cropParameterStyle.isChangeStatusBarFontColor = true;
        cropParameterStyle.cropStatusBarColorPrimaryDark = Color.argb(a, r, g, b);
        cropParameterStyle.cropTitleBarBackgroundColor = Color.argb(a, r, g, b);
        if (l > (int) (255 * 0.7)) {
            cropParameterStyle.cropTitleColor = ContextCompat.getColor(context, R.color.bar_grey);
        } else {
            cropParameterStyle.cropTitleColor = ContextCompat.getColor(context, R.color.white);
        }
        return cropParameterStyle;
    }

}
