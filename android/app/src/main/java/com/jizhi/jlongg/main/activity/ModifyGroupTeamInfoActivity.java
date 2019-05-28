package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.hcs.uclient.utils.AppUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DBMsgUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.lidroid.xutils.exception.HttpException;

import java.util.Timer;
import java.util.TimerTask;

/**
 * 功能:修改班组、项目组信息
 * 时间:2016年9月28日 18:00:31
 * 作者:xuj
 */
public class ModifyGroupTeamInfoActivity extends BaseActivity implements View.OnClickListener {

    /* 修改我在本组的名称 */
    public static final int UPDATE_IN_GROUP_MY_NAME = 1;
    /* 修改项目组名称 */
    public static final int UPDATE_TEAM_NAME = 2;
    /* 修改人员备注 */
    public static final int UPDATE_PERSON_REMARK = 3;
    /* 修改群聊名称 */
    public static final int UPDATE_GROUPCHAT_NAME = 4;
    /* 修改班组名称 */
    public static final int UPDATE_GROUP_NAME = 5;
    /* 修改类型 */
    public static final String UPDATE_TYPE = "type";
    /* 输入框 */
    private EditText remarkEdit;
    /* 当前修改的选项 */
    private int currentUpdateState;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param defaultInputString 默认文本输入框
     * @param groupId            项目组id
     * @param classType          项目组、班组类型
     * @param uid                设置备注名称的人uid(如果不是修改人的备注名称这个参数可以不传)
     * @param update_type        消息列表类型 取值直接看ModifyGroupTeamInfoActivity里的常量
     */
    public static void actionStart(Activity context, String defaultInputString, String groupId, String classType, String uid, int update_type) {
        Intent intent = new Intent(context, ModifyGroupTeamInfoActivity.class);
        intent.putExtra(Constance.BEAN_STRING, defaultInputString);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.CLASSTYPE, classType);
        intent.putExtra(Constance.UID, uid); //需要备注人的名称
        intent.putExtra(UPDATE_TYPE, update_type);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.update_remark);
        initView();
    }

    private void initView() {
        Intent intent = getIntent();
        if (currentUpdateState == -1) {
            CommonMethod.makeNoticeShort(this, "获取项目类型出错", CommonMethod.ERROR);
            finish();
            return;
        }
        final TextView saveText = (TextView) findViewById(R.id.right_title);
        remarkEdit = getEditText(R.id.remarkEdit);
        currentUpdateState = intent.getIntExtra(UPDATE_TYPE, -1);
        String editDesc = intent.getStringExtra(Constance.BEAN_STRING);
        if (!TextUtils.isEmpty(editDesc)) {
            remarkEdit.requestFocus();
            remarkEdit.setFocusable(true);
            remarkEdit.setFocusableInTouchMode(true);
            remarkEdit.setText(editDesc);
            remarkEdit.setSelection(remarkEdit.getText().toString().length());
        }
        int editTextLength = 0;
        switch (currentUpdateState) {
            case UPDATE_IN_GROUP_MY_NAME: //设置我在本组的名称
                String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
                if (classType.equals(WebSocketConstance.TEAM) || classType.equals(WebSocketConstance.GROUP)) {
                    setTextTitle(R.string.inTeamMyName);
                    remarkEdit.setHint(R.string.inGroupMyNameTips);
                } else {
                    setTextTitle(R.string.inGroupChatMyName);
                    remarkEdit.setHint(R.string.inGroupChatShow);
                }
                editTextLength = 10;
                break;
            case UPDATE_TEAM_NAME: //修改项目组名称
                setTextTitle(R.string.update_remark);
                remarkEdit.setHint(R.string.team_remark);
                editTextLength = 20;
                break;
            case UPDATE_PERSON_REMARK: //设置通讯录人员备注
                setTextTitle(R.string.remark_name);
                remarkEdit.setHint(R.string.remark_person_desc);
                editTextLength = 10;
                break;
            case UPDATE_GROUPCHAT_NAME: //群聊名称
                setTextTitle(R.string.group_name);
                remarkEdit.setHint(R.string.input_group_name);
                editTextLength = 10;
                break;
            case UPDATE_GROUP_NAME: //修改班组名称
                setTextTitle(R.string.item_group_name);
                remarkEdit.setHint(getString(R.string.input_team_name));
                editTextLength = 20;
                break;
        }
        saveText.setText(getString(R.string.save));
        remarkEdit.setFilters(new InputFilter[]{new InputFilter.LengthFilter(editTextLength)}); //设置我在本组的名称最多为10个字、设置班组名称最长为13
        new Timer().schedule(new TimerTask() { //弹出键盘
            public void run() {
                showSoftKeyboard(remarkEdit);
            }
        }, 300);
        remarkEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (currentUpdateState == UPDATE_GROUPCHAT_NAME) { //群聊名称
                    String inputValue = s.toString();
                    if (TextUtils.isEmpty(inputValue)) {
                        saveText.setClickable(false);
                        saveText.setTextColor(getResources().getColor(R.color.color_999999));
                    } else {
                        saveText.setClickable(true);
                        saveText.setTextColor(getResources().getColor(R.color.app_color));
                    }
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


    public void sunMit() { //保存按钮
        final String remark = remarkEdit.getText().toString().trim();
        if (currentUpdateState != UPDATE_IN_GROUP_MY_NAME && currentUpdateState != UPDATE_PERSON_REMARK) { //修改我在群的名称、和修改通讯录人员名称可以输入空
            if (TextUtils.isEmpty(remark)) {
                CommonMethod.makeNoticeShort(ModifyGroupTeamInfoActivity.this, remarkEdit.getHint().toString(), CommonMethod.ERROR);
                return;
            }
        }
        final Intent intent = getIntent();
        String lastValue = intent.getStringExtra(Constance.BEAN_STRING);
        if (!TextUtils.isEmpty(lastValue) && lastValue.equals(remark)) { //如果名字相同的 就不需要做更改
            finish();
            return;
        }
        final String groupId = intent.getStringExtra(Constance.GROUP_ID);
        final String classType = intent.getStringExtra(Constance.CLASSTYPE);
        if (currentUpdateState == UPDATE_PERSON_REMARK) {  //个人资料、通讯录 设置备注名称
            final String uid = intent.getStringExtra(Constance.UID);
            MessageUtil.setCommentName(this, null, null, uid, remark, new CommonHttpRequest.CommonRequestCallBack() {
                @Override
                public void onSuccess(Object object) {
                    DBMsgUtil.getInstance().updateNickName(groupId, classType, remark, getIntent().getStringExtra(Constance.UID), getApplicationContext());
                    //如果没有Group和ClassType 则不是在组里面对人设置备注
                    if (TextUtils.isEmpty(groupId) || TextUtils.isEmpty(classType)) {
                        //如果在本地有这条单聊信息 我们需要将单聊的对象数据变化一下
                        if (MessageUtil.checkGroupIsExist(ModifyGroupTeamInfoActivity.this, getIntent().getStringExtra(Constance.UID), WebSocketConstance.SINGLECHAT)) {
                            MessageUtil.modityLocalTeamGroupInfo(ModifyGroupTeamInfoActivity.this, null, remark, null, uid, WebSocketConstance.SINGLECHAT,
                                    null, null, null, null, 0, null, null, null, null);
                        }
                    }
                    intent.putExtra(Constance.COMMENT_NAME, remark);
                    setResult(Constance.SUCCESS, intent);
                    finish();
                }

                @Override
                public void onFailure(HttpException exception, String errormsg) {

                }
            });
        } else {
            String groupName = null;
            String nickName = null;
            switch (currentUpdateState) {
                case UPDATE_GROUP_NAME://修改班组名称
                    if (!AppUtils.filterAppImportantWord(getApplicationContext(), remark, "班组", false)) {
                        return;
                    }
                    groupName = remark;
                    break;
                case UPDATE_TEAM_NAME: //修改项目组名称
                    if (!AppUtils.filterAppImportantWord(getApplicationContext(), remark, "项目", false)) {
                        return;
                    }
                    groupName = remark;
                    break;
                case UPDATE_GROUPCHAT_NAME: //修改群聊组名称
                    if (!AppUtils.filterAppImportantWord(getApplicationContext(), remark, "群聊", true)) {
                        return;
                    }
                    groupName = remark;
                    break;
                case UPDATE_IN_GROUP_MY_NAME: //设置我在班组的名称
                    nickName = remark;
                    break;
            }
            MessageUtil.modifyTeamGroupInfo(this, groupId, classType, groupName, nickName, null, null, null,
                    null, new CommonHttpRequest.CommonRequestCallBack() {
                        @Override
                        public void onSuccess(Object object) {
                            //我们这里改变一下本地已存储的班组信息
                            switch (currentUpdateState) {
                                case UPDATE_IN_GROUP_MY_NAME: //设置我在本组的名称
                                    DBMsgUtil.getInstance().updateNickName(groupId, classType, remark, UclientApplication.getUid(), ModifyGroupTeamInfoActivity.this);
                                    break;
                                case UPDATE_GROUP_NAME://修改班组名称
                                case UPDATE_TEAM_NAME: //修改项目组名称
                                case UPDATE_GROUPCHAT_NAME: //修改群聊组名称
                                    MessageUtil.modityLocalTeamGroupInfo(ModifyGroupTeamInfoActivity.this, null, remark, null, groupId, classType,
                                            null, null, null, null, 0, null, null, null, null);
                                    break;
                            }
                            intent.putExtra(Constance.BEAN_STRING, remark);
                            intent.putExtra(Constance.BEAN_INT, currentUpdateState);
                            setResult(Constance.SUCCESS, intent);
                            finish();
                        }

                        @Override
                        public void onFailure(HttpException exception, String errormsg) {

                        }
                    });
        }
    }


    @Override
    public void onClick(View view) {
        sunMit();
    }


}
