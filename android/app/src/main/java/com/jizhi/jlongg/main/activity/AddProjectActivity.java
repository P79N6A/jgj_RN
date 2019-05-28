package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.StringUtil;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;
import com.lidroid.xutils.view.annotation.event.OnClick;

import java.util.Timer;
import java.util.TimerTask;

import static com.jizhi.jlongg.main.util.Constance.REQUEST;

/**
 * 功能: 记账-->添加项目
 * 时间:2016/3/11 11:39
 * 作者:xuj
 */
public class AddProjectActivity extends BaseActivity {

    /**
     * 项目名称
     */
    private EditText projectName;


    /**
     * @param context 请求当前页
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, AddProjectActivity.class);
        context.startActivityForResult(intent, REQUEST);
    }

    /**
     * @param context 请求当前页
     */
    public static void actionStart(Activity context, boolean isShowCreateText) {
        Intent intent = new Intent(context, AddProjectActivity.class);
        intent.putExtra(Constance.BEAN_BOOLEAN, isShowCreateText);
        context.startActivityForResult(intent, REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.addproject);
        ViewUtils.inject(this);
        projectName = (EditText) findViewById(R.id.project_name);
        projectName.setHint(getString(R.string.input_project_name));
        if (getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
//            SetTitleName.setTitle(findViewById(R.id.title), "新建项目");
            setTextTitle(R.string.add_pro);
        } else {
            setTextTitle(R.string.add_pro);
        }

        projectName.requestFocus();
        projectName.setFocusable(true);
        projectName.setFocusableInTouchMode(true);
        new Timer().schedule(new TimerTask() { //弹出键盘
            public void run() {
                showSoftKeyboard(projectName);
            }
        }, 300);

    }

    @OnClick(R.id.submit)
    public void sunMit(View v) { //保存按钮
        String proName = projectName.getText().toString().trim();
        if (StringUtil.isNullOrEmpty(proName)) {
            CommonMethod.makeNoticeShort(AddProjectActivity.this, "请输入项目名称", CommonMethod.ERROR);
            return;
        }
        if (!Utils.JudgeInput(proName)) {
            CommonMethod.makeNoticeShort(AddProjectActivity.this, "项目名称只能由数字,字母,汉字组成", CommonMethod.ERROR);
            return;
        }
        requestServerAddPro();
    }


    public void requestServerAddPro() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(AddProjectActivity.this);
        params.addBodyParameter("pro_name", projectName.getText().toString());
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.ADDPRO, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<Project> base = CommonJson.fromJson(responseInfo.result, Project.class);
                    if (base.getState() != 0) {
                        Intent intent = getIntent();
                        Project project = base.getValues();
                        project.setPro_id(String.valueOf(project.getPid()));
                        intent.putExtra(Constance.BEAN_CONSTANCE, project);
                        setResult(Constance.RESULTWORKERS, intent);
                        finish();
                    } else {
                        DataUtil.showErrOrMsg(AddProjectActivity.this, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(AddProjectActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }
        });
    }

}
