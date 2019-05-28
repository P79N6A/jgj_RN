package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.google.gson.GsonBuilder;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.adpter.TeamCreateAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.WrapGridview;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;

/**
 * CName:新建班组
 * User: hcs
 * Date: 2016-08-23
 * Time: 14:37
 */
public class CreateTeamGroupActivity extends BaseActivity implements View.OnClickListener, AddMemberListener {

    /**
     * 城市编码、项目id
     */
    private String cityCode, pid;
    /**
     * 所选项目Text
     */
    private TextView containProjectText;
    /**
     * 班组名称Text
     */
    private TextView groupNameText;
    /**
     * 所选城市Text
     */
    private TextView cityText;
    /**
     * 班组成员适配器
     */
    private TeamCreateAdapter adapter;


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, CreateTeamGroupActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param proName 项目名称
     * @param pid     项目id
     * @param context
     */
    public static void actionStart(Activity context, String proName, String pid) {
        Intent intent = new Intent(context, CreateTeamGroupActivity.class);
        intent.putExtra(Constance.PRONAME, proName);
        intent.putExtra(Constance.PID, pid);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_team_group);
        initView();
    }

    private void initView() {
        setTextTitle(R.string.create_group);
        groupNameText = getTextView(R.id.groupNameText);
        containProjectText = getTextView(R.id.containProjectText);
        cityText = getTextView(R.id.cityText);
        WrapGridview wrapGrid = (WrapGridview) findViewById(R.id.team_grid); //设置讨论组头像
        adapter = new TeamCreateAdapter(this, null, this);
        wrapGrid.setAdapter(adapter);
        //获取本地记录的当前所选的城市
        String cityName = SPUtils.get(getApplicationContext(), Constance.PROVICECITY, "", Constance.JLONGG).toString();
        cityCode = UclientApplication.getCityCode(getApplicationContext());
        if (!TextUtils.isEmpty(cityName) && cityName.contains("null")) {
            cityName = "四川省 成都市";
        }
        cityText.setText(cityName);//获取本地定位成功后的城市名称
        getButton(R.id.red_btn).setText("确定创建");

        Intent intent = getIntent();
        String proName = intent.getStringExtra(Constance.PRONAME);
        if (!TextUtils.isEmpty(proName)) { //从上个页面带过来的默认项目名称
            containProjectText.setText(proName);
            pid = intent.getStringExtra(Constance.PID);
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.containingProjectLayout: //所在项目
                getProjectList();
                break;
            case R.id.groupNameLayout: //班组名称
                AddProjectNameActivity.actionStart(this, groupNameText.getText().toString().trim());
                break;
            case R.id.cityLayout: //城市名称
                SelectProviceAndCityActivity.actionStart(this);
                break;
            case R.id.red_btn: //创建项目
                if (TextUtils.isEmpty(containProjectText.getText().toString())) {
                    CommonMethod.makeNoticeShort(this, "请选择所在项目", CommonMethod.ERROR);
                    return;
                }
                if (TextUtils.isEmpty(pid)) {
                    CommonMethod.makeNoticeShort(this, "项目id获取出错", CommonMethod.ERROR);
                    return;
                }
                if (TextUtils.isEmpty(groupNameText.getText().toString())) {
                    CommonMethod.makeNoticeShort(this, "请输入班组名称", CommonMethod.ERROR);
                    return;
                }
                if (TextUtils.isEmpty(cityCode)) {
                    CommonMethod.makeNoticeShort(this, "请选择所在城市", CommonMethod.ERROR);
                    return;
                }
                if (adapter == null && adapter.getList() == null) {
                    CommonMethod.makeNoticeShort(this, "请选择班组成员", CommonMethod.ERROR);
                    return;
                }
                createTeam();
                break;
        }
    }


    /**
     * 获取项目列表信息
     */
    private void getProjectList() {
        String httpUrl = NetWorkRequest.CREATE_GROUP_GET_PRO_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        CommonHttpRequest.commonRequest(this, httpUrl, Project.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<Project> list = (ArrayList<Project>) object;
                if (list != null && list.size() > 0) {
                    ProjectListActivity.actionStart(CreateTeamGroupActivity.this, pid, list);
                } else {
                    AddProjectActivity.actionStart(CreateTeamGroupActivity.this, true);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    /**
     * 新建班组
     */
    public void createTeam() {
        String httpUrl = NetWorkRequest.CREATE_GROUP;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("group_name", groupNameText.getText().toString().trim()); //班组名称
        params.addBodyParameter("city_code", cityCode); //城市id
        params.addBodyParameter("group_members", adapter.getList() == null ? null : new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create().toJson(adapter.getList())); //班组成员 ,这里以JSON数组发送
        params.addBodyParameter("pro_id", pid); //项目id
        CommonHttpRequest.commonRequest(this, httpUrl, GroupDiscussionInfo.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                //获取已创建的班组信息
                GroupDiscussionInfo groupDiscussionInfo = (GroupDiscussionInfo) object;
                //我们将新创建的班组存储在数据库中
                MessageUtil.addTeamOrGroupToLocalDataBase(CreateTeamGroupActivity.this, "创建成功", groupDiscussionInfo, true);
                Intent intent = getIntent();
                intent.putExtra(Constance.IS_ENTER_GROUP, false);
                intent.putExtra(Constance.BEAN_CONSTANCE, groupDiscussionInfo);
                setResult(MessageUtil.WAY_CREATE_GROUP_CHAT, intent);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SUCCESS) {//添加班组名称回调
            groupNameText.setText(data.getStringExtra(Constance.BEAN_STRING));
        } else if (resultCode == Constance.SET_CITY_INFO_SUCCESS) {//选择城市回调
            String mCityName = data.getStringExtra("cityName"); //城市名称
            String mCityCode = data.getStringExtra("cityCode"); //城市编码
            cityText.setText(mCityName);
            cityCode = mCityCode;
        } else if (resultCode == MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER) { //添加班组成员
            ArrayList<GroupMemberInfo> selected = (ArrayList<GroupMemberInfo>) data.getSerializableExtra(Constance.BEAN_ARRAY);
            if (selected != null && selected.size() > 0) {
                if (adapter.getList() == null) {
                    adapter.setList(new ArrayList<GroupMemberInfo>());
                }
                adapter.getList().addAll(selected);
                adapter.notifyDataSetChanged();
            }
        } else if (resultCode == Constance.SELECTE_PROJECT || resultCode == Constance.RESULTWORKERS) { //所属项目回调
            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            if (project != null) {
                pid = String.valueOf(project.getPro_id());
                containProjectText.setText(project.getPro_name());
            }
        } else if (resultCode == Constance.CANCEL_SELECTE) { //取消所选项目选择
            pid = null;
            containProjectText.setText("");
        }
    }

    @Override
    public void add(int addType) { //添加班组
        AddMemberWayActivity.actionStart(this, MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER, null,
                Constance.GROUP, null, null, adapter.getList(), false);
    }

    @Override
    public void remove(int state) {
    }


}