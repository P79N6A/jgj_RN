package com.jizhi.jlongg.main.util;

import com.jizhi.jlongg.main.bean.Photo;

import java.util.Comparator;

/**
 * 功能: 根据照片id 排序
 * 作者：Xuj
 * 时间: 2016-4-7 15:13
 */
public class SortPhoto implements Comparator<Photo> {

    @Override
    public int compare(Photo lhs, Photo rhs) {
        return lhs.getId() - rhs.getId();
    }

}
