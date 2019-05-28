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
import com.jizhi.jlongg.main.adpter.CommonPersonListAdapter;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 转让群聊管理权
 *
 * @author Xuj
 * @time 2016-12-27 14:45:33
 * @Version 1.0
 */
public class SwitchManagerActivity extends BaseActivity {

    /**
     * 管理员列表适配器
     */
    private CommonPersonListAdapter adapter;


    /**
     * 启动当前Acitivty
     *
     * @param context
     * @param groupMemberInfos 成员信息
     * @param groupId          项目组id
     */
    public static void actionStart(Activity context, List<GroupMemberInfo> groupMemberInfos, String groupId) {
        Intent intent = new Intent(context, SwitchManagerActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, (Serializable) groupMemberInfos);
        intent.putExtra(Constance.GROUP_ID, groupId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview_sidebar);
        initData();
    }


    private void initData() {
        setTextTitle(R.string.transfer_management);
        Intent intent = getIntent();
        ArrayList<GroupMemberInfo> list = (ArrayList<GroupMemberInfo>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (list == null || list.size() == 0) {
            finish();
            return;
        }
        int size = list.size();
        for (int i = 0; i < size; i++) { //排除当前管理员
            if (list.get(i).getIs_creater() == 1) {
                list.remove(i);
                break;
            }
        }
        if (list.size() == 0) {
            CommonMethod.makeNoticeShort(getApplicationContext(), "没有更多成员，不能转让管理权", CommonMethod.ERROR);
            finish();
            return;
        }
        Utils.setPinYinAndSort(list);
        adapter = new CommonPersonListAdapter(this, list, false);
        adapter.setFootText("共" + list.size() + "人");
        adapter.setHiddenTel(true);
        final ListView listView = (ListView) findViewById(R.id.listView);
        final View headView = getLayoutInflater().inflate(R.layout.text_head, null);
        TextView headText = (TextView) headView.findViewById(R.id.headText);
        headText.setText("请选择新的群主");
        listView.addHeaderView(headView, null, false);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                position = position - listView.getHeaderViewsCount();
                final GroupMemberInfo groupMemberInfo = adapter.getList().get(position);
                new DialogOnlyTitle(SwitchManagerActivity.this, new DiaLogTitleListener() {
                    @Override
                    public void clickAccess(int position) {
                        switchManager(groupMemberInfo.getUid());
                    }
                }, position, String.format(getString(R.string.switch_manager_tips), groupMemberInfo.getReal_name())).show();
            }
        });
        TextView centerText = getTextView(R.id.center_text);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //搜索框
        sideBar.setTextView(centerText);
        // 设置右侧触摸监听
        sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() {
            @Override
            public void onTouchingLetterChanged(String s) {
                if (adapter != null) {
                    //该字母首次出现的位置
                    int position = adapter.getPositionForSection(s.charAt(0));
                    if (position != -1) {
                        listView.setSelection(position);
                    }
                }
            }
        });
    }

    /**
     * 转让管理权
     *
     * @param uid
     */
    private void switchManager(String uid) {
        String httpUrl = NetWorkRequest.SWITCH_MANAGER;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID));
        params.addBodyParameter("class_type", WebSocketConstance.GROUP_CHAT);
        params.addBodyParameter("uid", uid);
        CommonHttpRequest.commonRequest(this, httpUrl, BaseNetNewBean.class, false, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "管理权转让成功", CommonMethod.SUCCESS);
                setResult(Constance.SWITCH_MANAMGER);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }

//    @Override
//    public void onFinish(View view) {
//        if (isRemoveGroup) {
//            setResult(Constance.REFRESH);
//        }
//        super.onFinish(view);
//    }
//
//    @Override
//    public void onBackPressed() {
//        if (isRemoveGroup) {
//            setResult(Constance.REFRESH);
//        }
//        super.onBackPressed();
//    }
//
////    private boolean isRemoveGroup;
//
//    /**
//     * 广播回调
//     */
//    class MessageBroadcast extends BroadcastReceiver {
//        @Override
//        public void onReceive(Context context, Intent intent) {
//            String action = intent.getAction();
////            if (action.equals(WebSocketConstance.ACTION_SWICH_MANGER_IS_EXIT)) {
////                isRemoveGroup = true;
////                adapter.getList().remove(clickPosition);
////                adapter.notifyDataSetChanged();
////                CommonMethod.makeNoticeShort(getApplicationContext(), "该成员已退出本群", CommonMethod.ERROR);
////            }
//        }
//    }
}