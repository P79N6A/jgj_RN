package com.jizhi.jongg.widget;


import android.app.Activity;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.animation.AnimationUtils;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.baidu.platform.comapi.map.C;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.RemberWokerInfoPeopleAdapter;
import com.jizhi.jlongg.main.adpter.RemberWorkerInfoTargerNameAdapter;
import com.jizhi.jlongg.main.bean.RemberInfoTargetNameBean;
import com.jizhi.jlongg.main.dialog.WheelViewSelectYearAndMonth;
import com.jizhi.jlongg.main.listener.YearAndMonthClickListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;


/**
 * 功能:记工流水抽屉
 * 时间:2018/5/31 2:41
 * 作者:huchangsheng
 */

public class RightSideslipLay extends RelativeLayout implements View.OnClickListener, CompoundButton.OnCheckedChangeListener {
    private static final String PERSON = "person";
    private static final String PROJECT = "project";
    private Activity context;
    /*选择项目，工人、工头按钮*/
    private RadioButton rb_project, rb_people;
    /*项目项目，工人、工头数据*/
    protected List<RemberInfoTargetNameBean> remberInfoTargetNameBeanList, remberInfoTargetPersonBeanList;
    /*筛选的人id,以及筛选的项目id*/
    private String uid, pid;
    /*是否显示数据*/
    private boolean isShowData;
    /*项目适配器*/
    private RemberWorkerInfoTargerNameAdapter remberWorkerInfoTargerNameAdapter;
    /*工人、工头适配器*/
    private RemberWokerInfoPeopleAdapter remberWokerInfoPeopleAdapter;
    private ListView list_all_pro;
    /*工人、工头顶部view*/
    private View headView;
    /*工人、工头勾选全部*/
    private ImageView img_gou;
    /*角色*/
    private String role;
    private String group_id;
    private FilterSelectInterFace filterSelectInterFace;
    private CheckBox ck_hour, ck_all_account, ck_borrow, ck_all_kq, ck_remark, ck_wage, ck_agency;
    private String accountIds;
    /*年、月*/
    protected String year, month;
    //时间选择框
    private WheelViewSelectYearAndMonth selecteYearMonthPopWindow;

    public RightSideslipLay(Activity context, String uid, String pid, String role, String accountIds, String group_id, String year, String month, FilterSelectInterFace filterSelectInterFace) {
        super(context);
        this.context = context;
        this.uid = uid;
        this.pid = pid;
        this.role = role;
        this.group_id = group_id;
        this.accountIds = accountIds;
        this.year = year;
        this.month = month;
        this.filterSelectInterFace = filterSelectInterFace;
        inflateView();
        getTargetNameAndProjectList(PERSON, false);
        getTargetNameAndProjectList(PROJECT, false);
    }

    /**
     * 设置日期
     *
     * @param year
     * @param month
     */
    public void setDate(String year, String month) {
        this.year = year;
        this.month = month;
        ((RadioButton) findViewById(R.id.rb_rea_year_month)).setText(year + "年" + month + "月");

    }

    private void inflateView() {
        View.inflate(getContext(), R.layout.include_right_sideslip_layout, this);
        rb_project = findViewById(R.id.rb_project);
        rb_people = findViewById(R.id.rb_people);
        list_all_pro = findViewById(R.id.list_all_pro);
        findViewById(R.id.rb_project).setOnClickListener(this);
        findViewById(R.id.rb_people).setOnClickListener(this);
        findViewById(R.id.img_back).setOnClickListener(this);
        findViewById(R.id.img_back_top).setOnClickListener(this);
        findViewById(R.id.btn_reset).setOnClickListener(this);
        findViewById(R.id.btn_save).setOnClickListener(this);
        findViewById(R.id.rea_project).setOnClickListener(this);
        findViewById(R.id.rea_people).setOnClickListener(this);
        findViewById(R.id.ck_agency).setOnClickListener(this);
        findViewById(R.id.rea_year_month).setOnClickListener(this);
        findViewById(R.id.rb_rea_year_month).setOnClickListener(this);
        ck_hour = findViewById(R.id.ck_hour);
        ck_all_account = findViewById(R.id.ck_all_account);
        ck_borrow = findViewById(R.id.ck_borrow);
        ck_wage = findViewById(R.id.ck_wage);
        ck_all_kq = findViewById(R.id.ck_all_kq);
        ck_remark = findViewById(R.id.ck_remark);
        ck_agency = findViewById(R.id.ck_agency);
        ck_hour.setOnCheckedChangeListener(this);
        ck_all_account.setOnCheckedChangeListener(this);
        ck_borrow.setOnCheckedChangeListener(this);
        ck_wage.setOnCheckedChangeListener(this);
        ck_all_kq.setOnCheckedChangeListener(this);
        ck_remark.setOnCheckedChangeListener(this);
        ck_agency.setOnCheckedChangeListener(this);
        //设置筛选人默认数据
        headView = context.getLayoutInflater().inflate(R.layout.item_rember_info_target_name, null);
        img_gou = headView.findViewById(R.id.img_gou);
        img_gou.setVisibility(View.VISIBLE);
        if (role.equals(Constance.ROLETYPE_FM)) {
            ((TextView) findViewById(R.id.tv_select_tole)).setText("选择工人");
            rb_people.setText("全部工人");
        } else {
            ((TextView) findViewById(R.id.tv_select_tole)).setText("选班组长");
            rb_people.setText("全部班组长");
        }
        ((RadioButton) findViewById(R.id.rb_rea_year_month)).setText(year + "年" + month + "月");
        headView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                uid = "";
                filterSelectInterFace.FilterSelectClick(PERSON, uid, null);
                for (int i = 0; i < remberInfoTargetPersonBeanList.size(); i++) {
                    remberInfoTargetPersonBeanList.get(i).setSelect(false);
                }
                if (role.equals(Constance.ROLETYPE_FM)) {
                    rb_people.setText("全部工人");
                } else {
                    rb_people.setText("全部班组长");
                }
                findViewById(R.id.rea_filter_rootView).startAnimation(AnimationUtils.loadAnimation(context, R.anim.page_anima_right_out));
                findViewById(R.id.rea_filter_rootView).setVisibility(View.GONE);
            }
        });
        setAccountIds(accountIds);
    }

    public void setAccountIds(String accountIds) {
        if (TextUtils.isEmpty(accountIds)) {
            return;
        }
        clearAllAccountIds();
        if (accountIds.contains("1")) {
            ck_hour.setChecked(true);
        }
        if (accountIds.contains("2")) {
            ck_all_account.setChecked(true);
        }
        if (accountIds.contains("3")) {
            ck_borrow.setChecked(true);
        }
        if (accountIds.contains("4")) {
            ck_wage.setChecked(true);
        }
        if (accountIds.contains("5")) {
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

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.rb_project:
            case R.id.rea_project:
                //如果是代班记工跳转过来的就不可以选项目
                if (context.getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
                    return;
                }
                //项目
                ((TextView) findViewById(R.id.tv_title_three)).setText("全部项目");
                findViewById(R.id.rea_filter_rootView).setVisibility(View.VISIBLE);
                findViewById(R.id.rea_filter_rootView).startAnimation(AnimationUtils.loadAnimation(context, R.anim.page_anima_right_in));
                shoeProjectDate();
                break;
            case R.id.rb_people:
            case R.id.rea_people:
                //选择工人，班组长
                if (role.equals(Constance.ROLETYPE_FM)) {
                    ((TextView) findViewById(R.id.tv_title_three)).setText("全部工人");
                    ((TextView) headView.findViewById(R.id.tv_name)).setText("全部工人");
                } else {
                    ((TextView) findViewById(R.id.tv_title_three)).setText("全部班组长");
                    ((TextView) headView.findViewById(R.id.tv_name)).setText("全部班组长");
                }
                findViewById(R.id.rea_filter_rootView).startAnimation(AnimationUtils.loadAnimation(context, R.anim.page_anima_right_in));
                findViewById(R.id.rea_filter_rootView).setVisibility(View.VISIBLE);
                shoePeopleDate();
                break;
            case R.id.img_back:
                //返回
                findViewById(R.id.rea_filter_rootView).startAnimation(AnimationUtils.loadAnimation(context, R.anim.page_anima_right_out));
                findViewById(R.id.rea_filter_rootView).setVisibility(View.GONE);
                break;
            case R.id.img_back_top:
                //关闭抽屉
                filterSelectInterFace.colose();
                break;
            case R.id.btn_reset:
                //重置
                ck_hour.setChecked(false);
                ck_all_account.setChecked(false);
                ck_borrow.setChecked(false);
                ck_wage.setChecked(false);
                ck_all_kq.setChecked(false);
                ck_remark.setChecked(false);
                ck_agency.setChecked(false);
                uid = "";
                remberInfoTargetNameBeanList = null;
                remberInfoTargetPersonBeanList = null;
                if (!context.getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
                    rb_project.setText("全部项目");
                    pid = "";
                }
//                filterSelectInterFace.FilterSelectClick(PROJECT, "", "");

                if (role.equals(Constance.ROLETYPE_FM)) {
                    rb_people.setText("全部工人");
                } else {
                    rb_people.setText("全部班组长");
                }
                filterSelectInterFace.FilterReset();
                break;
            case R.id.btn_save:
                //确定
                filterSelectInterFace.FilterClick(getAccount_type(), ((CheckBox) findViewById(R.id.ck_remark)).isChecked() ? 1 + "" : "", ((CheckBox) findViewById(R.id.ck_agency)).isChecked() ? 1 + "" : "", year, month);
                break;
            case R.id.rea_year_month:
            case R.id.rb_rea_year_month:
                //选择月份
                if (TextUtils.isEmpty(year) || TextUtils.isEmpty(month)) {
                    return;
                }
                if (selecteYearMonthPopWindow == null) {
                    selecteYearMonthPopWindow = new WheelViewSelectYearAndMonth(context, new YearAndMonthClickListener() {
                        @Override
                        public void YearAndMonthClick(String years, String months) {
                            year = years;
                            month = months;
                            ((RadioButton) findViewById(R.id.rb_rea_year_month)).setText(years + "年" + months + "月");
                            filterSelectInterFace.FilterDate();

                        }
                    }, Integer.parseInt(year), Integer.parseInt(month));
                } else {
                    selecteYearMonthPopWindow.update();
                }
                selecteYearMonthPopWindow.showAtLocation(context.getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(context, 0.5F);
                break;
        }
    }

    public String getIsRemark() {
        return ((CheckBox) findViewById(R.id.ck_remark)).isChecked() ? 1 + "" : "";
    }

    public String getIsAgency() {
        return ((CheckBox) findViewById(R.id.ck_agency)).isChecked() ? 1 + "" : "";
    }

    public String getYear() {
        return year;
    }


    public String getMonth() {
        return month;
    }


    /**
     * 获取筛选记账类型
     *
     * @return
     */
    public String getAccount_type() {
        StringBuffer sb = new StringBuffer();
        if (((CheckBox) findViewById(R.id.ck_hour)).isChecked()) {
            sb.append("1,");
        }
        if (((CheckBox) findViewById(R.id.ck_all_account)).isChecked()) {
            sb.append("2,");
        }
        if (((CheckBox) findViewById(R.id.ck_borrow)).isChecked()) {
            sb.append("3,");
        }
        if (((CheckBox) findViewById(R.id.ck_wage)).isChecked()) {
            sb.append("4,");
        }
        if (((CheckBox) findViewById(R.id.ck_all_kq)).isChecked()) {
            sb.append("5,");
        }
        if (!TextUtils.isEmpty(sb.toString())) {
            return sb.toString().substring(0, sb.toString().length() - 1);
        }

        return sb.toString();
    }

    public void getTargetNameAndProjectList(final String class_type, final boolean isShowData) {
        String httpUrl = NetWorkRequest.GET_TARGETNAMELIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
        params.addBodyParameter("class_type", class_type);
        if (!TextUtils.isEmpty(group_id)) {
            params.addBodyParameter("group_id", group_id);
        }
        CommonHttpRequest.commonRequest(context, httpUrl, RemberInfoTargetNameBean.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                List<RemberInfoTargetNameBean> listBean = (List<RemberInfoTargetNameBean>) object;
                if (class_type.equals(PERSON)) {
                    if (null == remberInfoTargetPersonBeanList) {
                        remberInfoTargetPersonBeanList = new ArrayList<>();
                    }
                    remberInfoTargetPersonBeanList = listBean;
                    if (context.getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN1, false) || context.getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
                        //设置默认选择
                        for (int j = 0; j < remberInfoTargetPersonBeanList.size(); j++) {
                            if (remberInfoTargetPersonBeanList.get(j).getClass_type_id().equals(uid)) {
                                img_gou.setVisibility(View.GONE);
                                remberInfoTargetPersonBeanList.get(j).setSelect(true);
                                rb_people.setText(remberInfoTargetPersonBeanList.get(j).getName());
                            }
                        }
                    }
                    if (isShowData) {
                        setPeopleData();
                    }
                } else if (class_type.equals(PROJECT)) {
                    List<RemberInfoTargetNameBean> list1;
                    List<RemberInfoTargetNameBean> list2 = new ArrayList<>();
                    list1 = listBean;
                    if (list1.size() > 0 && list1.size() == 2) {
                        remberInfoTargetNameBeanList = list1;
                    } else if (list1.size() > 0 && list1.size() > 2) {
                        //全部项目未分项目不用排序，剩下的需要排序
                        list2.add(list1.get(0));
                        list2.add(list1.get(1));
                        List<RemberInfoTargetNameBean> list = list1.subList(2, list1.size() - 1);
                        Utils.setPinYinAndSortRember(list);
                        list2.addAll(list);
                        remberInfoTargetNameBeanList = list2;
                    } else {
                        remberInfoTargetNameBeanList = list1;
                    }

                    if (null == remberInfoTargetNameBeanList) {
                        remberInfoTargetNameBeanList = new ArrayList<>();
                    }
                    remberInfoTargetNameBeanList = listBean;
                    if (remberInfoTargetNameBeanList.size() > 0) {
                        remberInfoTargetNameBeanList.get(0).setSelect(true);
                    }
                    if (context.getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN1, false) || context.getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
                        //设置默认选择
                        for (int j = 0; j < remberInfoTargetNameBeanList.size(); j++) {
                            if (remberInfoTargetNameBeanList.get(j).getClass_type_id().equals(pid)) {
                                remberInfoTargetNameBeanList.get(j).setSelect(true);
                                remberInfoTargetNameBeanList.get(0).setSelect(false);
                                rb_project.setText(remberInfoTargetNameBeanList.get(j).getName());
                            }
                        }
                    }
                    if (isShowData) {
                        setProjectData();
                    }
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    public void setUserName(String userName) {
        if (!TextUtils.isEmpty(userName)) {
            rb_people.setText(userName);
        }

    }

    public void setProName(String proname) {
        if (!TextUtils.isEmpty(proname)) {
            rb_project.setText(proname);
        }

    }

    public void shoePeopleDate() {
        if (null == remberInfoTargetPersonBeanList || remberInfoTargetPersonBeanList.size() == 0) {
            getTargetNameAndProjectList(PERSON, true);
            return;
        }
        setPeopleData();
    }

    public void shoeProjectDate() {
        if (null == remberInfoTargetNameBeanList || remberInfoTargetNameBeanList.size() == 0) {
            getTargetNameAndProjectList(PROJECT, true);
            return;
        }
        setProjectData();
    }

    /**
     * 显示班主长数据
     */
    public void setPeopleData() {
        if (list_all_pro.getHeaderViewsCount() == 0) {
            list_all_pro.addHeaderView(headView);
        }
        remberWokerInfoPeopleAdapter = null;
        Utils.setPinYinAndSortRember(remberInfoTargetPersonBeanList);
        remberWokerInfoPeopleAdapter = new RemberWokerInfoPeopleAdapter(context, remberInfoTargetPersonBeanList, new RemberWokerInfoPeopleAdapter.ItemClickListener() {
            @Override
            public void itemClick(int posotion) {
                for (int i = 0; i < remberInfoTargetPersonBeanList.size(); i++) {
                    if (i == posotion) {
                        remberInfoTargetPersonBeanList.get(i).setSelect(true);
                    } else {
                        remberInfoTargetPersonBeanList.get(i).setSelect(false);
                    }
                }
                uid = remberInfoTargetPersonBeanList.get(posotion).getClass_type_id();
                rb_people.setText(remberInfoTargetPersonBeanList.get(posotion).getName());
                filterSelectInterFace.FilterSelectClick(PROJECT, uid, null);
                findViewById(R.id.rea_filter_rootView).startAnimation(AnimationUtils.loadAnimation(context, R.anim.page_anima_right_out));
                findViewById(R.id.rea_filter_rootView).setVisibility(View.GONE);
            }
        });
        list_all_pro.setAdapter(remberWokerInfoPeopleAdapter);
        boolean isExitSelect = false;
        for (int i = 0; i < remberInfoTargetPersonBeanList.size(); i++) {
            if (remberInfoTargetPersonBeanList.get(i).isSelect()) {
                isExitSelect = true;
            }
        }
        if (isExitSelect) {
            img_gou.setVisibility(View.GONE);
        } else {
            img_gou.setVisibility(View.VISIBLE);
        }
    }

    /**
     * 显示项目数据
     */
    public void setProjectData() {
        if (list_all_pro.getHeaderViewsCount() != 0) {
            list_all_pro.removeHeaderView(headView);
        }
        remberWorkerInfoTargerNameAdapter = null;
        remberWorkerInfoTargerNameAdapter = new RemberWorkerInfoTargerNameAdapter(context, remberInfoTargetNameBeanList, new RemberWorkerInfoTargerNameAdapter.ItemClickListener() {
            @Override
            public void itemClick(int posotion) {
                for (int i = 0; i < remberInfoTargetNameBeanList.size(); i++) {
                    if (i == posotion) {
                        remberInfoTargetNameBeanList.get(i).setSelect(true);
                    } else {
                        remberInfoTargetNameBeanList.get(i).setSelect(false);
                    }
                }
                pid = remberInfoTargetNameBeanList.get(posotion).getClass_type_id();
                rb_project.setText(NameUtil.setRemark(remberInfoTargetNameBeanList.get(posotion).getName(), 10));
                filterSelectInterFace.FilterSelectClick(PROJECT, null, pid);
                findViewById(R.id.rea_filter_rootView).startAnimation(AnimationUtils.loadAnimation(context, R.anim.page_anima_right_out));
                findViewById(R.id.rea_filter_rootView).setVisibility(View.GONE);
            }
        });
        list_all_pro.setAdapter(remberWorkerInfoTargerNameAdapter);
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        switch (buttonView.getId()) {
            case R.id.ck_hour:
                setBck(isChecked, R.id.rea_hour, ck_hour);
                setSelectAccountType(isChecked, context.getString(R.string.pricemode_hour) + " ");
                break;
            case R.id.ck_all_account:
                setBck(isChecked, R.id.rea_all_account, ck_all_account);
                setSelectAccountType(isChecked, context.getString(R.string.account_allwork_bill) + " ");
                break;
            case R.id.ck_borrow:
                setBck(isChecked, R.id.rea_borrow, ck_borrow);
                setSelectAccountType(isChecked, context.getString(R.string.borrowing) + " ");
                break;
            case R.id.ck_wage:
                setBck(isChecked, R.id.rea_wage, ck_wage);
                setSelectAccountType(isChecked, context.getString(R.string.wages_settlement) + " ");
                break;
            case R.id.ck_all_kq:
                setBck(isChecked, R.id.rea_all_kq, ck_all_kq);
                setSelectAccountType(isChecked, "包工记工天" + " ");
                break;
            case R.id.ck_remark:
                setBck(isChecked, R.id.rea_remark, ck_remark);
//                if (isChecked) {
//                    ((TextView) findViewById(R.id.tv_remark)).setText("有备注");
//                } else {
//                    ((TextView) findViewById(R.id.tv_remark)).setText("");
//                }
                break;
            case R.id.ck_agency:
                setBck(isChecked, R.id.rea_agency, ck_agency);
                break;

        }

        //tv_account
    }

    String sbAccount = "";

    public void setSelectAccountType(boolean isChecked, String text) {
        if (isChecked) {
            sbAccount = sbAccount + "" + text;
        } else {
            sbAccount = sbAccount.replace(text, "");
        }
        if (sbAccount.contains("点") && sbAccount.contains("借") && sbAccount.contains("结") && sbAccount.contains("记账") && sbAccount.contains("工天")) {
            ((TextView) findViewById(R.id.tv_account)).setText("已选全部");
        } else {
            ((TextView) findViewById(R.id.tv_account)).setText("");
        }

    }

    /**
     * 设置选择布局背景
     *
     * @param isChecked
     * @param rea_id
     * @param check_id
     */
    public void setBck(boolean isChecked, int rea_id, CheckBox check_id) {
        filterSelectInterFace.FilterChange();
        if (isChecked) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                findViewById(rea_id).setBackground(ContextCompat.getDrawable(context, R.drawable.sk_gy_fdeded_20radius));
            } else {
                findViewById(rea_id).setBackgroundResource(R.drawable.sk_gy_fdeded_20radius);
            }
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                findViewById(rea_id).setBackground(ContextCompat.getDrawable(context, R.drawable.sk_gy_f5f5f5_20radius));
            } else {
                findViewById(rea_id).setBackgroundResource(R.drawable.sk_gy_f5f5f5_20radius);
            }
        }
        setCheckBck(isChecked, check_id);
    }

    /**
     * 设置够
     *
     * @param isChecked
     * @param check_id
     */
    public void setCheckBck(boolean isChecked, CheckBox check_id) {
        Resources res = getResources();
        Drawable img_on = res.getDrawable(R.drawable.icon_filter_gou);
        //调用setCompoundDrawables时，必须调用Drawable.setBounds()方法,否则图片不显示
        img_on.setBounds(0, 0, img_on.getMinimumWidth(), img_on.getMinimumHeight());
        if (isChecked) {
            check_id.setCompoundDrawables(img_on, null, null, null); //设置左图标
        } else {
            check_id.setCompoundDrawables(null, null, null, null); //设置左图标
        }
    }

    public interface FilterSelectInterFace {
        void FilterSelectClick(String type, String uid, String pid);

        void FilterClick(String filter_account_type, String is_note, String is_agency, String year, String month);

        void FilterChange();

        void FilterReset();

        void FilterDate();

        void colose();
    }
}
