package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.SynBill;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.regex.Pattern;

/**
 * 功能:编辑同步人
 * 作者：xuj
 * 时间: 2016-5-9 15:37
 */
public class EditSynchPersonActivity extends BaseActivity implements View.OnClickListener {
    private SynBill synchBill;
    private EditText username_textview;
    private EditText remark_textview;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.syn_editor);
        ViewUtils.inject(this); // Xutil必须调用的一句话
        setTextTitle(R.string.edit_synch_object);
        init();
    }

    public void init() {
        synchBill = (SynBill) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (null == synchBill) {
            CommonMethod.makeNoticeShort(EditSynchPersonActivity.this, "程序出错", CommonMethod.ERROR);
        }
        String userName = synchBill.getReal_name();
        String remark = synchBill.getDescript();
        if (remark == null) {
            remark = "";
        }
        getTextView(R.id.telph).setText(synchBill.getTelephone());
        username_textview = (EditText) findViewById(R.id.username);
        remark_textview = (EditText) findViewById(R.id.remark);
        username_textview.setText(userName);
        remark_textview.setText(remark);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.save_update: //保存修改
                String nickNamevalue = username_textview.getText().toString();
                if (TextUtils.isEmpty(nickNamevalue)) {
                    CommonMethod.makeNoticeShort(EditSynchPersonActivity.this, "姓名不能为空", CommonMethod.ERROR);
                    return;
                }
                String ruler = "(([\u4E00-\u9FA5]{2,7})|([a-zA-Z]{3,10}))";
                if (!Pattern.matches(ruler, nickNamevalue)) {
                    CommonMethod.makeNoticeShort(EditSynchPersonActivity.this, "姓名格式不正确", CommonMethod.ERROR);
                    return;
                }

                if (synchBill.getReal_name().trim().equals(username_textview.getText().toString().trim()) && synchBill.getDescript().trim().equals(remark_textview.getText().toString().trim())) {
                    finish();
                    return;
                }

                changeSynchPbject(nickNamevalue);
                break;
        }
    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }

    /**
     * 提交所需参数
     */
    public RequestParams params() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("realname", username_textview.getText().toString()); //姓名
        params.addBodyParameter("telph", synchBill.getTelephone()); //电话号码
        params.addBodyParameter("descript", remark_textview.getText().toString()); //备注
        params.addBodyParameter("option", "u"); //如果是添加传a，如果是修改传u
        return params;
    }

    /**
     * 添加人员信息
     */
    public void changeSynchPbject(String nickNamevalue) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("realname", nickNamevalue); //姓名
        params.addBodyParameter("telph", synchBill.getTelephone()); //电话号码
        params.addBodyParameter("descript", remark_textview.getText().toString()); //备注
        params.addBodyParameter("option", "u"); //如果是添加传a，如果是修改传u
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.OPTUSERSYN, params,
                new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        CommonListJson<CommonListJson> bean = CommonListJson.fromJson(responseInfo.result, CommonListJson.class);
                        if (bean.getState() != 0) {
                            CommonMethod.makeNoticeShort(EditSynchPersonActivity.this, "修改成功", CommonMethod.SUCCESS);
                            synchBill.setReal_name(username_textview.getText().toString());
                            synchBill.setDescript(remark_textview.getText().toString());
                            Intent intent = new Intent();
                            intent.putExtra(Constance.BEAN_CONSTANCE, synchBill);
                            setResult(Constance.EDITOR_SUCCESS, intent);
                            finish();
                        } else {
                            DataUtil.showErrOrMsg(EditSynchPersonActivity.this, bean.getErrno(), bean.getErrmsg());
                        }
                        closeDialog();
                    }
                });
    }
}
