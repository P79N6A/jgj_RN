package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.DeleteUserListener;
import com.jizhi.jlongg.main.adpter.SetAdministratorAdapter;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.dialog.DialogTeamManageSourceMemberTips;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;


/**
 * 管理员列表
 *
 * @author Xuj
 * @time 2016-11-28 17:47:42
 * @Version 1.0
 */
public class AdministratorListActivity extends BaseActivity implements OnClickListener {

    /**
     * 管理员列表适配器
     */
    private SetAdministratorAdapter administratorAdapter;
    /**
     * 管理员数量
     */
    private TextView administratorCount;

    /**
     * 启动当前Acitivty
     *
     * @param context
     * @param memberNum 成员数量
     * @param groupId   项目组id
     */
    public static void actionStart(Activity context, int memberNum, String groupId) {
        Intent intent = new Intent(context, AdministratorListActivity.class);
        intent.putExtra(Constance.MEMBER_NUMBER, memberNum);
        intent.putExtra(Constance.GROUP_ID, groupId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.set_adminstrator);
        initView();
        getAdminList();
    }

    private void initView() {
        setTextTitle(R.string.set_administrator);
        getTextView(R.id.defaultDesc).setText("暂未设置管理员");
        TextView defaultDesc1 = getTextView(R.id.defaultDesc1);
        defaultDesc1.setVisibility(View.VISIBLE);
        defaultDesc1.setText("点击右上角【添加管理员】图标可设置管理员");
        administratorCount = getTextView(R.id.administratorCount);
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.rightImage: //添加管理员
                SetAdministratorActivity.actionStart(this, getIntent().getStringExtra(Constance.GROUP_ID));
                break;
            case R.id.administrator_introduce_layout: //管理员权限说明
                new DialogTeamManageSourceMemberTips(this, getString(R.string.administrator_title),
                        getString(R.string.administrator_tips)).show();
                break;
        }
    }

    /**
     * 获取管理员列表数据
     */
    private void getAdminList() {
        MessageUtil.getAdminList(this, getIntent().getStringExtra(Constance.GROUP_ID), WebSocketConstance.TEAM, "get_admin_list", new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<GroupMemberInfo> manager = (ArrayList<GroupMemberInfo>) object;
                setAdapter(manager);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 删除管理员
     *
     * @param uid 用户id
     */
    private void deleteAdminstrator(String uid) {
        String httpUrl = NetWorkRequest.REMOVE_OR_ADD_ADMIN;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID));
        params.addBodyParameter("class_type", WebSocketConstance.TEAM);
        params.addBodyParameter("status", "1");//0:设置管理元（默认）；1取消管理员
        params.addBodyParameter("uid", uid);
        CommonHttpRequest.commonRequest(this, httpUrl, BaseNetNewBean.class, false, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                getAdminList();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }


    private void setAdapter(List<GroupMemberInfo> list) {
        if (administratorAdapter == null) {
            administratorAdapter = new SetAdministratorAdapter(getApplicationContext(), list, new DeleteUserListener() {
                @Override
                public void remove(int position) {
                    deleteAdminstrator(administratorAdapter.getList().get(position).getUid());
                }
            });
            ListView listView = (ListView) findViewById(R.id.listView);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setAdapter(administratorAdapter);
        } else {
            administratorAdapter.updateList(list);
        }
        //因为我们这里成员数量是包括了自己的 所以我们要把自己的数量给排除掉
        int memberNum = getIntent().getIntExtra(Constance.MEMBER_NUMBER, 0) - 1;
        administratorCount.setText(String.format(getString(R.string.already_exit_administrator), list != null && list.size() > 0 ? list.size() : 0, memberNum));
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SUCCESS) { //添加管理员成功后的回调
            getAdminList();
        }
    }


    @Override
    public void onBackPressed() {
        setResult(Constance.REFRESH);
        super.onBackPressed();
    }

    @Override
    public void onFinish(View view) {
        setResult(Constance.REFRESH);
        super.onFinish(view);
    }
}