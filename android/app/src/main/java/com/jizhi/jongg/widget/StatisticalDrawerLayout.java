package com.jizhi.jongg.widget;


import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.View;
import android.view.animation.AnimationUtils;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DatePickerUtil;
import com.hcs.uclient.utils.LunarCalendar;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.RemberWokerInfoPeopleAdapter;
import com.jizhi.jlongg.main.adpter.RemberWorkerInfoTargerNameAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.RemberInfoTargetNameBean;
import com.jizhi.jlongg.main.popwindow.RecordAccountDateNotWeekPopWindow;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.Calendar;
import java.util.List;


/**
 * 功能:记工统计抽屉
 * 时间:2018年9月25日16:36:53
 * 作者:xuj
 */

public class StatisticalDrawerLayout extends RelativeLayout implements View.OnClickListener, CompoundButton.OnCheckedChangeListener {

    /**
     * 默认开始时间，默认结束时间
     */
    private String defalutStartTime, defalutEndTime;
    /**
     * 查看全部记账成员标识
     */
    private final String PERSON = "person";
    /**
     * 查看全部项目标识
     */
    private final String PROJECT = "project";
    /**
     * 当前选择的下标
     */
    private String CURRENT_SELECTE;
    /**
     * 外层的Activity 主要是做弹出框使用
     */
    private Activity activity;
    /**
     * 选择项目，工人、工头按钮
     */
    private TextView rb_project, rb_people;
    /**
     * 项目项目，工人、工头数据
     */
    private List<RemberInfoTargetNameBean> projectList, personList;
    /**
     * 筛选的人id,以及筛选的项目id
     */
    private String uid, pid;
    /**
     * 工人、工头勾选全部
     */
    private ImageView img_gou;
    /**
     * 项目组id
     */
    private String group_id;
    /**
     * 点工、包工记账、借支、结算、包工记工天
     */
    private CheckBox ck_hour, ck_all_account, ck_borrow, ck_wage, ck_all_kq;
    /**
     * listView
     */
    private ListView list_all_pro;
    /**
     * 开始日期 的时间戳   当还要选择结束时间做时间判断   结束时间不能小于开始时间
     */
    private long startTimeStamp, endTimeStamp;
    /**
     * 开始日期,结束日期
     */
    private TextView rb_start_time, rb_end_time;
    /**
     * 开始时间的农历,结束时间的农历
     */
    private String start_time_string, end_time_string, start_time_luncher, end_time_luncher;
    /**
     * 筛选后的ListView 布局
     */
    private View rea_listView_filter;
    /**
     * 筛选后的标题
     */
    private TextView filter_title;
    /**
     * 选择记账按钮提示的文字信息
     */
    private TextView tv_account;
    /**
     *
     */
    private TextView tv_name;
    /**
     * 回调参数
     */
    private FilterSelectInterFace filterSelectInterFace;

    /**
     * true表示可以点击成员
     * trur表示可以点击项目
     */
    private boolean canClickPerson = true, canClickPro = true;


    public StatisticalDrawerLayout(Context context) {
        super(context);
        inflateView();
    }

    public StatisticalDrawerLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        inflateView();
    }

    private void inflateView() {
        View.inflate(getContext(), R.layout.statistical_drawer_layout, this);
        rb_project = findViewById(R.id.rb_project);
        rb_people = findViewById(R.id.rb_people);
        list_all_pro = (ListView) findViewById(R.id.list_all_pro);

        rb_start_time = findViewById(R.id.rb_start_time);
        rb_end_time = findViewById(R.id.rb_end_time);
        rea_listView_filter = findViewById(R.id.rea_filter_rootView);
        filter_title = findViewById(R.id.tv_title_three);
        tv_account = findViewById(R.id.tv_account);


        findViewById(R.id.img_back).setOnClickListener(this);
        findViewById(R.id.img_back_top).setOnClickListener(this);
        findViewById(R.id.btn_reset).setOnClickListener(this);
        findViewById(R.id.btn_save).setOnClickListener(this);
        findViewById(R.id.rea_project).setOnClickListener(this);
        findViewById(R.id.rea_people).setOnClickListener(this);
        findViewById(R.id.lin_start_time).setOnClickListener(this);
        findViewById(R.id.lin_end_time).setOnClickListener(this);


        ck_hour = ((CheckBox) findViewById(R.id.ck_hour));
        ck_all_account = ((CheckBox) findViewById(R.id.ck_all_account));
        ck_borrow = ((CheckBox) findViewById(R.id.ck_borrow));
        ck_wage = ((CheckBox) findViewById(R.id.ck_wage));
        ck_all_kq = ((CheckBox) findViewById(R.id.ck_all_kq));
        ck_hour.setOnCheckedChangeListener(this);
        ck_all_account.setOnCheckedChangeListener(this);
        ck_borrow.setOnCheckedChangeListener(this);
        ck_wage.setOnCheckedChangeListener(this);
        ck_all_kq.setOnCheckedChangeListener(this);
        //设置筛选人默认数据
        View selecteAllView = inflate(getContext(), R.layout.item_rember_info_target_name, null);
        tv_name = selecteAllView.findViewById(R.id.tv_name);
        img_gou = (ImageView) selecteAllView.findViewById(R.id.img_gou);
        img_gou.setVisibility(View.VISIBLE);
        final String roler = UclientApplication.getRoler(getContext());
        if (roler.equals(Constance.ROLETYPE_FM)) {
            ((TextView) findViewById(R.id.tv_select_tole)).setText("选择工人");
            rb_people.setText("全部工人");
        } else {
            ((TextView) findViewById(R.id.tv_select_tole)).setText("选班组长");
            rb_people.setText("全部班组长");
        }
        list_all_pro.addHeaderView(selecteAllView);
        selecteAllView.setOnClickListener(new OnClickListener() { //全部项目、全部成员 View
            @Override
            public void onClick(View v) {
                switch (CURRENT_SELECTE) {
                    case PERSON:
                        uid = null;
                        rb_people.setText(roler.equals(Constance.ROLETYPE_FM) ? "全部工人" : "全部班组长");
                        for (RemberInfoTargetNameBean person : personList) {
                            person.setSelect(false);
                        }
                        break;
                    case PROJECT:
                        pid = null;
                        rb_project.setText("全部项目");
                        for (RemberInfoTargetNameBean project : projectList) {
                            project.setSelect(false);
                        }
                        break;
                }
                closeFileterAnim();
            }
        });
    }

    /**
     * 开启查看项目或选择工人、班组长动画
     *
     * @param title
     */
    public void startFileterAnim(String title) {
        filter_title.setText(title);
        rea_listView_filter.setVisibility(View.VISIBLE);
        rea_listView_filter.startAnimation(AnimationUtils.loadAnimation(getContext(), R.anim.page_anima_right_in));
        //这里为了不出现数据刷新的延迟我们在这里每次都先清空一下列表数据
        list_all_pro.setAdapter(null);
    }

    /**
     * 关闭查看项目或选择工人、班组长动画
     */
    public void closeFileterAnim() {
        rea_listView_filter.startAnimation(AnimationUtils.loadAnimation(getContext(), R.anim.page_anima_right_out));
        rea_listView_filter.setVisibility(View.GONE);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.lin_start_time://开始时间
                showStartTime();
                break;
            case R.id.lin_end_time://结束时间
                showEndTime();
                break;
            case R.id.rea_project://选择项目
                if (!canClickPro) {
                    return;
                }
                img_gou.setVisibility(TextUtils.isEmpty(pid) ? View.VISIBLE : View.GONE);
                tv_name.setText("全部项目");
                startFileterAnim("全部项目");
                showProjectDate();
                break;
            case R.id.rea_people://选择工人，班组长
                if (!canClickPerson) {
                    return;
                }
                String name = UclientApplication.getRoler(getContext()).equals(Constance.ROLETYPE_FM) ? "全部工人" : "全部班组长";
                img_gou.setVisibility(TextUtils.isEmpty(uid) ? View.VISIBLE : View.GONE);
                tv_name.setText(name);
                startFileterAnim(name);
                showPeopleDate();
                break;
            case R.id.img_back://返回按钮
                closeFileterAnim();
                break;
            case R.id.img_back_top://关闭抽屉按钮
                filterSelectInterFace.FilterClose();
                break;
            case R.id.btn_reset://重置按钮
                ck_hour.setChecked(false);
                ck_all_account.setChecked(false);
                ck_borrow.setChecked(false);
                ck_wage.setChecked(false);
                ck_all_kq.setChecked(false);
                rb_people.setText(UclientApplication.getRoler(getContext()).equals(Constance.ROLETYPE_FM) ? "全部工人" : "全部班组长");
                rb_project.setText("全部项目");

                setDefaultEndTime();
                setDefaultStartTime();

                uid = null;
                pid = null;
                break;
            case R.id.btn_save://确定按钮
                filterSelectInterFace.FilterConfirm(start_time_string, end_time_string, start_time_luncher, end_time_luncher);
                break;
        }
    }


    /**
     * 获取筛选记账类型
     *
     * @return
     */
    public String getAccount_type() {
        StringBuffer sb = new StringBuffer();
        if (ck_hour.isChecked()) {
            sb.append(AccountUtil.HOUR_WORKER + ",");
        }
        if (ck_all_account.isChecked()) {
            sb.append(AccountUtil.CONSTRACTOR + ",");
        }
        if (ck_borrow.isChecked()) {
            sb.append(AccountUtil.BORROWING + ",");
        }
        if (ck_wage.isChecked()) {
            sb.append(AccountUtil.SALARY_BALANCE + ",");
        }
        if (ck_all_kq.isChecked()) {
            sb.append(AccountUtil.CONSTRACTOR_CHECK + ",");
        }
        if (!TextUtils.isEmpty(sb.toString())) {
            return sb.toString().substring(0, sb.toString().length() - 1);
        }
        return sb.toString();
    }

    /**
     * 获取所有项目名称、记账对象
     *
     * @param classType
     * @param isShowData
     */
    public void getNameOrProjectList(final String classType, final boolean isShowData) {
        String httpUrl = NetWorkRequest.GET_TARGETNAMELIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getContext());
        params.addBodyParameter("class_type", classType);
        if (!TextUtils.isEmpty(group_id)) {
            params.addBodyParameter("group_id", group_id);
        }
        CommonHttpRequest.commonRequest(activity, httpUrl, RemberInfoTargetNameBean.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                List<RemberInfoTargetNameBean> listBean = (List<RemberInfoTargetNameBean>) object;
                switch (classType) {
                    case PERSON://显示记账对象成员
                        personList = listBean;
                        if (isShowData) {
                            setPeopleData();
                        }
                        break;
                    case PROJECT: //显示全部项目
                        projectList = listBean;
                        int count = 0;
                        if (listBean != null && listBean.size() > 0) {
                            for (RemberInfoTargetNameBean remberInfoTargetNameBean : listBean) {
                                //因为我们本地添加了全部项目我们在这里排除一下
                                if ("0".equals(remberInfoTargetNameBean.getClass_type_id())) {
                                    listBean.remove(count);
                                    break;
                                }
                                count++;
                            }
                        }
                        if (isShowData) {
                            setProjectData();
                        }
                        break;
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    public void showPeopleDate() {
        CURRENT_SELECTE = PERSON;
        if (null == personList || personList.size() == 0) {
            getNameOrProjectList(PERSON, true);
            return;
        }
        setPeopleData();
    }

    public void showProjectDate() {
        CURRENT_SELECTE = PROJECT;
        if (null == projectList || projectList.size() == 0) {
            getNameOrProjectList(PROJECT, true);
            return;
        }
        setProjectData();
    }

    /**
     * 显示班组长数据
     */
    public void setPeopleData() {
        if (!TextUtils.isEmpty(uid)) {
            if (personList != null && personList.size() > 0) {
                for (RemberInfoTargetNameBean remberInfoTargetNameBean : personList) {
                    if (uid.equals(remberInfoTargetNameBean.getClass_type_id())) {
                        remberInfoTargetNameBean.setSelect(true);
                    }
                }
            }
        } else {
            for (RemberInfoTargetNameBean remberInfoTargetNameBean : personList) {
                if (remberInfoTargetNameBean.isSelect()) {
                    remberInfoTargetNameBean.setSelect(false);
                }
            }
        }

        Utils.setPinYinAndSortRember(personList);
        RemberWokerInfoPeopleAdapter remberWokerInfoPeopleAdapter = new RemberWokerInfoPeopleAdapter(activity, personList, new RemberWokerInfoPeopleAdapter.ItemClickListener() {
            @Override
            public void itemClick(int posotion) {
                List<RemberInfoTargetNameBean> personList = StatisticalDrawerLayout.this.personList;
                for (RemberInfoTargetNameBean remberInfoTargetNameBean : personList) {
                    if (remberInfoTargetNameBean.isSelect()) {
                        remberInfoTargetNameBean.setSelect(false);
                    }
                }
                RemberInfoTargetNameBean person = personList.get(posotion);
                person.setSelect(true);
                uid = personList.get(posotion).getClass_type_id();
                rb_people.setText(personList.get(posotion).getName());
                closeFileterAnim();
            }
        });
        list_all_pro.setAdapter(remberWokerInfoPeopleAdapter);
    }

    /**
     * 显示项目数据
     */
    public void setProjectData() {
        if (!TextUtils.isEmpty(pid)) {
            if (projectList != null && projectList.size() > 0) {
                for (RemberInfoTargetNameBean remberInfoTargetNameBean : projectList) {
                    if (pid.equals(remberInfoTargetNameBean.getClass_type_id())) {
                        remberInfoTargetNameBean.setSelect(true);
                    }
                }
            }
        } else {
            for (RemberInfoTargetNameBean remberInfoTargetNameBean : projectList) {
                if (remberInfoTargetNameBean.isSelect()) {
                    remberInfoTargetNameBean.setSelect(false);
                }
            }
        }
        Utils.setPinYinAndSortRember(projectList);
        RemberWorkerInfoTargerNameAdapter remberWorkerInfoTargerNameAdapter = new RemberWorkerInfoTargerNameAdapter(activity, projectList, new RemberWorkerInfoTargerNameAdapter.ItemClickListener() {
            @Override
            public void itemClick(int posotion) {
                List<RemberInfoTargetNameBean> projectList = StatisticalDrawerLayout.this.projectList;
                for (RemberInfoTargetNameBean remberInfoTargetNameBean : projectList) {
                    if (remberInfoTargetNameBean.isSelect()) {
                        remberInfoTargetNameBean.setSelect(false);
                    }
                }
                RemberInfoTargetNameBean project = projectList.get(posotion);
                project.setSelect(true);
                pid = project.getClass_type_id();
                rb_project.setText(NameUtil.setRemark(project.getName(), 10));
                closeFileterAnim();
            }
        });
        list_all_pro.setAdapter(remberWorkerInfoTargerNameAdapter);
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        switch (buttonView.getId()) {
            case R.id.ck_hour: //点工
                setBck(isChecked, R.id.rea_hour, ck_hour);
                setSelectAccountType(isChecked);
                break;
            case R.id.ck_all_account: //包工记账
                setBck(isChecked, R.id.rea_all_account, ck_all_account);
                setSelectAccountType(isChecked);
                break;
            case R.id.ck_borrow: //借支
                setBck(isChecked, R.id.rea_borrow, ck_borrow);
                setSelectAccountType(isChecked);
                break;
            case R.id.ck_wage: //结算
                setBck(isChecked, R.id.rea_wage, ck_wage);
                setSelectAccountType(isChecked);
                break;
            case R.id.ck_all_kq://包工记工天
                setBck(isChecked, R.id.rea_all_kq, ck_all_kq);
                setSelectAccountType(isChecked);
                break;
        }
    }


    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }


    /**
     * 显示开始时间
     */
    private void showStartTime() {
        RecordAccountDateNotWeekPopWindow datePickerPopWindow = new RecordAccountDateNotWeekPopWindow(activity, getContext().getString(R.string.choosetime), 2,
                new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                    @Override
                    public void selectedDays() { //选择多天
                    }

                    @Override
                    public void selectedDate(String year, String monthOfYear, String dayOfMonth, String week) {
                        Calendar calendar = Calendar.getInstance();
                        if (endTimeStamp != 0) { //已选择了结束时间 需要判断开始时间不能大于结束时间
                            calendar.set(Calendar.YEAR, Integer.parseInt(year)); //设置年
                            calendar.set(Calendar.MONTH, Integer.parseInt(monthOfYear) - 1); //设置月
                            calendar.set(Calendar.DAY_OF_MONTH, Integer.parseInt(dayOfMonth)); //设置日
                            calendar.set(Calendar.HOUR_OF_DAY, 0); //设置小时
                            calendar.set(Calendar.MINUTE, 0);  //设置分钟
                            calendar.set(Calendar.SECOND, 0); //设置秒
                            calendar.set(Calendar.MILLISECOND, 0); //设置毫秒
                            if (calendar.getTimeInMillis() > endTimeStamp) {
                                CommonMethod.makeNoticeShort(getContext(), "开始日期不能大于结束日期", CommonMethod.ERROR);
                                return;
                            }
                        }
                        String month = Integer.parseInt(monthOfYear) < 10 ? "0" + Integer.parseInt(monthOfYear) : Integer.parseInt(monthOfYear) + "";
                        String day = Integer.parseInt(dayOfMonth) < 10 ? "0" + dayOfMonth : dayOfMonth + "";
                        String luncherDate = getLunarDate(Integer.parseInt(year), Integer.parseInt(monthOfYear), Integer.parseInt(dayOfMonth));

                        rb_start_time.setText(year + "-" + month + "-" + day + luncherDate);
                        start_time_string = year + "-" + month + "-" + day;
                        start_time_luncher = luncherDate;
                        startTimeStamp = calendar.getTimeInMillis();
                    }
                });
        datePickerPopWindow.setClearListener(new RecordAccountDateNotWeekPopWindow.ClearListener() { //重置开始时间
            @Override
            public void clear() {
                setDefaultEndTime();
                setDefaultStartTime();
            }
        });
        datePickerPopWindow.hideCancelBtnShowClearBtn(" 重置");
        datePickerPopWindow.showAtLocation(activity.getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        datePickerPopWindow.hideSelecteDaysView();
        BackGroundUtil.backgroundAlpha(activity, 0.5F);
    }

    /**
     * 显示结束时间
     */
    private void showEndTime() {
        RecordAccountDateNotWeekPopWindow datePickerPopWindow = new RecordAccountDateNotWeekPopWindow(activity, getContext().getString(R.string.choosetime), 2,
                new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                    @Override
                    public void selectedDays() { //选择多天
                    }

                    @Override
                    public void selectedDate(String year, String monthOfYear, String dayOfMonth, String week) {
                        Calendar calendar = Calendar.getInstance();
                        if (startTimeStamp != 0) { //已选择了开始时间,结束时间不能小于开始时间
                            calendar.set(Calendar.YEAR, Integer.parseInt(year));
                            calendar.set(Calendar.MONTH, Integer.parseInt(monthOfYear) - 1);
                            calendar.set(Calendar.DAY_OF_MONTH, Integer.parseInt(dayOfMonth) + 1);
                            calendar.set(Calendar.HOUR_OF_DAY, 0); //设置小时
                            calendar.set(Calendar.MINUTE, 0);  //设置分钟
                            calendar.set(Calendar.SECOND, 0); //设置秒
                            calendar.set(Calendar.MILLISECOND, 0); //设置毫秒
                            if (calendar.getTimeInMillis() < startTimeStamp) {
                                CommonMethod.makeNoticeShort(getContext(), "开始日期不能大于结束日期", CommonMethod.ERROR);
                                return;
                            }
                        }
                        String month = Integer.parseInt(monthOfYear) < 10 ? "0" + Integer.parseInt(monthOfYear) : Integer.parseInt(monthOfYear) + "";
                        String day = Integer.parseInt(dayOfMonth) < 10 ? "0" + dayOfMonth : dayOfMonth + "";
                        String luncherDate = getLunarDate(Integer.parseInt(year), Integer.parseInt(monthOfYear), Integer.parseInt(dayOfMonth));
                        rb_end_time.setText(year + "-" + month + "-" + day + luncherDate);
                        end_time_string = year + "-" + month + "-" + day;
                        end_time_luncher = luncherDate;
                        endTimeStamp = calendar.getTimeInMillis();
                    }
                });
        datePickerPopWindow.setClearListener(new RecordAccountDateNotWeekPopWindow.ClearListener() { //重置结束时间
            @Override
            public void clear() {
                setDefaultEndTime();
                setDefaultStartTime();
            }
        });
        datePickerPopWindow.hideCancelBtnShowClearBtn("重置");
        datePickerPopWindow.showAtLocation(activity.getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        datePickerPopWindow.hideSelecteDaysView();
        BackGroundUtil.backgroundAlpha(activity, 0.5F);
    }

    /**
     * 获取农历
     *
     * @param year
     * @param month
     * @param day
     * @return
     */
    private String getLunarDate(int year, int month, int day) {
        StringBuilder builder = new StringBuilder();
        builder.append("(");
        int[] date = LunarCalendar.solarToLunar(year, month, day);
        builder.append(DatePickerUtil.getLunarMonth(date[1]) + "月");
        builder.append(DatePickerUtil.getLunarDate(date[2]));
        builder.append(")");
        return builder.toString();
    }

    public Activity getActivity() {
        return activity;
    }

    public void setActivity(Activity activity) {
        this.activity = activity;
    }


    public void setStartTime(String startTime, String startTimeLuncher, long startTimeStamp) {
        rb_start_time.setText(startTime + startTimeLuncher);
        start_time_luncher = startTimeLuncher;
        start_time_string = startTime;
        this.startTimeStamp = startTimeStamp;
        if (TextUtils.isEmpty(defalutStartTime)) {
            defalutStartTime = startTime;
        }

    }

    public void setEndTime(String endTime, String endTimeLuncher, long endTimeStamp) {
        rb_end_time.setText(endTime + endTimeLuncher);
        end_time_string = endTime;
        end_time_luncher = endTimeLuncher;
        this.endTimeStamp = endTimeStamp;
        if (TextUtils.isEmpty(defalutEndTime)) {
            defalutEndTime = endTime;
        }
    }

    public interface FilterSelectInterFace {
        /**
         * 点击确认按钮的回调
         *
         * @param startTime 开始时间
         * @param endTime   结束时间
         */
        void FilterConfirm(String startTime, String endTime, String startTimeLuncherValue, String endTimeLuncherValue);

        /**
         * 筛选框关闭
         */
        void FilterClose();
    }


    public void setFilterSelectInterFace(FilterSelectInterFace filterSelectInterFace) {
        this.filterSelectInterFace = filterSelectInterFace;
    }


    /**
     * 设置默认开始时间
     * 默认为今年的第一天 也就是大年初一
     */
    private void setDefaultStartTime() {
        Calendar yearOfFirstDayCalendar = DatePickerUtil.getCurrYearFirst(); //获取当前年的第一天 比如2018年 的1月1日
        int[] date = DatePickerUtil.lunarToSolar(yearOfFirstDayCalendar.get(Calendar.YEAR), yearOfFirstDayCalendar.get(Calendar.MONTH) + 1, yearOfFirstDayCalendar.get(Calendar.DAY_OF_MONTH)); //将农历日期转为公历日期
        Calendar yearOfFirstDay = DatePickerUtil.strongYearMonthDayToCalendar(date); //获取转换后的公历Calendar 获取的就是新年的第一天时间
        if (checkStartTimeIsGtEndTime(yearOfFirstDay)) {
            yearOfFirstDay = DatePickerUtil.strongYearMonthDayToCalendar(DatePickerUtil.lunarToSolar(yearOfFirstDayCalendar.get(Calendar.YEAR) - 1,
                    yearOfFirstDayCalendar.get(Calendar.MONTH) + 1, yearOfFirstDayCalendar.get(Calendar.DAY_OF_MONTH)));
        }
        int year = yearOfFirstDay.get(Calendar.YEAR);
        int monthOfYear = yearOfFirstDay.get(Calendar.MONTH);
        int dayOfMonth = yearOfFirstDay.get(Calendar.DAY_OF_MONTH);
        String month = monthOfYear + 1 < 10 ? "0" + (monthOfYear + 1) : (monthOfYear + 1) + "";
        String day = dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth + "";
        String defaultStartTime = year + "-" + month + "-" + day; //获取默认开始时间
        String defaultStartLuncher = getLunarDate(year, monthOfYear + 1, dayOfMonth);//默认开始时间的农历
        rb_start_time.setText(defaultStartTime + defaultStartLuncher);
        start_time_string = defaultStartTime;
        start_time_luncher = defaultStartLuncher;
        startTimeStamp = yearOfFirstDay.getTimeInMillis();
    }

    /**
     * 检查开始时间是否大于结束时间
     *
     * @param yearOfFirstDay
     */
    private boolean checkStartTimeIsGtEndTime(Calendar yearOfFirstDay) {
        String[] date = rb_end_time.getText().toString().substring(0, rb_end_time.getText().toString().indexOf("(")).split("-");
        Calendar endTimeCalendar = Calendar.getInstance();
        endTimeCalendar.set(Calendar.YEAR, Integer.parseInt(date[0]));
        endTimeCalendar.set(Calendar.MONTH, Integer.parseInt(date[1]) - 1);
        endTimeCalendar.set(Calendar.DAY_OF_MONTH, Integer.parseInt(date[2]));
        if (yearOfFirstDay.getTimeInMillis() > endTimeCalendar.getTimeInMillis()) {
            return true;
        }
        return false;
    }

    /**
     * 设置默认结束时间
     * 默认为今天的时间
     */
    private void setDefaultEndTime() {
        Calendar calendar = DatePickerUtil.getTodayDate();
        int year = calendar.get(Calendar.YEAR);
        int monthOfYear = calendar.get(Calendar.MONTH);
        int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);
        String month = monthOfYear + 1 < 10 ? "0" + (monthOfYear + 1) : (monthOfYear + 1) + "";
        String day = dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth + "";
        String defaultEndTime = year + "-" + month + "-" + day; //获取默认结束时间
        String defaultEndLuncher = getLunarDate(year, monthOfYear + 1, dayOfMonth); //默认结束时间的农历
        rb_end_time.setText(defaultEndTime + defaultEndLuncher);
        end_time_string = defaultEndTime;
        end_time_luncher = defaultEndLuncher;
        endTimeStamp = calendar.getTimeInMillis();
    }

    public String getName() {
        return this.rb_people.getText().toString();
    }

    public String getProjectName() {
        return this.rb_project.getText().toString();
    }


    public void setPidAndProjectName(String pid, String proName) {
//        if (TextUtils.isEmpty(pid) || TextUtils.isEmpty(proName)) {
//            return;
//        }
        this.pid = pid;
        rb_project.setText(!TextUtils.isEmpty(proName) ? proName : "全部项目");
    }

    public void setUidAndName(String uid, String userName) {
//        if (TextUtils.isEmpty(uid) || TextUtils.isEmpty(userName)) {
//            return;
//        }
        this.uid = uid;
        rb_people.setText(!TextUtils.isEmpty(userName) ? userName : UclientApplication.getRoler(getContext()).equals(Constance.ROLETYPE_FM) ? "全部工人" : "全部班组长");
    }

//    String sbAccount = "";

    public void setSelectAccountType(boolean isChecked) {
//        if (isChecked) {
//            sbAccount = sbAccount + text;
//        } else {
//            sbAccount = sbAccount.replace(text, "");
//        }
        tv_account.setText(ck_hour.isChecked() && ck_all_account.isChecked() && ck_borrow.isChecked() && ck_wage.isChecked() && ck_all_kq.isChecked() ? "已选全部" : "");
    }

    /**
     * 设置选择布局背景
     *
     * @param isChecked
     * @param rea_id
     * @param check_id
     */
    public void setBck(boolean isChecked, int rea_id, CheckBox check_id) {
        Utils.setBackGround(findViewById(rea_id), getResources().getDrawable(isChecked ? R.drawable.sk_gy_fdeded_20radius : R.drawable.sk_gy_f5f5f5_20radius));
        setCheckBck(isChecked, check_id);
    }

    /**
     * 设置够
     *
     * @param isChecked
     * @param check_id
     */
    public void setCheckBck(boolean isChecked, CheckBox check_id) {
        if (isChecked) {
            Drawable img_on = getResources().getDrawable(R.drawable.icon_filter_gou);
            //调用setCompoundDrawables时，必须调用Drawable.setBounds()方法,否则图片不显示
            img_on.setBounds(0, 0, img_on.getMinimumWidth(), img_on.getMinimumHeight());
            check_id.setCompoundDrawables(img_on, null, null, null); //设置左图标
        } else {
            check_id.setCompoundDrawables(null, null, null, null); //设置左图标
        }
    }


    public void setAccountIds(String accountIds) {
        clearAllAccountIds();
        if (TextUtils.isEmpty(accountIds)) {
            return;
        }
        if (accountIds.contains(AccountUtil.HOUR_WORKER)) {
            ck_hour.setChecked(true);
        }
        if (accountIds.contains(AccountUtil.CONSTRACTOR)) {
            ck_all_account.setChecked(true);
        }
        if (accountIds.contains(AccountUtil.BORROWING)) {
            ck_borrow.setChecked(true);
        }
        if (accountIds.contains(AccountUtil.SALARY_BALANCE)) {
            ck_wage.setChecked(true);
        }
        if (accountIds.contains(AccountUtil.CONSTRACTOR_CHECK)) {
            ck_all_kq.setChecked(true);
        }
    }


    public void clearAllAccountIds() {
        ck_hour.setChecked(false);
        ck_all_account.setChecked(false);
        ck_borrow.setChecked(false);
        ck_wage.setChecked(false);
        ck_all_kq.setChecked(false);
    }


    /**
     * 所有的选项是否已恢复初始值
     */
    public boolean isRestoryInit() {
        if (pid == null && uid == null && start_time_string.equals(defalutStartTime) && end_time_string.equals(defalutEndTime) && !ck_hour.isChecked()
                && !ck_all_account.isChecked() && !ck_borrow.isChecked() && !ck_wage.isChecked() && !ck_all_kq.isChecked()) {
            return true;
        }
        return false;
    }


    public void setCanClickPerson(boolean canClickPerson) {
        this.canClickPerson = canClickPerson;
        if (!canClickPerson) {
            findViewById(R.id.rb_people_click_icon).setVisibility(View.INVISIBLE);
        }
    }

    public void setCanClickPro(boolean canClickPro) {
        this.canClickPro = canClickPro;
        if (!canClickPro) {
            findViewById(R.id.rb_project_click_icon).setVisibility(View.INVISIBLE);
        }
    }
}
