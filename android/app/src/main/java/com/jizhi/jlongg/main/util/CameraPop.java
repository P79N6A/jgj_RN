package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.content.Intent;

import com.jizhi.jlongg.main.bean.ImageItem;

import java.util.ArrayList;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

/**
 * 选择相机图片库pop
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-12-8 下午3:10:14
 */
public class CameraPop {


    public static final int REQUEST_IMAGE = 2;
    public static final int REQUEST_IMAGE_WEB = 3;

    public static final int IMAGE_CROP = 5;
    /**
     * 多选相册图片
     */
    public static void multiSelector(Activity activity, ArrayList<String> mSelectPath, int maxNumber,boolean isShowCamera) {
        int selectedMode = MultiImageSelectorActivity.MODE_MULTI;
        Intent intent = new Intent(activity, MultiImageSelectorActivity.class);
        // 是否显示拍摄图片
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SHOW_CAMERA, isShowCamera);
//        // 最大可选择图片数量
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_COUNT, maxNumber);
        // 选择模式
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_MODE, selectedMode);
        // 默认选择
        if (mSelectPath != null && mSelectPath.size() > 0) {
            intent.putExtra(MultiImageSelectorActivity.EXTRA_DEFAULT_SELECTED_LIST, mSelectPath);
        }
        activity.startActivityForResult(intent, REQUEST_IMAGE);
    }
    /**
     * 多选相册图片
     */
    public static void multiSelector(Activity activity, ArrayList<String> mSelectPath, int maxNumber) {
        int selectedMode = MultiImageSelectorActivity.MODE_MULTI;
        Intent intent = new Intent(activity, MultiImageSelectorActivity.class);
        // 是否显示拍摄图片
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SHOW_CAMERA, true);
//        // 最大可选择图片数量
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_COUNT, maxNumber);
        // 选择模式
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_MODE, selectedMode);
        // 默认选择
        if (mSelectPath != null && mSelectPath.size() > 0) {
            intent.putExtra(MultiImageSelectorActivity.EXTRA_DEFAULT_SELECTED_LIST, mSelectPath);
        }
        activity.startActivityForResult(intent, REQUEST_IMAGE);
    }
    /**
     * 多选相册图片web
     */
    public static void multiSelectorWeb(Activity activity, ArrayList<String> mSelectPath, int maxNumber) {
        int selectedMode = MultiImageSelectorActivity.MODE_MULTI;
        Intent intent = new Intent(activity, MultiImageSelectorActivity.class);
        // 是否显示拍摄图片
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SHOW_CAMERA, true);
//        // 最大可选择图片数量
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_COUNT, maxNumber);
        // 选择模式
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_MODE, selectedMode);
        // 默认选择
        if (mSelectPath != null && mSelectPath.size() > 0) {
            intent.putExtra(MultiImageSelectorActivity.EXTRA_DEFAULT_SELECTED_LIST, mSelectPath);
        }
        activity.startActivityForResult(intent, REQUEST_IMAGE_WEB);
    }
    /**
     * 单选相册图片适配web
     */
    public static void singleSelectorWeb(Activity activity, ArrayList<String> mSelectPath) {
        int selectedMode = MultiImageSelectorActivity.MODE_MULTI;
        Intent intent = new Intent(activity, MultiImageSelectorActivity.class);
        // 是否显示拍摄图片
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SHOW_CAMERA, true);
        // 最大可选择图片数量
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_COUNT, 1);
        // 选择模式
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_MODE, selectedMode);
        // 默认选择
        if (mSelectPath != null && mSelectPath.size() > 0) {
            intent.putExtra(MultiImageSelectorActivity.EXTRA_DEFAULT_SELECTED_LIST, mSelectPath);
        }
        activity.startActivityForResult(intent, REQUEST_IMAGE_WEB);
    }


    /**
     * 单选相册图片
     */
    public static void singleSelector(Activity activity, ArrayList<String> mSelectPath) {
        int selectedMode = MultiImageSelectorActivity.MODE_MULTI;
        Intent intent = new Intent(activity, MultiImageSelectorActivity.class);
        // 是否显示拍摄图片
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SHOW_CAMERA, true);
        // 最大可选择图片数量
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_COUNT, 1);
        // 选择模式
        intent.putExtra(MultiImageSelectorActivity.EXTRA_SELECT_MODE, selectedMode);
        // 默认选择
        if (mSelectPath != null && mSelectPath.size() > 0) {
            intent.putExtra(MultiImageSelectorActivity.EXTRA_DEFAULT_SELECTED_LIST, mSelectPath);
        }
        activity.startActivityForResult(intent, REQUEST_IMAGE);
    }



    public static ImageItem initPhotos() {
        ImageItem item = new ImageItem();
        item.isNetPicture = false;
        return item;
    }


}
