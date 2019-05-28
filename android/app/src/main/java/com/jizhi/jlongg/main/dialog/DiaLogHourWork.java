package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.EveryDayAttenDanceActivity;
import com.jizhi.jlongg.main.activity.RecordWorkConfirmActivity;
import com.jizhi.jlongg.main.activity.RememberWorkerInfosActivity;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;

import java.util.Calendar;

/**
 * 功能:没有更多项目
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogHourWork extends Dialog implements View.OnClickListener {

    //上下文
    private Activity context;
   //记账ID
    private String record_id;
    //关闭弹窗
    private CloseDialogListener closeDialogListener;
    //记账类型
    private String account_type;
    //用户uid，记账日期，用户名字
    private String uid, date;
    //被记账人uid
//    private String real_name,account_uid;
    private int is_next_act;
    //带班长信息
    private AgencyGroupUser agencyGroupUser;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }



    /**
     * 记账添加工人、工头
     */
    public DiaLogHourWork(Activity context, String desc) {
        super(context, R.style.Custom_Progress);
        createLayout(desc);
        commendAttribute(true);
    }

    /**
     * 记账添加工人、工头
     */
    public DiaLogHourWork(Activity context, String account_type, String desc, String record_id, String uid, String date, int is_next_act, AgencyGroupUser agencyGroupUser, CloseDialogListener closeDialogListener) {
        super(context, R.style.Custom_Progress);
        this.context = context;
        this.record_id = record_id;
        this.account_type = account_type;
        this.uid = uid;
        this.date = date;
        this.is_next_act = is_next_act;
        this.agencyGroupUser = agencyGroupUser;
        this.closeDialogListener = closeDialogListener;
        createLayout(desc);
        commendAttribute(true);
    }

//    public void setReal_name(String real_name) {
//        this.real_name = real_name;
//    }
//
//    public void setAccount_uid(String account_uid) {
//        this.account_uid = account_uid;
//    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String desc) {
        setContentView(R.layout.dialog_bottom_white);
        if (is_next_act == 1) {
            findViewById(R.id.lin_is_next_act).setVisibility(View.VISIBLE);
            findViewById(R.id.redBtn).setVisibility(View.GONE);
            findViewById(R.id.closeIcon).setVisibility(View.GONE);
        } else {
            findViewById(R.id.lin_is_next_act).setVisibility(View.GONE);
            findViewById(R.id.redBtn).setVisibility(View.VISIBLE);
            findViewById(R.id.closeIcon).setVisibility(View.VISIBLE);
        }
        TextView tv_content = findViewById(R.id.tv_content);
        tv_content.setText(desc);
        TextView close = findViewById(R.id.redBtn);
        tv_content.setGravity(Gravity.LEFT);
        if (TextUtils.isEmpty(record_id) && TextUtils.isEmpty(uid) && TextUtils.isEmpty(date)) {
            close.setText("我知道了");
        } else {
            close.setText("查看该记账");
        }
        close.setOnClickListener(this);
        findViewById(R.id.closeIcon).setOnClickListener(this);
        findViewById(R.id.btn_cancel).setOnClickListener(this);
        findViewById(R.id.btn_asscess).setOnClickListener(this);
        ((TextView) findViewById(R.id.btn_asscess)).setText("继续保存");
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn: //关闭
                //is_next_act ==0继续记账 有uid记工记账 无uid每日考勤
                if (!TextUtils.isEmpty(uid)) {
                    if (null != agencyGroupUser && !TextUtils.isEmpty(agencyGroupUser.getGroup_id())) {
                        RecordWorkConfirmActivity.actionStart(context, date, uid, null, agencyGroupUser, null,null);
                    } else {
                        RecordWorkConfirmActivity.actionStart(context, date, uid, null);
                    }
                } else {
                    //带班长记账需要传入带班长信息
                    if (null != agencyGroupUser && !TextUtils.isEmpty(agencyGroupUser.getGroup_id())) {
                        int month = Calendar.getInstance().get(Calendar.MONTH) + 1;
                        RememberWorkerInfosActivity.actionStart(context, Calendar.getInstance().get(Calendar.YEAR) + "", month < 10 ? "0" + month : String.valueOf(month), agencyGroupUser);
                    } else {
                        //普通记账传入被记账信息
                        if (date.length() == 8) {
//                            RememberWorkerInfosActivity.actionStart(context, date.substring(0, 4), date.substring(4, 6),account_uid,TextUtils.isEmpty(real_name)?"":real_name,null,null,UclientApplication.getRoler(context));
                            String time = date.substring(0, 4) + "-" + date.substring(4, 6) + "-" + date.substring(6, date.length());
                            EveryDayAttenDanceActivity.actionStart(context, time);
                        }
                    }

                }
                dismiss();
                break;
            case R.id.closeIcon: //关闭
            case R.id.btn_cancel: //取消
                dismiss();
                closeDialogListener.closeDialogClick();
                break;
            case R.id.btn_asscess: //确定,继续记账
                dismiss();
                closeDialogListener.accountRelease(is_next_act);
                break;
        }
    }

    public interface CloseDialogListener {
        void closeDialogClick();

        void accountRelease(int is_next_act);
    }
}
