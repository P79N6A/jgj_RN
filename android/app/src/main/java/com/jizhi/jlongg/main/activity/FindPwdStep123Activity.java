package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.CallPhoneUtil;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.FindPwdQuestionAdapter;
import com.jizhi.jlongg.main.bean.FindPwdQuestion;
import com.jizhi.jlongg.main.dialog.DiaLogRedLongProgress;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.HandleDataListView;
import com.jizhi.jongg.widget.PageListView;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.regex.Pattern;

/**
 * 找回密码 步骤1,2,3
 *
 * @author Xuj
 * @time 2018年6月11日10:30:09
 */

public class FindPwdStep123Activity extends BaseActivity implements View.OnClickListener {

    /**
     * 问题详情数据
     */
    private ArrayList<FindPwdQuestion> questions;
    /**
     * 只有实名认证弹出的弹出框
     */
    private EditText idCardEdit;
    /**
     * 已实名认证文本
     */
    private TextView options;
    /**
     * 是否还会跳转到下一个页面
     */
    private boolean intentNextActivity;
    /**
     * 问题3 返回的token,验证的时候需要传递给服务器
     */
    private String question3Token;
    /**
     * 问题
     */
    private TextView questionTitleText;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param telphone   原电话号码
     * @param idCard     实名认证身份
     * @param step       步骤 总共分为3步   前两步为实名认证、平常使用的功能模块
     *                   步骤1.和步骤2.是在本地生成的数据 步骤3.需要调用服务器
     * @param selecteIds 问题选项ids 主要是带入上一个问题所选的id
     */
    public static void actionStart(Activity context, String telphone, String idCard, int step, String selecteIds) {
        Intent intent = new Intent(context, FindPwdStep123Activity.class);
        intent.putExtra(Constance.TELEPHONE, telphone);
        intent.putExtra(Constance.ID, idCard);
        intent.putExtra(Constance.BEAN_INT, step);
        intent.putExtra(Constance.SELECTED_IDS, selecteIds);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param telphone 原电话号码
     * @param idCard   实名认证身份
     * @param step     步骤 总共分为3步   前两步为实名认证、平常使用的功能模块
     *                 步骤1.和步骤2.是在本地生成的数据 步骤3.需要调用服务器
     */
    public static void actionStart(Activity context, String telphone, String idCard, int step) {
        Intent intent = new Intent(context, FindPwdStep123Activity.class);
        intent.putExtra(Constance.TELEPHONE, telphone);
        intent.putExtra(Constance.ID, idCard);
        intent.putExtra(Constance.BEAN_INT, step);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param telphone 原电话号码
     * @param step     步骤 总共分为3步   前两步为实名认证、平常使用的功能模块
     *                 步骤1.和步骤2.是在本地生成的数据 步骤3.需要调用服务器
     */
    public static void actionStart(Activity context, String telphone, int step) {
        Intent intent = new Intent(context, FindPwdStep123Activity.class);
        intent.putExtra(Constance.TELEPHONE, telphone);
        intent.putExtra(Constance.BEAN_INT, step);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setRestartWebSocketService(false);
        setContentView(R.layout.listview_bottom_red_btn);
        initView();
    }

    private void initView() {
        setTextTitle(R.string.find_pwd);
        Intent intent = getIntent();
        int step = intent.getIntExtra(Constance.BEAN_INT, 1);
        View headView = getLayoutInflater().inflate(R.layout.find_pwd_title, null);
        TextView telephoneText = (TextView) headView.findViewById(R.id.telephoneText);
        questionTitleText = (TextView) headView.findViewById(R.id.questionTitleText);
        Button redBtn = getButton(R.id.red_btn);
        PageListView listView = (PageListView) findViewById(R.id.listView);
        Utils.setBackGround(listView, getResources().getDrawable(R.color.white)); //设置背景色
        telephoneText.setText(intent.getStringExtra(Constance.TELEPHONE)); //设置原手机号码
        listView.addHeaderView(headView, null, false); // 加载对话框);
        switch (step) {
            case 1:
                questionTitleText.setText(getQuestionTitle(step)); //设置问题标题
                redBtn.setText(R.string.next);
                handlerStep1(step, headView, listView);
                break;
            case 2:
                questionTitleText.setText(getQuestionTitle(step)); //设置问题标题
                redBtn.setText(R.string.next);
                handlerStep2(step, headView, listView);
                break;
            case 3:
                String ids = intent.getStringExtra(Constance.SELECTED_IDS);
                if (TextUtils.isEmpty(ids)) {
                    finish();
                    return;
                }
                //如果选项里面包含了记工选项 那么就还会有步骤4验证记工对象的手机号码
                //如果没有包含记工选项，那么就不需要跳转到步骤3直接在步骤3就验证数据
                if (ids.contains("1")) {
                    redBtn.setText(R.string.next);
                    intentNextActivity = true;
                } else {
                    redBtn.setText(R.string.start_validation);
                    intentNextActivity = false;
                }
                handlerStep3(step, listView, questionTitleText);
                break;
        }
    }

    /**
     * 获取选项的cids
     *
     * @return
     */
    private String getSelecteQuestionCids() {
        if (questions == null || questions.size() == 0)
            return null;
        StringBuilder builder = new StringBuilder();
        for (FindPwdQuestion question : questions) {
            if (question.is_selected()) {
                builder.append(TextUtils.isEmpty(builder.toString()) ? question.getCid() : "," + question.getCid());
            }
        }
        return builder.toString();
    }

    /**
     * 步骤1 实名认证
     *
     * @param step
     */
    private void handlerStep1(int step, View headView, final ListView listView) {
        idCardEdit = (EditText) headView.findViewById(R.id.idcardEdit);
        options = (TextView) headView.findViewById(R.id.options);
        final View idCardLayout = headView.findViewById(R.id.idCardLayout);
        final ImageView selectedIcon = (ImageView) headView.findViewById(R.id.selectedIcon);
        idCardLayout.setVisibility(View.VISIBLE);
        final FindPwdQuestionAdapter adapter = new FindPwdQuestionAdapter(this, getQuestionItem(step), true, new FindPwdQuestionAdapter.SelecteQuestionCallBackListener() {
            @Override
            public void callBack(FindPwdQuestion question) {
                //选择了未实名认证选项 回调 需要将实名认证的弹框选中状态取消
                if (idCardEdit.getVisibility() == View.VISIBLE) {
                    idCardEdit.setVisibility(View.GONE);
                    options.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.color_333333));
                    selectedIcon.setImageResource(R.drawable.question_btn_normal);
                    Utils.setBackGround(idCardLayout, getResources().getDrawable(R.drawable.draw_sk_dbdbdb_2radius));
                }
            }
        });
        listView.setAdapter(adapter);
        idCardLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (idCardEdit.getVisibility() == View.GONE) {
                    idCardEdit.setVisibility(View.VISIBLE);
                    options.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.color_eb4e4e));
                    selectedIcon.setImageResource(R.drawable.question_btn_pressed);
                    Utils.setBackGround(idCardLayout, getResources().getDrawable(R.drawable.draw_sk_eb4e4e_2radius));
                    //清空上次的选项
                    adapter.clearOptions();
                    adapter.notifyDataSetChanged();
                }
            }
        });
        intentNextActivity = true;
    }

    /**
     * 步骤2 选择平常使用的功能模块
     *
     * @param step
     */
    private void handlerStep2(int step, View headView, ListView listView) {
        listView.setAdapter(new FindPwdQuestionAdapter(this, getQuestionItem(step)));
        intentNextActivity = true;
    }

    /**
     * 步骤3
     *
     * @param step
     */
    private void handlerStep3(int step, final PageListView listView, final TextView questionTitleText) {
        String telphone = getIntent().getStringExtra(Constance.TELEPHONE);
        String idcard = getIntent().getStringExtra(Constance.ID);
        String optionsIds = getIntent().getStringExtra(Constance.SELECTED_IDS);
        String httpUrl = NetWorkRequest.FIND_ACCOUNT_QUESTION3;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("telephone", telphone); //	原电话号码
        if (!TextUtils.isEmpty(idcard)) {
            params.addBodyParameter("idcard", idcard); //身份证号码
        }
        params.addBodyParameter("type", optionsIds); //1,记工，2，找活，3招工,4都不是 ，多选用逗号相连，如1,2,3
        CommonHttpRequest.commonRequest(this, httpUrl, FindPwdQuestion.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                FindPwdQuestion question = (FindPwdQuestion) object;
                question3Token = question.getToken();
                questionTitleText.setText(question.getQues_title());
                listView.setAdapter(new FindPwdQuestionAdapter(FindPwdStep123Activity.this, question.getAnswer_list(), true));
                listView.addFooterView(getChangeQuestionView(listView));
                questions = question.getAnswer_list();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    /**
     * 获取换一组问题View
     *
     * @return
     */
    private View getChangeQuestionView(final PageListView listView) {
        View foot_view = getLayoutInflater().inflate(R.layout.item_change_question, null); // 加载对话框
        foot_view.findViewById(R.id.changeQuestionLayout).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                params.addBodyParameter("token", question3Token); //	找回账号时的token
                String httpUrl = NetWorkRequest.REFRESH_FIND_ACCOUNT_QUESTION;
                CommonHttpRequest.commonRequest(FindPwdStep123Activity.this, httpUrl,
                        FindPwdQuestion.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                FindPwdQuestion question = (FindPwdQuestion) object;
                                question3Token = question.getToken();
                                listView.setAdapter(new FindPwdQuestionAdapter(FindPwdStep123Activity.this, question.getAnswer_list(), true));
                                listView.setDataChangedListener(new HandleDataListView.DataChangedListener() {
                                    @Override
                                    public void onSuccess() {
                                        listView.setSelection(0);
                                    }
                                });
                                questions = question.getAnswer_list();
                            }

                            @Override
                            public void onFailure(HttpException exception, String errormsg) {
                                finish();
                            }
                        });
            }
        });
        return foot_view;
    }


    /**
     * 获取提问标题
     *
     * @param step
     */
    private String getQuestionTitle(int step) {
        switch (step) {
            case 1: //步骤1
                return "1.原手机号码是否实名认证";
            case 2:
            default:
                return "2.你曾经使用平台的哪些功能?(可多选)";
        }
    }

    /**
     * 获取提问内容
     *
     * @param step
     */
    private ArrayList<FindPwdQuestion> getQuestionItem(int step) {
        ArrayList<FindPwdQuestion> list = new ArrayList<>();
        switch (step) {
            case 1: //步骤1
                list.add(new FindPwdQuestion("未实名认证", "WEISHIMING"));
                break;
            case 2:
                list.add(new FindPwdQuestion("记工", "1"));
                list.add(new FindPwdQuestion("找活", "2"));
                list.add(new FindPwdQuestion("招工", "3"));
                break;
        }
        this.questions = list;
        return list;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.red_btn: //下一步
                Intent intent = getIntent();
                int step = intent.getIntExtra(Constance.BEAN_INT, 1);
                String cids = getSelecteQuestionCids();
                if (step == 1) { //步骤1的验证
                    if (idCardEdit == null) {
                        return;
                    }
                    if (TextUtils.isEmpty(cids) && idCardEdit.getVisibility() == View.GONE) {
                        CommonMethod.makeNoticeLong(getApplicationContext(), "请选择答案", CommonMethod.ERROR);
                        return;
                    }
                } else {
                    if (TextUtils.isEmpty(cids)) {
                        CommonMethod.makeNoticeLong(getApplicationContext(), "请选择答案", CommonMethod.ERROR);
                        return;
                    }
                }
                switch (step) {
                    case 1:
                        //如果输入框为Visible 那么选择项为需要输入实名认证
                        if (idCardEdit.getVisibility() == View.VISIBLE) {
                            String idCard = idCardEdit.getText().toString().trim();
                            if (TextUtils.isEmpty(idCard)) {
                                CommonMethod.makeNoticeLong(getApplicationContext(), "请输入身份证号码！", CommonMethod.ERROR);
                                return;
                            }
                            String reguler = "(^1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|71|81|82|90)([0-5][0-9]|90)(\\d{2})(19|20)(\\d{2})((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))(\\d{3})([0-9]|X|x^)";
                            if (!Pattern.matches(reguler, idCard)) {
                                CommonMethod.makeNoticeLong(getApplicationContext(), "请输入正确的身份证号码！", CommonMethod.ERROR);
                                return;
                            }
                            FindPwdStep123Activity.actionStart(this, intent.getStringExtra(Constance.TELEPHONE), idCard, step + 1);
                        } else {
                            FindPwdStep123Activity.actionStart(this, intent.getStringExtra(Constance.TELEPHONE), null, step + 1);
                        }
                        break;
                    case 2:
                        FindPwdStep123Activity.actionStart(this, intent.getStringExtra(Constance.TELEPHONE), intent.getStringExtra(Constance.ID), step + 1, cids);
                        break;
                    case 3:
                        if (intentNextActivity) { //需要跳转到步骤4验证
                            FindPwdStep4Activity.actionStart(this, intent.getStringExtra(Constance.TELEPHONE), getQuestionName(), question3Token, cids);
                        } else {
                            startValidate(cids);
                        }
                        break;
                }
                break;
        }
    }

    /**
     * 获取记工对象的名称
     *
     * @return
     */
    private String getQuestionName() {
        if (questions == null || questions.size() == 0) return null;
        for (FindPwdQuestion question : questions) {
            if (question.is_selected()) {
                return question.getOptions();
            }
        }
        return null;
    }


    /**
     * 开始验证
     *
     * @param cids
     */
    private void startValidate(String cids) {
        String httpUrl = NetWorkRequest.FIND_ACCOUNT_VALIDATION;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("token", question3Token); //	v2/signup/findaccount返回的token
        params.addBodyParameter("cid", cids); //用户选择的cid
        final DiaLogRedLongProgress diaLogRedLongProgress = new DiaLogRedLongProgress(this, "正在验证...");
        diaLogRedLongProgress.show();
        CommonHttpRequest.commonRequest(this, httpUrl, FindPwdQuestion.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                diaLogRedLongProgress.dismissDialog();
                FindPwdQuestion question = (FindPwdQuestion) object;
                if (question.getIs_pass() == 1) { //验证通过
                    UpdateTelSecondActivity.actionStart(FindPwdStep123Activity.this, getIntent().getStringExtra(Constance.TELEPHONE), question3Token);
                    setResult(1);
                    finish();
                } else { //验证未通过
                    DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(
                            FindPwdStep123Activity.this, "验证失败", "如有疑问，请联系吉工家客服!", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                        @Override
                        public void clickLeftBtnCallBack() { //重新验证
                            setResult(2);
                            finish();
                        }

                        @Override
                        public void clickRightBtnCallBack() { //联系客服
                            CallPhoneUtil.callPhone(FindPwdStep123Activity.this, "4008623818");
                        }
                    });
                    dialogLeftRightBtnConfirm.setLeftBtnText("重新验证");
                    dialogLeftRightBtnConfirm.setRightBtnText("联系客服");
                    dialogLeftRightBtnConfirm.show();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                diaLogRedLongProgress.dismissDialog();
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == 1) { //验证成功
            setResult(1);
            finish();
        } else if (resultCode == 2) { //重新验证、需要回到步骤1
            //这里判断一下如果回到了 步骤1则不关闭此页面
            if (getIntent().getIntExtra(Constance.BEAN_INT, 1) != 1) {
                setResult(2);
                finish();
            }
        }
    }

}
