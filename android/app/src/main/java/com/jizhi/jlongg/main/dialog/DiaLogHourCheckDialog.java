package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.os.Build;
import android.support.annotation.Nullable;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.view.View;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Salary;

import org.apache.poi.ss.formula.functions.T;

/**
 * 功能:添加班组成员
 * 时间:2016年9月14日 15:40:05
 * 作者:xuj
 */
public class DiaLogHourCheckDialog extends Dialog implements View.OnClickListener {
    /* 添加记账对象接口回调 */
    private AccountSuccessListenerClick listener;
    /*是否是包工记工天*/
    private boolean isAllwork;
//    private String role_type;


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(false);
    }


    public DiaLogHourCheckDialog(Context context, String other_name, Salary my_tpl, Salary oth_tpl, boolean isAllwork, AccountSuccessListenerClick listener) {
        super(context, R.style.Custom_Progress);
        this.listener = listener;
        this.isAllwork = isAllwork;
//        this.role_type = role_type;
        createLayout(context, other_name, my_tpl, oth_tpl);
        commendAttribute(false);
    }

    public void setListener(AccountSuccessListenerClick listener) {
        this.listener = listener;
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(Context context, String other_name, Salary my_tpl, Salary oth_tpl) {
        setContentView(R.layout.dialog_hour_check);
        findViewById(R.id.tv_cancel).setOnClickListener(this);
        findViewById(R.id.tv_asscess).setOnClickListener(this);
//        if (my_tpl.getW_h_tpl() != oth_tpl.getW_h_tpl()) {
//            ((TextView) findViewById(R.id.tv_w_h_tpl_other)).setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
//        }
//        if (my_tpl.getO_h_tpl() != oth_tpl.getO_h_tpl()) {
//            ((TextView) findViewById(R.id.tv_o_h_tpl_other)).setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
//        }
        //4.0.2显示工资模板方式
        int my_hour_type = my_tpl.getHour_type();
        int oth_hour_type = oth_tpl.getHour_type();
        if (my_hour_type==1){
            ((TextView) findViewById(R.id.tv_w_h_tpl_my)).setText((my_tpl.getW_h_tpl() + "小时算一个工").replace(".0", ""));
            ((TextView) findViewById(R.id.tv_o_h_tpl_my)).setText(String.format("%s元/小时", Utils.m2(my_tpl.getO_s_tpl())));
        }else {
            ((TextView) findViewById(R.id.tv_w_h_tpl_my)).setText((my_tpl.getW_h_tpl() + "小时算一个工").replace(".0", ""));
            ((TextView) findViewById(R.id.tv_o_h_tpl_my)).setText((my_tpl.getO_h_tpl() + "小时算一个工").replace(".0", ""));
        }
        if (oth_hour_type==1){
            ((TextView) findViewById(R.id.tv_w_h_tpl_other)).setText((oth_tpl.getW_h_tpl() + "小时算一个工").replace(".0", ""));
            ((TextView) findViewById(R.id.tv_o_h_tpl_other)).setText(String.format("%s元/小时", Utils.m2(oth_tpl.getO_s_tpl())));
        }else {
            ((TextView) findViewById(R.id.tv_w_h_tpl_other)).setText((oth_tpl.getW_h_tpl() + "小时算一个工").replace(".0", ""));
            ((TextView) findViewById(R.id.tv_o_h_tpl_other)).setText((oth_tpl.getO_h_tpl() + "小时算一个工").replace(".0", ""));
        }
//        ((TextView) findViewById(R.id.tv_w_h_tpl_my)).setText((my_tpl.getW_h_tpl() + "小时算一个工").replace(".0", ""));
//        ((TextView) findViewById(R.id.tv_o_h_tpl_my)).setText((my_tpl.getO_h_tpl() + "小时算一个工").replace(".0", ""));
//        ((TextView) findViewById(R.id.tv_w_h_tpl_other)).setText((oth_tpl.getW_h_tpl() + "小时算一个工").replace(".0", ""));
//        ((TextView) findViewById(R.id.tv_o_h_tpl_other)).setText((oth_tpl.getO_h_tpl() + "小时算一个工").replace(".0", ""));
        String w_h_tpl_other = ((TextView) findViewById(R.id.tv_w_h_tpl_other)).getText().toString();
        String w_h_tpl_my = ((TextView) findViewById(R.id.tv_w_h_tpl_my)).getText().toString();
        String o_h_tpl_other = ((TextView) findViewById(R.id.tv_o_h_tpl_other)).getText().toString();
        String o_h_tpl_my = ((TextView) findViewById(R.id.tv_o_h_tpl_my)).getText().toString();
        if (!w_h_tpl_other.equals(w_h_tpl_my)){
            ((TextView) findViewById(R.id.tv_w_h_tpl_other)).setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
        }
        if (!o_h_tpl_other.equals(o_h_tpl_my)){
            ((TextView) findViewById(R.id.tv_o_h_tpl_other)).setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
        }
        ((TextView) findViewById(R.id.tv_name_other)).setText(other_name);
        if (!isAllwork) {
            ((TextView) findViewById(R.id.tv_title)).setText(Html.fromHtml("<font color='#000000'>" + other_name + "</font>与你设置的工资标准不一样"));
            ((TextView) findViewById(R.id.tv_cancel)).setText("使用我的标准");
            ((TextView) findViewById(R.id.tv_asscess)).setText("同意他的工资标准");

        } else {
            ((TextView) findViewById(R.id.tv_title)).setText(Html.fromHtml("<font color='#000000'>" + other_name + "</font>与你设置的考勤模版不一样"));
            ((TextView) findViewById(R.id.tv_cancel)).setText("使用我的模版");
            ((TextView) findViewById(R.id.tv_asscess)).setText("同意他的考勤模版");

        }


    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_cancel://左边
                listener.cancelAccountClick();
                dismiss();
                break;
            case R.id.tv_asscess://右边
                listener.successAccountClick();
                dismiss();
                break;
        }
    }

    @Override
    public void setOnDismissListener(@Nullable OnDismissListener listener) {
        super.setOnDismissListener(listener);
    }

    public interface AccountSuccessListenerClick {
        //确认
        void successAccountClick();

        //取消
        void cancelAccountClick();
    }

}
