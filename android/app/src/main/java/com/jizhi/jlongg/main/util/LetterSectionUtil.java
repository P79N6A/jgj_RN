package com.jizhi.jlongg.main.util;

import android.text.TextUtils;

import com.jizhi.jlongg.main.bean.GroupMemberInfo;

import java.util.ArrayList;
import java.util.List;

/**
 * 字母分类工具
 * 从a-z分类  获取分类的首字母的Char ascii值
 */
public class LetterSectionUtil {


    /**
     * 根据分类的首字母的Char ascii值获取其第一次出现该首字母的位置
     */
    @SuppressWarnings("unused")
    public static boolean getPositionForSection(ArrayList<GroupMemberInfo> groupMemberInfos, String sortLetters, int position) {
        if (TextUtils.isEmpty(sortLetters) || groupMemberInfos == null || groupMemberInfos.size() == 0) {
            return false;
        }
        int section = sortLetters.charAt(0);
        int size = groupMemberInfos.size();
        for (int i = 0; i < size; i++) {
            String mSortLetters = groupMemberInfos.get(i).getSortLetters();
            if (!TextUtils.isEmpty(mSortLetters)) {
                char firstChar = mSortLetters.toUpperCase().charAt(0);
                if (firstChar == section) {
                    return i == position ? true : false;
                }
            }
        }
        return false;
    }

    /**
     * 根据ListView的当前位置获取分类的首字母的Char ascii值
     */
    public static int getSectionForPosition(int section, List<GroupMemberInfo> list) {
        if (list == null || list.size() == 0) {
            return -1;
        }
        int count = list.size();
        for (int i = 0; i < count; i++) {
            String sortStr = list.get(i).getSortLetters();
            if (null != sortStr) {
                char firstChar = sortStr.toUpperCase().charAt(0);
                if (firstChar == section) {
                    return i;
                }
            }
        }
        return -1;
    }
}
