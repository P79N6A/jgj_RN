package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.AddAdministratorAdapter;
import com.jizhi.jlongg.main.bean.ChatMainInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
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
 * 添加管理员
 *
 * @author Xuj
 * @time 2016-11-28 17:47:42
 * @Version 1.0
 */
public class SetAdministratorActivity extends BaseActivity {

    /**
     * 列表适配器
     */
    private AddAdministratorAdapter administratorAdapter;
    /**
     * listView
     */
    private ListView listView;

    /**
     * 启动当前Acitivty
     *
     * @param context
     * @param groupId 项目组id
     */
    public static void actionStart(Activity context, String groupId) {
        Intent intent = new Intent(context, SetAdministratorActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview_sidebar);
        initView();
        getAdminList();
    }


    private void initView() {
        setTextTitle(R.string.add_administrator);
        getTextView(R.id.defaultDesc).setText("当前没有可设置的成员");
        listView = (ListView) findViewById(R.id.listView);
        TextView center_text = getTextView(R.id.center_text);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //搜索框
        sideBar.setTextView(center_text);
        // 设置右侧触摸监听
        sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() {
            @Override
            public void onTouchingLetterChanged(String s) {
                if (administratorAdapter != null) {
                    //该字母首次出现的位置
                    int position = administratorAdapter.getPositionForSection(s.charAt(0));
                    if (position != -1) {
                        listView.setSelection(position);
                    }
                }
            }
        });
    }


    /**
     * 获取管理员列表数据
     */
    private void getAdminList() {
        MessageUtil.getAdminList(this, getIntent().getStringExtra(Constance.GROUP_ID), WebSocketConstance.TEAM, "set_admin_list", new CommonHttpRequest.CommonRequestCallBack() {
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
     * 添加管理员
     *
     * @param uid 用户id
     */
    private void addAdministrator(String uid) {
        String httpUrl = NetWorkRequest.REMOVE_OR_ADD_ADMIN;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID));
        params.addBodyParameter("class_type", WebSocketConstance.TEAM);
        params.addBodyParameter("status", "0");//0:设置管理元（默认）；1取消管理员
        params.addBodyParameter("uid", uid);
        CommonHttpRequest.commonRequest(this, httpUrl, ChatMainInfo.class, false, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                setResult(Constance.SUCCESS);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }


    private void setAdapter(List<GroupMemberInfo> list) {
        Utils.setPinYinAndSort(list);
        if (administratorAdapter == null) {
            administratorAdapter = new AddAdministratorAdapter(getApplicationContext(), list);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setAdapter(administratorAdapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    addAdministrator(administratorAdapter.getList().get(position).getUid());
                }
            });
        } else {
            administratorAdapter.updateList(list);
        }
    }
}