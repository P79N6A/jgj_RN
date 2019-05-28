package com.jizhi.jlongg.main.util;

import android.text.TextUtils;

import com.jizhi.jlongg.main.bean.PersonBean;

import java.util.Comparator;

/**
 * 功能: 根据照片id 排序
 * 作者：Xuj
 * 时间: 2016-4-7 15:13
 */
public class SortPerson implements Comparator<PersonBean> {
    @Override
    public int compare(PersonBean lhs, PersonBean rhs) {
        if (TextUtils.isEmpty(lhs.getSortLetters())) {
            return -1;
        }
        if (TextUtils.isEmpty(rhs.getSortLetters())) {
            return -1;
        }
        char a = lhs.getSortLetters().charAt(0);
        char b = rhs.getSortLetters().charAt(0);
        return a - b;
    }
}
