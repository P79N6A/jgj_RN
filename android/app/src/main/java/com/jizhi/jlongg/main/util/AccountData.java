package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.support.v4.content.ContextCompat;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountBean;
import com.jizhi.jlongg.main.bean.RecordItem;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Administrator on 2017/9/25 0025.
 */

public class AccountData {
    /**
     * 点工详情数据
     *
     * @return
     */
    public static List<AccountBean> getAccountDetailHour(boolean isHour) {
        List<AccountBean> listHour = new ArrayList<>();
        AccountBean item1 = new AccountBean("上班时长:", "", AccountBean.WORK_TIME);
        AccountBean item2 = new AccountBean("加班时长:", "", AccountBean.OVER_TIME);
        AccountBean item3 = new AccountBean(isHour ? "工资标准:" : "考勤模板:", "", AccountBean.SALARY);
        AccountBean item4 = new AccountBean("所在项目:", "", AccountBean.SELECTED_PROJECT);
//        RecordItem item7 = new RecordItem("", "", RecordItem.LINE);
        listHour.add(item1);
        listHour.add(item2);
        listHour.add(item3);
        listHour.add(item4);
        return listHour;
    }

    /**
     * 包工详情数据
     *
     * @return
     */
    public static List<AccountBean> getAccountDetailAll(boolean isShowtime) {
        List<AccountBean> listHour = new ArrayList<>();
        AccountBean item1 = new AccountBean("分项名称:", "", AccountBean.SUBENTRY_NAME);
        AccountBean item2 = new AccountBean("单价:", "", AccountBean.UNIT_PRICE);
        AccountBean item3 = new AccountBean("数量:", "", AccountBean.COUNT);
        AccountBean item4 = new AccountBean("所在项目:", "", AccountBean.SELECTED_PROJECT);
        listHour.add(item1);
        listHour.add(item2);
        listHour.add(item3);
        listHour.add(item4);
//        if (isShowtime) {
//            AccountBean item5 = new AccountBean("开工时间:", "", AccountBean.P_S_TIME);
//            AccountBean item6 = new AccountBean("完工时间:", "", AccountBean.P_E_TIME);
//            listHour.add(item5);
//            listHour.add(item6);
//        }


        return listHour;
    }

    /**
     * 借支,结算详情数据
     *
     * @return
     */
    public static List<AccountBean> getAccountDetailBorrow() {
        List<AccountBean> listHour = new ArrayList<>();
        AccountBean item1 = new AccountBean("所在项目:", "", RecordItem.SELECTED_PROJECT);
        listHour.add(item1);
        return listHour;
    }

    /**
     * 借支,结算详情数据
     *
     * @return
     */
    public static List<AccountBean> getAccountDetailWages(String role_type) {
        LUtils.e("-----------role_type---------:" + role_type);
        List<AccountBean> listHour = new ArrayList<>();
        AccountBean item1 = new AccountBean(role_type.equals(Constance.ROLETYPE_FM) ? "本次实付金额:" : "本次实收金额:", "", AccountBean.WAGE_INCOME_MONEY);
        AccountBean item2 = new AccountBean("补贴金额:", "", AccountBean.WAGE_SUBSIDY);
        AccountBean item3 = new AccountBean("奖励金额:", "", AccountBean.WAGE_REWARD);
        AccountBean item4 = new AccountBean("罚款金额:", "", AccountBean.WAGE_FINE);
        AccountBean item5 = new AccountBean("抹零金额:", "", AccountBean.WAGE_DEL);
        AccountBean item6 = new AccountBean("所在项目:", "", AccountBean.SELECTED_PROJECT);
        listHour.add(item1);
        listHour.add(item2);
        listHour.add(item3);
        listHour.add(item4);
        listHour.add(item5);
        listHour.add(item6);
        return listHour;
    }

    /**
     * 点工编辑数据
     *
     * @return
     */
    public static List<AccountBean> getAccountEditHour(Activity context, String roleType, boolean roleIsClick, boolean projectIsClick) {
        List<AccountBean> listHour = new ArrayList<>();
        AccountBean item1 = new AccountBean(AccountBean.SELECTED_ROLE, AccountBean.TYPE_TEXT, "", R.color.color_666666, false, roleType.equals(Constance.ROLETYPE_FM) ? "工人" : "班组长", roleType.equals(Constance.ROLETYPE_FM) ? "请选择工人" : "请添加你的班组长/工头", ContextCompat.getDrawable(context, R.drawable.icon_account_role), roleIsClick, false);
        AccountBean item2 = new AccountBean(AccountBean.SELECTED_DATE, AccountBean.TYPE_TEXT, "", R.color.color_666666, false, "日期", "", ContextCompat.getDrawable(context, R.drawable.icon_account_date), true, true);
        AccountBean item3 = new AccountBean(AccountBean.SALARY, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "工资标准", "这里设置工资\n上班时长/加班时长", ContextCompat.getDrawable(context, R.drawable.icon_account_salary), true, false);
        AccountBean item4 = new AccountBean(AccountBean.WORK_TIME, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "上班时长", "", ContextCompat.getDrawable(context, R.drawable.icon_account_work_time), true, false);
        AccountBean item5 = new AccountBean(AccountBean.OVER_TIME, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "加班时长", "", ContextCompat.getDrawable(context, R.drawable.icon_account_over_time), true, false);
        AccountBean item6 = new AccountBean(AccountBean.ALL_MONEY, AccountBean.TYPE_TEXT, "", R.color.color_eb4e4e, false, "点工工钱", "", ContextCompat.getDrawable(context, R.drawable.icon_account_price), true, true);
        AccountBean item7 = new AccountBean(AccountBean.SELECTED_PROJECT, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "所在项目", "例如:万科魅力之城", ContextCompat.getDrawable(context, R.drawable.icon_account_project), projectIsClick, false);

        listHour.add(item1);
        listHour.add(item2);
        listHour.add(item3);
        listHour.add(item4);
        listHour.add(item5);
        listHour.add(item6);
        listHour.add(item7);

        return listHour;
    }

    /**
     * 点工编辑数据
     *
     * @return
     */
    public static List<AccountBean> getAccountEdiAllCheck(Activity context, String roleType, boolean roleIsClick, boolean projectIsClick) {
        List<AccountBean> listHour = new ArrayList<>();
        AccountBean item1 = new AccountBean(AccountBean.SELECTED_ROLE, AccountBean.TYPE_TEXT, "", R.color.color_666666, false, roleType.equals(Constance.ROLETYPE_FM) ? "工人" : "班组长", roleType.equals(Constance.ROLETYPE_FM) ? "请选择工人" : "请添加你的班组长/工头", ContextCompat.getDrawable(context, R.drawable.icon_account_role), roleIsClick, false);
        AccountBean item2 = new AccountBean(AccountBean.SELECTED_DATE, AccountBean.TYPE_TEXT, "", R.color.color_666666, false, "日期", "", ContextCompat.getDrawable(context, R.drawable.icon_account_date), true, true);
        AccountBean item3 = new AccountBean(AccountBean.SALARY, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "考勤模板", "这里设置工资\n上班时长/加班时长", ContextCompat.getDrawable(context, R.drawable.icon_account_salary), true, false);
        AccountBean item4 = new AccountBean(AccountBean.WORK_TIME, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "上班时长", "", ContextCompat.getDrawable(context, R.drawable.icon_account_work_time), true, false);
        AccountBean item5 = new AccountBean(AccountBean.OVER_TIME, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "加班时长", "", ContextCompat.getDrawable(context, R.drawable.icon_account_over_time), true, false);
        AccountBean item7 = new AccountBean(AccountBean.SELECTED_PROJECT, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "所在项目", "例如:万科魅力之城", ContextCompat.getDrawable(context, R.drawable.icon_account_project), projectIsClick, false);

        listHour.add(item1);
        listHour.add(item2);
        listHour.add(item3);
        listHour.add(item4);
        listHour.add(item5);
        listHour.add(item7);

        return listHour;
    }

    /**
     * 包工编辑数据
     *
     * @return
     */
    public static List<AccountBean> getAccountEditAll(Activity context, String roleType) {
        List<AccountBean> list = new ArrayList<>();
        AccountBean item1 = new AccountBean(AccountBean.SELECTED_ROLE, AccountBean.TYPE_TEXT, "", R.color.color_666666, false, roleType.equals(Constance.ROLETYPE_FM) ? "工人" : "班组长", roleType.equals(Constance.ROLETYPE_FM) ? "请选择工人" : "请添加你的班组长/工头", ContextCompat.getDrawable(context, R.drawable.icon_account_role), true, false);
        AccountBean item2 = new AccountBean(AccountBean.SELECTED_DATE, AccountBean.TYPE_TEXT, "", R.color.color_666666, false, "日期", "", ContextCompat.getDrawable(context, R.drawable.icon_account_date), true, true);
        AccountBean item3 = new AccountBean(AccountBean.SUBENTRY_NAME, AccountBean.TYPE_EDIT, "", R.color.color_333333, false, "分项名称", "例如:包柱子/挂窗帘", ContextCompat.getDrawable(context, R.drawable.icon_account_project_name), true, false);
        AccountBean item4 = new AccountBean(AccountBean.UNIT_PRICE, AccountBean.TYPE_EDIT, "", R.color.color_333333, false, "填写单价", "这里输入单价金额", ContextCompat.getDrawable(context, R.drawable.icon_account_salary), true, false);
        AccountBean item5 = new AccountBean(AccountBean.COUNT, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "填写数量", "这里输入数量", ContextCompat.getDrawable(context, R.drawable.icon_account_count), true, true);
        AccountBean item6 = new AccountBean(AccountBean.ALL_MONEY, AccountBean.TYPE_TEXT, "", R.color.color_333333, false, "包工工钱", "", ContextCompat.getDrawable(context, R.drawable.icon_account_price), false, true);
        AccountBean item7 = new AccountBean(AccountBean.SELECTED_PROJECT, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "所在项目", "例如:万科魅力之城", ContextCompat.getDrawable(context, R.drawable.icon_account_project), true, false);
        item3.setClick(false);
        item4.setClick(false);
        list.add(item1);
        list.add(item2);
        list.add(item3);
        list.add(item4);
        list.add(item5);
        list.add(item6);
        list.add(item7);
        return list;
    }

    /**
     * 借支编辑数据
     *
     * @return
     */
    public static List<AccountBean> getAccountDetailBorrow(Activity context, String roleType) {
        List<AccountBean> list = new ArrayList<>();
        AccountBean item1 = new AccountBean(AccountBean.SELECTED_ROLE, AccountBean.TYPE_TEXT, "", R.color.color_666666, false, roleType.equals(Constance.ROLETYPE_FM) ? "工人" : "班组长", roleType.equals(Constance.ROLETYPE_FM) ? "请选择工人" : "请添加你的班组长/工头", ContextCompat.getDrawable(context, R.drawable.icon_account_role), true, false);
        AccountBean item2 = new AccountBean(AccountBean.SELECTED_DATE, AccountBean.TYPE_TEXT, "", R.color.color_666666, false, "日期", "", ContextCompat.getDrawable(context, R.drawable.icon_account_date), true, true);
        AccountBean item3 = new AccountBean(AccountBean.SUM_MONEY, AccountBean.TYPE_EDIT, "", R.color.color_83c76e, false, "填写金额", "这里输入金额", ContextCompat.getDrawable(context, R.drawable.icon_account_salary), true, false);
        AccountBean item4 = new AccountBean(AccountBean.SELECTED_PROJECT, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "所在项目", "例如:万科魅力之城", ContextCompat.getDrawable(context, R.drawable.icon_account_project), true, false);
        list.add(item1);
        list.add(item2);
        list.add(item3);
        list.add(item4);
        return list;
    }
}
