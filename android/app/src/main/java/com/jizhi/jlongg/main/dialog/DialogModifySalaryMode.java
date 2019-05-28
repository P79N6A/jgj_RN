package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;


/**
 * 功能:文本弹出框
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DialogModifySalaryMode extends Dialog implements View.OnClickListener {


    private DiaLogTitleListener listener;
    private EditText ed_price;
    private Activity activity;
    private String ids;
    private String role;
    private CustomProgress customProgress;


    public DialogModifySalaryMode(Activity activity, DiaLogTitleListener listener, int length, String ids, String role) {
        super(activity, R.style.Custom_Progress);
        this.listener = listener;
        this.activity = activity;
        this.ids = ids;
        this.role = role;
        commendAttribute(true);
        createLayout(length);
    }

    public void createLayout(int length) {
        setContentView(R.layout.dialog_modify_salary_mode);
        ed_price = findViewById(R.id.ed_price);
        ed_price.setHint(role.equals(Constance.ROLETYPE_WORKER) ? "请输入与班组长协商的金额" : "请输入与工人协商的金额");
        findViewById(R.id.btn_cancel).setOnClickListener(this);
        findViewById(R.id.btn_accsess).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (TextUtils.isEmpty(ed_price.getText().toString().trim())) {
                    CommonMethod.makeNoticeShort(activity, "请设置工资金额", false);
                    return;
                }
                String salary = ed_price.getText().toString().trim();
                if (salary.endsWith(".")) {
                    salary = salary.replace(".", "");
                }
                setSalary(salary);
            }
        });
        findViewById(R.id.btn_cancel).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
        ((TextView) findViewById(R.id.tv_account_count)).setText(Html.fromHtml("<font color='#000000'>本次共选中 </font><font color='#eb4e4e'>" + length + "</font><font color='#000000'>笔 点工</font>"));
        ;

        Utils.setEditTextDecimalNumberLength(ed_price, 6, 2);


    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess: //确认
                LUtils.e("-----11-------");
                if (TextUtils.isEmpty(ed_price.getText().toString().trim())) {
                    CommonMethod.makeNoticeShort(activity, "请设置工资金额", false);
                    return;
                }
                LUtils.e("-----22-------" + ed_price.getText().toString().trim());

//                setSalary();
                return;
        }
//        dismiss();
    }


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public void createCustomDialog() {
        if (customProgress != null) {
        } else {
            customProgress = new CustomProgress(activity);
            customProgress.show(activity, "加载中…", false);
        }
    }

    public void closeDialog() {
        if (null != customProgress && customProgress.isShowing()) {
            customProgress.closeDialog();
            customProgress = null;
        }
    }

    /**
     * 批量工资模版设置
     */

    public void setSalary(String salary) {
        createCustomDialog();
        final RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("record_id", ids);
        params.addBodyParameter("salary", salary);

        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.SET_BATCH_SALARY_TPL, params,
                new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<BaseNetBean> bean = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                            if (bean.getMsg().equals(Constance.SUCCES_S)) {
                                CommonMethod.makeNoticeShort(activity, "工资标准修改成功！", CommonMethod.SUCCESS);
                                LocalBroadcastManager.getInstance(activity).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                                listener.clickAccess(0);
                                dismiss();
                            } else {
                                DataUtil.showErrOrMsg(activity, bean.getErrno(), bean.getErrmsg());

                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                        }
                        closeDialog();
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {
                        closeDialog();
                        CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                    }
                });
    }


}
