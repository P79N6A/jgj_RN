package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.Html;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.zxing.client.android.scanner.CaptureActivity;
import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AddFriendsSources;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import static com.hcs.uclient.utils.SPUtils.get;


/**
 * 添加朋友、主页
 *
 * @author Xuj
 * @time 2017年2月10日15:51:52
 * @Version 1.0
 */
public class AddFriendMainctivity extends BaseActivity implements View.OnClickListener {

    /**
     * 模糊搜索文字
     */
    private TextView searchText;
    /**
     * 输入文字时显示的布局
     */
    private LinearLayout inputLayout;
    /**
     * 未输入时显示的布局
     */
    private LinearLayout unInputLayout;
    /**
     * 用户不存在时的提示
     */
    private View unExistUser;
    /**
     * 用户存在时的布局
     */
    private View existUser;
    /**
     * 搜索结果用户头像
     */
    private RoundeImageHashCodeTextLayout userSearchResultHead;
    /**
     * 搜索结果用户名称
     */
    private TextView userSearchResultName;
    /**
     * 搜索结果用户电话
     */
    private TextView userSearchResultTel;
    /**
     * 搜索电话编辑框
     */
    private ClearEditText telEditor;
    /**
     * 查询出来的用户id
     */
    private String searchOfUid;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, AddFriendMainctivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_friend_main);
        initView();
        setMyInfo();
    }

    private void initView() {
        setTextTitle(R.string.add_friend);
        searchText = getTextView(R.id.searchText);
        unExistUser = findViewById(R.id.unExistUser);
        existUser = findViewById(R.id.existUser);
        userSearchResultHead = (RoundeImageHashCodeTextLayout) findViewById(R.id.userSearchResultHead);
        userSearchResultName = getTextView(R.id.userSearchResultName);
        userSearchResultTel = getTextView(R.id.userSearchResultTel);
        inputLayout = (LinearLayout) findViewById(R.id.inputLayout);
        unInputLayout = (LinearLayout) findViewById(R.id.unInputLayout);

        telEditor = (ClearEditText) findViewById(R.id.filterEdit);
        telEditor.setImeOptions(EditorInfo.IME_ACTION_SEARCH);
        telEditor.setSingleLine(true);
        telEditor.setFilters(new InputFilter[]{new InputFilter.LengthFilter(11)}); //最多为11个字
        // 根据输入框输入值的改变来过滤搜索
        telEditor.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_SEARCH) {//按下手机键盘的搜索按钮的时候去 执行搜索的操作
                    getLookUpMemberResult(telEditor.getText().toString());
                }
                return false;
            }
        });

        telEditor.setHint("请输入手机号码查找");

        telEditor.setInputType(InputType.TYPE_CLASS_NUMBER);
        telEditor.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String inputValue = s.toString();
                if (TextUtils.isEmpty(inputValue)) { //当前搜索框未输入内容
                    if (existUser.getVisibility() == View.VISIBLE) {
                        existUser.setVisibility(View.GONE);
                    }
                    if (unExistUser.getVisibility() == View.VISIBLE) {
                        unExistUser.setVisibility(View.GONE);
                    }
                    inputLayout.setVisibility(View.GONE);
                    unInputLayout.setVisibility(View.VISIBLE);
                } else { //已输入
                    if (searchText.getVisibility() == View.GONE) {
                        searchText.setVisibility(View.VISIBLE);
                    }
                    if (existUser.getVisibility() == View.VISIBLE) {
                        existUser.setVisibility(View.GONE);
                    }
                    if (unExistUser.getVisibility() == View.VISIBLE) {
                        unExistUser.setVisibility(View.GONE);
                    }
                    searchText.setText(Html.fromHtml("<font color='#666666'>搜索</font><font color='#d7252c'>\"" + inputValue + "\"</font>"));
                    inputLayout.setVisibility(View.VISIBLE);
                    unInputLayout.setVisibility(View.GONE);
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
    }

    /**
     * 设置当前登录人信息
     */
    private void setMyInfo() {
        String headImage = get(getApplicationContext(), Constance.HEAD_IMAGE, "", Constance.JLONGG).toString(); //头像路径
        String telphone = get(getApplicationContext(), Constance.TELEPHONE, "", Constance.JLONGG).toString(); //电话号码
        String realName = get(getApplicationContext(), Constance.USERNAME, "", Constance.JLONGG).toString(); //当前登录人姓名
        String nickName = get(getApplicationContext(), Constance.NICKNAME, "", Constance.JLONGG).toString(); //当前登录人昵称
//        TextView userNameText = getTextView(R.id.userNameText);
        TextView telText = getTextView(R.id.telText);
        RoundeImageHashCodeTextLayout textLayout = (RoundeImageHashCodeTextLayout) findViewById(R.id.roundImageHashText);
//        userNameText.setText(!TextUtils.isEmpty(nickName) ? nickName : realName); //如果用户有昵称则设置昵称 否则设置真实姓名
        telText.setText(telphone); //设置电话号码
        textLayout.setView(headImage, !TextUtils.isEmpty(nickName) ? nickName : realName, 0);
    }


    /**
     * 获取精确账号搜索结果
     */
    private void getLookUpMemberResult(String telephone) {
        if (TextUtils.isEmpty(telephone)) {
            return;
        }
        String httpUrl = NetWorkRequest.ACCORD_TEL_FIND_USERINFO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("telephone", telephone);
        CommonHttpRequest.commonRequest(this, httpUrl, UserInfo.class, false, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                UserInfo userInfo = (UserInfo) object;
                searchText.setVisibility(View.GONE);
                if (userInfo != null && !TextUtils.isEmpty(userInfo.getUid())) {
                    searchOfUid = userInfo.getUid();
                    unExistUser.setVisibility(View.GONE);
                    existUser.setVisibility(View.VISIBLE);
                    userSearchResultName.setText(userInfo.getReal_name());
                    userSearchResultTel.setText(userInfo.getTelephone());
                    userSearchResultHead.setView(userInfo.getHead_pic(), userInfo.getReal_name(), 0);
                } else {
                    unExistUser.setVisibility(View.VISIBLE);
                    existUser.setVisibility(View.GONE);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.myContactLayout: //我的名片
                toMyContactActivity();
                break;
            case R.id.scanLayout: //扫描二维码
                AddFriendsSources.create().setReset(true).setSource(AddFriendsSources.SOURCE_SCANNER_CODE);
                CaptureActivity.actionStart(this);
                break;
            case R.id.phontContact: //手机联系人
                AddFriendsSources.create().setReset(true).setSource(AddFriendsSources.SOURCE_MOBILE_ADDRESS);
                TelContactActivity.actionStart(this);
                break;
            case R.id.searchText: //搜索结果
                AddFriendsSources.create().setReset(true).setSource(AddFriendsSources.SOURCE_SEARCH_PHONE);
                getLookUpMemberResult(telEditor.getText().toString());
                break;
            case R.id.fromGroupAdd: //从项目添加朋友
                ChooseTeamActivity.actionStart(this, MessageUtil.TYPE_GROUP_AND_TEAM, null, null, null,
                        MessageUtil.WAY_CREATE_GROUP_CHAT);
                break;
            case R.id.existUser: //用户查询结果
                if (TextUtils.isEmpty(searchOfUid)) {
                    return;
                }
                if (searchOfUid.equals(UclientApplication.getUid(this))) { //如果匹配到的是自己的uid则直接展示自己的名片
                    toMyContactActivity();
                } else {
                    Intent intent = new Intent(getApplicationContext(), ChatUserInfoActivity.class);
                    intent.putExtra(Constance.UID, searchOfUid);
                    startActivityForResult(intent, Constance.REQUESTCODE_SINGLECHAT);
                }
                break;
        }
    }

    /**
     * 获取我的名片
     *
     * @returnz
     */
    private void toMyContactActivity() {
        String nickName = UclientApplication.getNickName(getApplicationContext()); //昵称
        String realName = UclientApplication.getRealName(getApplicationContext()); //真实姓名
        MyScanQrCodeActivity.actionStart(this, !TextUtils.isEmpty(realName) ? realName : nickName, SPUtils.get(getApplicationContext(), Constance.HEAD_IMAGE, "", Constance.JLONGG).toString());
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) { //点击单聊
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (resultCode == Constance.FIND_WORKER_CALLBACK) { //回主页
            setResult(Constance.FIND_WORKER_CALLBACK, getIntent());
            finish();
        } else if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) {
            setResult(resultCode, data);
            finish();
        } else if (requestCode == Constance.REQUESTCODE_SINGLECHAT) { //搜索用户返回页
            telEditor.setText("");
        }
    }
}