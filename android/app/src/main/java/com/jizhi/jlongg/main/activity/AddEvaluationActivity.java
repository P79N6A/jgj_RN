package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.ProjectBase;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.StarUtil;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.MyRattingBar;
import com.jizhi.jongg.widget.MyRattingBar.ClickStar;
import com.jizhi.jongg.widget.WorkLinerLayout;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;
import com.lidroid.xutils.view.annotation.ViewInject;

/**
 * 功能: 新增评价
 * 时间:2016/3/11 11:19
 * 作者: xuj
 */
public class AddEvaluationActivity extends BaseActivity implements OnClickListener, ClickStar {
    /**
     * 个人诚信
     */
    @ViewInject(R.id.credibility)
    private MyRattingBar credibility;
    /**
     * 结款速度
     */
    @ViewInject(R.id.payspeed)
    private MyRattingBar payspeed;
    /**
     * 带人态度
     */
    @ViewInject(R.id.appetence)
    private MyRattingBar appetence;
    /**
     * 是否匿名
     */
    @ViewInject(R.id.hidename_linearlayout)
    private LinearLayout hidename_linearlayout;
    /**
     * 是否匿名
     */
    @ViewInject(R.id.anonymous)
    private CheckBox checkBox;
    /**
     * 评论内容
     */
    @ViewInject(R.id.content)
    private EditText content;

    /**
     * 个人诚信文字
     */
    @ViewInject(R.id.credibility_text)
    private TextView credibility_text;
    /**
     * 结款速度文字
     */
    @ViewInject(R.id.payspeed_text)
    private TextView payspeed_text;
    /**
     * 带人态度文字
     */
    @ViewInject(R.id.appetence_text)
    private TextView appetence_text;
    /**
     * 剩余字数
     */
    @ViewInject(R.id.surplus_Words)
    private TextView surplus_Words;
    /**
     * 是否匿名 true 代表匿名 false 代表不匿名
     */
    private boolean isChecked = true;
    /**
     * 项目id
     */
    private int pid;


    /**
     * 清除星星图片内存
     */
    public void onFinish(View view) {
        credibility.recycle();
        payspeed.recycle();
        appetence.recycle();
        finish();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_evaluate);
        ViewUtils.inject(this);//Xutil必须调用的一句话
        SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.add_evaluation));
        init();
    }

    private TextWatcher watcher = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
            surplus_Words.setText("剩" + (500 - s.toString().length()) + "字");
        }

        @Override
        public void afterTextChanged(Editable s) {
        }

    };

    private void init() {
        ProjectBase bean = (ProjectBase) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (bean == null) {
            finish();
            return;
        }
        getTextView(R.id.protitle).setText(bean.getProtitle()); // 项目标题
        getTextView(R.id.ctime).setText(bean.getCreate_time_txt()); // 发布时间
        getTextView(R.id.review_cnt).setText(String.format(getString(R.string.review_cnt), bean.getReview_cnt())); // 浏览次数
        getTextView(R.id.proname).setText(bean.getProname()); // 项目名称
        getTextView(R.id.proaddress).setText(bean.getProaddress()); // 项目地址
        WorkLinerLayout linear = (WorkLinerLayout) findViewById(R.id.worklevel_list); //工种详情
//        linear.createSonView(this, bean.getClasses()); //设置工种详情
        pid = bean.getPid();
        credibility.setListener(this);
        payspeed.setListener(this);
        appetence.setListener(this);
        checkBox.setOnCheckedChangeListener(new OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView,
                                         boolean isChecked) {
                if (AddEvaluationActivity.this.isChecked != isChecked) {
                    AddEvaluationActivity.this.isChecked = isChecked;
                }
            }
        });
        content.addTextChangedListener(watcher);
    }

    public RequestParams params() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("credibility", credibility.getGrade() + "");// 诚信度
        params.addBodyParameter("payspeed", payspeed.getGrade() + "");// 付款速度
        params.addBodyParameter("appetence", appetence.getGrade() + "");// 待人态度
        params.addBodyParameter("pid", pid + "");// 项目id
        params.addBodyParameter("content", TextUtils.isEmpty(content.getText().toString()) ? "还不错哦" : content.getText().toString()); //评价内容
        params.addBodyParameter("hidename", isChecked ? "1" : "0");// 是否匿名 1.匿名 // 0.不匿名
        return params;
    }

    /**
     * 新增评价
     */
    public void addEvaluation() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.TOAPPRAISE,
                params(), new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            Gson gson = new Gson();
                            BaseNetBean base = gson.fromJson(responseInfo.result, BaseNetBean.class);
                            if (base.getState() != 0) {
                                Intent intent = new Intent(AddEvaluationActivity.this, EvaluationActivity.class);
                                intent.putExtra(Constance.PID, pid);
                                intent.putExtra(Constance.BEAN_STRING, getTextView(R.id.protitle).getText().toString());
                                startActivity(intent);
                                CommonMethod.makeNoticeShort(AddEvaluationActivity.this, "评价成功 快去查看吧!",CommonMethod.SUCCESS);
                                setResult(Constance.RESULTENEVALUATION, getIntent());
                                finish();
                            } else {
                                DataUtil.showErrOrMsg(AddEvaluationActivity.this, base.getErrno(), base.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(AddEvaluationActivity.this, getString(R.string.service_err),CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }
                });
    }

    /**
     * 设置星星点击事件
     */
    @Override
    public void click(View view, int grade) {
        switch (view.getId()) {
            case R.id.credibility:
                credibility_text.setText(StarUtil.getStarText(grade, this));
                break;
            case R.id.payspeed:
                payspeed_text.setText(StarUtil.getStarText(grade, this));
                break;
            case R.id.appetence:
                appetence_text.setText(StarUtil.getStarText(grade, this));
                break;
            default:
                break;
        }
    }



    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.submit: //新增评论
                addEvaluation();
                break;
            case R.id.hidename_linearlayout: //是否匿名
                isChecked = !isChecked;
                checkBox.setChecked(isChecked);

                break;
            default:
                break;
        }
    }

}
