package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;

import com.hcs.uclient.utils.AppUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.Constance;

import java.util.Timer;
import java.util.TimerTask;

/**
 * 功能:添加班组名称
 * 时间:2016-9-7 10:30
 * 作者:hcs
 */
public class AddProjectNameActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 班组名称输入框
     */
    private EditText projectName;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupName 班组名称
     */
    public static void actionStart(Activity context, String groupName) {
        Intent intent = new Intent(context, AddProjectNameActivity.class);
        intent.putExtra(Constance.BEAN_STRING, groupName);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.addproject);
        initView();
    }

    private void initView() {
        setTextTitle(R.string.item_group_name);
        projectName = getEditText(R.id.project_name);
        projectName.setHint(getString(R.string.input_team_name));
        String desc = getIntent().getStringExtra(Constance.BEAN_STRING);
        projectName.requestFocus();
        projectName.setFocusable(true);
        projectName.setFocusableInTouchMode(true);
        if (!TextUtils.isEmpty(desc)) {
            projectName.setText(desc);
            projectName.setSelection(desc.length());
        }
        new Timer().schedule(new TimerTask() { //弹出键盘
            public void run() {
                showSoftKeyboard(projectName);
            }
        }, 300);
    }


    @Override
    public void onClick(View view) {
        String proName = projectName.getText().toString().trim();
        if (!AppUtils.filterAppImportantWord(getApplicationContext(), proName, "班组", false)) {
            return;
        }
        Intent intent = getIntent();
        intent.putExtra(Constance.BEAN_STRING, proName);
        setResult(Constance.SUCCESS, intent);
        finish();
    }
}
