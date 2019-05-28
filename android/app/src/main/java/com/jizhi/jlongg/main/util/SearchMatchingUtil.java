package com.jizhi.jlongg.main.util;

import android.text.TextUtils;

import com.hcs.cityslist.widget.CharacterParser;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.bean.SynBill;
import com.jizhi.jlongg.main.bean.UserInfo;

import java.util.ArrayList;
import java.util.List;

/**
 * 搜索匹配
 */

public class SearchMatchingUtil {
    /**
     * 匹配通讯录数据
     *
     * @param list        列表数据
     * @param matchString 匹配数据
     * @return
     */
    public static List match(Class classModel, List list, String matchString) {
        if (TextUtils.isEmpty(matchString)) {
            return list;
        }
        if (classModel == GroupMemberInfo.class) { //项目组成员
            return handlerGroupMemberInfoList(list, matchString);
        } else if (classModel == SynBill.class) { //同步消息
            return handlerSynBillList(list, matchString);
        } else if (classModel == UserInfo.class) { //用户信息
            return handlerUserInfoList(list, matchString);
        } else if (classModel == GroupDiscussionInfo.class) {
            return handlerGroupDiscussionList(list, matchString);
        } else if (classModel == Repository.class) {
            return handlerRepositoryList(list, matchString);
        } else if (classModel == PersonBean.class) {
            return handlerPersonBeanList(list, matchString);
        } else if (classModel == Project.class) {
            return handlerProjectList(list, matchString);
        } else {
            return list;
        }
    }


    private static List<GroupMemberInfo> handlerGroupMemberInfoList(List<GroupMemberInfo> list, String matchString) {
        List<GroupMemberInfo> filterDataList = null;
        CharacterParser parser = CharacterParser.getInstance();
        for (GroupMemberInfo bean : list) {
            String realName = bean.getReal_name();
            String telphone = bean.getTelephone();
            if (!TextUtils.isEmpty(realName) && realName.indexOf(matchString) != -1
                    || !TextUtils.isEmpty(realName) && parser.getSelling(realName).startsWith(matchString)
                    || !TextUtils.isEmpty(telphone) && telphone.startsWith(matchString)) {
                if (filterDataList == null) {
                    filterDataList = new ArrayList<>();
                }
                filterDataList.add(bean);
            }
        }
        return filterDataList;
    }


    private static List<UserInfo> handlerUserInfoList(List<UserInfo> list, String matchString) {
        List<UserInfo> filterDataList = null;
        CharacterParser parser = CharacterParser.getInstance();
        for (UserInfo bean : list) {
            String realName = bean.getReal_name();
            String telphone = bean.getTelephone();
            if (!TextUtils.isEmpty(realName) && realName.indexOf(matchString) != -1
                    || !TextUtils.isEmpty(realName) && parser.getSelling(realName).startsWith(matchString)
                    || !TextUtils.isEmpty(telphone) && telphone.startsWith(matchString)) {
                if (filterDataList == null) {
                    filterDataList = new ArrayList<>();
                }
                filterDataList.add(bean);
            }
        }
        return filterDataList;
    }

    private static List<SynBill> handlerSynBillList(List<SynBill> list, String matchString) {
        List<SynBill> filterDataList = null;
        CharacterParser parser = CharacterParser.getInstance();
        for (SynBill bean : list) {
            String realName = bean.getReal_name();
            String telphone = bean.getTelephone();
            if (!TextUtils.isEmpty(realName) && realName.indexOf(matchString) != -1
                    || !TextUtils.isEmpty(realName) && parser.getSelling(realName).startsWith(matchString)
                    || !TextUtils.isEmpty(telphone) && telphone.startsWith(matchString)) {
                if (filterDataList == null) {
                    filterDataList = new ArrayList<>();
                }
                filterDataList.add(bean);
            }
        }
        return filterDataList;
    }

    private static List<GroupDiscussionInfo> handlerGroupDiscussionList(List<GroupDiscussionInfo> list, String matchString) {
        List<GroupDiscussionInfo> filterDataList = null;
        CharacterParser parser = CharacterParser.getInstance();
        for (GroupDiscussionInfo bean : list) {
            String groupName = bean.getGroup_name();
            if (TextUtils.isEmpty(groupName)) {
                continue;
            }
            if (groupName.indexOf(matchString) != -1 || parser.getSelling(groupName).startsWith(matchString)) {
                if (filterDataList == null) {
                    filterDataList = new ArrayList<>();
                }
                filterDataList.add(bean);
            }
        }
        return filterDataList;
    }

    private static List<Repository> handlerRepositoryList(List<Repository> list, String matchString) {
        List<Repository> filterDataList = null;
        CharacterParser parser = CharacterParser.getInstance();
        for (Repository bean : list) {
            String name = bean.getFile_name();
            if (name.indexOf(matchString) != -1 || parser.getSelling(name).startsWith(matchString)) {
                if (filterDataList == null) {
                    filterDataList = new ArrayList<>();
                }
                filterDataList.add(bean);
            }
        }
        return filterDataList;
    }


    private static List<PersonBean> handlerPersonBeanList(List<PersonBean> list, String matchString) {
        List<PersonBean> filterDataList = null;
        CharacterParser parser = CharacterParser.getInstance();
        for (PersonBean bean : list) {
            String name = bean.getName();
            String telphone = bean.getTelph();
            if (name.indexOf(matchString) != -1 || parser.getSelling(name).startsWith(matchString) || !TextUtils.isEmpty(telphone) && telphone.startsWith(matchString)) {
                if (filterDataList == null) {
                    filterDataList = new ArrayList<>();
                }
                filterDataList.add(bean);
            }
        }
        return filterDataList;
    }

    private static List<Project> handlerProjectList(List<Project> list, String matchString) {
        List<Project> filterDataList = null;
        CharacterParser parser = CharacterParser.getInstance();
        for (Project bean : list) {
            String proName = bean.getPro_name();
            if (proName.indexOf(matchString) != -1 || parser.getSelling(proName).startsWith(matchString)) {
                if (filterDataList == null) {
                    filterDataList = new ArrayList<>();
                }
                filterDataList.add(bean);
            }
        }
        return filterDataList;
    }


}
