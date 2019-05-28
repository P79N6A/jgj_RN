package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Message;
import android.provider.MediaStore;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SimpleItemAnimator;
import android.text.TextUtils;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.facebook.react.bridge.ReactApplicationContext;
import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.emoji.emotionkeyboard.EmotionKeyboard;
import com.jizhi.jlongg.emoji.fragment.EmotionMsgFragment;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.GroupChatManagerActivity;
import com.jizhi.jlongg.main.activity.GroupManagerActivity;
import com.jizhi.jlongg.main.activity.SingleChatManagerActivity;
import com.jizhi.jlongg.main.activity.TeamManagerActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.activity.procloud.LoadCloudPicActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AddFriendsSources;
import com.jizhi.jlongg.main.bean.DeleteMessageBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.PersonWorkInfoBean;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.dialog.NewMessageItemDialog;
import com.jizhi.jlongg.main.message.WebSocketMeassgeParameter;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DBMsgUtil;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.ThreadPoolManager;
import com.jizhi.jlongg.main.util.WebSocket;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.ChatPrimaryMenuBase;
import com.jizhi.jongg.widget.SmoothScrollLayoutManager;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import org.json.JSONArray;
import org.json.JSONObject;
import org.litepal.LitePal;
import org.litepal.crud.callback.SaveCallback;

import java.io.File;
import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import me.nereo.multi_image_selector.MultiImageSelectorFragment;
import me.nereo.multi_image_selector.utils.FileUtils;
import top.zibin.luban.CompressionPredicate;
import top.zibin.luban.Luban;
import top.zibin.luban.OnCompressListener;
import top.zibin.luban.OnRenameListener;

/**
 * CName:3.4.0聊天基类
 * User: hcs
 * Date: 2018-07-30
 * Time: 下午 3:39
 */
public class NewMessageBaseActivity extends BaseActivity implements ChatPrimaryMenuBase.EaseChatPrimaryMenuListener, EmotionKeyboard.ClickKeyBoardClickListner {

    protected NewMessageBaseActivity mActivity;
    /*表情主界面*/
    protected MessageBroadCastListener broadCastSuccessListener;
    /*表情主界面*/
    protected EmotionMsgFragment emotionMsgFragment;
    /*消息RecyclerView*/
    protected RecyclerView lv_msg;
    /*群组信息 */
    protected GroupDiscussionInfo gnInfo;
    /*用户名字,头像 */
    protected String userName, headImage;
    /*标题文字*/
    protected TextView titleText;
    /*标题右边按钮 */
    protected ImageView right_image;
    /*消息类型集合*/
    protected List<String> msg_type_list;
    /*消息集合*/
    protected List<MessageBean> messageList;
    /*消息适配器*/
    protected NewMessageAdapter messageAdapter;
    /* @人员信息 */
    protected List<PersonBean> personList;
    /*是否是单聊*/
    protected boolean isSignChat;
    //消息工具类
    protected NewMessageUtils messageUtils;
    //重发消息的localid
    protected String isRecalLocalId;
    // 消息时间事件
    protected NewMessageItemDialog itemLongClickDialog;
    protected DBMsgUtil dbMsgUtil;
    //当前显示的第一条msg_id
    protected long first_msg_id;
    //是否还有更多消息
    protected boolean is_message_more;
    protected SwipeRefreshLayout mSwipeLayout;
    protected SmoothScrollLayoutManager linearLayoutManager;
    //消息处理线程
    protected HandlerThread messageHanderThread;
    protected Handler messageHandler;
    //临时消息
    protected List<MessageBean> tempList;
    //是否显示防诈骗消息
    protected boolean isFraudHintText;
    //拍照临时文件
    protected File mTmpFile;
    //网页带过来带找工作信息类
    protected PersonWorkInfoBean personWorkInfoBean;
    //是否已经初始化过网页传递的消息
    protected boolean isInitFindWorkMsg;

    public void setBroadCastSuccessListener(MessageBroadCastListener broadCastSuccessListener) {
        this.broadCastSuccessListener = broadCastSuccessListener;
    }

    /**
     * 初始化View
     */
    public void initBaseView(Activity activity) {
        dbMsgUtil = DBMsgUtil.getInstance();
        messageUtils = new NewMessageUtils(activity, gnInfo);
        titleText = activity.findViewById(R.id.title);
        userName = (String) SPUtils.get(activity, Constance.USERNAME, "", Constance.JLONGG);
        headImage = SPUtils.get(activity, Constance.HEAD_IMAGE, "", Constance.JLONGG).toString();
        right_image = findViewById(R.id.rightImage);
        lv_msg = findViewById(R.id.listView);
        lv_msg.setItemViewCacheSize(200);
        mSwipeLayout = findViewById(R.id.swipe_layout);
        mSwipeLayout.setColorSchemeColors(getResources().getColor(R.color.color_eb4e4e), getResources().getColor(R.color.blue_46a6ff));
        messageList = new ArrayList<>();
        msg_type_list = Utils.getMsgTypeList();
        //初始化底部键盘
        initEmotionMainFragment();
        initKeyBoardView();
        linearLayoutManager = new SmoothScrollLayoutManager(mActivity, LinearLayoutManager.VERTICAL, false);
        //初始化空列表数据
        lv_msg.setLayoutManager(linearLayoutManager);
        ((SimpleItemAnimator) lv_msg.getItemAnimator()).setSupportsChangeAnimations(false);
        lv_msg.setItemAnimator(null);
//        setMessageAdapter();
        lv_msg.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                hideSoftKeyboard();
                if (null != emotionMsgFragment.lin_msg_bottom) {
                    emotionMsgFragment.lin_msg_bottom.setVisibility(View.GONE);
                }
                if (null != emotionMsgFragment) {
                    emotionMsgFragment.isInterceptBackPress();
                    emotionMsgFragment.setImageButtonBck();
                }
                return false;
            }
        });
        // 接收的消息处理线程
        initMessageHandleThread();
        getIsFraud();
    }

    /**
     * 读取是否防诈骗
     */
    public void getIsFraud() {
        if (gnInfo.getClass_type().equals(WebSocketConstance.GROUP_CHAT)) {
            String date = dbMsgUtil.selectMsgHintDate(gnInfo.getGroup_id(), gnInfo.getClass_type());
            if (TextUtils.isEmpty(date) || !date.equals(TimesUtils.getyyyyMMddTime())) {
                isFraudHintText = true;
                LUtils.e("----显示防诈骗消息---");
            } else {
                isFraudHintText = false;
                LUtils.e("----不显示显示防诈骗消息---");
            }
        }

    }

    /**
     * 初始化接收的消息处理线程
     */
    public void initMessageHandleThread() {
        //创建一个线程,线程名字：message_handler_thread
        messageHanderThread = new HandlerThread("message_handler_thread");
        //开启一个线程
        messageHanderThread.start();
        messageHandler = new Handler(messageHanderThread.getLooper()) {
            @Override
            public void handleMessage(final Message msg) {
                super.handleMessage(msg);
                //这个方法是运行在 handler-thread 线程中的 ，可以执行耗时操作
                switch (msg.what) {
                    case 0X99:
                        List<MessageBean> beanList = (List<MessageBean>) msg.obj;
                        if (null == tempList) {
                            tempList = new ArrayList<>();
                        } else {
                            tempList.clear();
                        }
                        //取出当组消息并且排重
                        for (MessageBean bean : beanList) {
//                            LUtils.e(bean.getMsg_type()+"----msg-----AAAA");
                            if (bean.getClass_type().equals(gnInfo.getClass_type()) && bean.getGroup_id().equals(gnInfo.getGroup_id())) {

                                if (!messageList.contains(bean) && !tempList.contains(bean)) {
                                    tempList.add(bean);
                                    //文字消息增加敏感词汇提示
                                    if (bean.getMsg_type().equals(MessageType.MSG_TEXT_STRING) && Utils.isHintText(bean.getMsg_text())) {
                                        tempList.add(messageUtils.getHintBean(UclientApplication.getNickName(mActivity)));
                                    }

                                    //文字消息增加敏感词汇提示
                                    if (bean.getMsg_type().equals(MessageType.MSG_TEXT_STRING) && Utils.isFraudHintText(bean.getMsg_text()) && isFraudHintText && gnInfo.getClass_type().equals(WebSocketConstance.GROUP_CHAT)) {
                                        tempList.add(messageUtils.getFraudHintBean(UclientApplication.getNickName(mActivity)));
                                        dbMsgUtil.updateMsgHintDate(gnInfo.getGroup_id(), gnInfo.getClass_type(), TimesUtils.getyyyyMMddTime());
                                        isFraudHintText = false;
                                    }

                                } else if (bean.getMsg_type().equals(MessageType.MSG_RECALL_STRING)) {
                                    //撤回的消息需要更新显示界面
                                    broadCastSuccessListener.reCallMessage(bean);
                                }

                            }
                        }
                        for (int i = 0; i < tempList.size(); i++) {
                            LUtils.e(tempList.get(i).getMsg_type() + "---tempList------AAAAA");

                        }

                        broadCastSuccessListener.showMoreMessageBottom(tempList);
                        break;
                    case 0X02:
                        MessageBean bean = (MessageBean) msg.getData().getSerializable(Constance.BEAN_CONSTANCE);
                        broadCastSuccessListener.showSingleMessageBottom(bean);
                        break;
                    case 0X03:
                        bean = (MessageBean) msg.obj;
                        broadCastSuccessListener.changetMsgState(bean);
                        break;
                }

            }
        };
    }

    /**
     * 设置右边按钮
     */
    public void initRightImage() {
        right_image.setVisibility(View.VISIBLE);
        right_image.setImageResource(gnInfo.getClass_type().equals(WebSocketConstance.SINGLECHAT) ? R.drawable.icon_single_right_title : R.drawable.icon_group_right_title);
        right_image.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //单聊详情
                if (gnInfo.getClass_type().equals(WebSocketConstance.SINGLECHAT)) {
                    Intent intent = new Intent(mActivity, SingleChatManagerActivity.class);
                    intent.putExtra(Constance.GROUP_CHAT_ID, gnInfo.getGroup_id());
                    intent.putExtra(Constance.IS_MY_GROUP_INFO, UclientApplication.getUid(getApplicationContext()).equals(gnInfo.getCreater_uid()));
                    startActivityForResult(intent, Constance.REQUESTCODE_SINGLECHAT);
                } else if (gnInfo.getClass_type().equals(WebSocketConstance.GROUP_CHAT)) {
                    //群聊详情
                    Intent intent = new Intent(mActivity, GroupChatManagerActivity.class);
                    intent.putExtra(Constance.GROUP_CHAT_ID, gnInfo.getGroup_id());
                    intent.putExtra(Constance.IS_MY_GROUP_INFO, UclientApplication.getUid(getApplicationContext()).equals(gnInfo.getCreater_uid()));
                    intent.putExtra(Constance.BEAN_CONSTANCE, (Serializable) gnInfo.getMembers_head_pic());
                    startActivityForResult(intent, Constance.REQUESTCODE_SINGLECHAT);
                } else if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
                    //项目组详情
                    Intent intent = new Intent(mActivity, TeamManagerActivity.class);
                    intent.putExtra(Constance.BEAN_CONSTANCE, gnInfo);
                    if (gnInfo.getIs_closed() == 1) {
                        intent.putExtra(Constance.BEAN_BOOLEAN, true);
                    }
                    startActivityForResult(intent, Constance.REQUEST);
                } else if (gnInfo.getClass_type().equals(WebSocketConstance.GROUP)) {
                    GroupManagerActivity.actionStart(mActivity, gnInfo, gnInfo.getIs_closed() == 1, getIntent().getBooleanExtra("isMyAgenUser", false));
                }
            }
        });
    }

    /**
     * 设置标题
     */
    public void setTitle() {
        SetTitleName.setTitle(titleText, gnInfo.getClass_type().equals(WebSocketConstance.SINGLECHAT) ? gnInfo.getGroup_name() : gnInfo.getGroup_name() + "(" + gnInfo.getMembers_num() + ")");
    }

    /**
     * 设置消息适配器
     */
    public void setMessageAdapter() {
        messageAdapter = new NewMessageAdapter(this, gnInfo, messageList, broadCastSuccessListener);
        //3.4.1尝试解决头像闪烁问题
        messageAdapter.setHasStableIds(true);
        lv_msg.setAdapter(messageAdapter);

    }

    /**
     * 找工作找帮手跳转过来的聊天
     */
    public void findJobHelperToMsg() {
        if (!gnInfo.getClass_type().equals(WebSocketConstance.SINGLECHAT) || isInitFindWorkMsg) {
            return;
        }
        isInitFindWorkMsg = true;
        personWorkInfoBean = (PersonWorkInfoBean) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE1);
        //1.显示名片 2.显示找工作信息
        if (null != personWorkInfoBean && personWorkInfoBean.getClick_type() != 0) {
            MessageBean bean = new MessageBean();
            bean.setGroup_id(personWorkInfoBean.getGroup_id());
            bean.setGroup_name(personWorkInfoBean.getGroup_name());
            bean.setMsg_sender(UclientApplication.getUid());
            bean.setVerified(personWorkInfoBean.getVerified());
            bean.setMsg_type(MessageType.MSG_FINDWORK_TEMP_STRING);
            bean.setMsg_text_other(new Gson().toJson(personWorkInfoBean));
            broadCastSuccessListener.showSingleMessageBottom(bean);
            //创建聊天对象到聊聊列表
            MessageUtil.addTeamOrGroupToLocalDataBase(mActivity, "", gnInfo, false);
        }
    }

    /**
     * 注册广播
     */
    protected void registerReceiver() {
        receiver = new MessageBroadcast();
        registerLocal(receiver, messageUtils.getfilter());
    }

    public static void actionStart(Activity context, GroupDiscussionInfo info) {
        Intent intent = new Intent(context, NewMsgActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
//        context.startActivityForResult(intent, Constance.REQUEST);
        context.startActivity(intent);
    }

    public static void actionStart(ReactApplicationContext context, GroupDiscussionInfo info) {
        Intent intent = new Intent(context, NewMsgActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
//        context.startActivityForResult(intent, Constance.REQUEST);
        context.startActivity(intent);
    }

    public static void actionStart(ReactApplicationContext context, GroupDiscussionInfo info, PersonWorkInfoBean worker_json) {
        Intent intent = new Intent(context, NewMsgActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.BEAN_STRING, worker_json);
        context.startActivity(intent);

//        context.startActivityForResult(intent, Constance.requestCode_msg);
    }

    public static void actionStart(Activity context, GroupDiscussionInfo info, String worker_json) {
        Intent intent = new Intent(context, NewMsgActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.BEAN_STRING, worker_json);
        context.startActivity(intent);

//        context.startActivityForResult(intent, Constance.requestCode_msg);
    }

    public static void actionStart(Activity context, GroupDiscussionInfo info, PersonWorkInfoBean personWorkInfoBean) {
        Intent intent = new Intent(context, NewMsgActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.BEAN_CONSTANCE1, personWorkInfoBean);
//        intent.putExtra(Constance.BEAN_STRING, worker_json);
        context.startActivity(intent);

//        context.startActivityForResult(intent, Constance.requestCode_msg);
    }

    protected void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (null == gnInfo) {
            CommonMethod.makeNoticeShort(this, "数据出错", CommonMethod.SUCCESS);
            finish();
        }
        //4.0.2设置好友来源
        //单聊详情
        if (gnInfo.getClass_type().equals(WebSocketConstance.SINGLECHAT)) {
            if (AddFriendsSources.create().isReset()){
                AddFriendsSources.create().setSource(AddFriendsSources.SOURCE_SINGLE_CHAT);
            }
            AddFriendsSources.create().setReset(true);
        } else if (gnInfo.getClass_type().equals(WebSocketConstance.GROUP_CHAT)) {
            //群聊详情
            AddFriendsSources.create().setReset(true).setSource(AddFriendsSources.SOURCE_GROUP_CHAT);
        } else if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
            //项目组详情
            AddFriendsSources.create().setReset(true).setSource(AddFriendsSources.SOURCE_PROJECT_TEAM);
            //班组
        } else if (gnInfo.getClass_type().equals(WebSocketConstance.GROUP)) {
            AddFriendsSources.create().setReset(true).setSource(AddFriendsSources.SOURCE_TEAM);
        }
        LUtils.e(gnInfo.getClass_type() + ",,," + gnInfo.getGroup_id());
        LUtils.e("====添加朋友聊天页面====="+gnInfo.getClass_type()+AddFriendsSources.create().getSource());
        //设置当前点击的classType
        DBMsgUtil.getInstance().currentEnterClassType = gnInfo.getClass_type();
        //设置当前点击的groupId
        DBMsgUtil.getInstance().currentEnterGroupId = gnInfo.getGroup_id();
    }


    /**
     * 初始化表情面板
     */
    public void initEmotionMainFragment() {

        if (gnInfo.is_closed == 1) {
            return;
        }
        //构建传递参数
        Bundle bundle = new Bundle();
        //绑定主内容编辑框
        bundle.putBoolean(EmotionMsgFragment.BIND_TO_EDITTEXT, true);
        //替换fragment
        //创建修改实例
        emotionMsgFragment = EmotionMsgFragment.newInstance(EmotionMsgFragment.class, bundle);
        emotionMsgFragment.bindToContentView(mSwipeLayout);
        emotionMsgFragment.setChatPrimaryMenuListener(this, gnInfo);
        emotionMsgFragment.setClickKeyBoardClickListner(this);
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        transaction.replace(R.id.fl_emotionview_main, emotionMsgFragment);
        transaction.addToBackStack(null);
        //提交修改
        transaction.commit();

    }

    /**
     * 初始化键盘监听
     */
    public void initKeyBoardView() {
        rea_noticedetail = findViewById(R.id.root_layout);
        //contentlayout是最外层布局
        mChildOfContent = rea_noticedetail.getChildAt(0);
        mChildOfContent.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            public void onGlobalLayout() {
                possiblyResizeChildOfContent();
            }
        });
    }

    private LinearLayout rea_noticedetail;
    private View mChildOfContent;
    private int usableHeightPrevious = 0;

    private void possiblyResizeChildOfContent() {
        int usableHeightNow = computeUsableHeight();
        if (usableHeightNow != usableHeightPrevious) {
            int usableHeightSansKeyboard = mChildOfContent.getRootView().getHeight();
            int heightDifference = usableHeightSansKeyboard - usableHeightNow;
            if (heightDifference > (usableHeightSansKeyboard / 4)) {
                // 键盘弹出
                emotionMsgFragment.keyBoradShow();
                if (null != emotionMsgFragment.lin_msg_bottom) {
                    emotionMsgFragment.lin_msg_bottom.setVisibility(View.GONE);
                }
                lv_msg.scrollToPosition(messageAdapter.getItemCount() - 1);

            } else {
                // 键盘收起
//                emotionMainFragment.keyBoradHint();

            }
            mChildOfContent.requestLayout();
            usableHeightPrevious = usableHeightNow;
        }
    }

    private int computeUsableHeight() {
        Rect r = new Rect();
        mChildOfContent.getWindowVisibleDisplayFrame(r);
        return (r.bottom - r.top);
    }

    /**
     * 发送文本消息
     */
    @Override
    public void onSendTextmsg(String content) {
        if (null != emotionMsgFragment) {
            emotionMsgFragment.isInterceptBackPress();
        }
        if (!content.trim().equals("")) {
            if (null != personWorkInfoBean && personWorkInfoBean.getClick_type() == 1) {
                broadCastSuccessListener.onSendPostCard(messageList.size() > 0 ? messageList.size() - 1 : -1, content, false);
            } else if (null != personWorkInfoBean && personWorkInfoBean.getClick_type() == 3) {
                if (!TextUtils.isEmpty(messageList.get(messageList.size() > 0 ? messageList.size() - 1 : -1).getVerified()) && !messageList.get(messageList.size() > 0 ? messageList.size() - 1 : -1).getVerified().equals("3")) {
                    //实名提示
                    HandleMessage(messageUtils.getAuthBean(!TextUtils.isEmpty(personWorkInfoBean.getReal_name()) ? personWorkInfoBean.getReal_name() : ""), false);
                }
                HandleMessage(messageUtils.getTextBean(content), false);
            } else {
                //发送普通文字消息
                HandleMessage(messageUtils.getTextBean(content), false);
            }
        }
    }

    protected Timer timer;

    public void timer() {
        timer = new Timer();
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                HandleMessage(messageUtils.getTextBean(System.currentTimeMillis() + ""), false);
            }
        }, 0, 1500);
    }

    @Override
    public void onVoicefinish(float seconds, String filePath) {
        if (!SocketManager.SOCKET_OPEN.equals(SocketManager.getInstance(getApplicationContext()).socketState)) {

            CommonMethod.makeNoticeShort(mActivity, "请检查你的网络连接", CommonMethod.ERROR);
            return;
        }
        uploadVoice(seconds, filePath, false, "");
    }

    /**
     * 拍照
     */
    @Override
    public void onCamera() {
        /**
         * 选择相机
         */

        // 跳转到系统照相机
        Intent cameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (cameraIntent.resolveActivity(mActivity.getPackageManager()) != null) {
            // 设置系统相机拍照后的输出路径
            // 创建临时文件
            try {
                mTmpFile = FileUtils.createTmpFile(mActivity);
                if (mTmpFile != null && mTmpFile.exists()) {
                    cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(mTmpFile));
                    startActivityForResult(cameraIntent, MultiImageSelectorFragment.REQUEST_CAMERA);
                } else {
                    Toast.makeText(mActivity, "图片错误", Toast.LENGTH_SHORT).show();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

        } else {
            Toast.makeText(mActivity, me.nereo.multi_image_selector.R.string.msg_no_camera, Toast.LENGTH_SHORT).show();
        }
    }


    /**
     * 上传语音文件
     *
     * @param seconds          时长
     * @param voicePath        语音路径
     * @param isRetransmission true，重发
     * @param local_id         语音重发local_id,不能重置，否者发送成功更改状态失败
     */
    public void uploadVoice(final float seconds, final String voicePath, final boolean isRetransmission, final String local_id) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("voice", new File(voicePath));
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPLOAD, params, new RequestCallBackExpand() {

            @Override
            public void onSuccess(ResponseInfo responseInfo) {
                try {
                    JSONObject jsonObject = new JSONObject((String) responseInfo.result);
                    int state = jsonObject.getInt("state");
                    if (state != 0) {
                        JSONArray jSONArray = jsonObject.getJSONArray("values");
                        String voicePath = jSONArray.get(0).toString();
                        MessageBean bean = messageUtils.getVoiceBean(seconds, voicePath, 2, dbMsgUtil, UclientApplication.getNickName(mActivity));
                        List<String> list = new ArrayList<>();
                        list.add(jSONArray.get(0).toString());
                        bean.setMsg_src(list);
                        if (!TextUtils.isEmpty(local_id)) {
                            bean.setLocal_id(local_id);
                        }
                        HandleMessage(bean, isRetransmission);
                    } else {
                        String errno = jsonObject.getString("errno");
                        String errmsg = jsonObject.getString("errmsg");
                        DataUtil.showErrOrMsg(mActivity, errno, errmsg);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();
                if (!isRetransmission) {
                    MessageBean entity = messageUtils.getVoiceBean(seconds, voicePath, 1, dbMsgUtil, UclientApplication.getNickName(mActivity));
                    entity.setMsg_state(1);
//                    broadCastSuccessListener.broadCastReceiveMessage(null, entity, false);
                    ThreadPoolManager.getInstance().executeSaveMessage(entity);
                }

            }
        });
    }

    /**
     * 发送消息到服务
     *
     * @param isRetransmission true：重发
     */
    public void HandleMessage(MessageBean bean, boolean isRetransmission) {
        WebSocket webSocket = SocketManager.getInstance(getApplicationContext()).getWebSocket();
        if (!SocketManager.SOCKET_OPEN.equals(SocketManager.getInstance(getApplicationContext()).socketState)) {
            CommonMethod.makeNoticeShort(mActivity, "请检查你的网络连接", CommonMethod.ERROR);
            try {
                if (!TextUtils.isEmpty(bean.getMsg_type()) && bean.getMsg_type().equals(MessageType.MSG_TEXT_STRING)) {
                    emotionMsgFragment.getEtMessage().setText(bean.getMsg_text());
                    emotionMsgFragment.getEtMessage().setSelection(bean.getMsg_text().length() > 0 ? bean.getMsg_text().length() : 0);
                }
                SocketManager.getInstance(getApplicationContext()).reconnectNow();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }
        //如果重发就不需要再次保存本地
        if (!isRetransmission) {
            //保存消息到本息
            ThreadPoolManager.getInstance().executeSaveSendMessage(bean, broadCastSuccessListener);
        }

        if (webSocket != null) {
            WebSocketMeassgeParameter msgParmeter = messageUtils.getMessageParemeter(bean, personList, gnInfo.is_chat == 0 ? false : true, 0);
            if (!TextUtils.isEmpty(msgParmeter.getAt_uid())) {
                personList = null;
            }
            webSocket.requestServerMessage(msgParmeter);

        } else {
            CommonMethod.makeNoticeShort(mActivity, "消息发送失败", CommonMethod.ERROR);
        }
    }

    /**
     * 发送找工作消息或者名片消息
     *
     * @param isRetransmission true：重发
     */
    public void HandlePostCardAndFindWorkMessage(MessageBean bean, boolean isRetransmission) {
        WebSocket webSocket = SocketManager.getInstance(getApplicationContext()).getWebSocket();
        if (!SocketManager.SOCKET_OPEN.equals(SocketManager.getInstance(getApplicationContext()).socketState)) {
            CommonMethod.makeNoticeShort(mActivity, "请检查你的网络连接", CommonMethod.ERROR);
            try {
                if (!TextUtils.isEmpty(bean.getMsg_type()) && bean.getMsg_type().equals(MessageType.MSG_TEXT_STRING)) {
                    emotionMsgFragment.getEtMessage().setText(bean.getMsg_text());
                    emotionMsgFragment.getEtMessage().setSelection(bean.getMsg_text().length() > 0 ? bean.getMsg_text().length() : 0);
                }
                SocketManager.getInstance(getApplicationContext()).reconnectNow();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return;
        }
        //如果重发就不需要再次保存本地
        if (!isRetransmission) {
            //保存消息到本息
            ThreadPoolManager.getInstance().executeSaveSendMessage(bean, broadCastSuccessListener);
        }
        if (webSocket != null) {
            //转化socket消息对象
            WebSocketMeassgeParameter paremeter = messageUtils.getMessageParemeter(bean, personList, true, 0);
            webSocket.requestServerMessage(paremeter);
        } else {
            CommonMethod.makeNoticeShort(mActivity, "消息发送失败", CommonMethod.ERROR);
        }
    }

    /**
     * 消息撤回
     *
     * @param msg_id
     */
    protected void recall_Message(String msg_id) {
        if (TextUtils.isEmpty(msg_id)) {
            return;
        }
        WebSocket webSocket = SocketManager.getInstance(getApplicationContext()).getWebSocket();
        if (webSocket != null) {
            WebSocketMeassgeParameter msgParmeter = new WebSocketMeassgeParameter();
            msgParmeter.setCtrl(WebSocketConstance.MESSAGE);
            msgParmeter.setAction(WebSocketConstance.RECALLMESSAGE);
            msgParmeter.setMsg_id(msg_id);
            webSocket.requestServerMessage(msgParmeter);
        }
    }

    /**
     * 消息撤回
     * 离线消息列表
     */
    protected void getOfflineMessageList() {
        WebSocket webSocket = SocketManager.getInstance(getApplicationContext()).getWebSocket();
        if (webSocket != null) {
            WebSocketMeassgeParameter msgParmeter = new WebSocketMeassgeParameter();
            msgParmeter.setCtrl(WebSocketConstance.MESSAGE);
            msgParmeter.setAction(WebSocketConstance.GET_OFFLINE_MESSAGE_LIST);
            webSocket.requestServerMessage(msgParmeter);
        }
    }

    RequestParams params;


    /**
     * 获取线上历史消息
     */
    public void getOnlineHistoryMessage() {
        MessageUtil.getRoamMessageList(this, gnInfo.getGroup_id(), gnInfo.getClass_type(),
                messageList.size() == 0 ? "0" : String.valueOf(messageList.get(0).getMsg_id()), new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        //接收消息
                        final List<MessageBean> beanList = (List<MessageBean>) object;
                        if (beanList.size() == 0) {
                            is_message_more = true;
                            mSwipeLayout.setRefreshing(false);
                            findJobHelperToMsg();
                            return;
                        }
                        for (int i = 0; i < beanList.size(); i++) {
                            beanList.get(i).setIs_readed(1);
                            beanList.get(i).setIs_readed_local(1);
                            beanList.get(i).setMessage_uid(UclientApplication.getUid(mActivity));
                            beanList.get(i).setUser_info_json(new Gson().toJson(beanList.get(i).getUser_info()));

                            //处理找工作类型的消息
                            if (beanList.get(i).getMsg_type().equals(MessageType.MSG_FINDWORK_STRING)) {
                                //保存找工作消息到本地
//                              DBMsgUtil.getInstance().saveWorkMessage(beanList.get(i), worker_json);

                                if (null != beanList.get(i).getMsg_prodetail()) {
                                    //网页传递过来的消息手动赋值
                                    String worker_json = new Gson().toJson(beanList.get(i).getMsg_prodetail());
                                    beanList.get(i).setMsg_prodetails(worker_json);
                                    LUtils.e("-------getOnlineHistoryMessage-----------开始保存网页消息----------------" + worker_json);
                                }
                            }
                        }
                        //显示线上的消息
                        LitePal.saveAllAsync(beanList).listen(new SaveCallback() {
                            @Override
                            public void onFinish(boolean success) {
                                //直接显示多条消息到顶部
                                Collections.reverse(beanList);
                                broadCastSuccessListener.showMoreMessageTop(beanList);
                            }
                        });
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        if (mSwipeLayout.isRefreshing()) {
                            mSwipeLayout.setRefreshing(false);
                        }
                    }
                });
    }

    /**
     * 发送图片消息
     */
    protected void fileUpData(final MessageBean messageBean) {
        LUtils.e((messageBean.getMsg_src().get(0) + "-------fileUpData--------------" + messageBean.getLocal_id()));
        if (null != messageBean.getMsg_src() && messageBean.getMsg_src().size() > 0) {
            Luban.with(this)
                    .load(new File(messageBean.getMsg_src().get(0)))
                    .ignoreBy(100)
//                    .setTargetDir(DataCleanManager.REPOSITORY_FILE)
                    .filter(new CompressionPredicate() {
                        @Override
                        public boolean apply(String path) {
                            return !(TextUtils.isEmpty(path) || path.toLowerCase().endsWith(".gif"));
                        }
                    })
                    .setRenameListener(new OnRenameListener() {
                        @Override
                        public String rename(String filePath) {

                            List<String> list = Utils.getImageWidthAndHeight(messageBean.getMsg_src().get(0));
                            if (list != null && list.size() == 2) {
                                String filename = list.get(0) + "_" + list.get(1) + "_" + "images" + System.currentTimeMillis() + ".png";
                                return filename;
                            }
                            return System.currentTimeMillis() + ".png";
                        }
                    })
                    .setCompressListener(new OnCompressListener() {
                        @Override
                        public void onStart() {
                            // TODO 压缩开始前调用，可以在方法内启动 loading UI
//                            LUtils.e("压缩开始----");
                        }

                        @Override
                        public void onSuccess(File file) {
                            // TODO 压缩成功后调用，返回压缩后的图片文件
                            params = RequestParamsToken.getExpandRequestParams(mActivity);
                            params.addBodyParameter("os", "A");
                            params.addBodyParameter("file[" + 1 + "]", file);
                            uploadPic(params, messageBean);
                            LUtils.e("压缩成功----" + file.getAbsolutePath() + ",,," + file.getName());
                        }

                        @Override
                        public void onError(Throwable e) {
                            // TODO 当压缩过程出现问题时调用
//                            LUtils.e("压缩---失败-");

                        }
                    }).launch();


        }
    }

    /**
     * 上传图片
     *
     * @param params
     * @param messageBean
     */
    protected void uploadPic(RequestParams params, final MessageBean messageBean) {
        if (null == messageBean.getMsg_src() && messageBean.getMsg_src().size() == 0) {
            return;
        }
        LUtils.e("-----------uploadPic----------" + messageBean.getMsg_src().get(0));
        HttpUtils http = SingsHttpUtils.getHttp();
        params.getBodyParameters();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPLOAD, params, new RequestCallBack() {
            @Override
            public void onLoading(long total, long current, boolean isUploading) {
                super.onLoading(total, current, isUploading);
            }

            @Override
            public void onSuccess(ResponseInfo responseInfo) {
                try {
                    CommonListJson<String> bean = CommonListJson.fromJson(responseInfo.result.toString(), String.class);
                    if (bean.getState() != 0) {
                        List<String> valuesPath = bean.getValues();
                        if (null != valuesPath && valuesPath.size() > 0) {
                            for (int i = 0; i < valuesPath.size(); i++) {
                                messageBean.getMsg_src().add(valuesPath.get(0));
                                //发送socket消息到服务器
                                HandleMessage(messageBean, true);
                            }
                        }
                    } else {
                        String errno = bean.getErrno();
                        String errmsg = bean.getErrmsg();
                        DataUtil.showErrOrMsg(mActivity, errno, errmsg);
                        CommonMethod.makeNoticeShort(mActivity, errmsg, CommonMethod.ERROR);
                        messageBean.setMsg_state(1);
                        broadCastSuccessListener.changetMsgState(messageBean);
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, "网络连接失败", CommonMethod.ERROR);
                    messageBean.setMsg_state(1);
                    broadCastSuccessListener.changetMsgState(messageBean);
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                messageBean.setMsg_state(1);
                broadCastSuccessListener.changetMsgState(messageBean);

            }
        });
    }
//    /**
//     * 发送图片消息
//     */
//    protected void fileUpData(final List<String> path) {
//        createCustomDialog();
//        new Thread(new Runnable() {
//            @Override
//            public void run() {
//                params = RequestParamsToken.getExpandRequestParams(mActivity);
//                if (null != path && path.size() > 0) {
//                    ImageUtil.compressImageSetParams(params, path, mActivity);
//                }
//                params.addBodyParameter("os", "A");
//                Message message = Message.obtain();
//                message.obj = path;
//                message.what = 0X01;
//                mHandler.sendMessage(message);
//            }
//        }).start();
//    }
//
//    protected Handler mHandler = new Handler() {
//        public void handleMessage(Message msg) {
//            switch (msg.what) {
//                case 0X01:
//                    LUtils.e("---mHandler-----------把即将显示的消息加入队列处理-----------");
//                    List<String> path = (List<String>) msg.obj;
//                    uploadPic(params, path);
//                    break;
//            }
//
//        }
//    };
//
//    protected void uoloadPicNew() {
//
//    }
//
//    protected void uploadPic(RequestParams params, final List<String> path) {
//        LUtils.e("-----------uploadPic----------" + path.toString());
//        HttpUtils http = SingsHttpUtils.getHttp();
//        params.getBodyParameters();
//        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPLOAD, params, new RequestCallBack() {
//            @Override
//            public void onLoading(long total, long current, boolean isUploading) {
//                super.onLoading(total, current, isUploading);
//            }
//
//            @Override
//            public void onSuccess(ResponseInfo responseInfo) {
//                try {
//                    CommonListJson<String> bean = CommonListJson.fromJson(responseInfo.result.toString(), String.class);
//                    if (bean.getState() != 0) {
//                        List<String> valuesPath = bean.getValues();
//                        if (null != valuesPath && valuesPath.size() > 0) {
//                            for (int i = 0; i < valuesPath.size(); i++) {
//                                if (null != path && path.size() == valuesPath.size()) {
//                                    MessageBean messageBean = messageUtils.getPicBean(valuesPath.get(i));
//                                    messageBean.setPic_w_h(Utils.getImageWidthAndHeight(path.get(i)));
//                                    HandleMessage(messageBean, false);
//                                }
//                            }
//                        }
//                    } else {
//                        String errno = bean.getErrno();
//                        String errmsg = bean.getErrmsg();
//                        DataUtil.showErrOrMsg(mActivity, errno, errmsg);
//                        CommonMethod.makeNoticeShort(mActivity, "网络连接失败", CommonMethod.ERROR);
//                        closeDialog();
//                    }
//
//                } catch (Exception e) {
//                    e.printStackTrace();
//                    CommonMethod.makeNoticeShort(mActivity, "网络连接失败", CommonMethod.ERROR);
//                } finally {
//                    closeDialog();
//                }
//            }
//
//            @Override
//            public void onFailure(HttpException e, String s) {
//                closeDialog();
//            }
//        });
//    }

    /**
     * 设置@成员信息
     *
     * @param personBean
     */
    public void addAtInfo(PersonBean personBean) {
        if (null != personBean) {
            if (null == personList) {
                personList = new ArrayList<>();
            }
            personList.add(personBean);
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.GO_MAIN_ACTIVITY) { //回到主页
            setResult(resultCode, data);
            finish();
        } else if (resultCode == Constance.WAY_CREATE_GROUP_CHAT) { //发起群聊
            setResult(resultCode, data);
            finish();
        } else if (resultCode == Constance.UPGRADE) { //群聊升级成班组
            setResult(resultCode, data);
            finish();
        }
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, final Intent intent) {
            String action = intent.getAction();
            switch (action) {
                case WebSocketConstance.SENDMESSAGE:
                    MessageUtil.addTeamOrGroupToLocalDataBase(mActivity, "", gnInfo, false);

                    //发送单挑消息回执
                    MessageBean bean = (MessageBean) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                    //找工作或者名片消息只发送一次，成功就清掉，无需在发送
                    if (bean.getMsg_type().equals(MessageType.RECTUITMENT_STRING) || bean.getMsg_type().equals(MessageType.MSG_AUTH_STRING) || bean.getMsg_type().equals(MessageType.MSG_POSTCARD_STRING)) {
                        personWorkInfoBean = null;
                    }
                    if (TextUtils.isEmpty(bean.getUser_info().getHead_pic())) {
                        bean.getUser_info().setHead_pic(UclientApplication.getHeadPic(mActivity));
                    }
                    if (!bean.getUser_info().getHead_pic().equals(UclientApplication.getHeadPic(mActivity))) {
                        SPUtils.put(context, Constance.HEAD_IMAGE, bean.getUser_info().getHead_pic(), Constance.JLONGG);
                    }
                    if (!bean.getUser_info().getReal_name().equals(UclientApplication.getNickName(mActivity))) {
                        SPUtils.put(context, Constance.NICKNAME, bean.getUser_info().getReal_name(), Constance.JLONGG);
                    }
                    //消息发送状态成功
                    bean.setMsg_state(0);
                    if (bean.getMsg_type().equals(MessageType.MSG_NOTICE_STRING) || bean.getMsg_type().equals(MessageType.MSG_LOG_STRING)
                            || bean.getMsg_type().equals(MessageType.MSG_QUALITY_STRING) || bean.getMsg_type().equals(MessageType.MSG_SAFE_STRING)) {
                        //发送成功后刷新
                        broadCastSuccessListener.showSingleMessageBottom(bean);
                        return;
                    }
                    //刷新显示的消息
                    new Thread(new Runnable() {
                        public void run() {
                            try {
                                Thread.sleep(200);
                                MessageBean bean = (MessageBean) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                                Message message = Message.obtain();
                                message.what = 0X03;
                                message.obj = bean;
                                messageHandler.sendMessage(message);
                            } catch (InterruptedException e) {
                                e.printStackTrace();
                            }


                        }
                    }).start();
                    break;
                case WebSocketConstance.SHOW_GROUP_MESSAGE:
                    //把即将显示的消息加入队列处理
                    List<MessageBean> beanList = (List<MessageBean>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE1);
                    LUtils.e("---把即将显示的消息加入队列处理-----" +beanList.get(0).getMsg_text());

                    Message message = Message.obtain();
                    message.what = 0X99;
                    message.obj = beanList;
                    messageHandler.sendMessage(message);
                    break;
                case WebSocketConstance.GET_CALLBACK_OPERATIONMESSAGE:
                    //回执readed 已读
                    LUtils.e("----------已读取回执------");
                    beanList = (List<MessageBean>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                    if (beanList.size() > 0) {

                        for (int i = 0; i < beanList.size(); i++) {
                            if (beanList.get(i).getType().equals(WebSocketConstance.READED)) {
                                //回执成功更新数据库状态
                                ThreadPoolManager.getInstance().executeUpdateMsgCallbanckReaded(beanList.get(i));
                            }
                        }
                    }
                    break;
                case WebSocketConstance.MSGREADTOSENDER:
                    //回执类型（readed 已读 / received 接收 ）
                    //消息剩余未读数回执
                    beanList = (List<MessageBean>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                    for (int i = 0; i < beanList.size(); i++) {
//                        dbMsgUtil.updateMessageReadedToSender(beanList.get(i));
                        broadCastSuccessListener.MsgUnderReadCount(beanList.get(i));
                    }
                    break;
                case WebSocketConstance.RECALLMESSAGE:
                    //消息撤回
                    LUtils.e("----------消息撤回---------");
                    bean = (MessageBean) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                    dbMsgUtil.updateRecallMsg(bean);
                    broadCastSuccessListener.reCallMessage(bean);
                    break;
                case WebSocketConstance.GET_OFFLINE_MESSAGE_LIST:
                    //消息撤回
                    LUtils.e("----------离线消息---------");
                    break;
                case WebSocketConstance.CLEAR_MESSAGE:
                    //清空当前消息列表
                    LUtils.e("----------清空当前消息列表---------" + messageList.get(messageList.size() - 1).getMsg_id());
                    if (null != messageList && messageList.size() > 0) {
                        long msg_id = messageList.get(messageList.size() - 1).getMsg_id();
                        dbMsgUtil.saveDeleteMessage(new DeleteMessageBean(gnInfo.getClass_type(), gnInfo.getGroup_id(), msg_id == 0 ? -1 : msg_id, UclientApplication.getUid()));
                        messageList.clear();
                    }
                    messageAdapter.notifyDataSetChanged();
                    break;
                case WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST:
                    //组名或者人员数量有变化
                    String menberNumber = intent.getStringExtra(Constance.MEMBER_NUMBER);
                    String groupName = intent.getStringExtra(Constance.GROUP_NAME);
                    String classType = intent.getStringExtra(Constance.CLASSTYPE);
                    if (WebSocketConstance.SINGLECHAT.equals(classType)) { //如果这个参数为单聊信息的话那么就是在修改单聊的备注
                        return;
                    }
                    if (!TextUtils.isEmpty(menberNumber)) {
                        gnInfo.setMembers_num(menberNumber);
                    }
                    //单聊需要不更新组名
                    if (!TextUtils.isEmpty(groupName)) {
                        gnInfo.setGroup_name(groupName);
                    }
                    setTitle();
                    break;
                case WebSocketConstance.UPDATE_GROUP_PERSON_NAME_INCLUDE_MINE:
                    //我在本组的名字有变化
                    String userName = intent.getStringExtra(Constance.USERNAME);
                    String uid = intent.getStringExtra(Constance.UID);

                    if (TextUtils.isEmpty(userName) || TextUtils.isEmpty(uid)) {
                        return;
                    }
                    if (!TextUtils.isEmpty(userName) && gnInfo.getClass_type().equals(WebSocketConstance.SINGLECHAT) && !uid.equals(UclientApplication.getUid())) {
                        //如果是单聊和对方聊天需要更新组名
                        gnInfo.setGroup_name(userName);
                        setTitle();
                    }
                    if (messageList != null && messageList.size() > 0) {
                        for (MessageBean messageBean : messageList) {
                            if (null != messageBean.getUser_info() && !TextUtils.isEmpty(messageBean.getUser_info().getUid()) && messageBean.getUser_info().getUid().equals(uid)) {
                                messageBean.getUser_info().setReal_name(userName);
                            }
                        }
                        messageAdapter.notifyDataSetChanged();
                    }
                    break;
                case WebSocketConstance.CHECK_HEAD_ISCHANGE:
                    boolean isChangeDb = false;
                    //检测头像是否改变
                    uid = intent.getStringExtra(Constance.UID);
                    String head_pic = intent.getStringExtra(Constance.HEAD_IMAGE);
                    //如果是自己的头像并且不一致就把本地的头像改变了
                    if (uid.equals(UclientApplication.getUid()) && !SPUtils.get(context, Constance.HEAD_IMAGE, head_pic, Constance.JLONGG).toString().equals(head_pic)) {
                        SPUtils.put(context, Constance.HEAD_IMAGE, head_pic, Constance.JLONGG);
                    }
                    for (int i = 0; i < messageList.size(); i++) {
                        //如果是uid用户并且头像不一样就更新
                        if (null != messageList.get(i).getUser_info() && messageList.get(i).getMsg_sender().equals(uid) && !messageList.get(i).getUser_info().getHead_pic().equals(head_pic)) {
                            messageList.get(i).getUser_info().setHead_pic(head_pic);
                            messageAdapter.notifyItemChanged(i);
                            isChangeDb = true;
                        }
                    }
                    if (isChangeDb) {
                        dbMsgUtil.updateHeadpic(uid, head_pic);
                    }
                    break;
                //显示发送的转发消息
                case WebSocketConstance.FORWARD_SUCCESS:
                    bean = (MessageBean) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                    LUtils.e(bean.getLocal_id() + ",1111," + bean.getLocal_id());
                    if (null != bean && null != broadCastSuccessListener && bean.getClass_type().equals(gnInfo.getClass_type()) && bean.getGroup_id().equals(gnInfo.getGroup_id())) {
                        broadCastSuccessListener.showSingleMessageBottom(bean);
                    }
                    break;
                //消息发送失败
                case WebSocketConstance.SEND_MSG_FAIL:
                    LUtils.e("-----------AAAAAAA-----------");

                    broadCastSuccessListener.sendMsgFail(intent.getStringExtra("local_id"));
                    break;
            }
        }

    }

    public void showImageView(List<String> list, int index, Context context) {
        //imagesize是作为loading时的图片size
        LUtils.e(new Gson().toJson(list) + ",,,,,,,,图片路径" +
                ",,,");
        ArrayList<String> arrayList = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            arrayList.add(NetWorkRequest.CDNURL + list.get(i));
        }
        LoadCloudPicActivity.actionStart((Activity) context, arrayList, index);
    }

    /**
     * 刷新聊聊列表未读数
     */
    public void updateChatListUnread() {
        if (messageList.size() > 0 && messageList.get(messageList.size() - 1).getMsg_state() == 0) {
            DBMsgUtil.getInstance().clearEnterMessageInfo();
            MessageBean bean = null;
            if (messageList.size() > 0 && messageList.get(messageList.size() - 1).isUnShowChatLish()) {
                for (int i = messageList.size() - 1; i >= 0; i--) {
                    if (!messageList.get(i).isUnShowChatLish()) {
                        bean = messageList.get(i);
                        break;
                    }
                }
            } else {
                bean = messageList.size() > 0 ? messageList.get(messageList.size() - 1) : null;
            }
            if (null != bean && bean.getMsg_state() == 0) {
                MessageUtil.setGroupChatLastMessageInfo(mActivity, "", 0, gnInfo.getGroup_id(), gnInfo.getClass_type(), bean);
            }
        }
    }

    /**
     * 根据消息id获取已读未读数
     */
    protected void getMessageReadNum(String msg_id) {
        if (gnInfo.getClass_type().equals(WebSocketConstance.SINGLECHAT)) {
            return;
        }
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter(MessageType.GROUP_ID, gnInfo.getGroup_id());
        params.addBodyParameter(MessageType.CLASS_TYPE, gnInfo.getClass_type());
        params.addBodyParameter(MessageType.MSG_ID, msg_id);
        CommonHttpRequest.commonRequest(this, NetWorkRequest.GET_MESSAGE_READED_NUM, MessageBean.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                List<MessageBean> messageBeanList = (List<MessageBean>) object;
                for (MessageBean bean : messageBeanList) {
                    if (messageList.contains(bean) && bean.getUnread_members_num() < messageList.get(messageList.indexOf(bean)).getUnread_members_num()) {
                        messageList.get(messageList.indexOf(bean)).setUnread_members_num(bean.getUnread_members_num());
                        messageAdapter.notifyItemChanged(messageList.indexOf(bean));
                        dbMsgUtil.updateMessageReadedToSender(bean);
                    }

                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();
            }
        });
    }

    /**
     * 点击表情键盘之后是否需要清楚数据
     * 聊天忽略此回调
     *
     * @param isClear
     */
    @Override
    public void CLickKeyBoardClick(boolean isClear) {

    }

    /**
     * 点击表情键盘按钮
     */
    @Override
    public void ClickEmojiButtom() {
        if (null != emotionMsgFragment.lin_msg_bottom) {
            emotionMsgFragment.lin_msg_bottom.setVisibility(View.GONE);
        }
        /**
         * 点击的时候聊天滚动到最后一条
         */
        if (null != messageList && messageList.size() > 0) {
            lv_msg.scrollToPosition(messageList.size() - 1);
        }
    }

    /**
     * 点击表情键盘更多按钮
     */
    @Override
    public void ClickMoreButtom() {
        hideSoftKeyboard();
        if (null != emotionMsgFragment) {
            emotionMsgFragment.isInterceptBackPress();
        }
        if (null != emotionMsgFragment.lin_msg_bottom) {
            emotionMsgFragment.lin_msg_bottom.setVisibility(emotionMsgFragment.lin_msg_bottom.getVisibility() == View.VISIBLE ? View.GONE : View.VISIBLE);
        }
        /**
         * 点击的时候聊天滚动到最后一条
         */
        if (null != messageList && messageList.size() > 0) {
            lv_msg.scrollToPosition(messageList.size() - 1);
        }
    }

    /**
     * 点击表情键盘更多按钮
     */
    @Override
    public void ClickShareInfo() {
        getWorkInfo();
    }

    /**
     * 获取个人名片
     */
    public void getWorkInfo() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("uid", UclientApplication.getUid());
        CommonHttpRequest.commonRequest(this, NetWorkRequest.GET_WORK_INFO_PRO_INFO, PersonWorkInfoBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                PersonWorkInfoBean bean = (PersonWorkInfoBean) object;
                closeDialog();
                if (bean.getIs_info() == 1) {
                    //名片消息
                    HandlePostCardAndFindWorkMessage(messageUtils.getInfoBean(new Gson().toJson(bean), MessageType.MSG_POSTCARD_STRING), false);
                    return;
                }
                DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(mActivity, null, "你还未完善名片信息，无法发送名片", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        X5WebViewActivity.actionStart(mActivity, NetWorkRequest.MY_RESUME);

                    }
                });
                dialogLeftRightBtnConfirm.show();
                dialogLeftRightBtnConfirm.setLeftBtnText("取消");
                dialogLeftRightBtnConfirm.setRightBtnText("现在去完善");

            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();
            }
        });
    }
}
