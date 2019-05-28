package com.jizhi.jlongg.main.activity;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.AddAtMemberAdapter;
import com.jizhi.jlongg.main.bean.BaseRequestParameter;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.WebSocket;
import com.lidroid.xutils.ViewUtils;

import java.util.List;


/**
 * 添加@对象
 *
 * @author Xuj
 * @time 2016-11-28 17:47:42
 * @Version 1.0
 */
public class AddAtMemberActivity extends BaseActivity {


    private AddAtMemberAdapter administratorAdapter;

    private ListView listView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_at_member);
        ViewUtils.inject(this); // Xutil必须调用的一句话
        initSideBar();
        registerReceiver();
        requestData();
    }

    private void initSideBar() {
        setTextTitle(R.string.addMember);
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
     * 注册广播
     */
    public void registerReceiver() {
        IntentFilter filter = new IntentFilter();
//        filter.addAction(WebSocketConstance.ACTION_OPER_MEMBERLIST);//管理员列表
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }

    /**
     * 请求数据
     */
    private void requestData() {
        WebSocket webSocket = SocketManager.getInstance(getApplicationContext()).getWebSocket();
        if (webSocket != null) {
            String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
            BaseRequestParameter parameter = new BaseRequestParameter();
            parameter.setCtrl("team");
            parameter.setType("at_member");
            parameter.setClient_type(classType.equals(Constance.GROUP) ? "person" : "manage");
            parameter.setGroup_id(getIntent().getStringExtra(Constance.GROUP_ID));
            parameter.setClass_type(classType);
            webSocket.requestServerMessage(parameter);
        }
    }

    /**
     * 添加管理员
     */
    private void addAdministrator(GroupMemberInfo info) {
        PersonBean clickPerson = new PersonBean();
        clickPerson.setName(info.getReal_name());
        clickPerson.setTelph(info.getTelephone());
        clickPerson.setUid(Integer.parseInt(info.getUid()));
        Intent intent = getIntent();
        intent.putExtra(Constance.BEAN_ARRAY, clickPerson);
        setResult(Constance.PERSON, intent);
        finish();
    }


    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
//            if (action.equals(WebSocketConstance.ACTION_OPER_MEMBERLIST)) { //查询管理员列表
//                GroupManager manager = (GroupManager) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
//                if (manager.getType().equals(WebSocketConstance.AT_MEMBER)) {
//                    setAdapter(manager.getList());
//                }
//            }
        }
    }


    private void setAdapter(List<GroupMemberInfo> list) {
        Utils.setPinYinAndSort(list);
        if (administratorAdapter == null) {
            administratorAdapter = new AddAtMemberAdapter(getApplicationContext(), list);
            listView.setAdapter(administratorAdapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    GroupMemberInfo info = administratorAdapter.getList().get(position);
                    addAdministrator(info);
                }
            });
        } else {
            administratorAdapter.updateList(list);
        }
    }


}