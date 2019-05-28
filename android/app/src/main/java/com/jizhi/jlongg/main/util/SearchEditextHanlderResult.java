package com.jizhi.jlongg.main.util;

import android.text.TextUtils;

import com.jizhi.jlongg.main.activity.ChooseMemberActivity;
import com.jizhi.jlongg.main.activity.ChooseTeamActivity;
import com.jizhi.jlongg.main.activity.ContactsActivity;
import com.jizhi.jlongg.main.activity.GetGroupAccountActivity;
import com.jizhi.jlongg.main.activity.TelContactActivity;
import com.jizhi.jlongg.main.fragment.ChatFragment;

/**
 * Created by Administrator on 2017/10/23 0023.
 */

public class SearchEditextHanlderResult {


    public static String getDefaultResultString(String activityName) {
        if (TextUtils.isEmpty(activityName)) {
            return "暂无记录";
        }
        if (activityName.equals(TelContactActivity.class.getName())) {
            return "暂无联系人";
        } else if (activityName.equals(ChatFragment.class.getName())) {
            return "暂无聊天记录";
        } else if (activityName.equals(ChooseMemberActivity.class.getName())) {
            return "该项目中没有更多的成员可添加";
        }
        return "暂无记录";
    }


    public static String getUoEmptyResultString(String activityName) {
        if (TextUtils.isEmpty(activityName)) {
            return "暂无记录";
        }
        if (activityName.equals(ContactsActivity.class.getName())) { //通讯录
            return "你还没和任何人成为朋友";
        } else if (activityName.equals(ChooseTeamActivity.class.getName())) { //选择群聊、项目组
            return "你暂时没有加入任何项目\n不能从项目添加成员";
        } else if (activityName.equals(GetGroupAccountActivity.class.getName())) {
            return "你还未创建任何班组";
        } else {
            return "暂无记录";
        }
    }

    public static String getEmptyResultString(String ActivityName) {
        return "未搜索到相关内容";
    }

}
