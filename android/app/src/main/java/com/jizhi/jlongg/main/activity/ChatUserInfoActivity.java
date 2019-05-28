package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.CallPhoneUtil;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.UserInfoClickListener;
import com.jizhi.jlongg.main.AppMainActivity;
import com.jizhi.jlongg.main.adpter.UserInfoImageAdapter;
import com.jizhi.jlongg.main.adpter.UserinfoRecyclerViewAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.ChatUserInfo;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.dialog.DialogMore;
import com.jizhi.jlongg.main.dialog.UserInfoMorePopWindow;
import com.jizhi.jlongg.main.fragment.NewLifeFragment;
import com.jizhi.jlongg.main.fragment.foreman.FindHelperFragment;
import com.jizhi.jlongg.main.fragment.foreman.MyFragmentWebview;
import com.jizhi.jlongg.main.message.MessageImagePagerActivity;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.msg.NewMsgActivity;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DBMsgUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.ThreadPoolManager;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.CanDoBlankGridView;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;


/**
 * CName:聊天对象信息
 * User: xuj
 * Date: 2016-12-20
 * Time: 9:53:21
 */
public class ChatUserInfoActivity extends BaseActivity implements View.OnClickListener {

    private RoundeImageHashCodeTextLayout headImage;

    /**
     * 备注名称
     */
    private TextView tv_remarkName;

    private ChatUserInfoActivity mActivity;
    /**
     * 回调刷新了数据
     */
    private boolean MsgActIsFlush;
    private ChatUserInfo info;
    private CanDoBlankGridView ngl_imagest;
    private String uid;
    private LinearLayout signLayout;
    private String add_friend_desc;
    private boolean add_friend_validate;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.chat_userinfo);
        getIntentData();
        initView();
        registerReceiver();
        initButton();
        getChatMemberInfo();
    }

    /**
     * 注册广播
     */
    private void registerReceiver() {
        IntentFilter filter = new IntentFilter(); //消息接收广播器
        filter.addAction(WebSocketConstance.MODIFT_PERSON_INFO); //更新了个人资料
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
                    case WebSocketConstance.MODIFT_PERSON_INFO: // 更新了个人资料
                        LUtils.e("----更新了个人资料------");
                        getChatMemberInfo();
                        break;

                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param uid
     * @param addFriendDesc 添加好友验证的描述
     */
    public static void actionStart(Activity context, String uid, String addFriendDesc) {
        Intent intent = new Intent(context, ChatUserInfoActivity.class);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra("add_friend_desc", addFriendDesc);
        intent.putExtra("add_friend_validate", true);//添加好友的标识
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * @param context
     */
    public static void actionStart(Activity context, String uid) {
        Intent intent = new Intent(context, ChatUserInfoActivity.class);
        intent.putExtra(Constance.UID, uid);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 同意好友申请
     *
     * @param uid 用户id
     */
    public void agreeFriend(String uid) {
        String httpUrl = NetWorkRequest.AGREE_FRIENDS;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("uid", uid);
        CommonHttpRequest.commonRequest(this, httpUrl, BaseNetNewBean.class, false, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "添加成功", CommonMethod.SUCCESS);
//                autoRefresh();
                findViewById(R.id.btn_pass).setVisibility(View.GONE);
                findViewById(R.id.add_friend_req_text).setVisibility(View.GONE);
                findViewById(R.id.btn_chat).setVisibility(View.VISIBLE);
                findViewById(R.id.btn_black).setVisibility(View.VISIBLE);
                findViewById(R.id.btn_addfriend).setVisibility(View.VISIBLE);
                findViewById(R.id.btn_callPhone).setVisibility(View.VISIBLE);
                add_friend_validate = false;
                add_friend_desc = null;
                info.setIs_friend(1);
                info.setIs_chat(1);
                initButton();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                //只要报错我们就去刷新消息
//                autoRefresh();
            }
        });
    }

    /**
     * 获取传递过来的数据
     */
    public void getIntentData() {
        uid = getIntent().getStringExtra(Constance.UID);
        add_friend_desc = getIntent().getStringExtra("add_friend_desc");
        add_friend_validate = getIntent().getBooleanExtra("add_friend_validate", false);
    }

    /**
     * 某个成员信息
     */
    public void getChatMemberInfo() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter(Constance.UID, uid);
        CommonHttpRequest.commonRequest(this, NetWorkRequest.GET_CHAT_MEMBER_INFO, ChatUserInfo.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                info = (ChatUserInfo) object;
                if (null == info) {
                    mActivity.finish();
                    return;
                }
                if (!TextUtils.isEmpty(info.getUid()) && !TextUtils.isEmpty(info.getHead_pic())) {
                    Intent intent = new Intent(WebSocketConstance.CHECK_HEAD_ISCHANGE);
                    intent.putExtra(Constance.UID, info.getUid());
                    intent.putExtra(Constance.HEAD_IMAGE, info.getHead_pic());
                    LocalBroadcastManager.getInstance(UclientApplication.instance).sendBroadcast(intent);
                }
                initUserInfo();
                initButton();
                if (add_friend_validate
                        && !TextUtils.isEmpty(add_friend_desc)) {
                    ((TextView) findViewById(R.id.add_friend_req_text)).setText(info.getChat_name() + " : " + add_friend_desc);
                    return;

                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();
                mActivity.finish();

            }
        });
    }

    /**
     * 加入移除黑名单
     */
    public void addOrRemoveBlckList() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter(Constance.UID, uid);
        //用户状态 true表示移除黑名单,false表示加入黑名单
        final boolean removeBlackList = info.getIs_black() == 1 ? true : false;
        MessageUtil.removeBlackList(this, uid, removeBlackList, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                info.setIs_black(removeBlackList ? 0 : 1);
                initButton();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    /**
     * 删除好友
     */
    public void deleteFrend() {
        String httpUrl = NetWorkRequest.DEL_FRIEND;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("uid", uid);
        CommonHttpRequest.commonRequest(this, httpUrl, GroupMemberInfo.class, true, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                //删除本地已聊天的单聊对象
                DBMsgUtil.getInstance().deleteMessage(ChatUserInfoActivity.this, uid, WebSocketConstance.SINGLECHAT);
                info.setIs_friend(0);
                //4.0.2 fix #20193 【共同好友】在聊天对话框点击分享的招工信息添加好友 对方通过后显示为“通过聊天添加”，应该是通过“找活招工添加”
                //info.setIs_chat(0);
                initButton();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 是否在黑名单
     */
    public void isBalckList() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter(Constance.UID, uid);
        CommonHttpRequest.commonRequest(this, NetWorkRequest.IS_BLACK_LIST, ChatUserInfo.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ChatUserInfo userInfo = (ChatUserInfo) object;
                if (userInfo.getIs_black() == 1) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "对方暂时不想和你聊天", CommonMethod.ERROR);
                    return;
                }
                GroupDiscussionInfo gInfo = new GroupDiscussionInfo();
                gInfo.setGroup_id(uid);
                gInfo.setClass_type(WebSocketConstance.SINGLECHAT);
                gInfo.setGroup_name(info.getChat_name());
                List<String> headList = new ArrayList<>();
                headList.add(info.getHead_pic());
                gInfo.setMembers_head_pic(headList);

                Intent intent = getIntent();
                Bundle bundle = new Bundle();
                bundle.putSerializable(Constance.BEAN_CONSTANCE, gInfo);
                intent.putExtras(bundle);
                if (MsgActIsFlush) {
                    //如果修改了名字聊天之前先把数据库名字更改了
                    String real_name = TextUtils.isEmpty(info.getComment_name()) ? info.getReal_name() : info.getComment_name();
                    DBMsgUtil.getInstance().updateNickName(gInfo.getGroup_id(), gInfo.getClass_type(), real_name, getIntent().getStringExtra(Constance.UID), getApplicationContext());
                }
//                ChatUserInfoActivity.this.setResult(Constance.CLICK_SINGLECHAT, intent);
//                finish();

                NewMsgActivity.actionStart(mActivity, gInfo);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 判断是否资格添加朋友
     */
    public void getFriendsConfidion() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter(Constance.UID, uid);
        CommonHttpRequest.commonRequest(this, NetWorkRequest.GET_FRIENDS_CONFIDITION, ChatUserInfo.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ChatUserInfo userInfo = (ChatUserInfo) object;
                if (userInfo.getStatus() == 1) {
                    AddFriendSendCodectivity.actionStart(mActivity, getIntent().getStringExtra(Constance.UID));
                } else {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "不能添加对方为好友", CommonMethod.ERROR);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 设置用户信息
     */
    public void initUserInfo() {
        //头像
        headImage.setView(info.getHead_pic(), info.getChat_name(), 0);
        //电话
        ((TextView) findViewById(R.id.telephone)).setText("手机号码：" + info.getTelephone());
        //真实姓名
        ((TextView) findViewById(R.id.realName)).setText(TextUtils.isEmpty(info.getReal_name()) ? "" : info.getReal_name());
        tv_remarkName.setText(TextUtils.isEmpty(info.getComment_name()) ? "" : info.getComment_name());
        //昵称
        ((TextView) findViewById(R.id.userName)).setText("昵称：" + (TextUtils.isEmpty(info.getNick_name()) ? "" : info.getNick_name()));
        findViewById(R.id.userName).setVisibility(TextUtils.isEmpty(info.getNick_name()) ? View.GONE : View.VISIBLE);
        //个性签名
        if (!TextUtils.isEmpty(info.getSignature())) {
            ((TextView) findViewById(R.id.tv_signature)).setText(info.getSignature());
        } else {
            ((TextView) findViewById(R.id.tv_signature)).setText("独一无二的个性介绍，会让你的朋友满天下！");

        }

        //他的贴子
        if (info.getPic_src() == null || info.getPic_src().size() == 0) {
            if (!TextUtils.isEmpty(info.getContent())) {
                ((TextView) findViewById(R.id.tv_content)).setText(info.getContent());
                findViewById(R.id.tv_content).setVisibility(View.VISIBLE);
            }
        } else {
            ngl_imagest.setVisibility(View.VISIBLE);
            UserInfoImageAdapter squaredImageAdapter = new UserInfoImageAdapter(mActivity, info.getPic_src());
            ngl_imagest.setAdapter(squaredImageAdapter);
        }
        //共同好友
        if (null != info.getCommon_friends() && info.getCommon_friends().size() > 0 && !uid.equals(UclientApplication.getUid())) {
            findViewById(R.id.lin_connection).setVisibility(View.VISIBLE);
            ((TextView) findViewById(R.id.tv_connection)).setText(info.getCommon_friends().size() + "个共同好友");
            final RecyclerView mRecyclerView = findViewById(R.id.recyclerview);
            //设置布局管理器
            LinearLayoutManager linearLayoutManager = new LinearLayoutManager(mActivity);
            linearLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
            mRecyclerView.setLayoutManager(linearLayoutManager);
            List<GroupMemberInfo> list = info.getCommon_friends().size() > 4 ? info.getCommon_friends().subList(0, 4) : info.getCommon_friends();
            mRecyclerView.setAdapter(new UserinfoRecyclerViewAdapter(mActivity, list, new UserinfoRecyclerViewAdapter.OnItemClickLitener() {
                @Override
                public void onItemClick(View view, int position) {


                    CommonFriendActivity.actionStart(mActivity, info.getCommon_friends(), info.getNick_name());
                    unRegisterReceiver();

                }
            }));
            findViewById(R.id.lin_connection).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    CommonFriendActivity.actionStart(mActivity, info.getCommon_friends(), info.getNick_name());
                    unRegisterReceiver();
                }
            });
        } else {
            findViewById(R.id.lin_connection).setVisibility(View.GONE);
        }
    }

    /**
     * 初始化View
     */
    private void initView() {
        mActivity = ChatUserInfoActivity.this;
//        ImageView imageView = findViewById(R.id.rightImage);
        headImage = findViewById(R.id.roundImageHashText);
        tv_remarkName = findViewById(R.id.remarkName);
        signLayout = findViewById(R.id.signLayout);
        headImage.setOnClickListener(this);
        setTextTitleAndRight(UclientApplication.getUid().equals(uid) ? R.string.userinfo_my : R.string.userinfo, R.string.more);

        ((TextView) findViewById(R.id.tv_myzone)).setText(UclientApplication.getUid().equals(uid) ? "我的贴子" : "他的贴子");
        findViewById(R.id.remarkLayout).setVisibility(UclientApplication.getUid().equals(uid) ? View.GONE : View.VISIBLE);
        findViewById(R.id.btn_black).setVisibility(View.GONE);
        findViewById(R.id.btn_addfriend).setVisibility(View.GONE);
        findViewById(R.id.btn_callPhone).setVisibility(View.GONE);
        findViewById(R.id.right_title).setVisibility(View.GONE);
        findViewById(R.id.right_title).setOnClickListener(this);
        findViewById(R.id.lin_homepage).setOnClickListener(this);
        ngl_imagest = findViewById(R.id.ngl_images);
        //item点击事件
        ngl_imagest.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                X5WebViewActivity.actionStart(mActivity, NetWorkRequest.user + uid + "&hidebtn=1");

            }
        });
        //空白区响应点击事件
        ngl_imagest.setOnTouchInvalidPositionListener(new CanDoBlankGridView.OnTouchInvalidPositionListener() {
            @Override
            public boolean onTouchInvalidPosition(int motionEvent) {
                X5WebViewActivity.actionStart(mActivity, NetWorkRequest.user + uid + "&hidebtn=1");


                return false;
            }
        });
        if (!UclientApplication.getUid().equals(uid)) {
            signLayout.setClickable(false);
            ((ImageView) findViewById(R.id.right_arrow)).setVisibility(View.INVISIBLE);
        } else {
            signLayout.setClickable(true);
            ((ImageView) findViewById(R.id.right_arrow)).setVisibility(View.VISIBLE);
        }
    }

    /**
     * 设置按钮显示情况
     */
    public void initButton() {
        //如果是自己只消息发送消息
        if (UclientApplication.getUid().equals(uid)) {
            findViewById(R.id.right_title).setVisibility(View.VISIBLE);
            return;
        }
        if (add_friend_validate
                && !TextUtils.isEmpty(add_friend_desc)) {
            //隐藏之前的四个按钮，并且显示新加的文本和按钮
            findViewById(R.id.btn_pass).setVisibility(View.VISIBLE);
            findViewById(R.id.add_friend_req_text).setVisibility(View.VISIBLE);
            findViewById(R.id.btn_chat).setVisibility(View.GONE);
            findViewById(R.id.btn_black).setVisibility(View.GONE);
            findViewById(R.id.btn_addfriend).setVisibility(View.GONE);
            findViewById(R.id.btn_callPhone).setVisibility(View.GONE);
            findViewById(R.id.right_title).setVisibility(View.VISIBLE);
            return;

        }
        if (null == info) {
            return;
        }
        if (info.getIs_black() == 1) {
            //在黑名单
            findViewById(R.id.btn_black).setVisibility(View.VISIBLE);
            ((Button) findViewById(R.id.btn_black)).setText(getString(R.string.remove_blacklist));
            findViewById(R.id.btn_chat).setVisibility(View.GONE);
            findViewById(R.id.btn_addfriend).setVisibility(View.GONE);
            findViewById(R.id.btn_callPhone).setVisibility(View.GONE);
        } else {
            //不在黑名单
            ((Button) findViewById(R.id.btn_black)).setText(getString(R.string.join_blacklist));
            findViewById(R.id.btn_black).setVisibility(View.GONE);
            findViewById(R.id.btn_addfriend).setVisibility(info.getIs_friend() == 1 ? View.GONE : View.VISIBLE);
            findViewById(R.id.btn_callPhone).setVisibility(info.getIs_hidden() == 1 ? View.GONE : View.VISIBLE);
            findViewById(R.id.btn_chat).setVisibility(info.getIs_chat() == 1 ? View.VISIBLE : View.GONE);
        }
        //是好友或者不在黑名单显示
        if (info.getIs_friend() == 1 || info.getIs_black() == 0) {
            findViewById(R.id.right_title).setVisibility(View.VISIBLE);
        } else {
            findViewById(R.id.right_title).setVisibility(View.GONE);

        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_callPhone: //拨打电话
                if (null == info || TextUtils.isEmpty(info.getTelephone())) {
                    CommonMethod.makeNoticeShort(this, "拨打电话失败", CommonMethod.ERROR);
                    return;
                } else if (null == info || info.getTelephone().contains("*")) {
                    CommonMethod.makeNoticeShort(this, "你还不能拨打电话!", CommonMethod.ERROR);
                    return;
                }
                CallPhoneUtil.callPhone(this, info.getTelephone());
                break;
            case R.id.btn_chat: //聊天
                if (null == info) {
                    return;
                }
                isBalckList();
                break;
            case R.id.btn_black:
                if (null == info) {
                    return;
                }
                //加入移除黑名单
                addOrRemoveBlckList();
                break;
            case R.id.right_title:
                if (UclientApplication.getUid().equals(uid)) {
                    DialogMore dialogMore = new DialogMore(mActivity, DialogMore.getUserInfoBean(), new DialogMore.DialogMoreInterFace() {
                        @Override
                        public void delete() {
                        }

                        @Override
                        public void success() {
                            X5WebViewActivity.actionStart(mActivity, NetWorkRequest.MYINFO);

                        }
                    });
                    dialogMore.showAtLocation(findViewById(R.id.rootView), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);//这种方式无论有虚拟按键还是没有都可完全显示，因为它显示的在整个父布局中
                    BackGroundUtil.backgroundAlpha(mActivity, 0.5f);
                    return;
                }
                //黑名单、删除好友弹出框
                UserInfoMorePopWindow blackListPopWindow = new UserInfoMorePopWindow(this, getIntent().getStringExtra(Constance.UID), info.getIs_black(), info.getIs_friend(), new UserInfoClickListener() {
                    @Override
                    public void addOrRemoveBalck() {
                        addOrRemoveBlckList();
                    }

                    @Override
                    public void delFriend() {
                        deleteFrend();
                    }
                });
                //显示窗口
                blackListPopWindow.showAsDropDown(findViewById(R.id.right_title), 0, DensityUtils.dp2px(mActivity, 0));
                break;
            case R.id.remarkLayout: //设置备注名称
                ModifyGroupTeamInfoActivity.actionStart(mActivity, tv_remarkName.getText().toString(), getIntent().getStringExtra(Constance.GROUP_ID),
                        getIntent().getStringExtra(Constance.CLASSTYPE), getIntent().getStringExtra(Constance.UID), ModifyGroupTeamInfoActivity.UPDATE_PERSON_REMARK);
                break;
            case R.id.lin_homepage: //TA的动态
                //hidebtn=1隐藏底部按钮
                X5WebViewActivity.actionStart(mActivity, NetWorkRequest.user + uid + "&hidebtn=1");
                break;
            case R.id.btn_addfriend: //加为朋友
                getFriendsConfidion();
                break;
            case R.id.roundImageHashText: //头像方法
                if (headImage.getRoundeImageView() != null) {
                    List<String> list = new ArrayList<>();
                    list.add(info.getHead_pic());
                    picBrrow(list, 0, headImage.getRoundeImageView());
                }
                break;
            case R.id.signLayout:
                if (UclientApplication.getUid().equals(uid)) {
                    X5WebViewActivity.actionStart(this, NetWorkRequest.MYINFO);
                }
                break;
            case R.id.btn_pass:
                agreeFriend(uid);
                break;
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUEST && resultCode == Constance.SUCCESS) {
            MsgActIsFlush = true;
            info.setComment_name(data.getStringExtra(Constance.COMMENT_NAME));
            tv_remarkName.setText(TextUtils.isEmpty(info.getComment_name()) ? "" : info.getComment_name());
        } else if (requestCode == Constance.requestCode_msg && resultCode == Constance.FIND_WORKER_CALLBACK) {
            LUtils.e("-------3-----------");
            setResult(Constance.FIND_WORKER_CALLBACK, getIntent());
            finish();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        }
    }


    public void picBrrow(List<String> list, int index, ImageView imageView) {
        //imagesize是作为loading时的图片size
        MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(imageView.getMeasuredWidth(), imageView.getMeasuredHeight());
        MessageImagePagerActivity.startImagePagerActivity(mActivity, list, index, imageSize);
    }


    @Override
    public void onFinish(View view) {
        if (MsgActIsFlush) {
            Intent intent = new Intent();
//            intent.putExtra(Constance.BEAN_STRING, WebSocketConstance.SINGLECHAT);
            intent.putExtra(Constance.COMMENT_NAME, TextUtils.isEmpty(info.getComment_name()) ? info.getReal_name() : info.getComment_name());
            intent.putExtra(Constance.UID, getIntent().getStringExtra(Constance.UID));
            setResult(Constance.FLUSH_NICKNAME, intent);
        }
        /**
         * 回到{@link FriendApplicationListActivity}刷新数据，更新状态等
         */
        setResult(RESULT_OK);
        super.onFinish(view);


    }

    @Override
    public void onBackPressed() {
        if (MsgActIsFlush) {
            LUtils.e("------11--修改备注回调--------");
            Intent intent = new Intent();
//            intent.putExtra(Constance.BEAN_STRING, WebSocketConstance.SINGLECHAT);
            intent.putExtra(Constance.COMMENT_NAME, TextUtils.isEmpty(info.getComment_name()) ? info.getReal_name() : info.getComment_name());
            intent.putExtra(Constance.UID, getIntent().getStringExtra(Constance.UID));
            setResult(Constance.FLUSH_NICKNAME, intent);
        } else {
            LUtils.e("------00--修改备注回调--------");
        }
        /**
         * 回到{@link FriendApplicationListActivity}刷新数据，更新状态等
         */
        setResult(RESULT_OK);
        super.onBackPressed();
    }
}
