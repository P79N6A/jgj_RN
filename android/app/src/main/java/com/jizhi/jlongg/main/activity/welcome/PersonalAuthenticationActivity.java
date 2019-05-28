package com.jizhi.jlongg.main.activity.welcome;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.IDU;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;
import com.lidroid.xutils.view.annotation.ViewInject;
import com.lidroid.xutils.view.annotation.event.OnClick;

import java.util.regex.Pattern;

/**
 * 个人认证
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2016-1-13 上午10:55:23
 */
public class PersonalAuthenticationActivity extends BaseActivity {

    private String TAG = getClass().getName();

    // 姓名
    @ViewInject(R.id.ed_name)
    private EditText ed_name;
    // 身份证号码
    @ViewInject(R.id.ed_idcard)
    private EditText ed_idcard;

    // -1 认证失败0未认证1认证中2已认证
    private int verified = 0;
    /**
     * 是否提交了认证
     */
    private boolean isSubmit;
    private String realname, icno;
    private ImageView certification_icon;
    private TextView top_first_desc;
    private RelativeLayout top_layout;
    private TextView top_second_desc;
    private Button btn_submit;
    private LinearLayout bottom_layout;

    public PersonalAuthenticationActivity() {
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_personal_authentication);
        ViewUtils.inject(this);
        setTextTitle(R.string.personauth);
        verified = getIntent().getIntExtra("verified", 0);
        initView();
        initUI();
    }


    public void initView() {
        TextView personauth_hint3 = (TextView) findViewById(R.id.personauth_hint3);
        personauth_hint3.setText(getString(R.string.personauth_hint3));
        top_layout = (RelativeLayout) findViewById(R.id.top_layout); // 顶部Layout
        certification_icon = (ImageView) findViewById(R.id.certification_icon);//顶部图片
        top_first_desc = (TextView) findViewById(R.id.top_first_desc);//顶部 第一行文字描述
        top_second_desc = (TextView) findViewById(R.id.top_second_desc);//顶部 第 二行文字描述
        btn_submit = (Button) findViewById(R.id.btn_submit);//提交认证按钮
        bottom_layout = (LinearLayout) findViewById(R.id.bottom_layout); //底部Layout
        realname = getIntent().getStringExtra("name");
        icno = getIntent().getStringExtra("icno");
        ed_name.setText(realname);
        if (null == icno || icno.equals("")) {
            ed_idcard.setText("");
        } else {
            ed_idcard.setText(idCardSplit(icno));
        }
    }


    private void initUI() {
        if (verified == -1) { //认证失败
            top_layout.setVisibility(View.VISIBLE);
            btn_submit.setText("重新提交认证");
            certification_icon.setImageResource(R.drawable.icon_authenfail);
            top_first_desc.setText(getString(R.string.personauth_hint8));
            top_second_desc.setText(getString(R.string.personauth_hint9));
            top_second_desc.setTextSize(14);
            top_second_desc.setTextColor(getResources().getColor(R.color.app_color));
            ed_name.setEnabled(true);
            ed_idcard.setEnabled(true);
            bottom_layout.setVisibility(View.VISIBLE);
            btn_submit.setVisibility(View.VISIBLE);
        } else if (verified == 0) { //未认证
            top_layout.setVisibility(View.GONE);
            btn_submit.setText("提交认证");
            bottom_layout.setVisibility(View.VISIBLE);
            btn_submit.setVisibility(View.VISIBLE);
            ed_name.setEnabled(true);
            ed_idcard.setEnabled(true);
        } else if (verified == 1) { //认证中
            top_layout.setVisibility(View.VISIBLE);
            btn_submit.setVisibility(View.GONE);
            certification_icon.setImageResource(R.drawable.icon_authening);
            top_first_desc.setText(getString(R.string.personauth_hint6));
            top_second_desc.setText(getString(R.string.personauth_hint7));
            top_second_desc.setTextSize(11);
            top_second_desc.setTextColor(getResources().getColor(R.color.gray_8b8b8b));
            ed_name.setEnabled(false);
            ed_idcard.setEnabled(false);
            bottom_layout.setVisibility(View.GONE);
            btn_submit.setVisibility(View.GONE);
        } else if (verified == 2) { //已认证
            top_layout.setVisibility(View.VISIBLE);
            certification_icon.setImageResource(R.drawable.icon_authenok);
            top_first_desc.setText(getString(R.string.personauth_hint4));
            top_second_desc.setText(getString(R.string.personauth_hint5));
            top_second_desc.setTextSize(11);
            top_second_desc.setTextColor(getResources().getColor(R.color.gray_8b8b8b));
            ed_name.setEnabled(false);
            ed_idcard.setEnabled(false);
            bottom_layout.setVisibility(View.GONE);
            btn_submit.setVisibility(View.GONE);
        }
    }

    @OnClick(R.id.btn_submit)
    public void submitClick(View view) {
        String name = ed_name.getText().toString().trim();
        if (TextUtils.isEmpty(name)) {
            CommonMethod.makeNoticeShort(this, getString(R.string.name_null), CommonMethod.ERROR);
            return;
        }
        String ruler = "(([\u4E00-\u9FA5]{2,7})|([a-zA-Z]{3,10}))";
        if (!Pattern.matches(ruler, name)) {
            CommonMethod.makeNoticeShort(this, "姓名格式不正确", CommonMethod.ERROR);
            return;
        }
        String idCard = ed_idcard.getText().toString().trim();
        if (TextUtils.isEmpty(idCard)) {
            CommonMethod.makeNoticeShort(this, getString(R.string.idcard_null), CommonMethod.ERROR);
            return;
        }
        boolean isIdCard = Utils.JudgeIDCard(ed_idcard.getText().toString().trim().toUpperCase());
        if (!isIdCard) {
            CommonMethod.makeNoticeShort(this, getString(R.string.idcard_error), CommonMethod.ERROR);
            return;
        }
        personAuth();
    }

    public String idCardSplit(String str) {
        if (null == str || str.length() != 18) {
            return str;
        }
        str = str.substring(0, 10) + "****" + str.substring(14);
        return str;

    }

    public RequestParams params() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("realname", ed_name.getText().toString().trim());
        params.addBodyParameter("icno", ed_idcard.getText().toString().trim().toUpperCase());
        return params;
    }

    /**
     * 提交个人认证
     */
    public void personAuth() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.IDAUTH, params(), new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    LUtils.e(TAG, responseInfo.result);
                    CommonJson<IDU> bean = CommonJson.fromJson(responseInfo.result, IDU.class);
                    if (bean.getState() != 0) {
                        isSubmit = true;
                        verified = bean.getValues().getVerified();
                        initUI();
                    } else {
                        CommonMethod.makeNoticeShort(PersonalAuthenticationActivity.this, bean.getErrmsg(), CommonMethod.ERROR);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(PersonalAuthenticationActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }
        });
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (isSubmit) {
            Intent intent = getIntent();
            intent.putExtra("verified", verified);
            intent.putExtra("idCard", ed_idcard.getText().toString()); //身份证号码
            intent.putExtra("idCardName", ed_name.getText().toString()); //身份证名称
            setResult(Constance.INFOMATION, intent);
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public void onFinish(View view) {
        if (isSubmit) {
            Intent intent = getIntent();
            intent.putExtra("verified", verified);
            intent.putExtra("idCard", ed_idcard.getText().toString()); //身份证号码
            intent.putExtra("idCardName", ed_name.getText().toString()); //身份证名称
            setResult(Constance.INFOMATION, intent);
        }
        finish();
    }
}
