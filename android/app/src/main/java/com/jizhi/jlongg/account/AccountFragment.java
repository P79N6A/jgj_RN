package com.jizhi.jlongg.account;

import android.animation.Animator;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.app.Activity;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.AccountFrgmentsAdapter;
import com.jizhi.jlongg.main.bean.AccountBean;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.dialog.WheelViewAboutMyProject;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DecimalInputFilter;
import com.jizhi.jongg.widget.CustomListView;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * 功能:记账父fragment
 * 时间:2017/2/14 20.08
 * 作者:hcs
 */

public abstract class AccountFragment extends Fragment {

//    /**
//     * 记账对象数据
//     */
//    public List<PersonBean> personList;
    /**
     * 今天的时间
     */
    public String todayTime;
    /**
     * 记账的年月日
     */
    public int year, month, day;
    /**
     * listView
     */
    public CustomListView listView;
    /**
     * 记账列表适配器
     */
    public AccountFrgmentsAdapter adapter;
    /**
     * 与我相关项目数据
     */
    public List<Project> projectList;
    /**
     * 选择与我相关项目的id
     */
    public int pid;
    /**
     * 与我相关项目的弹出框
     */
    public WheelViewAboutMyProject addProject;



    /* 查询最后一次记账信息 */
    public abstract void LastRecordInfo();

    /**
     * 确认记工滚动动画
     */
    private AnimatorSet animatorSet;

    /**
     * 点工数据
     *
     * @return
     */
    public List<AccountBean> getHourData(String roleType, String date) {
        List<AccountBean> listHour = new ArrayList<>();
        AccountBean item1 = new AccountBean(AccountBean.SELECTED_ROLE, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, roleType.equals(Constance.ROLETYPE_FM) ? "工人" : "班组长", roleType.equals(Constance.ROLETYPE_FM) ? "请选择工人" : "请添加你的班组长/工头", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_role), true, false);
        AccountBean item2 = new AccountBean(AccountBean.SELECTED_DATE, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "日期", "", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_date), true, true);
        AccountBean item3 = new AccountBean(AccountBean.SALARY, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "工资标准", "这里设置工资", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_salary), true, false);
        AccountBean item4 = new AccountBean(AccountBean.WORK_TIME, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "上班时长", "", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_work_time), true, false);
        AccountBean item5 = new AccountBean(AccountBean.OVER_TIME, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "加班时长", "", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_over_time), true, false);
        AccountBean item6 = new AccountBean(AccountBean.ALL_MONEY, AccountBean.TYPE_TEXT, "", R.color.color_eb4e4e, false, "点工工钱", "", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_price), true, true);
        AccountBean item7 = new AccountBean(AccountBean.SELECTED_PROJECT, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "所在项目", "例如:万科魅力之城", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_project), true, false);
        AccountBean item8 = new AccountBean(AccountBean.RECORD_REMARK, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "备注", "可填写备注信息", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_marks), true, true);


        if (TextUtils.isEmpty(date)) {
            //当前时间
            item2.setRight_value(getTodayTime());
        } else {
            setData(date);
            SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
            String todayTime = df.format(new Date());
            if (date.equals(todayTime)) {
                item2.setRight_value(year + "-" + (month < 10 ? "0" + month : month + "") + "-" + (day < 10 ? "0" + day : day + "") + "(今天)");
            } else {
                item2.setRight_value(year + "-" + (month < 10 ? "0" + month : month + "") + "-" + (day < 10 ? "0" + day : day + ""));
            }

        }
        listHour.add(item1);
        listHour.add(item2);
        listHour.add(item3);
        listHour.add(item4);
        listHour.add(item5);
        listHour.add(item6);
        listHour.add(item7);
        listHour.add(item8);

        return listHour;
    }

    /**
     * 包工数据
     *
     * @return
     */
    protected List<AccountBean> getAllData(String roleType, String date) {
        List<AccountBean> list = new ArrayList<>();
        AccountBean item1 = new AccountBean(AccountBean.SELECTED_ROLE, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, roleType.equals(Constance.ROLETYPE_FM) ? "工人" : "班组长", roleType.equals(Constance.ROLETYPE_FM) ? "请选择要记账的工人" : "请选择要记账的班组长/工头", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_role), true, false);
        AccountBean item2 = new AccountBean(AccountBean.SELECTED_DATE, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "日期", "", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_date), true, true);
        AccountBean item3 = new AccountBean(AccountBean.SUBENTRY_NAME, AccountBean.TYPE_EDIT, "", R.color.color_333333, false, "分项名称", "例如:包柱子/挂窗帘", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_project_name), true, false);
        AccountBean item4 = new AccountBean(AccountBean.UNIT_PRICE, AccountBean.TYPE_EDIT, "", R.color.color_eb4e4e, false, "填写单价", "这里输入单价金额", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_salary), true, false);
        AccountBean item5 = new AccountBean(AccountBean.COUNT, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "填写数量", "这里输入数量", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_count), true, false);
        AccountBean item6 = new AccountBean(AccountBean.ALL_MONEY, AccountBean.TYPE_TEXT, "", R.color.color_eb4e4e, false, "包工工钱", "", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_price), false, true);
        AccountBean item7 = new AccountBean(AccountBean.SELECTED_PROJECT, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "所在项目", "例如:万科魅力之城", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_project), true, false);
        AccountBean item8 = new AccountBean(AccountBean.RECORD_REMARK, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "备注", "可填写备注信息", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_marks), true, true);
        if (TextUtils.isEmpty(date)) {
            //当前时间
            item2.setRight_value(getTodayTime());
        } else {
            setData(date);
            SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
            String todayTime = df.format(new Date());
            if (date.equals(todayTime)) {
                item2.setRight_value(year + "-" + (month < 10 ? "0" + month : month + "") + "-" + (day < 10 ? "0" + day : day + "") + "(今天)");
            } else {
                item2.setRight_value(year + "-" + (month < 10 ? "0" + month : month + "") + "-" + (day < 10 ? "0" + day : day + ""));
            }
        }
        item2.setIcon_drawable(getResources().getDrawable(R.drawable.icon_account_date));
        item3.setClick(false);
        item4.setClick(false);
        list.add(item1);
        list.add(item2);
        list.add(item3);
        list.add(item4);
        list.add(item5);
        list.add(item6);
        list.add(item7);
        list.add(item8);
        return list;
    }

    /**
     * 借支数据
     *
     * @return
     */
    protected List<AccountBean> getBorrowData(String roleType, String date) {
        List<AccountBean> list = new ArrayList<>();
        AccountBean item1 = new AccountBean(AccountBean.SELECTED_ROLE, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, roleType.equals(Constance.ROLETYPE_FM) ? "工人" : "班组长", roleType.equals(Constance.ROLETYPE_FM) ? "请选择工人" : "请添加你的班组长/工头", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_role), true, false);
        AccountBean item2 = new AccountBean(AccountBean.SELECTED_DATE, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "日期", "", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_date), true, true);
        AccountBean item3 = new AccountBean(AccountBean.SUM_MONEY, AccountBean.TYPE_EDIT, "", R.color.color_83c76e, false, "填写金额", "这里输入金额", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_salary), true, true);
        AccountBean item4 = new AccountBean(AccountBean.SELECTED_PROJECT, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "所在项目", "例如:万科魅力之城", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_project), true, false);
        AccountBean item5 = new AccountBean(AccountBean.RECORD_REMARK, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "备注", "可填写备注信息", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_marks), true, true);
        if (TextUtils.isEmpty(date)) {
            //当前时间
            item2.setRight_value(getTodayTime());
        } else {
            setData(date);
            SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
            String todayTime = df.format(new Date());
            if (date.equals(todayTime)) {
                item2.setRight_value(year + "-" + (month < 10 ? "0" + month : month + "") + "-" + (day < 10 ? "0" + day : day + "") + "(今天)");
            } else  {
                item2.setRight_value(year + "-" + (month < 10 ? "0" + month : month + "") + "-" + (day < 10 ? "0" + day : day + ""));
            }
        }
        list.add(item1);
        list.add(item2);
        list.add(item3);
        list.add(item4);
        list.add(item5);
        return list;
    }

    /**
     * 借支数据
     *
     * @return
     */
    protected List<AccountBean> geWagesData(String roleType, String date, boolean is_show_unset) {
//        public static final String WAGE_UNSET = "wage_unset"; //未结工资
//        public static final String WAGE_S_R_F = "wage_s_r_f"; //补贴，奖励，罚款金额
//        public static final String WAGE_SUBSIDY = "wage_subsidy"; //补贴金额
//        public static final String WAGE_REWARD = "wage_reward"; //奖励金额
//        public static final String WAGE_FINE = "wage_fine"; //罚款金额
//        public static final String WAGE_INCOME_MONEY = "wage_income_money"; //本次实收收金额
//        public static final String WAGE_DEL = "wage_del"; //抹零金额
//        public static final String WAGE_WAGES = "wage_wages"; //本次结算金额
//        public static final String WAGE_SURPLUS_UNSET = "wage_supplus_unset"; //剩余未结金额
        List<AccountBean> list = new ArrayList<>();
        AccountBean item1 = new AccountBean(AccountBean.SELECTED_ROLE, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, roleType.equals(Constance.ROLETYPE_FM) ? "工人" : "班组长", roleType.equals(Constance.ROLETYPE_FM) ? "请选择要记账的工人" : "请选择要记账的班组长/工头", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_role), true, false);
        AccountBean item2 = new AccountBean(AccountBean.SELECTED_DATE, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "日期", "", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_date), true, true);
        list.add(item1);
        list.add(item2);
        if (is_show_unset) {
            AccountBean item3 = new AccountBean(AccountBean.WAGE_UNSET, AccountBean.TYPE_TEXT, "", R.color.color_999999, false, "未结工资", "", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_salary), true, true);
            list.add(item3);
        }
        AccountBean item4 = new AccountBean(AccountBean.WAGE_S_R_F, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "补贴、奖励、罚款’", "0.00", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_wages_s_r_f), true, false);
        AccountBean item5 = new AccountBean(AccountBean.WAGE_INCOME_MONEY, AccountBean.TYPE_EDIT, "", R.color.color_eb4e4e, false, roleType.equals(Constance.ROLETYPE_FM) ? "本次实付金额" : "本次实收金额", "0.00", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_wages_income), true, false);
        AccountBean item6 = new AccountBean(AccountBean.WAGE_DEL, AccountBean.TYPE_EDIT, "", R.color.color_333333, false, "抹零金额", "请输入金额(可不填)", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_wages_del), true, false);
        AccountBean item7 = new AccountBean(AccountBean.WAGE_WAGES, AccountBean.TYPE_TEXT, "", R.color.color_eb4e4e, false, "本次结算金额", "0.00", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_wages_wage), true, true);
        AccountBean item8 = new AccountBean(AccountBean.WAGE_SURPLUS_UNSET, AccountBean.TYPE_TEXT, "", R.color.color_333333, false, "剩余未结金额", "0.00", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_price), true, true);
        AccountBean item9 = new AccountBean(AccountBean.SELECTED_PROJECT, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "所在项目", "例如:万科魅力之城", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_project), true, false);
        AccountBean item10 = new AccountBean(AccountBean.RECORD_REMARK, AccountBean.TYPE_TEXT, "", R.color.color_333333, true, "备注", "可填写备注信息", ContextCompat.getDrawable(getContext(), R.drawable.icon_account_marks), true, true);
        if (TextUtils.isEmpty(date)) {
            //当前时间
            item2.setRight_value(getTodayTime());
        } else {
            setData(date);
            SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
            String todayTime = df.format(new Date());
            if (date.equals(todayTime)) {
                item2.setRight_value(year + "-" + (month < 10 ? "0" + month : month + "") + "-" + (day < 10 ? "0" + day : day + "") + "(今天)");
            } else {
                item2.setRight_value(year + "-" + (month < 10 ? "0" + month : month + "") + "-" + (day < 10 ? "0" + day : day + ""));
            }
        }

        list.add(item4);
        list.add(item5);
        list.add(item6);
        list.add(item7);
        list.add(item8);
        list.add(item9);
        list.add(item10);
        return list;
    }

    //设置当前日期（由前一个界面传过来的）
    public void setData(String dataintent) {//dataintent:20150106
        year = Integer.valueOf(dataintent.substring(0, 4));
        month = Integer.valueOf(dataintent.substring(4, 6));
        day = Integer.valueOf(dataintent.substring(6, 8));

    }

    protected int getPosion(List<AccountBean> itemData, String item_type) {
        for (int i = 0; i < itemData.size(); i++) {
            if (TextUtils.equals(item_type, itemData.get(i).getItem_type())) {
                return i;
            }
        }
        return 0;

    }

    /**
     * 获取今天时间
     * 格式yyyy-mm-dd (今天)
     *
     * @return
     */
    public String getTodayTime() {
        //今天时间
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        todayTime = df.format(new Date()) + " (今天)";
        Calendar c = Calendar.getInstance();
        //  年月日
        year = c.get(Calendar.YEAR);
        month = c.get(Calendar.MONTH) + 1;
        day = c.get(Calendar.DATE);
        return todayTime;
    }

    /**
     * 获取今天时间
     * 格式yyyy-mm-dd (今天)
     *
     * @return
     */
    public String getTodayDate() {
        //今天时间
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String todayTime = df.format(new Date());
        return todayTime;
    }

    protected PopupWindow accountPopupView;

    /**
     * 显示记账提示popwindow
     *
     * @param activity
     * @param view
     * @param type     类型 1.未结工资 2.本次结算金额 3.剩余未结金额
     */
    public void showAccountPopWin(Activity activity, View view, int type, String roleType) {
        if (null != accountPopupView) {
            accountPopupView.dismiss();
        }
        View popView = activity.getLayoutInflater().inflate(R.layout.layout_pop_wage, null);
        RelativeLayout rea_pop_layout = (RelativeLayout) popView.findViewById(R.id.rea_pop_layout);
        rea_pop_layout.setAlpha(0.9f);
        accountPopupView = new PopupWindow(popView, RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        // 设置动画
//         window.setAnimationStyle(R.style.popup_window_anim);
        //  设置背景颜色
        accountPopupView.setBackgroundDrawable(new ColorDrawable(Color.parseColor("#00000000")));
        // 设置可以获取焦点
        accountPopupView.setFocusable(true);
        //  设置可以触摸弹出框以外的区域
        accountPopupView.setOutsideTouchable(true);
        // 更新popupwindow的状态
        accountPopupView.update();


        //  以下拉的方式显示，并且可以设置显示的位置
//        accountPopupView.showAsDropDown(view, 0, 20);

        TextView tv_pop_content = (TextView) popView.findViewById(R.id.tv_pop_content);
        popView.findViewById(R.id.tv_pop_dismiss).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != accountPopupView) {
                    accountPopupView.dismiss();
                }
            }
        });
        switch (type) {
            case 1:
                tv_pop_content.setText("未结工资 = 点工工资 + 包工工资 - 借支金额 - 已结金额");
                break;
            case 2:
                if (roleType.equals(Constance.ROLETYPE_FM)) {
                    tv_pop_content.setText("本次结算金额 = 本次实付金额 + 抹零金额 + 罚款金额 - 补贴金额 - 奖励金额");
                } else {
                    tv_pop_content.setText("本次结算金额 = 本次实收金额 + 抹零金额 + 罚款金额 - 补贴金额 - 奖励金额");
                }

                break;
            case 3:
                if (roleType.equals(Constance.ROLETYPE_FM)) {
                    tv_pop_content.setText("剩余未结金额 = 未结工资 + 补贴金额 + 奖励金额 - 罚款金额 - 本次实付金额 - 抹零金额");
                } else {
                    tv_pop_content.setText("剩余未结金额 = 未结工资 + 补贴金额 + 奖励金额 - 罚款金额 - 本次实收金额 - 抹零金额");
                }
                break;
        }

        //在控件上方显示
        int[] location = new int[2];
        view.getLocationOnScreen(location);
        //获取自身的长宽高
        popView.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
        int popupHeight = popView.getMeasuredHeight();
        int popupWidth = popView.getMeasuredWidth();
//        accountPopupView.showAtLocation(view, Gravity.NO_GRAVITY, (location[0]) + popupWidth / 3, location[1] - popupHeight);
        accountPopupView.showAtLocation(view, Gravity.NO_GRAVITY, (location[0] - DensityUtils.dp2px(activity, 27)), location[1] - popupHeight);

        LUtils.e(location[0] + ",,," + location[1] + "---------" + popupWidth + "--------" + DensityUtils.dp2px(activity, 31));
        LUtils.e(((location[0]) + popupWidth / 2) + ",,," + (location[1] - popupHeight));
    }

    /**
     * 设置edittext小数位数
     *
     * @param editText
     * @param length        小数点前面位数
     * @param decimal_place 小数点后面位数
     */
    public void setEditTextDecimalNumberLength(EditText editText, int length, int decimal_place) {
        if (0 != decimal_place) {
            editText.setFilters(new InputFilter[]{new DecimalInputFilter(length, decimal_place)});
            editText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        } else {
            editText.setInputType(InputType.TYPE_CLASS_NUMBER);
        }

    }

    /**
     * 停止待确认动画
     */
    protected void stopWaitConfirmAnim() {
        if (animatorSet != null && animatorSet.isRunning()) {
            animatorSet.cancel();
        }
    }

    /**
     * 开启待确认动画
     */
    protected void startWaitConfirmAnim() {
        ImageView confirmIcon = (ImageView) getView().findViewById(R.id.confirmIcon);
        if (animatorSet != null) {
            if (!animatorSet.isRunning()) {
                LUtils.e("开启动画");
                animatorSet.start();
            }
            return;
        }
        int moveDistance = DensityUtils.dp2px(getActivity(), 8); //移动距离
        ObjectAnimator animator1 = ObjectAnimator.ofFloat(confirmIcon, "translationX", 0, -moveDistance);
        ObjectAnimator animator2 = ObjectAnimator.ofFloat(confirmIcon, "alpha", 1.0F, 0.1F);

        animator1.setRepeatCount(Integer.MAX_VALUE);
        animator2.setRepeatCount(Integer.MAX_VALUE);
        animator1.setRepeatMode(android.animation.ObjectAnimator.REVERSE);
        animator2.setRepeatMode(android.animation.ObjectAnimator.REVERSE);

        animatorSet = new AnimatorSet();
        animatorSet.playTogether(animator1);
        animatorSet.playTogether(animator2);
        animatorSet.setDuration(800);
        animatorSet.start();


        animator1.addListener(new Animator.AnimatorListener() {
            @Override
            public void onAnimationStart(Animator animator) {
            }

            @Override
            public void onAnimationEnd(Animator animator) {

            }

            @Override
            public void onAnimationCancel(Animator animator) {
                LUtils.e("停止动画:");
            }

            @Override
            public void onAnimationRepeat(Animator animator) {

            }
        });

    }
//
//    /**
//     * 获取当天是否记过工
//     *
//     * @param uid
//     */
//    public void getUnPaySalaryList(String uid) {
//        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
//        if (!TextUtils.isEmpty(uid)) {
//            params.addBodyParameter("uid", uid);
//        } else {
//            params.addBodyParameter("uid", this.uid + "");
//        }
//        params.addBodyParameter("accounts_type", AccountUtil.BORROWING);
//        String submitDate = year + (month < 10 ? "0" + month : month + "") + (day < 10 ? "0" + day : day + "");
//        params.addBodyParameter("date", submitDate);
//        HttpUtils http = SingsHttpUtils.getHttp();
//        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_UNBALANCEANDSALARYTPL, params, new RequestCallBack() {
//
//            @Override
//            public void onFailure(HttpException e, String s) {
//
//            }
//
//            @Override
//            public void onSuccess(ResponseInfo responseInfo) {
//                try {
//                    CommonJson<PersonBean> bean = CommonJson.fromJson(responseInfo.result.toString(), PersonBean.class);
//                    if (bean.getState() != 0) {
//                        // 对方已记账描述
//                        itemData.get(getPosion(itemData, RecordItem.SELECTED_DATE)).setBill_desc(bean.getValues().getBill_desc());
//                        adapter.notifyDataSetChanged();
//                    }
//                } catch (Exception e) {
//                    e.printStackTrace();
//                    CommonMethod.makeNoticeShort(getActivity(), getString(R.string.service_err), CommonMethod.ERROR);
//                }
//            }
//        });
//    }
}
