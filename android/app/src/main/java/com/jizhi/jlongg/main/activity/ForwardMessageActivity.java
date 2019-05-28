package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.MessageTransmitAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.dialog.ForwardMessageDialog;
import com.jizhi.jlongg.main.message.WebSocketMeassgeParameter;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ImageUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.ThreadPoolManager;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.WebSocket;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;

/**
 * 消息转发页面
 *
 * @author Xuj
 * @time 2019年3月26日10:18:26
 * @Version 1.0
 */
public class ForwardMessageActivity extends BaseActivity implements View.OnClickListener, ForwardMessageDialog.ForwardMessageListener, AdapterView.OnItemClickListener {
    /**
     * 多选按钮
     */
    private TextView multiPartText;
    /**
     * 多选提示
     */
    private TextView selectCountTips;
    /**
     * 已选的群聊数量,单聊数量
     */
    private int groupChatCount, singleGroupChatCount;
    /**
     * 列表适配器
     */
    private MessageTransmitAdapter adapter;
    /**
     * 列表数据
     */
    private ArrayList<GroupDiscussionInfo> list;
    /**
     * 需要转发的列表数据
     */
    private ArrayList<GroupDiscussionInfo> forwardList = new ArrayList<>();
    /**
     * 筛选文字
     */
    private String matchString;
    /**
     * 多选布局
     */
    private View multipartLayout;
    /**
     * 需要转发的消息体
     */
    private MessageBean forwardMessage;
    /**
     * 转发消息类型
     * 文字、表情 MessageType.MSG_TEXT_STRING
     * 图片 MessageType.MSG_PIC_STRING
     * 链接 MessageType.MSG_LINK_STRING
     * 名片 MessageType.MSG_POSTCARD_STRING
     */
    private String forwardMessageType;
    /**
     * 确认按钮
     */
    private Button confirmBtn;
    /**
     * 点击的下标
     */
    private int clickPosition;
    /**
     * 标题
     */
    private TextView title;

    /**
     * 启动当前Activity
     * 转发本地未存的消息
     *
     * @param context
     * @param msgType 消息对象 消息转发类型
     *                文字、表情 MessageType.MSG_TEXT_STRING
     *                图片 MessageType.MSG_PIC_STRING
     *                链接 MessageType.MSG_LINK_STRING
     *                名片 MessageType.MSG_POSTCARD_STRING
     * @param share   分享的信息
     */
    public static void actionStart(Activity context, String msgType, Share share) {
        Intent intent = new Intent(context, ForwardMessageActivity.class);
        MessageBean messageBean = new MessageBean();
        messageBean.setMsg_type(msgType);
        messageBean.setShare_info(share);
        if (share != null) {
            messageBean.setMsg_text_other(new Gson().toJson(share));
        }
        intent.putExtra(Constance.BEAN_CONSTANCE, messageBean);
        intent.putExtra(Constance.MSG_TYPE, msgType);
        // true表示转发的是本地已存在的信息,false表示的是其他地方的信息
        intent.putExtra(Constance.BEAN_BOOLEAN, false);
        context.overridePendingTransition(R.anim.scan_login_open, R.anim.scan_login_close);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     * 转发本地已存在的消息
     *
     * @param context
     * @param messageBean
     * @param msgType     消息对象 消息转发类型
     *                    文字、表情 MessageType.MSG_TEXT_STRING
     *                    图片 MessageType.MSG_PIC_STRING
     *                    链接 MessageType.MSG_LINK_STRING
     *                    名片 MessageType.MSG_POSTCARD_STRING
     */
    public static void actionStart(Activity context, MessageBean messageBean, String msgType) {
        Intent intent = new Intent(context, ForwardMessageActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, messageBean);
        intent.putExtra(Constance.MSG_TYPE, msgType);
        //true表示转发的是本地已存在的信息,false表示的是其他地方的信息
        intent.putExtra(Constance.BEAN_BOOLEAN, true);
        context.overridePendingTransition(R.anim.scan_login_open, R.anim.scan_login_close);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.forward_message);
        initView();
        loadLocalDataBaseData();
    }

    private void initView() {
        Intent intent = getIntent();
        MessageBean forwardMessage = (MessageBean) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (forwardMessage == null) {
            finish();
            return;
        }
        forwardMessageType = intent.getStringExtra(Constance.MSG_TYPE);
        this.forwardMessage = forwardMessage;
        setTextTitleAndRight(R.string.select_single_chat, R.string.select_multipart);
        title = findViewById(R.id.title);
        ImageView leftIcon = findViewById(R.id.left_icon);
        confirmBtn = findViewById(R.id.confirm_btn);
        multipartLayout = findViewById(R.id.multipart_layout);
        multiPartText = findViewById(R.id.right_title);
        selectCountTips = findViewById(R.id.select_count_tips);
        leftIcon.setImageResource(R.drawable.icon_notebook_cha);
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("输入姓名查找");
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence inputText, int start, int before, int count) {
                filterData(inputText.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        if (MessageType.MSG_LINK_STRING.equals(forwardMessageType) && !TextUtils.isEmpty(forwardMessage.getMsg_text_other())) { //单独处理一下链接类型的值
            Share share = new Gson().fromJson(forwardMessage.getMsg_text_other(), Share.class);
            if (share != null) {
                // [链接]XXXXX（有标题为标题，无标题为内容，都没有则只有“[链接]”两字）
                forwardMessage.setMsg_text(!TextUtils.isEmpty(share.getTitle()) ? share.getTitle() : share.getDescribe());
            }
        } else if (MessageType.MSG_POSTCARD_STRING.equals(forwardMessageType) && !TextUtils.isEmpty(forwardMessage.getMsg_text_other())) { //单独处理一下名片类型的值
            UserInfo userInfo = new Gson().fromJson(forwardMessage.getMsg_text_other(), UserInfo.class);
            if (userInfo != null) {
                forwardMessage.setMsg_text(userInfo.getReal_name());
            }
        }
    }

    /**
     * 搜索框 筛选数据
     *
     * @param mMatchString
     */
    private synchronized void filterData(final String mMatchString) {
        if (adapter == null || list == null || list.size() == 0) {
            return;
        }
        matchString = mMatchString;
        new Thread(new Runnable() {
            @Override
            public void run() {
                final ArrayList<GroupDiscussionInfo> filterDataList = (ArrayList<GroupDiscussionInfo>) SearchMatchingUtil.match(GroupDiscussionInfo.class, list, matchString);
                if (mMatchString.equals(matchString)) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            adapter.setFilterValue(mMatchString);
                            adapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }


    private void initSelectTips() {
        if (singleGroupChatCount != 0 && groupChatCount != 0) {
            selectCountTips.setText(singleGroupChatCount + "人，" + groupChatCount + "群组");
            btnClick();
        } else if (singleGroupChatCount != 0) {
            selectCountTips.setText(singleGroupChatCount + "人");
            btnClick();
        } else if (groupChatCount != 0) {
            selectCountTips.setText(groupChatCount + "群组");
            btnClick();
        } else {
            selectCountTips.setText("");
            btnUnClick();
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.confirm_btn: //多选确定按钮
                new ForwardMessageDialog(ForwardMessageActivity.this, forwardMessageType, forwardList,
                        getForwardContent(), getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false), this).show();
                break;
            case R.id.right_title: //多选
                title.setText("选择多个聊天");
                multiPartText.setVisibility(View.GONE);
                multipartLayout.setVisibility(View.VISIBLE);
                adapter.setMultiPart(true);
                adapter.notifyDataSetChanged();
                initSelectTips();
                break;
            case R.id.left_icon: //取消按钮
                if (adapter.isMultiPart()) {
                    cancelMultipartOperation();
                    return;
                }
                finish();
                break;
        }
    }

    private void btnUnClick() {
        confirmBtn.setClickable(false);
        Utils.setBackGround(confirmBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
    }

    private void btnClick() {
        confirmBtn.setClickable(true);
        Utils.setBackGround(confirmBtn, getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
    }


    public void onBackPressed() {
        if (adapter.isMultiPart()) {
            cancelMultipartOperation();
            return;
        }
        super.onBackPressed();//注释掉这行,back键不退出activity
    }

    /**
     * 取消多选的操作
     */
    public void cancelMultipartOperation() {
        multipartLayout.setVisibility(View.GONE);
        multiPartText.setVisibility(View.VISIBLE);
        adapter.setMultiPart(false);
        adapter.notifyDataSetChanged();
        singleGroupChatCount = 0;
        groupChatCount = 0;
        title.setText("选择一个聊天");
        if (forwardList.size() > 0) {
            for (GroupDiscussionInfo groupDiscussionInfo : forwardList) {
                groupDiscussionInfo.setIs_selected(0);
            }
            forwardList.clear();
        }
    }


    /**
     * 加载本地数据库数据
     */
    private void loadLocalDataBaseData() {
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                final ArrayList<GroupDiscussionInfo> list = MessageUtil.getLocalChatListData(true);
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        ForwardMessageActivity.this.list = list;
                        adapter = new MessageTransmitAdapter(ForwardMessageActivity.this, list);
                        ListView listView = findViewById(R.id.listView);
                        listView.setOnItemClickListener(ForwardMessageActivity.this);
                        listView.setAdapter(adapter);
                    }
                });
            }
        });
    }

    @Override
    public void finish() {
        overridePendingTransition(0, R.anim.scan_login_close);
        super.finish();
    }

    /**
     * 点击分享后的回调
     *
     * @param workds 留言的信息
     */
    @Override
    public void sendMsg(String workds) {
        if (!checkSocketNetStatus()) {
            return;
        }
        boolean forwadItemInfo = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
        //单独处理分享图片上传
        if (!forwadItemInfo && forwardMessageType.equals(MessageType.MSG_PIC_STRING)) {
            fileUpData(workds);
            return;
        }
        if (adapter.isMultiPart()) { //多选状态下的发送
            for (GroupDiscussionInfo groupDiscussionInfo : forwardList) {
                switch (forwardMessageType) {
                    case MessageType.MSG_TEXT_STRING: //文本、表情
                        handleLocalForwardMessage(cloneMessageBean(), workds, groupDiscussionInfo);
                        break;
                    case MessageType.MSG_PIC_STRING: //图片
                        handleLocalForwardMessage(cloneMessageBean(), workds, groupDiscussionInfo);
                        break;
                    case MessageType.MSG_LINK_STRING: //链接
                        if (forwadItemInfo) {
                            handleLocalForwardMessage(cloneMessageBean(), workds, groupDiscussionInfo);
                        } else {
                            handleLocalForwardMessage(workds, groupDiscussionInfo, null);
                        }
                        break;
                    case MessageType.MSG_POSTCARD_STRING: //名片
                        handleLocalForwardMessage(cloneMessageBean(), workds, groupDiscussionInfo);
                        break;
                }
            }
            CommonMethod.makeNoticeLong(getApplicationContext(), "已发送", CommonMethod.SUCCESS);
            finish();
        } else { //单选状态下的发送
            GroupDiscussionInfo groupDiscussionInfo = adapter.getItem(clickPosition);
            switch (forwardMessageType) {
                case MessageType.MSG_TEXT_STRING: //文本、表情
                    handleLocalForwardMessage(cloneMessageBean(), workds, groupDiscussionInfo);
                    break;
                case MessageType.MSG_PIC_STRING: //图片
                    handleLocalForwardMessage(cloneMessageBean(), workds, groupDiscussionInfo);
                    break;
                case MessageType.MSG_LINK_STRING: //链接
                    if (forwadItemInfo) {
                        handleLocalForwardMessage(cloneMessageBean(), workds, groupDiscussionInfo);
                    } else {
                        handleLocalForwardMessage(workds, groupDiscussionInfo, null);
                    }
                    break;
                case MessageType.MSG_POSTCARD_STRING: //名片
                    handleLocalForwardMessage(cloneMessageBean(), workds, groupDiscussionInfo);
                    break;
            }
            CommonMethod.makeNoticeLong(getApplicationContext(), "已发送", CommonMethod.SUCCESS);
            finish();
        }
    }


    private MessageBean cloneMessageBean() {
        try {
            return (MessageBean) forwardMessage.clone();
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 发送消息到服务器，分享消息
     *
     * @param words               留言信息
     * @param groupDiscussionInfo 组信息
     * @param msgSrc              图片信息
     */
    public void handleLocalForwardMessage(String words, GroupDiscussionInfo groupDiscussionInfo, ArrayList<String> msgSrc) {
        NewMessageUtils messageUtils = getNewMessageUtils(groupDiscussionInfo);
        if (MessageType.MSG_PIC_STRING.equals(forwardMessageType)) {
            if (forwardMessage.getShare_info() != null) {
                sendMsgToServer(messageUtils, messageUtils.getPicBean(msgSrc, forwardMessage.getShare_info().getShareFile().getAbsolutePath()));
            }
        } else {
            if (forwardMessage.getShare_info() != null) {
                sendMsgToServer(messageUtils, messageUtils.getInfoBean(new Gson().toJson(forwardMessage.getShare_info()), forwardMessageType));
            }
        }
        //转发留言信息
        if (!TextUtils.isEmpty(words)) {
            MessageBean wordsMessageBean = messageUtils.getTextBean(words);
            sendMsgToServer(messageUtils, wordsMessageBean);
        }
    }


    /**
     * 发送消息到服务器,转发消息
     *
     * @param forwardMessageBean
     * @param words              留言信息
     */
    public void handleLocalForwardMessage(MessageBean forwardMessageBean, String words, GroupDiscussionInfo groupDiscussionInfo) {
        NewMessageUtils messageUtils = getNewMessageUtils(groupDiscussionInfo);
        forwardMessageBean.setGroup_id(groupDiscussionInfo.getGroup_id());
        forwardMessageBean.setClass_type(groupDiscussionInfo.getClass_type());
        forwardMessageBean.setLocal_id(System.currentTimeMillis() + "");
        sendMsgToServer(messageUtils, forwardMessageBean);
        //转发留言信息
        if (!TextUtils.isEmpty(words)) {
            MessageBean wordsMessageBean = messageUtils.getTextBean(words);
            sendMsgToServer(messageUtils, wordsMessageBean);
        }
    }

    /**
     * 发送消息到服务器
     *
     * @param messageUtils
     * @param messageBean
     */
    private void sendMsgToServer(NewMessageUtils messageUtils, MessageBean messageBean) {
        //保存消息到本息
        ThreadPoolManager.getInstance().executeSaveSendMessage(messageBean);
        //通过WebSocket发送消息
        WebSocket webSocket = SocketManager.getInstance(getApplicationContext()).getWebSocket();
        if (webSocket != null) {
            // 分享数据 is_source => 1
            // 转发数据 is_source => 2
            boolean forwadItemInfo = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
            WebSocketMeassgeParameter msgParmeter = messageUtils.getMessageParemeter(messageBean, null, false, forwadItemInfo ? 2 : 1);
            webSocket.requestServerMessage(msgParmeter);
        } else {
            CommonMethod.makeNoticeShort(getApplicationContext(), "消息发送失败", CommonMethod.ERROR);
        }
    }

    /**
     * 检查Socket 状态
     *
     * @return
     */
    public boolean checkSocketNetStatus() {
        if (!SocketManager.SOCKET_OPEN.equals(SocketManager.getInstance(getApplicationContext()).socketState)) {
            CommonMethod.makeNoticeShort(getApplicationContext(), "请检查你的网络连接", CommonMethod.ERROR);
            SocketManager.getInstance(getApplicationContext()).reconnectNow();
            return false;
        }
        return true;
    }

    public NewMessageUtils getNewMessageUtils(GroupDiscussionInfo groupDiscussionInfo) {
        return new NewMessageUtils(getApplicationContext(), groupDiscussionInfo);
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        GroupDiscussionInfo info = adapter.getItem(position);
        if (adapter.isMultiPart()) { //多选状态
            //true表示选中
            boolean isSelect = info.is_selected == 1 ? false : true;
            //多选最多选择9个聊天
            if (isSelect && singleGroupChatCount + groupChatCount >= 9) {
                CommonMethod.makeNoticeLong(this, "最多只能选择9个聊天", CommonMethod.ERROR);
                return;
            }
            info.setIs_selected(isSelect ? 1 : 0);
            if (WebSocketConstance.SINGLECHAT.equals(info.getClass_type())) {
                singleGroupChatCount = isSelect ? singleGroupChatCount + 1 : singleGroupChatCount - 1;
            } else {
                groupChatCount = isSelect ? groupChatCount + 1 : groupChatCount - 1;
            }
            ArrayList<GroupDiscussionInfo> mFowardList = ForwardMessageActivity.this.forwardList;
            if (isSelect) {
                mFowardList.add(info);
            } else {
                int size = mFowardList.size();
                for (int i = 0; i < size; i++) {
                    //判断GroupId和ClassType相等的则认为移除了
                    if (mFowardList.get(i).getClass_type().equals(info.getClass_type()) && mFowardList.get(i).getGroup_id().equals(info.getGroup_id())) {
                        mFowardList.remove(i);
                        break;
                    }
                }
            }
            adapter.notifyDataSetChanged();
            initSelectTips();
        } else { //单选直接弹出分享的框
            clickPosition = position;
            boolean isSingleChat = WebSocketConstance.SINGLECHAT.equals(info.getClass_type());
            new ForwardMessageDialog(ForwardMessageActivity.this, forwardMessageType,
                    info.getGroup_name(), (ArrayList<String>) info.getMembers_head_pic(), getForwardContent(),
                    isSingleChat, getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false), this).show();
        }
    }

    /**
     * 获取分享内容
     *
     * @return
     */
    public String getForwardContent() {
        switch (forwardMessageType) {
            case MessageType.MSG_TEXT_STRING: //文本、表情
            case MessageType.MSG_POSTCARD_STRING: //名片
            case MessageType.MSG_LINK_STRING: //链接类型
                return forwardMessage.getMsg_text();
            case MessageType.MSG_PIC_STRING: //图片
                return getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false) ?
                        forwardMessage.getMsg_src() != null && forwardMessage.getMsg_src().size() > 0 ? forwardMessage.getMsg_src().get(0) : null :
                        forwardMessage.getShare_info().getShareFile().getAbsolutePath();
        }
        return null;
    }


    /**
     * 发送图片消息
     *
     * @param words 留言信息
     */
    protected void fileUpData(final String words) {
        //分享图片路径 需要压缩-->上传(http)-->发送(WebSocket)
        final CustomProgress uploadProgress = new CustomProgress(this);
        uploadProgress.show(this, null, false);
        //分享的本地图片路径
        final String filePath = forwardMessage.getShare_info().getShareFile().getAbsolutePath();
        compressImageSetParams(filePath, new ImageUtil.CompressImageListener() {
            @Override
            public void compressSuccess(RequestParams params) {
                CommonHttpRequest.uploadSinglePic(ForwardMessageActivity.this, params, filePath, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        uploadProgress.dismiss();
                        ArrayList<String> msgSrc = (ArrayList<String>) object;
                        if (msgSrc != null && !msgSrc.isEmpty()) {
                            if (adapter.isMultiPart()) { //多选状态下的发送
                                for (GroupDiscussionInfo groupDiscussionInfo : forwardList) {
                                    handleLocalForwardMessage(words, groupDiscussionInfo, msgSrc);
                                }
                                CommonMethod.makeNoticeLong(getApplicationContext(), "已发送", CommonMethod.SUCCESS);
                                finish();
                            } else { //单选状态下的发送
                                handleLocalForwardMessage(words, adapter.getItem(clickPosition), msgSrc);
                                CommonMethod.makeNoticeLong(getApplicationContext(), "已发送", CommonMethod.SUCCESS);
                                finish();
                            }
                        }
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        uploadProgress.dismiss();
                    }
                });
            }
        });
    }

    /**
     * 如果上传的网络图片需要先压缩图片
     *
     * @param filePath              图片路径
     * @param compressImageListener 压缩完成的回调
     */
    public void compressImageSetParams(final String filePath, final ImageUtil.CompressImageListener compressImageListener) {
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                final RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                ImageUtil.compressImageSetParams(params, filePath, ForwardMessageActivity.this);
                compressImageListener.compressSuccess(params);
            }
        });
    }
}