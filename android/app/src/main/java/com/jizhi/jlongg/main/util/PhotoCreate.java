package com.jizhi.jlongg.main.util;

import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;

import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.Photo;
import com.jizhi.jlongg.main.bean.SerializableMap;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * 功能:
 * 作者：Administrator
 * 时间: 2016-4-7 15:21
 */
public class PhotoCreate {

    public static List<Photo> getPhotos(int max) {
        List<Photo> list = new ArrayList<Photo>();
        list.add(new Photo(max + 1, null));
        return list;
    }


    /** 拍照 */
    public static Photo compressfromTakePhoto(String filePath,Context context,int id){
        if (!TextUtils.isEmpty(filePath)) {
            File f = new File(filePath);
            Photo photo = PicSizeUtils.getSmallBitmap(filePath, f.getName(), true); // 获取压缩后的图片
            if (photo != null) {
                photo.setId(id);
                return photo;
            }else{
                CommonMethod.makeNoticeShort(context, "当前拍摄路径不存在!",CommonMethod.ERROR);
            }
        }
        return null;
    }

    /** 相册回调 */
    public static List<Photo> compressfromAlbum(Context context,int id,Intent data){

        return null;
    }



    /** 相册回调 */
    public static List<ImageItem> compressfromAlbum_test(Context context,Intent data){
        SerializableMap map = (SerializableMap)data.getSerializableExtra(Constance.BEAN_CONSTANCE);
        List<ImageItem> tempList = new ArrayList<ImageItem>();
        Set<String> set = map.getMap().keySet();
        for(String s:set){
            ImageItem imageItem = map.getMap().get(s);
            tempList.add(0,imageItem);
        }
        return tempList;
    }


}
