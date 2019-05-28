package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.Constance;


/**
 * 功能:删除质量、安全的详情
 * 时间:2016-65-11 11:55
 * 作者:hucs
 */
public class AccountWageDialog extends Dialog implements View.OnClickListener {

    /* 添加记账对象接口回调 */
    private AccountSuccessListenerClick listener;
    private String role_type;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(true);
    }

    public AccountWageDialog(Context context, String role_type, String wage_wage, String wage_supplus_unset, AccountSuccessListenerClick listener) {
        super(context, R.style.Custom_Progress);
        this.role_type = role_type;
        this.listener = listener;
        createLayout(wage_wage, wage_supplus_unset);
        commendAttribute(false);
    }

    public void setListener(AccountSuccessListenerClick listener) {
        this.listener = listener;
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String twage_wage, String wage_supplus_unset) {
        setContentView(R.layout.dialog_account_wage);
        //本次结算金额
        ((TextView) findViewById(R.id.tv_wage_wage)).setText(twage_wage);
        //剩余未结工资
        ((TextView) findViewById(R.id.tv_wage_supplus_unset)).setText(wage_supplus_unset);
        if (role_type.equals(Constance.ROLETYPE_FM)) {
            ((TextView) findViewById(R.id.tv_wage_wage_hint1)).setText("本次结算金额 = 本次实付金额 + 抹零金额 + 罚款金额- 补贴金额 - 奖励金额");
        } else {
            ((TextView) findViewById(R.id.tv_wage_wage_hint1)).setText("本次结算金额 = 本次实收金额 + 抹零金额 + 罚款金额- 补贴金额 - 奖励金额");
        }
        ((TextView) findViewById(R.id.tv_wage_supplus_unset_hint1)).setText(" 剩余未结金额= 未结工资-本次结算金额");
        findViewById(R.id.tv_finish).setOnClickListener(this);
        findViewById(R.id.tv_asscess).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_finish://左边
                dismiss();
                break;
            case R.id.tv_asscess://右边
                listener.successAccountClick();
                dismiss();
                break;
        }
    }

    public interface AccountSuccessListenerClick {
        //确认
        void successAccountClick();
    }
}
//    /* 添加记账对象接口回调 */
//    private AccountSuccessListenerClick listener;
//    private String role_type;
//    private WorkDetail workDetail;
//
//    /**
//     * 设置弹出框公共属性
//     */
//    public void commendAttribute(boolean isCancelDialog) {
//        setCanceledOnTouchOutside(isCancelDialog);
//        setCancelable(true);
//    }
//
//
//    public AccountWageDialog(Context context, String role_type, WorkDetail workDetail, AccountSuccessListenerClick listener) {
//        super(context, R.style.Custom_Progress);
//        this.role_type = role_type;
//        this.listener = listener;
//        this.workDetail = workDetail;
//        createLayout();
//        commendAttribute(false);
//    }
//
//    public void setListener(AccountSuccessListenerClick listener) {
//        this.listener = listener;
//    }
//
//    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
//    public void createLayout() {
//        setContentView(R.layout.dialog_account_wages);
//        if (role_type.equals(Constance.ROLETYPE_FM)) {
//            ((TextView) findViewById(R.id.tv_wage_wage_hint1)).setText("本次实付金额:");
//        } else {
//            ((TextView) findViewById(R.id.tv_wage_wage_hint1)).setText("本次实收金额:");
//        }
//        //本次结算金额
//        ((TextView) findViewById(R.id.tv_wage_wage)).setText("=  " + Utils.m2(Double.parseDouble(workDetail.getAmounts() + "")));
//        String wage = Utils.m2(Double.parseDouble(workDetail.getAmounts()));
//        ((TextView) findViewById(R.id.tv_wage_wage1)).setText("- " + (wage.contains("-") ? "(" + wage + ")" : wage));
//        //剩余未结工资
//        ((TextView) findViewById(R.id.tv_wage_supplus_unset)).setText("=  " + Utils.m2(workDetail.getUnbalance_amount()));
//        findViewById(R.id.tv_finish).setOnClickListener(this);
//        findViewById(R.id.tv_asscess).setOnClickListener(this);
//
//        //本次实收金额
//        ((TextView) findViewById(R.id.tv_pay_amount)).setText(Utils.m2(Double.parseDouble(workDetail.getPay_amount() + "")));
//        //抹零金额
//        ((TextView) findViewById(R.id.tv_deduct_amount)).setText("+  " + Utils.m2(workDetail.getDeduct_amount()));
//        //罚款金额
//        ((TextView) findViewById(R.id.tv_penalty_amount)).setText("+  " + Utils.m2(workDetail.getPenalty_amount()));
//        //补贴金额
//        ((TextView) findViewById(R.id.tv_subsidy_amount)).setText("-  " + Utils.m2(workDetail.getSubsidy_amount()));
//        //奖励金额
//        ((TextView) findViewById(R.id.tv_reward_amount)).setText("-  " + Utils.m2(workDetail.getReward_amount()));
//        //未结工资
//        ((TextView) findViewById(R.id.tv_balance_amount)).setText("" + Utils.m2(workDetail.getBalance_amount()));
//    }
//
//
//    @Override
//    public void onClick(View v) {
//        switch (v.getId()) {
//            case R.id.tv_finish://左边
//                dismiss();
//                break;
//            case R.id.tv_asscess://右边
//                listener.successAccountClick();
//                dismiss();
//                break;
//        }
//    }
//
//    public interface AccountSuccessListenerClick {
//        //确认
//        void successAccountClick();
//    }
//
//}
