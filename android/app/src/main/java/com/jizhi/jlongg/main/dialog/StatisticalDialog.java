package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.graphics.Color;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.style.ForegroundColorSpan;
import android.text.style.StyleSpan;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.StatisticalWork;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.RecordUtils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能:记工统计情况详情
 * 时间:2018年6月5日16:56:40
 * 作者:xuj
 */
public class StatisticalDialog extends Dialog implements View.OnClickListener {


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(StatisticalWork statisticalWork, String startTime, String startLuncher, String endTime, String endLuncher) {
        setContentView(R.layout.statistical_dialog);
        fillData(statisticalWork, startTime, startLuncher, endTime, endLuncher);
        findViewById(R.id.closeDialogIcon).setOnClickListener(this);
    }

    private void fillData(StatisticalWork statisticalWork, String startTime, String startLuncher, String endTime, String endLuncher) {

        TextView startTimeValueText = (TextView) findViewById(R.id.start_time_value_text); //开始时间
        TextView endTimeValueText = (TextView) findViewById(R.id.end_time_value_text); //结束时间

        startTimeValueText.setText(Html.fromHtml("<font color='#333333'>" + startTime + "</font><font color='#666666'>(" + startLuncher + ")</font>"));
        endTimeValueText.setText(Html.fromHtml("<font color='#333333'>" + endTime + "</font><font color='#666666'>(" + endLuncher + ")</font>"));

        TextView hourWorkManhour = (TextView) findViewById(R.id.hour_work_manhour); //点工上班小时数
        TextView hourWorkoverTime = (TextView) findViewById(R.id.hour_work_over_time); //点工加班小时数
        TextView hourWorkAmount = (TextView) findViewById(R.id.hour_work_amount); //点工总金额

        TextView contractorCheckWorkManhour = (TextView) findViewById(R.id.contractor_check_work_manhour); //包工记工天上班小时数
        TextView contractorCheckWorkOverTime = (TextView) findViewById(R.id.contractor_check_work_over_time); //包工记工天加班小时数


        TextView contractorWorkOneTotal = (TextView) findViewById(R.id.contractor_work_one_total); //包工(承包)总笔数
        TextView contractorWorkOneAmount = (TextView) findViewById(R.id.contractor_work_one_amount); //包工(承包)总金额

        TextView borrowTotal = (TextView) findViewById(R.id.borrow_total); //借支总笔数
        TextView borrowAmount = (TextView) findViewById(R.id.borrow_amount); //借支金额

        TextView balanceTotal = (TextView) findViewById(R.id.balance_total); //结算总笔数
        TextView balanceAmount = (TextView) findViewById(R.id.balance_amount); //结算金额


        String mContractorOneTotal = String.format(getContext().getApplicationContext().getString(R.string.count_account_params), (int) statisticalWork.getContract_type_one().getTotal()); //结算笔数
        String mContractorTwoTotal = String.format(getContext().getApplicationContext().getString(R.string.count_account_params), (int) statisticalWork.getContract_type_two().getTotal()); //结算笔数

        String mBorrowTotal = String.format(getContext().getApplicationContext().getString(R.string.count_account_params), (int) statisticalWork.getExpend_type().getTotal()); //借支笔数
        String mBalanceTotal = String.format(getContext().getApplicationContext().getString(R.string.count_account_params), (int) statisticalWork.getBalance_type().getTotal()); //结算笔数


        hourWorkAmount.setText("￥" + statisticalWork.getWork_type().getAmounts()); //点工金额
        //班组长角色：包工（分包）算收入金额红色显示，包工（承包）算支出绿色显示
        //4、工人角色：工人只有包工（承包），算收入红色显示
        boolean isForeman = UclientApplication.isForemanRoler(getContext().getApplicationContext());
        if (isForeman) {
            findViewById(R.id.contractor_work_two_layout).setVisibility(View.VISIBLE);
            findViewById(R.id.contractor_work_one_layout).setVisibility(View.VISIBLE);

            TextView contractorWorkTwoTotal = (TextView) findViewById(R.id.contractor_work_two_total); //包工(分包)总笔数
            TextView contractorWorkTwoAmount = (TextView) findViewById(R.id.contractor_work_two_amount); //包工(分包)总金额
            contractorWorkOneAmount.setTextColor(ContextCompat.getColor(getContext().getApplicationContext(), R.color.borrow_color));

            contractorWorkTwoAmount.setText("￥" + statisticalWork.getContract_type_two().getAmounts());
            contractorWorkTwoTotal.setText(setMoneyViewAttritube(mContractorTwoTotal, ((int) statisticalWork.getContract_type_two().getTotal()) + "",
                    Color.parseColor("#eb4e4e")));

        } else {
            findViewById(R.id.contractor_work_two_layout).setVisibility(View.GONE);
            findViewById(R.id.contractor_work_one_layout).setVisibility(View.VISIBLE);

            contractorWorkOneAmount.setTextColor(ContextCompat.getColor(getContext().getApplicationContext(), R.color.app_color));
        }

        contractorWorkOneAmount.setText("￥" + statisticalWork.getContract_type_one().getAmounts());//包工(承包)总金额
        contractorWorkOneTotal.setText(setMoneyViewAttritube(mContractorOneTotal, ((int) statisticalWork.getContract_type_one().getTotal()) + "",
                Color.parseColor(isForeman ? "#83c76e" : "#eb4e4e")));


        borrowAmount.setText("￥" + statisticalWork.getExpend_type().getAmounts()); //借支金额
        balanceAmount.setText("￥" + statisticalWork.getBalance_type().getAmounts()); //结算金额


        borrowTotal.setText(setMoneyViewAttritube(mBorrowTotal, ((int) statisticalWork.getExpend_type().getTotal()) + "", Color.parseColor("#83c76e")));
        balanceTotal.setText(setMoneyViewAttritube(mBalanceTotal, ((int) statisticalWork.getBalance_type().getTotal()) + "", Color.parseColor("#83c76e")));

        String hourWorkManhourString = "上班 " + AccountUtil.getAccountShowTypeString(getContext(), false, true, true, statisticalWork.getWork_type().getManhour(),
                statisticalWork.getWork_type().getWorking_hours());
        String hourWorkOverTimeString = "加班 " + AccountUtil.getAccountShowTypeString(getContext(), false, true, false, statisticalWork.getWork_type().getOvertime(),
                statisticalWork.getWork_type().getOvertime_hours());

        String constractorWorkManhourString = "上班 " + AccountUtil.getAccountShowTypeString(getContext(), false, true, true, statisticalWork.getAttendance_type().getManhour(),
                statisticalWork.getAttendance_type().getWorking_hours());
        String constractorWorkOverTimeString = "加班 " + AccountUtil.getAccountShowTypeString(getContext(), false, true, false, statisticalWork.getAttendance_type().getOvertime(),
                statisticalWork.getAttendance_type().getOvertime_hours());


        String hourWorkManhourValue = null;
        String hourWorkOverTimeValue = null;

        String constractorWorkManhourValue = null;
        String constractorWorkOverTimeValue = null;
        switch (AccountUtil.getDefaultAccountUnit(getContext())) {
            case AccountUtil.WORK_AS_UNIT: //以工为单位
                //点工
                hourWorkManhourValue = statisticalWork.getWork_type().getWorking_hours();
                hourWorkOverTimeValue = statisticalWork.getWork_type().getOvertime_hours();
                //包包工记工天
                constractorWorkManhourValue = statisticalWork.getAttendance_type().getWorking_hours();
                constractorWorkOverTimeValue = statisticalWork.getAttendance_type().getOvertime_hours();
                break;
            case AccountUtil.MANHOUR_AS_UNIT_OVERTIME_AS_HOUR: //上班为小时，加班显示为空
                //点工
                hourWorkManhourValue = statisticalWork.getWork_type().getWorking_hours();
                hourWorkOverTimeValue = RecordUtils.cancelIntergerZeroFloat(statisticalWork.getWork_type().getOvertime());
                //包工记工天
                constractorWorkManhourValue = statisticalWork.getAttendance_type().getWorking_hours();
                constractorWorkOverTimeValue = RecordUtils.cancelIntergerZeroFloat(statisticalWork.getAttendance_type().getOvertime());
                break;
            case AccountUtil.WORK_OF_HOUR:
                //点工
                hourWorkManhourValue = RecordUtils.cancelIntergerZeroFloat(statisticalWork.getWork_type().getManhour());
                hourWorkOverTimeValue = RecordUtils.cancelIntergerZeroFloat(statisticalWork.getWork_type().getOvertime());
                //包工记工天
                constractorWorkManhourValue = RecordUtils.cancelIntergerZeroFloat(statisticalWork.getAttendance_type().getManhour());
                constractorWorkOverTimeValue = RecordUtils.cancelIntergerZeroFloat(statisticalWork.getAttendance_type().getOvertime());
                break;
        }
        hourWorkManhour.setText(setMoneyViewAttritube(hourWorkManhourString, hourWorkManhourValue, Color.parseColor("#eb4e4e"))); //设置点工上班时长
        hourWorkoverTime.setText(setMoneyViewAttritube(hourWorkOverTimeString, hourWorkOverTimeValue, Color.parseColor("#eb4e4e"))); //设置上班时长

        contractorCheckWorkManhour.setText(setMoneyViewAttritube(constractorWorkManhourString, constractorWorkManhourValue, Color.parseColor("#eb4e4e"))); //设置点工上班时长
        contractorCheckWorkOverTime.setText(setMoneyViewAttritube(constractorWorkOverTimeString, constractorWorkOverTimeValue, Color.parseColor("#eb4e4e"))); //设置上班时长
    }

    private SpannableStringBuilder setMoneyViewAttritube(String completeString, String changeString, int textColor) {
        SpannableStringBuilder builder = new SpannableStringBuilder(completeString);
        Matcher matcher = Pattern.compile(changeString).matcher(completeString);
        while (matcher.find()) {
            builder.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), matcher.start(), matcher.end(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);  //粗体
            builder.setSpan(new ForegroundColorSpan(textColor), matcher.start(), matcher.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        }
        return builder;
    }

    @Override
    public void onClick(View v) {
        dismiss();
    }

    /**
     * @param context
     * @param statisticalWork 记账信息
     * @param startTime       开始时间
     * @param startLuncher    开始时间的农历
     * @param endTime         结束时间
     * @param endLuncher      结束时间的农历
     */
    public StatisticalDialog(BaseActivity context, StatisticalWork statisticalWork, String startTime, String startLuncher, String endTime, String endLuncher) {
        super(context, R.style.Custom_Progress);
        createLayout(statisticalWork, startTime, startLuncher, endTime, endLuncher);
        commendAttribute(true);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


}
