package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGroupChatGridImageView;
import com.jizhi.jlongg.main.bean.BalanceWithdrawAccount;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.ScanCode;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

/**
 * 扫描二维码加入班组、项目组、群聊
 *
 * @author hcs
 * @time 2016年9月6日 18:34:13
 * @Version 2.0
 */
public class ScanCodeAddTeamGroupActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 二维码扫描 班组、项目组信息
     */
    private GroupDiscussionInfo groupDiscussionInfo;


    /**
     * @param context
     */
    public static void actionStart(Activity context, ScanCode scanCode) {
        Intent intent = new Intent(context, ScanCodeAddTeamGroupActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, scanCode);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.scancode_detail);
        ScanCode result = (ScanCode) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (result == null) {
            CommonMethod.makeNoticeShort(this, "数据加载出错", CommonMethod.ERROR);
            finish();
            return;
        }
        setTextTitle(R.string.addteamgroup);
        findViewById(R.id.bottom_layout).setVisibility(View.GONE);
        searchScanCodeData(result);
    }


    /**
     * 根据二维码查询班组、项目组、群聊信息
     *
     * @param bean
     */
    public void searchScanCodeData(ScanCode bean) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("inviter_uid", bean.getInviter_uid());// 	邀请者uid
        params.addBodyParameter("time", bean.getTime());// 二维码生成时间
        params.addBodyParameter("class_type", bean.getClass_type());//	group为班组，team为项目组
        params.addBodyParameter("group_id", !TextUtils.isEmpty(bean.getGroup_id()) ? bean.getGroup_id() : bean.getTeam_id());
        CommonHttpRequest.commonRequest(this, NetWorkRequest.QRCODE, GroupDiscussionInfo.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupDiscussionInfo groupDiscussionInfo = (GroupDiscussionInfo) object;
                if (groupDiscussionInfo != null) {
                    fillData(groupDiscussionInfo);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 填充班组、项目组、群聊信息
     *
     * @param result
     */
    private void fillData(GroupDiscussionInfo result) {
        findViewById(R.id.bottom_layout).setVisibility(View.VISIBLE);
        TextView naviTitle = (TextView) findViewById(R.id.title); //标题
        TextView createName = (TextView) findViewById(R.id.creator_name); //创建者名称
        TextView groupName = (TextView) findViewById(R.id.group_name); //项目名称
        Button joinButton = (Button) findViewById(R.id.red_btn); //加入按钮
        switch (result.getClass_type()) {
            case WebSocketConstance.TEAM: //扫描的项目组信息
                createName.setText(String.format(getString(R.string.team_creator), result.getCreater_name()));
                joinButton.setText(getString(R.string.join_team)); //底部按钮
                naviTitle.setText(getString(R.string.join_team)); //导航栏标题
                groupName.setText(result.getGroup_name());
                break;
            case WebSocketConstance.GROUP: //扫描的班组信息
                createName.setText(String.format(getString(R.string.group_creator), result.getCreater_name()));
                joinButton.setText(getString(R.string.into_group)); //底部按钮
                naviTitle.setText(getString(R.string.into_group)); //导航栏标题
                groupName.setText(result.getGroup_name());
                break;
            case WebSocketConstance.GROUP_CHAT://扫描的群聊信息
                createName.setText(String.format(getString(R.string.group_chat_creator), result.getCreater_name()));
                naviTitle.setText("进入群聊"); //导航栏标题
                joinButton.setText("进入群聊");//底部按钮
                groupName.setText(result.getGroup_name());
                break;
        }
        NineGroupChatGridImageView groudIcon = (NineGroupChatGridImageView) findViewById(R.id.groudIcon);
        groudIcon.setImagesData(result.getMembers_head_pic());
        joinButton.setVisibility(View.VISIBLE);
        groupDiscussionInfo = result;
    }

    @Override
    public void onClick(View v) {
        String groupId = groupDiscussionInfo.getGroup_id();
        final String classType = groupDiscussionInfo.getClass_type();
        String inviterUid = groupDiscussionInfo.getInviter_uid();
        MessageUtil.addMembers(this, groupId, classType, true, System.currentTimeMillis() / 1000, inviterUid, null, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                BalanceWithdrawAccount userInfo = (BalanceWithdrawAccount) object;
                if (userInfo != null && userInfo.getList() != null && userInfo.getList().size() > 0) {
                    groupDiscussionInfo.getMembers_head_pic().add(userInfo.getList().get(0).getHead_pic()); //将自己的头像添加进去
                    groupDiscussionInfo.setMembers_num((Integer.parseInt(groupDiscussionInfo.getMembers_num()) + 1) + ""); //设置数量+1
                }
                //我们将新创建的班组存储在数据库中
                MessageUtil.addTeamOrGroupToLocalDataBase(ScanCodeAddTeamGroupActivity.this, null, groupDiscussionInfo, true);
                Intent intent = getIntent();
                //如果是群聊则设置直接进入聊天的标识
                intent.putExtra(Constance.IS_ENTER_GROUP, WebSocketConstance.GROUP_CHAT.equals(classType) ? true : false);
                intent.putExtra(Constance.BEAN_CONSTANCE, groupDiscussionInfo);
                setResult(MessageUtil.WAY_CREATE_GROUP_CHAT, intent);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }
}