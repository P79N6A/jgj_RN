package com.hcs.uclient.utils;

import android.content.Context;
import android.graphics.Bitmap;

import com.jizhi.jlongg.R;
import com.nostra13.universalimageloader.core.DisplayImageOptions;

/**
 * 功能:ImageLoader DisplayImageOptions 返回
 * 时间:2016/3/11 11:09
 * 作者:
 */
public class UtilImageLoader {

    /**
     * 设置圆角为10px
     *
     * @return
     */
    public static DisplayImageOptions getImageOptionsFriendHead() {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.friend_head)
                .showImageForEmptyUri(R.drawable.friend_head)
                .showImageOnFail(R.drawable.friend_head)
                .cacheInMemory(true)
//                .displayer(new RoundedBitmapDisplayer(10))//是否设置为圆角，弧度为多少
                .cacheOnDisk(true).considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
        return options;
    }

    /**
     * 班组长/工头
     *
     * @return
     */
    public static DisplayImageOptions getFriend() {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.friend_head)
                .showImageForEmptyUri(R.drawable.friend_head)
                .showImageOnFail(R.drawable.friend_head)
                .cacheInMemory(true)
                .cacheOnDisk(true).considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
        return options;
    }


    /**
     * 班组长/工头
     *
     * @return
     */
    public static DisplayImageOptions getForeman() {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.foreman_head)
                .showImageForEmptyUri(R.drawable.foreman_head)
                .showImageOnFail(R.drawable.foreman_head)
                .cacheInMemory(true)
                .cacheOnDisk(true).considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
        return options;
    }


    /**
     * 工友 opstions
     *
     * @return
     */
    public static DisplayImageOptions getWoker() {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.worker_head)
                .showImageForEmptyUri(R.drawable.worker_head)
                .showImageOnFail(R.drawable.worker_head)
                .cacheInMemory(true)
                .cacheOnDisk(true).considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
        return options;
    }

    /**
     * 获取项目经验options
     *
     * @return
     */
    public static DisplayImageOptions getExperienceOptions() {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.experience)
                .showImageForEmptyUri(R.drawable.experience)
                .showImageOnFail(R.drawable.experience)
                .cacheInMemory(true)
                .cacheOnDisk(true).considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
        return options;
    }

    /**
     * 圆角图片
     *
     * @return
     */
    public static DisplayImageOptions getRoundOptions() {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.default_banner)
                .showImageForEmptyUri(R.drawable.default_banner)
                .showImageOnFail(R.drawable.default_banner)
                .cacheInMemory(true)  //设置下载的图片是否缓存在内存中
                .cacheOnDisk(true)  //设置下载的图片是否缓存在SD卡中
                .considerExifParams(true) ////是否考虑JPEG图像EXIF参数（旋转，翻转）
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
        return options;
    }

    /**
     * 获取视频缩略图
     *
     * @return
     */
    public static DisplayImageOptions getVideoThumbnailOptions() {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .cacheInMemory(true)  //设置下载的图片是否缓存在内存中
                .cacheOnDisk(true)  //设置下载的图片是否缓存在SD卡中
                .considerExifParams(true) ////是否考虑JPEG图像EXIF参数（旋转，翻转）
                .showImageOnLoading(R.drawable.video_default_image)
                .showImageForEmptyUri(R.drawable.video_default_image)
                .showImageOnFail(R.drawable.video_default_image)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
        return options;
    }


    /**
     * 加载头像选项
     *
     * @return
     */
    public static DisplayImageOptions getHeadOptions() {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.friend_head)
                .showImageForEmptyUri(R.drawable.friend_head)
                .showImageOnFail(R.drawable.friend_head)
                .cacheInMemory(true)  //设置下载的图片是否缓存在内存中
                .cacheOnDisk(true)  //设置下载的图片是否缓存在SD卡中
                .considerExifParams(true) ////是否考虑JPEG图像EXIF参数（旋转，翻转）
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
        return options;
    }


    public static DisplayImageOptions getRectangleHead(Context context) {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.friend_head)
                .showImageForEmptyUri(R.drawable.friend_head)
                .showImageOnFail(R.drawable.friend_head)
                .cacheInMemory(true)  //设置下载的图片是否缓存在内存中
                .cacheOnDisk(true)  //设置下载的图片是否缓存在SD卡中
                .considerExifParams(true) ////是否考虑JPEG图像EXIF参数（旋转，翻转）
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
        return options;
    }

    public static DisplayImageOptions getAdvertiseOptions(Context context) {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .cacheInMemory(true)  //设置下载的图片是否缓存在内存中
                .cacheOnDisk(true)  //设置下载的图片是否缓存在SD卡中
                .considerExifParams(true) ////是否考虑JPEG图像EXIF参数（旋转，翻转）
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
        return options;
    }

    public static DisplayImageOptions loadRepository(Context context) {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .cacheInMemory(true)  //设置下载的图片是否缓存在内存中
                .cacheOnDisk(true)  //设置下载的图片是否缓存在SD卡中
                .considerExifParams(true) ////是否考虑JPEG图像EXIF参数（旋转，翻转）
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
        return options;
    }


    public static DisplayImageOptions loadListItemCloudOptions(Context context) {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.pic_icon)
                .showImageForEmptyUri(R.drawable.pic_icon)
                .showImageOnFail(R.drawable.pic_icon)
                .cacheInMemory(true)  //设置下载的图片是否缓存在内存中
                .cacheOnDisk(true)  //设置下载的图片是否缓存在SD卡中
                .considerExifParams(true) ////是否考虑JPEG图像EXIF参数（旋转，翻转）
                .bitmapConfig(Bitmap.Config.ARGB_4444)
                .build();
        return options;
    }

    public static DisplayImageOptions loadCloudOptions(Context context) {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .showImageOnLoading(R.drawable.pic_icon)
                .showImageForEmptyUri(R.drawable.pic_icon)
                .showImageOnFail(R.drawable.pic_icon)
                .cacheInMemory(true)  //设置下载的图片是否缓存在内存中
                .cacheOnDisk(true)  //设置下载的图片是否缓存在SD卡中
                .considerExifParams(true) ////是否考虑JPEG图像EXIF参数（旋转，翻转）
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
        return options;
    }


    public static DisplayImageOptions getLocalPicOptions() {
        DisplayImageOptions options = new DisplayImageOptions.Builder()
                .considerExifParams(true) ////是否考虑JPEG图像EXIF参数（旋转，翻转）
                .bitmapConfig(Bitmap.Config.RGB_565)
                .build();
        return options;
    }
}
