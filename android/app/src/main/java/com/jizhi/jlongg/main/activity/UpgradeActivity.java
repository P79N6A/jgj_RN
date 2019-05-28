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

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.Constance;

import java.io.Serializable;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

/**
 * 功能:升级为项目组
 * 时间:2016年9月28日 18:00:31
 * 作者:xuj
 */
public class UpgradeActivity extends BaseActivity implements View.OnClickListener {


    /**
     * 请输入所在项目
     */
    private EditText hostPorjectEdit;
    /**
     * 项目名称
     */
    private EditText groupNameEdit;
    /**
     * 下一步按钮
     */
    private TextView nextTxt;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupChatName    群聊名称
     * @param groupChatId      群聊id
     * @param groupMemberInfos 成员信息
     */
    public static void actionStart(Activity context, String groupChatName, String groupChatId, List<GroupMemberInfo> groupMemberInfos) {
        Intent intent = new Intent(context, UpgradeActivity.class);
        intent.putExtra(Constance.PRONAME, groupChatName);
        intent.putExtra(Constance.GROUP_ID, groupChatId);
        intent.putExtra(Constance.BEAN_ARRAY, (Serializable) groupMemberInfos);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.upgrade_chat);
        initView();
    }

    private void setNextUnClick() {
        nextTxt.setClickable(false);
        nextTxt.setTextColor(getResources().getColor(R.color.color_999999));
    }

    private void setNextClick() {
        nextTxt.setClickable(true);
        nextTxt.setTextColor(getResources().getColor(R.color.app_color));
    }

    private void initView() {
        nextTxt = (TextView) findViewById(R.id.right_title);
        setNextUnClick();
        groupNameEdit = (EditText) findViewById(R.id.proNameEdit);
        hostPorjectEdit = (EditText) findViewById(R.id.hostProjectEdit);
        String proName = getIntent().getStringExtra(Constance.PRONAME);
        if (!TextUtils.isEmpty(proName)) {
            hostPorjectEdit.setText(proName);
            hostPorjectEdit.setSelection(proName.length());
        }
        hostPorjectEdit.requestFocus();
        hostPorjectEdit.setFocusable(true);
        hostPorjectEdit.setFocusableInTouchMode(true);
        setTextTitleAndRight(R.string.upgrade_group, R.string.next);
        groupNameEdit.setHint(R.string.group_remark);
        groupNameEdit.setFilters(new InputFilter[]{new InputFilter.LengthFilter(15)});
        hostPorjectEdit.setHint(R.string.host_proname);
        hostPorjectEdit.setFilters(new InputFilter[]{new InputFilter.LengthFilter(15)});
        groupNameEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String value = s.toString();
                if (TextUtils.isEmpty(value)) {
                    setNextUnClick();
                } else {
                    if (!TextUtils.isEmpty(hostPorjectEdit.getText().toString())) {
                        setNextClick();
                    } else {
                        setNextUnClick();
                    }
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
        hostPorjectEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String value = s.toString();
                if (TextUtils.isEmpty(value)) {
                    setNextUnClick();
                } else {
                    if (!TextUtils.isEmpty(groupNameEdit.getText().toString())) {
                        setNextClick();
                    } else {
                        setNextUnClick();
                    }
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
        new Timer().schedule(new TimerTask() { //弹出键盘
            public void run() {
                showSoftKeyboard(hostPorjectEdit);
            }
        }, 300);
    }


    @Override
    public void onClick(View view) {
        //下一步
        Intent intent = new Intent(this, UpgradeMemberListActivity.class);
        intent.putExtra(Constance.GROUP_ID, getIntent().getStringExtra(Constance.GROUP_ID));
        intent.putExtra(Constance.PRONAME, hostPorjectEdit.getText().toString());
        intent.putExtra(Constance.GROUP_NAME, groupNameEdit.getText().toString());
        intent.putExtra(Constance.BEAN_ARRAY, getIntent().getSerializableExtra(Constance.BEAN_ARRAY));
        startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.UPGRADE) {
            setResult(resultCode, data);
            finish();
        }
    }
}
