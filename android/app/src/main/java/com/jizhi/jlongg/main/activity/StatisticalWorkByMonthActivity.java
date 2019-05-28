package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;
import android.text.style.StyleSpan;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.StatisticalWorkAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.StatisticalWork;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.popwindow.TitleSingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能: 记工月统计
 * 作者：Xuj
 * 时间: 2018年1月4日10:47:06
 */
public class StatisticalWorkByMonthActivity extends BaseActivity implements View.OnClickListener {


    /**
     * 日期是否按天显示
     */
    private boolean isDayShow;
    /**
     * 未结金额、点工金额、包工金额、借支金额、结算金额
     */
    private TextView littleWorkAmount, contractorWorkAmount, borrowAmount, balanceAmount;
    /**
     * 上班时长、加班时长、借支合计、结算合计
     */
    private TextView manhour, overTime, borrowTotal, balanceTotal;
    /**
     * 显示日期
     */
    private TextView date;
    /**
     * 记工统计适配器
     */
    private StatisticalWorkAdapter adapter;
    /**
     * 主要是当切换点工显示方式时候直接使用 不用在查询服务器
     */
    private StatisticalWork statisticalWork;
    /**
     * 标题
     */
    private TextView titleText;
    /**
     * 标题旁边的图标
     */
    private ImageView titleImage;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param startTime           开始时间
     * @param endTime             结束时间
     * @param classType           个人person(默认),项目project
     * @param proNameOrPersonName 项目名称或人名
     * @param id                  id
     * @param otherPersonUid      如果这个参数不为空的话表示 是别人同步给我的项目信息的uid
     * @param canToNextPage       是否能到记工统计下个页面
     */
    public static void actionStart(Activity context, String startTime, String endTime, String classType, String proNameOrPersonName, String id, String otherPersonUid, boolean canToNextPage) {
        Intent intent = new Intent(context, StatisticalWorkByMonthActivity.class);
        intent.putExtra("param1", startTime);
        intent.putExtra("param2", endTime);
        intent.putExtra("param3", classType);
        intent.putExtra("param4", proNameOrPersonName);
        intent.putExtra("param5", id);
        intent.putExtra("param6", otherPersonUid);
        intent.putExtra("param7", canToNextPage);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.statistical_work_by_month);
        initView();
        getData();
    }


    private SpannableStringBuilder setMoneyViewAttritube(String completeString, String changeString, int textColor) {
        Pattern p = Pattern.compile(changeString);
        SpannableStringBuilder builder = new SpannableStringBuilder(completeString);
        Matcher telMatch = p.matcher(completeString);
        while (telMatch.find()) {
            ForegroundColorSpan redSpan = new ForegroundColorSpan(textColor);
            builder.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), telMatch.start(), telMatch.end(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);  //粗体
            builder.setSpan(redSpan, telMatch.start(), telMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
            builder.setSpan(new AbsoluteSizeSpan(DensityUtils.sp2px(getApplicationContext(), 14)), telMatch.start(), telMatch.end(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        }
        return builder;
    }


    private void initView() {

        setTextTitle(R.string.statistical_work);
        titleText = getTextView(R.id.title);
        titleImage = getImageView(R.id.titleImage);
        ImageView rightImageView = getImageView(R.id.rightImage);
        rightImageView.setImageResource(R.drawable.red_dots);
        rightImageView.setOnClickListener(this);
        rightImageView.setVisibility(View.VISIBLE);

        getTextView(R.id.defaultDesc).setText("暂无记工统计数据");

        View headView = getLayoutInflater().inflate(R.layout.statistical_work_by_month_head, null); // 加载对话框

        TextView recordRoler = (TextView) headView.findViewById(R.id.recordRoler);
        String currentRoler = UclientApplication.getRoler(getApplicationContext());
        String classType = getIntent().getStringExtra("param3"); //个人person(默认),项目project
        String proNameOrPersonName = getIntent().getStringExtra("param4"); //项目名称或人名

        if (classType.equals("project")) { //按项目
            recordRoler.setText(currentRoler.equals(Constance.ROLETYPE_WORKER) ? String.format(getString(R.string.from_project), proNameOrPersonName) : proNameOrPersonName);
        } else { //按人
            recordRoler.setText(String.format(getString(currentRoler.equals(Constance.ROLETYPE_WORKER) ? R.string.from_foreman : R.string.from_worker, proNameOrPersonName)));
        }
        ListView listView = (ListView) findViewById(R.id.listView);
        listView.addHeaderView(headView, null, false); //添加头部文件
        date = (TextView) headView.findViewById(R.id.date);
        littleWorkAmount = (TextView) headView.findViewById(R.id.littleWorkAmount);
        contractorWorkAmount = (TextView) headView.findViewById(R.id.contractorWorkAmount);
        borrowAmount = (TextView) headView.findViewById(R.id.borrowAmount);
        balanceAmount = (TextView) headView.findViewById(R.id.balanceAmount);
        manhour = (TextView) headView.findViewById(R.id.manhour);
        overTime = (TextView) headView.findViewById(R.id.overTime);
        borrowTotal = (TextView) headView.findViewById(R.id.borrowTotal);
        balanceTotal = (TextView) headView.findViewById(R.id.balanceTotal);
        if (getIntent().getStringExtra("param3").equals("project") && UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM)) {
            titleText.setOnClickListener(this);
            titleText.setText(isDayShow ? "按天统计" : "按月统计");
            titleImage.setVisibility(View.VISIBLE);
            titleImage.setOnClickListener(this);
            setTitleImageState(false);
        } else {
            titleText.setText("记工统计");
        }
    }

    /**
     * 设置标题图标状态
     */
    private void setTitleImageState(boolean isOpenPopWindow) {
        titleImage.setImageResource(isOpenPopWindow ? R.drawable.sanjiao_shang : R.drawable.sanjiao_xia);
    }


    /**
     * 获取记工统计数据
     */
    public void getData() {
        String URL = NetWorkRequest.GET_MONTH_RECORD_STATISTICS;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("start_time", getIntent().getStringExtra("param1")); //开始时间（值2016-11-01）
        params.addBodyParameter("end_time", getIntent().getStringExtra("param2")); //结束时间（值2016-12-01)
        params.addBodyParameter("class_type", getIntent().getStringExtra("param3")); //	个人person(默认),项目project
        params.addBodyParameter("class_type_id", getIntent().getStringExtra("param5")); //数据id
        String uid = getIntent().getStringExtra("param6");
        if (!TextUtils.isEmpty(uid)) {
            params.addBodyParameter("uid", uid);
        }
        if (isDayShow) {
            params.addBodyParameter("is_day", "1");
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<StatisticalWork> base = CommonJson.fromJson(responseInfo.result, StatisticalWork.class);
                    if (base.getState() != 0) {
                        StatisticalWork statisticalWork = base.getValues();
                        setAdapter(statisticalWork.getMonth_list());
                        fillData(statisticalWork);
                    } else {
                        DataUtil.showErrOrMsg(StatisticalWorkByMonthActivity.this, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(StatisticalWorkByMonthActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }

        });
    }

    /**
     * 填充列表数据
     *
     * @param statisticalWork
     */
    private void fillData(StatisticalWork statisticalWork) {
        date.setText(statisticalWork.getDate()); //设置记账日期
        String mLittleWorkAmount = statisticalWork.getWork_type().getAmounts(); //点工金额
        String mContractorWorkAmount = statisticalWork.getContract_type().getAmounts(); //包工金额
        String mBorrowAmount = statisticalWork.getExpend_type().getAmounts(); //借支金额
        String mBalanceAmount = statisticalWork.getBalance_type().getAmounts(); //结算金额

        String mBorrowTotal = String.format(getString(R.string.borrow_params), (int) statisticalWork.getExpend_type().getTotal()); //借支笔数
        String mBalanceTotal = String.format(getString(R.string.balance_params), (int) statisticalWork.getBalance_type().getTotal()); //结算笔数


        littleWorkAmount.setText(setMoneyViewAttritube("点工：" + mLittleWorkAmount, mLittleWorkAmount, Color.parseColor("#eb4e4e")));
        contractorWorkAmount.setText(setMoneyViewAttritube("包工：" + mContractorWorkAmount, mContractorWorkAmount, Color.parseColor("#eb4e4e")));
        borrowAmount.setText(setMoneyViewAttritube("借支：" + mBorrowAmount, mBorrowAmount, Color.parseColor("#83c76e")));
        balanceAmount.setText(setMoneyViewAttritube("结算：" + mBalanceAmount, mBalanceAmount, Color.parseColor("#83c76e")));

        borrowTotal.setText(setMoneyViewAttritube(mBorrowTotal, ((int) statisticalWork.getExpend_type().getTotal()) + "", Color.parseColor("#83c76e")));
        balanceTotal.setText(setMoneyViewAttritube(mBalanceTotal, ((int) statisticalWork.getBalance_type().getTotal()) + "", Color.parseColor("#83c76e")));

        String manhourString = AccountUtil.getAccountShowTypeString(this, true, true, true, statisticalWork.getWork_type().getManhour(), statisticalWork.getWork_type().getWorking_hours());
        String overTimeString = AccountUtil.getAccountShowTypeString(this, true, true, false, statisticalWork.getWork_type().getOvertime(), statisticalWork.getWork_type().getOvertime_hours());
        String manhourValue = null;
        String overTimeValue = null;

        switch (AccountUtil.getDefaultAccountUnit(getApplicationContext())) {
            case AccountUtil.WORK_AS_UNIT: //以工为单位
                manhourValue = statisticalWork.getWork_type().getWorking_hours();
                overTimeValue = statisticalWork.getWork_type().getOvertime_hours();
                break;
            case AccountUtil.MANHOUR_AS_UNIT_OVERTIME_AS_HOUR: //上班为小时，加班显示为空
                manhourValue = statisticalWork.getWork_type().getWorking_hours();
                overTimeValue = RecordUtils.cancelIntergerZeroFloat(statisticalWork.getWork_type().getOvertime());
                break;
            case AccountUtil.WORK_OF_HOUR:
                manhourValue = RecordUtils.cancelIntergerZeroFloat(statisticalWork.getWork_type().getManhour());
                overTimeValue = RecordUtils.cancelIntergerZeroFloat(statisticalWork.getWork_type().getOvertime());
                break;
        }
        manhour.setText(setMoneyViewAttritube(manhourString, manhourValue, Color.parseColor("#eb4e4e"))); //设置上班时长
        overTime.setText(setMoneyViewAttritube(overTimeString, overTimeValue, Color.parseColor("#eb4e4e"))); //设置上班时长
        this.statisticalWork = statisticalWork;
    }

    /**
     * 设置记工统计数据
     *
     * @param list
     */
    private void setAdapter(List<StatisticalWork> list) {
        if (adapter == null) {
            final ListView listView = (ListView) findViewById(R.id.listView);
            adapter = new StatisticalWorkAdapter(this, list, true, false, false);
            listView.setAdapter(adapter);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            final boolean isIntentNextActivity = getIntent().getBooleanExtra("param7", true);
//            adapter.setShowClickIcon(isIntentNextActivity);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                    if (!isIntentNextActivity) { //如果这个参数不为空的话表示 是别人同步给我的项目信息 所以我们这里不能进入到下一个页面 以防止修改数据
                        return;
                    }
                    position -= listView.getHeaderViewsCount();
                    if (position <= -1)
                        position = 0;
                    StatisticalWork statisticalWork = adapter.getList().get(position);
                    String date = DateUtil.dateFormat(statisticalWork.getDate());
                    if (TextUtils.isEmpty(date)) {
                        return;
                    }
                    try {
                        String year = date.substring(0, date.indexOf("-"));
                        String month;
                        LUtils.e("date:" + date);
                        if (isDayShow) {
                            month = date.substring(date.indexOf("-") + 1, date.lastIndexOf("-"));
                        } else {
                            month = date.substring(date.indexOf("-") + 1);
                        }
                        String proNameOrPersonName = getIntent().getStringExtra("param4"); //项目名称或人名
                        String classType = getIntent().getStringExtra("param3"); //个人person(默认),项目project
                        if (classType.equals("project")) { //按项目
                            RememberWorkerInfosActivity.actionStart(StatisticalWorkByMonthActivity.this, year, month, null, null,
                                    statisticalWork.getClass_type_id(), proNameOrPersonName, true); //项目名称或人名);
                        } else { //按人
                            RememberWorkerInfosActivity.actionStart(StatisticalWorkByMonthActivity.this, year, month,
                                    statisticalWork.getClass_type_id(), proNameOrPersonName, null, null, true); //项目名称或人名);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
        } else {
            adapter.updateListView(list);
        }
    }


    public List<SingleSelected> getItem() {
        List<SingleSelected> list = new ArrayList<>();
        list.add(new SingleSelected(false, true).setSelecteNumber("1"));
        list.add(new SingleSelected("下载", getString(R.string.hint_wps), false, true, "DOWNLOAD", Color.parseColor("#000000"), 18));
        list.add(new SingleSelected("取消", false, false, "", Color.parseColor("#999999")));
        return list;
    }

    public List<SingleSelected> getTitleItem() {
        List<SingleSelected> list = new ArrayList<>();
        SingleSelected singleSelected1 = new SingleSelected("按天统计", false, false, "to_day");
        SingleSelected singleSelected2 = new SingleSelected("按月统计", false, false, "to_month");
        if (isDayShow) {
            singleSelected1.setShowSelectedIcon(true);
        } else {
            singleSelected2.setShowSelectedIcon(true);
        }
        list.add(singleSelected1);
        list.add(singleSelected2);
        return list;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.titleImage:
            case R.id.title: //点击标题弹出月统计和天统计
                TitleSingleSelectedPopWindow titlePopWindow = new TitleSingleSelectedPopWindow(this, getTitleItem(),
                        isDayShow ? "按天统计" : "按月统计", R.drawable.sanjiao_shang, new TitleSingleSelectedPopWindow.TitleSingleSelectedListener() {
                    @Override
                    public void getSingleSelcted(SingleSelected bean) {
                        switch (bean.getSelecteNumber()) {
                            case "to_day": //按天统计
                                isDayShow = true;
                                break;
                            case "to_month": //按月统计
                                isDayShow = false;
                                break;
                        }
                        titleText.setText(isDayShow ? "按天统计" : "按月统计");
                        getData();
                    }

                    @Override
                    public void clickRightImage() {
                        onClick(findViewById(R.id.rightImage));
                    }
                });
                //当窗口关闭的时候需要将标题的图标状态恢复
                titlePopWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
                    @Override
                    public void onDismiss() {
                        setTitleImageState(false);
                        BackGroundUtil.backgroundAlpha(StatisticalWorkByMonthActivity.this, 1.0F);
                    }
                });
                setTitleImageState(true);
                //显示窗口
                titlePopWindow.showAtLocation(getWindow().getDecorView(), Gravity.TOP | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                break;
            case R.id.rightImage: //右上角菜单：点工按“工天”显示 / 点工按“小时”显示
                SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getItem(), new SingleSelectedPopWindow.SingleSelectedListener() {
                    @Override
                    public void getSingleSelcted(SingleSelected bean) {
                        switch (bean.getSelecteNumber()) {
                            case "1": //切换记工显示方式
                                AccountShowTypeActivity.actionStart(StatisticalWorkByMonthActivity.this);
                                break;
                            case "DOWNLOAD": //下载
                                if (adapter == null || adapter.getCount() == 0) {
                                    CommonMethod.makeNoticeShort(getApplicationContext(), "没有可下载的数据", CommonMethod.ERROR);
                                    return;
                                }
//                                AccountUtils.requestDownLoadAccountInfo(StatisticalWorkByMonthActivity.this, getIntent().getStringExtra("param1"),
//                                        getIntent().getStringExtra("param2"), getIntent().getStringExtra("param3"), getIntent().getStringExtra("param5")
//                                );
                                break;
                        }
                    }
                });
                popWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                popWindow.setAlpha(true);
                break;
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        //如果工显示方式已经被切换 则需要将数据变化了
        if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE && adapter != null && adapter.getCount() != 0) {
            fillData(statisticalWork);
            adapter.notifyDataSetChanged();
        }
        setResult(Constance.REFRESH); //只要回到当前页面就刷新数据
        getData();
    }

}

