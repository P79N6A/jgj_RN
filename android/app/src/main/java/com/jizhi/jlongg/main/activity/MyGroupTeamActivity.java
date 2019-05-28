package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.View;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.zxing.client.android.scanner.CaptureActivity;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGroupChatGridImageView;
import com.jizhi.jlongg.main.adpter.ChatMainGridModelAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AgencyGroupUser;
import com.jizhi.jlongg.main.bean.ChatMainInfo;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.msg.NewMsgActivity;
import com.jizhi.jlongg.main.popwindow.WorkCirclePopWindow;
import com.jizhi.jlongg.main.strategy.AccountStrategy;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;

import java.text.SimpleDateFormat;


/**
 * 我的项目班组
 *
 * @author Xuj
 * @time 2019年3月4日16:05:05
 * @Version 1.0
 */
public class MyGroupTeamActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 班组信息
     */
    private GridView messageGridView;
    /**
     * 群聊消息数
     */
    private TextView unreadGroupMessageCount;
    /**
     * 工作回复消息数
     */
    private TextView unreadWorkReplyCount;
    /**
     * 是否是我创建的项目组
     */
    private View isMyselfGroup;
    /**
     * 代班长表示
     */
    private TextView isMyProxy;
    /**
     * 项目名称
     */
    private TextView proName;
    /**
     * 其他项目小红点
     */
    private View otherGroupRedCircle;
    /**
     * 项目是否已关闭
     */
    private ImageView isClosedIcon;
    /**
     * 项目组头像
     */
    private NineGroupChatGridImageView teamHeads;
    /**
     * 项目组班组数据
     */
    private ChatMainInfo chatMainInfo;
    /**
     * 顶部 右边按钮
     */
    private ImageView rightImage;
    /**
     * 是否已修改了群聊信息
     * 如果在项目或班组设置里面进行了修改数据那么会发送一条广播将这个变量设为true
     * 如果这个变量为true  则每次回到这个页面 都会重新读取本地数据库进行数据的刷新
     * 默认为false
     */
    private boolean isUpdateLocalGroupInfo = false;
    /**
     * 当前Activity是否在前台
     */
    private boolean isFront = false;
    /**
     * 无数据时展示的页面
     */
    private View noDataLayout;
    /**
     * 如果退出、删除、关闭 群聊信息
     * 如果这个变量为true  则每次回到这个页面 都会重新请求服务器
     * 默认为false
     */
    private boolean isRequestServer = false;
    /**
     * true 表示正在加载数据库数据
     */
    private boolean isLoadingDataBase;

    @Override
    public void onPause() {
        super.onPause();
        isFront = false;
    }


    @Override
    public void onResume() {
        super.onResume();
        isFront = true;
        if (isUpdateLocalGroupInfo) {
            isUpdateLocalGroupInfo = false;
            loadLocalDataBaseData(AccountStrategy.LOAD_SUCCESS_STATE);
        }
        if (isRequestServer) { //请求服务器数据
            isRequestServer = false;
            MessageUtil.getWorkCircleData(this);
            LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(new Intent(WebSocketConstance.CANCEL_CHAT_MAIN_INDEX_SUCCESS));
            return;
        }
    }

    /**
     * 加载本地数据库数据
     *
     * @param loadState 加载状态
     */
    private void loadLocalDataBaseData(final int loadState) {
        LUtils.e("刷新我的项目班组首页数据:" + new SimpleDateFormat("yyyy-MM-dd hh:ss:mm").format(new java.util.Date()));
        if (!isLoadingDataBase) {
            LUtils.e("进入到刷新数据");
            isLoadingDataBase = true;
            //加载离线消息有可能速度会很快，频繁刷新数据库不是很好，我们这里每次只要涉及到加载数据库的操作就延迟0.2秒
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    setGroupInfo(MessageUtil.getLocalWorkCircleData());
                    isLoadingDataBase = false;
                }
            }, 100);
        }
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, MyGroupTeamActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.my_group_team_layout);
        initView();
        registerReceiver();
        loadLocalDataBaseData(AccountStrategy.LOADING_STATE);
    }

    private void initView() {
        setTextTitle(R.string.my_group_team);
        noDataLayout = findViewById(R.id.no_data_layout);
        rightImage = (ImageView) findViewById(R.id.rightImage);
        rightImage.setImageResource(R.drawable.add_icon_new);
        teamHeads = (NineGroupChatGridImageView) findViewById(R.id.teamHeads);
        messageGridView = (GridView) findViewById(R.id.messageGridView);
        unreadGroupMessageCount = (TextView) findViewById(R.id.unread_group_message_count);
        unreadWorkReplyCount = (TextView) findViewById(R.id.unread_work_reply_message_count);
        isMyselfGroup = findViewById(R.id.is_myself_group);
        isMyProxy = findViewById(R.id.is_my_proxy);
        proName = (TextView) findViewById(R.id.proName);
        otherGroupRedCircle = findViewById(R.id.otherGroupRedCircle);
        isClosedIcon = (ImageView) findViewById(R.id.isClosedIcon);

        findViewById(R.id.other_group_layout).setOnClickListener(this);
        findViewById(R.id.unread_group_message_layout).setOnClickListener(this);
        findViewById(R.id.work_reply_unread_count_layout).setOnClickListener(this);
        findViewById(R.id.scan_code_text).setOnClickListener(this);
        findViewById(R.id.create_group_text).setOnClickListener(this);
    }

    /**
     * 设置项目组信息
     */
    private void setGroupInfo(ChatMainInfo chatMainInfo) {
        if (chatMainInfo == null || chatMainInfo.getGroup_info() == null) {
            noDataLayout.setVisibility(View.VISIBLE);
            return;
        }
        noDataLayout.setVisibility(View.GONE);
        this.chatMainInfo = chatMainInfo;
        final GroupDiscussionInfo groupInfo = chatMainInfo.getGroup_info(); //项目组信息
        final String classType = groupInfo.getClass_type(); //获取组的类型 Team表示项目组  Group表示班组
        boolean isMyselfGroup = UclientApplication.getUid().equals(groupInfo.getCreater_uid()); //是否是我创建的班组,如果创建者的id和登录者的uid相同 则认为是创建者
        AgencyGroupUser agencyGroupUser = groupInfo.getAgency_group_user(); //获取带班组信息
        teamHeads.setImagesData(groupInfo.getMembers_head_pic()); //设置图片头像
        messageGridView.setAdapter(new ChatMainGridModelAdapter(this, chatMainInfo, isMyselfGroup));
        proName.setText(groupInfo.getGroup_name()); //项目名称
        unreadGroupMessageCount.setText(Utils.setMessageCount(groupInfo.getUnread_msg_count())); //设置未读群聊信息
        unreadWorkReplyCount.setText(Utils.setMessageCount(chatMainInfo.getWork_message_num())); //设置工作回复消息
        if (groupInfo.getUnread_msg_count() > 0) { //群聊未读消息
            unreadGroupMessageCount.setVisibility(View.VISIBLE);
            unreadGroupMessageCount.setText(Utils.setMessageCount(groupInfo.getUnread_msg_count())); //设置未读群聊信息
        } else { //没有未读消息
            unreadGroupMessageCount.setVisibility(View.GONE);
        }
        if (chatMainInfo.getWork_message_num() > 0) { //工作回复未读消息
            unreadWorkReplyCount.setVisibility(View.VISIBLE);
            unreadWorkReplyCount.setText(Utils.setMessageCount(chatMainInfo.getWork_message_num())); //设置未读群聊信息
        } else { //没有未读消息
            unreadWorkReplyCount.setVisibility(View.GONE);
        }
        this.isMyselfGroup.setVisibility(isMyselfGroup ? View.VISIBLE : View.GONE); //是否是我创建的班组
        otherGroupRedCircle.setVisibility(chatMainInfo.getOther_group_unread_msg_count() == 1 ? View.VISIBLE : View.GONE); //其他项目小红点
        if (agencyGroupUser != null && !TextUtils.isEmpty(agencyGroupUser.getUid())) {
            isMyProxy.setVisibility(View.VISIBLE);
            isMyProxy.setText(agencyGroupUser.getUid().equals(UclientApplication.getUid()) ? "我代班的" : "已设代班");
        } else {
            isMyProxy.setVisibility(View.GONE);
        }
        if (groupInfo.getIs_closed() == 1) { //项目已关闭
            isClosedIcon.setVisibility(View.VISIBLE);
            isClosedIcon.setImageResource(classType.equals(WebSocketConstance.GROUP) ? R.drawable.group_closed_icon : R.drawable.team_closed_icon);
        } else {
            isClosedIcon.setVisibility(View.GONE);
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.rightImage: //顶部右上角更多按钮
                new WorkCirclePopWindow(this).showAsDropDown(rightImage, 0, 0);
                break;
            case R.id.unread_group_message_layout: //群聊消息
                if (chatMainInfo != null && chatMainInfo.getGroup_info() != null) {
                    clickGroupMessage(chatMainInfo.getGroup_info());
                }
                break;
            case R.id.work_reply_unread_count_layout: //工作回复
                if (chatMainInfo != null && chatMainInfo.getGroup_info() != null) {
                    clickWorkMessage(chatMainInfo, chatMainInfo.getGroup_info());
                }
                break;
            case R.id.other_group_layout: //其他项目
                changePro(chatMainInfo.getGroup_info());
                break;
            case R.id.scan_code_text: //扫描二维码
                if (!IsSupplementary.isFillRealNameIntentActivity(this, false, CaptureActivity.class)) {
                    return;
                }
                break;
            case R.id.create_group_text: //创建班组
                if (!IsSupplementary.isFillRealNameIntentActivity(this, false, CreateTeamGroupActivity.class)) {
                    return;
                }
                break;
        }
    }


    /**
     * 点击群聊消息
     *
     * @param groupInfo
     */
    private void clickGroupMessage(final GroupDiscussionInfo groupInfo) {
        //组已关闭
        if (groupInfo.getIs_closed() == 1) {
            CommonMethod.makeNoticeLong(this, "该" + (groupInfo.getClass_type().equals(WebSocketConstance.GROUP) ? "班组" : "项目组") + "已经删除无法聊天", CommonMethod.ERROR);
            return;
        }
        //登录用户是否已完善了姓名
        IsSupplementary.isFillRealNameCallBackListener(this, false, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() {
                //完善姓名成功
                Utils.sendBroadCastToUpdateInfo(MyGroupTeamActivity.this);
                MessageUtil.clearUnreadMessageCount(MyGroupTeamActivity.this, groupInfo);
            }
        });
    }

    /**
     * 点击工作消息
     *
     * @param chatMainInfo
     * @param groupInfo
     */
    private void clickWorkMessage(final ChatMainInfo chatMainInfo, final GroupDiscussionInfo groupInfo) {
        //登录用户是否已完善了姓名
        IsSupplementary.isFillRealNameCallBackListener(this, false, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() {
                toWorkMessage(chatMainInfo, groupInfo);
            }
        });
    }

    private void toWorkMessage(ChatMainInfo chatMainInfo, GroupDiscussionInfo groupInfo) {
        MessageUtil.cleaWorkMessageCount(chatMainInfo);
        unreadWorkReplyCount.setVisibility(View.GONE);
        ReplyMsgContentActivity.actionStart(this, groupInfo, MessageType.MSG_SAFE_STRING);
    }


    /**
     * 切换项目
     *
     * @param groupInfo
     */
    private void changePro(final GroupDiscussionInfo groupInfo) {
        IsSupplementary.isFillRealNameCallBackListener(this, false, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() {
                ProListActivity.actionStart(MyGroupTeamActivity.this, groupInfo.getGroup_id());
            }
        });
    }

    /**
     * 注册广播
     */
    private void registerReceiver() {
        IntentFilter filter = new IntentFilter(); //消息接收广播器
        filter.addAction(WebSocketConstance.LOAD_CHAT_MAIN_HTTP_SUCCESS); //加载首页数据成功后
        filter.addAction(WebSocketConstance.LOAD_CHAT_MAIN_HTTP_ERROR); //加载首页数据失败后
        filter.addAction(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST); //重新加载首页和聊聊列表本地数据
        filter.addAction(WebSocketConstance.REFRESH_SERVER_MAIN_INDEX_AND_CHAT_LIST); //重新加载首页和聊聊列表本地数据
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            try {
                String action = intent.getAction();
                switch (action) {
                    case WebSocketConstance.LOAD_CHAT_MAIN_HTTP_SUCCESS: //加载首页Http数据成功后的回调
                        loadLocalDataBaseData(AccountStrategy.LOAD_SUCCESS_STATE);
                        break;
                    case WebSocketConstance.LOAD_CHAT_MAIN_HTTP_ERROR: //加载首页http数据失败后的回调
                        loadLocalDataBaseData(AccountStrategy.LOAD_FAIL_STATE);
                        break;
                    case WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST: //只要接收到这个表示就刷新首页和聊聊数据库数据
                        if (isFront) { //如果是在首页页面的话 直接刷新本地数据
                            loadLocalDataBaseData(AccountStrategy.LOAD_SUCCESS_STATE);
                        } else { //如果是在其他页面接受到了刷新标识 则设置变量 当onResume在去刷新数据
                            isUpdateLocalGroupInfo = true;
                        }
                        break;
                    case WebSocketConstance.REFRESH_SERVER_MAIN_INDEX_AND_CHAT_LIST://当接收到这个广播的时候如果停留在当前页面则重新调用Http获取首页数据,否则设置标识在onResume里调用Http数据
                        if (isFront) {
                            MessageUtil.getWorkCircleData(MyGroupTeamActivity.this);
                            LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(new Intent(WebSocketConstance.CANCEL_CHAT_MAIN_INDEX_SUCCESS));
                        } else { //如果是在其他页面接受到了刷新标识 则设置变量 当onResume在去刷新数据
                            isRequestServer = true;
                        }
                        break;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) { //加入班组、项目组、群聊
            if (data.getBooleanExtra(Constance.IS_ENTER_GROUP, false)) {
                NewMsgActivity.actionStart(this, (GroupDiscussionInfo) data.getSerializableExtra(Constance.BEAN_CONSTANCE));
            }
        }
    }
}