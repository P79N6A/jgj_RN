package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.CommonSingleSelectedAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.List;

/**
 * 功能:升级为项目组成员列表
 * 时间:2016年9月28日 18:00:31
 * 作者:xuj
 */
public class UpgradeMemberListActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 升级为项目组成员列表适配器
     */
    private CommonSingleSelectedAdapter adapter;
    /**
     * 下一步按钮
     */
    private TextView nextTxt;
    /**
     * 当前选中的列表下标
     */
    private int selectePosition = -1;

    /**
     * 移除没有真实姓名的人
     *
     * @param infos
     */
    private void removeNoRealNameUser(List<GroupMemberInfo> infos) {
        if (infos != null && !infos.isEmpty()) {
            int size = infos.size();
            for (int i = 0; i < size; i++) {
                if (infos.get(i).getIs_active() == 0) {
                    infos.remove(i);
                    removeNoRealNameUser(infos);
                    break;
                }
            }
        }
    }


    private void setNextUnClick() {
        nextTxt.setClickable(false);
        nextTxt.setTextColor(getResources().getColor(R.color.color_999999));
    }

    private void setNextClick() {
        nextTxt.setClickable(true);
        nextTxt.setTextColor(getResources().getColor(R.color.app_color));
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.upgrade_choose_member);
        initView();
    }

    private void initView() {
        nextTxt = (TextView) findViewById(R.id.right_title);
        setNextUnClick();
        setTextTitleAndRight(R.string.upgrade_group, R.string.button_ok);
        Intent intent = getIntent();
        List<GroupMemberInfo> groupMemberInfoList = (List<GroupMemberInfo>) intent.getSerializableExtra(Constance.BEAN_ARRAY);
        removeNoRealNameUser(groupMemberInfoList);
        Utils.setPinYinAndSort(groupMemberInfoList);
        adapter = new CommonSingleSelectedAdapter(this, groupMemberInfoList);
        final ListView listView = (ListView) findViewById(R.id.listView);
        final View headView = getLayoutInflater().inflate(R.layout.text_head, null); // 通讯录头部
        TextView headText = (TextView) headView.findViewById(R.id.headText);
        headText.setText("请选择班组创建者");
        listView.addHeaderView(headView, null, false);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (selectePosition != -1) {
                    adapter.getList().get(selectePosition).setSelected(false);
                }
                position = position - listView.getHeaderViewsCount();
                GroupMemberInfo info = adapter.getList().get(position);
                info.setSelected(!info.isSelected());
                selectePosition = position;
                adapter.notifyDataSetChanged();
                setNextClick();
            }
        });
    }


    @Override
    public void onClick(View view) {
        if (selectePosition == -1) {
            CommonMethod.makeNoticeShort(getApplicationContext(), "请选择班组创建者", CommonMethod.ERROR);
        } else {
            upgrade(adapter.getList().get(selectePosition).getUid());
        }
    }


    /**
     * 升级群聊为班组
     *
     * @param uid
     */
    public void upgrade(String uid) {
        String httpUrl = NetWorkRequest.UPGRADE_GROUP;
        final String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("group_name", getIntent().getStringExtra(Constance.GROUP_NAME));//班组名称
        params.addBodyParameter("pro_name", getIntent().getStringExtra(Constance.PRONAME)); //项目名称
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", WebSocketConstance.GROUP_CHAT);
        params.addBodyParameter("uid", uid);
        CommonHttpRequest.commonRequest(this, httpUrl, GroupDiscussionInfo.class, false, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupDiscussionInfo groupDiscussionInfo = (GroupDiscussionInfo) object;
                if (groupDiscussionInfo != null) {
                    MessageUtil.updateGroupClassTypeAndGroupId(UpgradeMemberListActivity.this, groupDiscussionInfo, groupId, WebSocketConstance.GROUP_CHAT);
                    Intent intent = getIntent();
                    intent.putExtra(Constance.BEAN_CONSTANCE, groupDiscussionInfo);
                    setResult(Constance.UPGRADE, intent);
                    finish();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

}
