package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextUtils;
import android.view.View;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.activity.ForwardMessageActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.activity.log.LogDetailActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.PersonWorkInfoBean;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.dialog.NewMessageItemDialog;
import com.jizhi.jlongg.main.message.ActivityNoticeDetailActivity;
import com.jizhi.jlongg.main.message.ActivityQualityAndSafeDetailActivity;
import com.jizhi.jlongg.main.message.MessageReadInfoListActivity;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DBMsgUtil;
import com.jizhi.jlongg.main.util.MediaManager;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.ThreadPoolManager;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.nineoldandroids.animation.Animator;
import com.nineoldandroids.animation.ObjectAnimator;

import java.util.ArrayList;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;
import me.nereo.multi_image_selector.MultiImageSelectorFragment;

/**
 * F
 * CName:3.4.0新聊天
 * User: hcs
 * Date: 2018-7-30
 * Time: 11:35
 */

public class NewMsgActivity extends NewMessageBaseActivity implements MessageBroadCastListener, NewMessageItemDialog.ItemClickInterface, SwipeRefreshLayout.OnRefreshListener {

    /**
     * 上次已读的最大消息
     */
    private long lastMaxReadId;
    /**
     * true表示正在加载未读最大消息的动画
     */
    private boolean isLoadAnimation;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_message);
        registerFinishActivity();
        mActivity = NewMsgActivity.this;
        getIntentData();
        setBroadCastSuccessListener(this);
        initBaseView(mActivity);//初始化view
        setUnreadMsg();
        registerReceiver();
        mSwipeLayout.setOnRefreshListener(this);
        setInitData();
    }


    protected void setInitData() {
        super.onStart();
        setTitle();//设置标题
        initRightImage();//设置更多按钮
        messageUtils = new NewMessageUtils(mActivity, gnInfo);
        messageList.clear();
        setMessageAdapter();
        autoRefresh();
        //读取草稿
        String draft_text = dbMsgUtil.getMsgDraftText(gnInfo.getGroup_id(), gnInfo.getClass_type());
        if (!TextUtils.isEmpty(draft_text) && null != emotionMsgFragment && null != emotionMsgFragment.getEtMessage()) {
            emotionMsgFragment.getEtMessage().setText(draft_text);
            emotionMsgFragment.getEtMessage().setSelection(draft_text.length());
        }
    }

    /**
     * V4.0.2
     * 增加未读消息定位功能
     * 1、聊天对话窗口有未读新消息时，在聊天窗口界面上方提示“xxx条新消息”，点击滚动到未读消息开始的地方（包括单聊、群聊、班组项目组内聊天），；
     * 2、未读消息超过30条，才显示“xxx条新消息”；
     * 3、点击“xxx条新消息”，滚动到未读消息开始的地方，“xxx条新消息”标签消失；
     * 4、手动下拉滑动到未读消息开始的地方，“xxx条新消息”标签也要消失；
     * 5、滚动到未读消息开始的地方，上面增加文字提示显示“——以下为新消息——”；
     */
    private void setUnreadMsg() {
        if (gnInfo.getUnread_msg_count() > 30) {
            lastMaxReadId = dbMsgUtil.selectLastMaxReadId(gnInfo.getGroup_id(), gnInfo.getClass_type());
            View unreadMsgCountLayout = findViewById(R.id.unread_msg_count_layout);
            unreadMsgCountLayout.setVisibility(View.VISIBLE);
            getTextView(R.id.unread_msg_count_text).setText(gnInfo.getUnread_msg_count() + "条新消息");
            unreadMsgCountLayout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    List<MessageBean> mMessageList = messageList;
                    if (mMessageList != null && mMessageList.size() > 0) {
                        //和列表的第一条消息的id做比较，如果未读的消息id数小于第一条消息列表数据则在列表中没有我们需要滑动到未读消息数据,那么我们需要在数据库中将消息给读取出来
                        if (mMessageList.get(0).getMsg_id() > lastMaxReadId) {
                            messageList.addAll(0, dbMsgUtil.selectScopeMessage(gnInfo.getGroup_id(), gnInfo.getClass_type(), lastMaxReadId, mMessageList.get(0).getMsg_id()));
                            //执行点击动画
                            executeUnreadMsgAnimation(0);
                        } else {
                            //定位的地址
                            int localtionPosition = 0;
                            for (MessageBean messageBean : mMessageList) {
                                if (messageBean.getMsg_id() == lastMaxReadId) {
                                    //执行点击动画
                                    executeUnreadMsgAnimation(localtionPosition + 1);
                                    break;
                                }
                                localtionPosition++;
                            }
                        }
                    }
                }
            });
            lv_msg.setOnScrollListener(new RecyclerView.OnScrollListener() {
                @Override
                public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                    super.onScrollStateChanged(recyclerView, newState);
                }

                @Override
                public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                    super.onScrolled(recyclerView, dx, dy);
                    //向下滚动,才去检测
                    if (dy < 0) {
                        int visiblesItems = linearLayoutManager.findFirstVisibleItemPosition();//得到显示屏内的第一个list的位置数position
//                        LUtils.e("visiblesItems:" + visiblesItems + "             msg_id:" + messageList.get(visiblesItems).getMsg_id());
                        //检测滑动的时候是否已滚动到了未读消息处，如果滚动到了未读消息处则执行关闭未读消息动画
                        if (lastMaxReadId != 0 && messageList != null && messageList.size() > 0 && messageList.get(visiblesItems).getMsg_id() <= lastMaxReadId) {
                            executeUnreadMsgAnimation(visiblesItems);
                        }
                    }
                }
            });
        }
    }


    private MessageBean addNewMsgType() {
        MessageBean messageBean = new MessageBean();
        messageBean.setMsg_type(MessageType.MSG_NEW_STRING);
        messageBean.setMsg_id(messageList.get(0).getMsg_id());
        return messageBean;
    }


    /**
     * 滚动到未读消息的操作
     */
    private void executeUnreadMsgAnimation(final int localPosition) {
        if (!isLoadAnimation) {
            isLoadAnimation = true;
            //新增一条以下为未读的消息的提示
            messageList.add(localPosition, addNewMsgType());
            //滚动到未读消息的地点
            lv_msg.smoothScrollToPosition(localPosition);
            //更新列表数据
            messageAdapter.notifyDataSetChanged();
            final View unreadMsgCountLayout = findViewById(R.id.unread_msg_count_layout);
            ObjectAnimator translateAnimation = ObjectAnimator.ofFloat(unreadMsgCountLayout, "translationX", 0, unreadMsgCountLayout.getWidth()).setDuration(700);
            translateAnimation.addListener(new Animator.AnimatorListener() {
                @Override
                public void onAnimationStart(Animator animator) {

                }

                @Override
                public void onAnimationEnd(Animator animator) {
                    unreadMsgCountLayout.setVisibility(View.GONE);
                    lv_msg.setOnScrollListener(null);
                    isLoadAnimation = false;
                }

                @Override
                public void onAnimationCancel(Animator animator) {

                }

                @Override
                public void onAnimationRepeat(Animator animator) {

                }
            });
            translateAnimation.start();
        }
    }


    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        getIntentData();
        setInitData();
    }

    /**
     * 自动下拉刷新
     */
    public void autoRefresh() {
        mSwipeLayout.post(new Runnable() {
            @Override
            public void run() {
                mSwipeLayout.setRefreshing(true);
                onRefresh();
            }
        });
    }


    @Override
    public void onRefresh() {
        getRoamMessageList(10);
    }

    /**
     * 获取更多消息
     */
    public void getRoamMessageList(int limit) {
        //如果界面已有消息就直接msg_id，否者就在数据库读取最大的
        if (messageList.size() > 0) {
            first_msg_id = messageList.get(0).getMsg_id();
        } else {
            first_msg_id = Integer.parseInt(dbMsgUtil.selectMaxId(gnInfo.getGroup_id(), gnInfo.getClass_type())) + 1;
        }
        dbMsgUtil.selectMessageList(gnInfo.getGroup_id(), gnInfo.getClass_type(), first_msg_id + "", limit, broadCastSuccessListener);
    }

    /**
     * 本地数据库查询消息后回调，如果本地存在就直接显示到顶部，如果本地没有就去线上拉去离线
     * 显示本地的消息
     *
     * @param beanList 消息集合
     */
    @Override
    public void showRoamMessage(List<MessageBean> beanList) {
        if (null == beanList || beanList.size() == 0) {
            long del_msg_id = dbMsgUtil.selectDeleteMsg_id(gnInfo.getGroup_id(), gnInfo.getClass_type());
            //线上拉去离线没有更多或者本地清空过就不用去线上拉去
            if (is_message_more || del_msg_id != 0) {
                mSwipeLayout.setRefreshing(false);
                findJobHelperToMsg();
                LUtils.e("----------拉去线上漫游条件不满足------------");
                return;
            } else {
                //拉去线上漫游
                LUtils.e("----------拉去线上漫游------------");
                getOnlineHistoryMessage();
                return;
            }
        }
        //存在直接显示到界面上
        LUtils.e("---------直接显示到界面上------------");
        showMoreMessageTop(beanList);
    }


    /**
     * 下拉加载更多操作，显示多条消息到顶部
     *
     * @param beanList 消息集合
     */
    @Override
    public void showMoreMessageTop(final List<MessageBean> beanList) {
        if (null == beanList || beanList.size() == 0) {
            //初始化找工作消息
            findJobHelperToMsg();
            return;
        }
        final int lastpositon = messageList.size();
        // 排重当前显示的消息
        StringBuffer sb_unread = new StringBuffer();
        for (MessageBean bean : beanList) {
            if (bean.getClass_type().equals(gnInfo.getClass_type()) && bean.getGroup_id().equals(gnInfo.getGroup_id())) {
                if (!messageList.contains(bean)) {
                    messageList.add(0, bean);
                    //如果是自己发送的消息，并且未读数大于0，就去线上查询最大未读数
                    if (bean.getMsg_sender().equals(UclientApplication.getUid()) && bean.getUnread_members_num() > 0) {
                        sb_unread.append(bean.getMsg_id() + ",");
                    }
                } else if (bean.getMsg_id() == 0) {
                    //发送失败的也需要加载
                    messageList.add(0, bean);

                }
            }
        }
        //查询未读数
        if (!TextUtils.isEmpty(sb_unread.toString())) {
            getMessageReadNum(sb_unread.toString());
        }
        mActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mSwipeLayout.setRefreshing(false);
                if (messageList.size() <= 10 || messageList.size() == beanList.size()) {
                    LUtils.e("---messageList----111-----------");
                    lv_msg.scrollToPosition(messageAdapter.getItemCount() - 1);
                    messageAdapter.notifyDataSetChanged();
                } else {
                    if (lastpositon == messageList.size()) {
                        LUtils.e("---messageList----222-----------");

                        lv_msg.scrollToPosition(0);
                    } else if (messageList.size() == beanList.size()) {
                        LUtils.e("---messageList----333-----------");

//                        lv_msg.scrollToPosition(messageAdapter.getItemCount() - 1);
                    } else {
                        messageAdapter.notifyDataSetChanged();
//                        if (messageList.get(messageList.size() - 1).getMsg_type().equals(MessageType.MSG_FINDWORK_TEMP_STRING)) {
//                            LUtils.e("---messageList----444-----------");
//
//                            lv_msg.scrollToPosition(messageAdapter.getItemCount() - 1);
//                        } else
                        {
                            LUtils.e("---messageList----555-----------");

                            lv_msg.scrollToPosition(messageList.size() > 0 ? beanList.size() + 1 : beanList.size());
                        }
                    }
                }
                //初始化找工作消息
                findJobHelperToMsg();

            }
        });
//        if (!gnInfo.getClass_type().equals(WebSocketConstance.SINGLECHAT)) {
        for (int i = beanList.size() - 1; i >= 0; i--) {
            if (!NewMessageUtils.isMySendMessage(beanList.get(i)) && beanList.get(i).getIs_readed() == 0) {
                if (dbMsgUtil.getMaxReadedId(gnInfo.getGroup_id(), gnInfo.getClass_type()) <= beanList.get(i).getMsg_id()) {
                    MessageUtils.getCallBackOperationMessage(getApplicationContext(), MessageUtils.getReciveReadInfo(beanList.get(i)), WebSocketConstance.READED);
                }
            }
        }
//        }
    }

    /**
     * 显示多条消息到底部
     *
     * @param beanList 消息集合
     */
    @Override
    public void showMoreMessageBottom(final List<MessageBean> beanList) {
        if (null == beanList || beanList.size() == 0) {
            return;
        }
        final int lastpositon = messageList.size();
        //排重当前显示的消息
        for (MessageBean bean : beanList) {
            if (bean.getClass_type().equals(gnInfo.getClass_type()) && bean.getGroup_id().equals(gnInfo.getGroup_id()) && !messageList.contains(bean)) {
                messageList.add(bean);
            }
        }
        mActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mSwipeLayout.setRefreshing(false);
                messageAdapter.notifyItemChanged(lastpositon > 0 ? lastpositon - 1 : lastpositon, messageList.size() - 1);
                int lastVisibleItemPosition = linearLayoutManager.findLastVisibleItemPosition();
                if (lastVisibleItemPosition + 5 >= lastpositon) {
                    lv_msg.scrollToPosition(messageAdapter.getItemCount() - 1);
                }

            }
        });
//        if (!gnInfo.getClass_type().equals(WebSocketConstance.SINGLECHAT)) {
        for (int i = beanList.size() - 1; i >= 0; i--) {
            if (!NewMessageUtils.isMySendMessage(beanList.get(i))) {
//                    if (dbMsgUtil.getMaxReadedId(gnInfo.getGroup_id(), gnInfo.getClass_type()) >= beanList.get(i).getMsg_id()) {
//                        return;
//                    }
                LUtils.e("-------showMoreMessageBottom-----22--------");
                MessageUtils.getCallBackOperationMessage(NewMsgActivity.this, MessageUtils.getReciveReadInfo(beanList.get(i)), WebSocketConstance.READED);
                return;
            }
        }
//        }
    }

    /**
     * 自己发送的消息直接显示到底部
     */
    @Override
    public void showSingleMessageBottom(final MessageBean bean) {
        if (null == bean) {
            return;
        }
        mActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                messageList.add(bean);
                messageAdapter.notifyDataSetChanged();
                lv_msg.scrollToPosition(messageAdapter.getItemCount() - 1);
            }
        });
    }

    /**
     * 发送多条消息
     *
     * @param beanList 消息集合
     */
    @Override
    public void sendPicMessage(List<MessageBean> beanList) {
        messageList.addAll(beanList);
        messageAdapter.notifyDataSetChanged();
        lv_msg.scrollToPosition(messageList.size() - 1);
    }

    /**
     * 撤回消息刷新本地
     *
     * @param bean
     */
    @Override
    public void reCallMessage(MessageBean bean) {
        final int position = messageList.indexOf(bean);
        if (position != -1) {
            messageList.get(position).setMsg_text(bean.getMsg_text());
            messageList.get(position).setMsg_type(bean.getMsg_type());
            mActivity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    messageAdapter.notifyItemChanged(position);
                }
            });
        }
    }

    /**
     * 改变消息状态
     */
    @Override
    public void changetMsgState(final MessageBean bean) {
        if (messageUtils.isEmptyList(messageList)) {
            return;
        }
        for (int i = messageList.size() - 1; i >= 0; i--) {
            if (null != messageList.get(i).getLocal_id() && messageList.get(i).getLocal_id().equals(bean.getLocal_id())) {
                if (!TextUtils.isEmpty(isRecalLocalId) && bean.getLocal_id().equals(isRecalLocalId)) {
                    //重发消息就移除当条消息，在添加
                    messageList.remove(i);
                    messageList.add(bean);
                } else {
                    //图片不解决
                    if (messageList.get(i).getMsg_type().equals(MessageType.MSG_PIC_STRING)) {
                        bean.setMsg_src(messageList.get(i).getMsg_src());
                    }
                    //否者直接改变当条消息状态
                    messageList.set(i, bean);
                    messageList.get(i).setMsg_state(bean.getMsg_state());

                }

                final int finalI = i;
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (bean.getMsg_type().equals(MessageType.MSG_PIC_STRING)) {
                            messageAdapter.notifyDataSetChanged();
                        } else {
                            messageAdapter.notifyItemChanged(finalI);
                        }
                    }
                });
                return;
            }
        }

    }

    /**
     * 标题接收到的消息为已读
     *
     * @param beans 接收到的消息
     */
    @Override
    public void MsgAlreadyRead(List<MessageBean> beans) {
        try {
            for (int i = 0; i < messageList.size(); i++) {
                for (int j = 0; j < beans.size(); j++) {
                    if (messageList.get(i).getMsg_id() == beans.get(j).getMsg_id()) {
                        messageList.get(i).setIs_readed(1);
                    }
                }
            }
            messageAdapter.notifyDataSetChanged();

        } catch (Exception e) {

        }
    }

    /**
     * 更新群聊未读数
     */
    @Override
    public void MsgUnderReadCount(MessageBean bean) {
        for (int i = messageList.size() - 1; i >= 0; i--) {
            if (messageList.get(i).getMsg_sender().equals(UclientApplication.getUid(mActivity))) {
                if (messageList.get(i).getMsg_id() == bean.getMsg_id()) {
                    messageList.get(i).setIs_readed(1);
                    messageList.get(i).setUnread_members_num(bean.getUnread_members_num());
                    break;
                } else if (bean.getMsg_id() > messageList.get(i).getMsg_id() && messageList.get(i).getUnread_members_num() > bean.getUnread_members_num()) {

                }
            }
        }
        messageAdapter.notifyDataSetChanged();
    }


    private int oldVoicePostion = -1;

    /**
     * 点击语音
     */
    @Override
    public void clickVoice(int position) {
        if (null == messageList.get(position).getMsg_src() || messageList.get(position).getMsg_src().size() == 0) {
            CommonMethod.makeNoticeShort(mActivity, "播放失败", CommonMethod.ERROR);
            return;
        }
        if (messageList.get(position).isPlaying()) {
            //播放中就停止播放
            messageList.get(position).setPlaying(false);
            LUtils.e("---------停止播放-------" + position);
        } else {
            MediaManager.release();//重置
            //没有播放就开始播放
            messageList.get(position).setPlaying(true);
            if (!NewMessageUtils.isMySendMessage(messageList.get(position))) {
                messageList.get(position).setIs_readed_local(1);
            }
            if (oldVoicePostion != -1 && oldVoicePostion != position) {
                messageList.get(oldVoicePostion).setPlaying(false);
                messageAdapter.notifyItemChanged(oldVoicePostion);
                LUtils.e("---------之前有正在播放的语音先把他关掉-------" + position);
            }
            LUtils.e(oldVoicePostion + "---------开始播放-------" + position);
        }
        oldVoicePostion = position;
        messageAdapter.notifyItemChanged(position);
    }

    /**
     * 点击头像
     *
     * @param position 下标
     */
    @Override
    public void clickHead(int position) {
        LUtils.e("------111------clickHead------");
        if (TextUtils.isEmpty(messageList.get(position).getUser_info().getUid())) {
            return;
        }
        LUtils.e("------222------clickHead------");
        ChatUserInfoActivity.actionStart(mActivity, messageList.get(position).getUser_info().getUid());
    }

    @Override
    public void sendFialMessage(int position) {
        if (!SocketManager.SOCKET_OPEN.equals(SocketManager.getInstance(getApplicationContext()).socketState)) {
            CommonMethod.makeNoticeShort(mActivity, "请检查你的网络连接", CommonMethod.ERROR);
            return;
        }
        messageList.get(position).setMsg_state(2);
        messageAdapter.notifyDataSetChanged();
        isRecalLocalId = messageList.get(position).getLocal_id();
        if (messageList.get(position).getMsg_type().equals(MessageType.MSG_TEXT_STRING)) {
            HandleMessage(messageList.get(position), true);
        } else if (messageList.get(position).getMsg_type().equals(MessageType.MSG_VOICE_STRING)) {
            uploadVoice(messageList.get(position).getVoice_long(), messageList.get(position).getMsg_src().get(0), true, messageList.get(position).getLocal_id());
        } else if (messageList.get(position).getMsg_type().equals(MessageType.MSG_PIC_STRING)) {
            if (null != messageList.get(position).getMsg_src() && messageList.get(position).getMsg_src().size() > 0) {
                if (messageList.get(position).getMsg_src().get(0).contains("/storage/")) {
                    fileUpData(messageList.get(position));
                } else {
                    HandleMessage(messageList.get(position), true);
                }

            }

//            String picPath = (messageList.get(position).getMsg_src().get(0).contains("/storage/") ? "file://" : NetWorkRequest.NETURL) + message.getMsg_src().get(0);

        }
    }

    /**
     * 未读详情
     *
     * @param position
     */
    @Override
    public void toReadInfoList(int position) {
        if (messageList.get(position).getUnread_members_num() > 0) {
            MessageReadInfoListActivity.actionStart(mActivity, gnInfo, String.valueOf(messageList.get(position).getMsg_id()), true);
        }
    }

    /**
     * 消息长按
     */
    @Override
    public void onLongClickListener(int position) {

        LUtils.e("--------1111---onLongClickListener-------");
        if (NewMessageUtils.getMsgLongClickList(messageList.get(position)).size() == 0) {
            LUtils.e("--------2222---onLongClickListener-------");

            return;
        }
        if (null != itemLongClickDialog) {
            itemLongClickDialog.dismiss();
            itemLongClickDialog = null;
        }
        itemLongClickDialog = new NewMessageItemDialog(mActivity, this, NewMessageUtils.getMsgLongClickList(messageList.get(position)), position);
        itemLongClickDialog.show();
    }

    /**
     * 重发
     *
     * @param position
     */
    @Override
    public void send(int position) {
        sendFialMessage(position);
    }

    /**
     * 长按头像处理@信息
     */
    @Override
    public void onHeadLongClickListener(int position) {
        LUtils.e("----1111---onHeadLongClickListener--------");
        LUtils.e(new Gson().toJson(messageList.get(position).getUser_info()));
        //单聊不处理
        if (messageList.get(position).getClass_type().trim().equals(WebSocketConstance.SINGLECHAT.trim())) {
            return;
        }
        LUtils.e("---2222----onHeadLongClickListener--------");
        String uid = messageList.get(position).getUser_info().getUid();
        if (!TextUtils.isEmpty(uid)) {
            PersonBean personBean = new PersonBean();
            personBean.setUid(Integer.parseInt(uid));
            if (!TextUtils.isEmpty(messageList.get(position).getUser_info().getFull_name())) {
                personBean.setName(messageList.get(position).getUser_info().getFull_name());
            } else {
                personBean.setName(messageList.get(position).getUser_info().getReal_name());
            }
            addAtInfo(personBean);
            emotionMsgFragment.getEtMessage().setText(emotionMsgFragment.getEtMessage().getText().toString() + "@" + personBean.getName() + " ");
            cursorEnd(emotionMsgFragment.getEtMessage());
        }
    }

    /**
     * 点击了图片
     *
     * @param position
     */
    @Override
    public void onPictureClick(int position) {
        List<String> list = new ArrayList<>();
        if (null == messageList.get(position).getMsg_src() || messageList.get(position).getMsg_src().size() == 0) {
            return;
        }
        LUtils.e("-------onPictureClick--------------" + messageList.get(position).getMsg_src());

//        for (int i = 0; i < messageList.size(); i++) {
//            if (messageList.get(i).getMsg_type().equals(MessageType.MSG_PIC_STRING) && null != messageList.get(i).getMsg_src() && messageList.get(i).getMsg_src().size() == 2) {
//                for (int j = 0; j < messageList.get(i).getMsg_src().size(); j++) {
//                    if (!messageList.get(i).getMsg_src().get(j).contains("/storage/")) {
//                        String path = messageList.get(position).getMsg_src().get(j);
//                        messageList.get(i).getMsg_src().clear();
//                        messageList.get(i).getMsg_src().add(path);
//                    }
//                }
//            }
//
//        }
        int index = 0;
        for (int i = 0; i < messageList.size(); i++) {
            if (messageList.get(i).getMsg_type().equals(MessageType.MSG_PIC_STRING) && null != messageList.get(i).getMsg_src()) {
                if (messageList.get(i).getMsg_src().size() == 2) {
                    String tempPath = "";
                    String tempPath1 = "";
                    for (int j = 0; j < messageList.get(i).getMsg_src().size(); j++) {
                        if (!messageList.get(i).getMsg_src().get(j).contains("/storage/")) {
                            tempPath = messageList.get(i).getMsg_src().get(j);
                            list.add(tempPath);
                        }

                    }
                    for (int j = 0; j < messageList.get(position).getMsg_src().size(); j++) {
                        if (!messageList.get(position).getMsg_src().get(j).contains("/storage/")) {
                            tempPath1 = messageList.get(position).getMsg_src().get(j);
                        }

                    }
                    if (tempPath.equals(tempPath1)) {
                        index = list.size();
                    }

                } else {
                    list.add(messageList.get(i).getMsg_src().get(0));
                    if (messageList.get(i).getMsg_src().get(0).equals(messageList.get(position).getMsg_src().get(0))) {
                        index = list.size();
                    }
                }


            }
        }
        showImageView(list, index, mActivity);
    }

    /**
     * 复制信息
     */
    @Override
    public void copy(int position) {
        ClipboardManager clipboardManager =
                (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
        /**之前的应用过期的方法，clipboardManager.setText(copy);*/
        assert clipboardManager != null;
        clipboardManager.setPrimaryClip(ClipData.newPlainText(null, messageList.get(position).getMsg_text()));
        if (clipboardManager.hasPrimaryClip()) {
            clipboardManager.getPrimaryClip().getItemAt(0).getText();
            CommonMethod.makeNoticeShort(mActivity, "复制成功", CommonMethod.SUCCESS);
        }
    }


    /**
     * 删除
     *
     * @param position
     */
    @Override
    public void delete(int position) {
        dbMsgUtil.deleteSingleMessage(messageList.get(position));
        messageList.remove(position);
        messageAdapter.notifyDataSetChanged();
    }

    /**
     * 撤回
     *
     * @param position
     */
    @Override
    public void recall(int position) {
        long time = System.currentTimeMillis() / 1000 - messageList.get(position).getSend_time();
        if (time > 120) {
            CommonMethod.makeNoticeShort(mActivity, "不能撤回2分钟之前发送的消息", CommonMethod.ERROR);
            return;
        }
        recall_Message(messageList.get(position).getMsg_id() + "");
    }

    //转发
    @Override
    public void forward(int position) {
        MessageBean messageBean = messageList.get(position);
        if (null != messageList.get(position).getMsg_src() && messageList.get(position).getMsg_src().size() > 1) {
            for (int j = 0; j < messageList.get(position).getMsg_src().size(); j++) {
                if (!messageList.get(position).getMsg_src().get(j).contains("/storage/")) {
                    String path = messageList.get(position).getMsg_src().get(j);
                    messageBean.getMsg_src().clear();
                    messageBean.getMsg_src().add(path);
                }
            }
        }
        ForwardMessageActivity.actionStart(this, messageBean, messageBean.getMsg_type());
    }

    /**
     * 播放语音
     *
     * @param position
     */
    @Override
    public void startPlayVoice(final int position) {
//        final int tempPosition = position;
        String path = messageList.get(position).getMsg_src().get(0);
        String voicePath = (path.contains("/storage/") ? "file://" : NetWorkRequest.NETURL) + path;
        messageList.get(position).setIs_readed_local(1);
        DBMsgUtil.getInstance().updateVoiceIsReadLocal(messageList.get(position));
        LUtils.e(voicePath + "--------正在播放的语音下标----------" + position);
        MediaManager.playSound(voicePath,
                new MediaPlayer.OnCompletionListener() {
                    @Override
                    public void onCompletion(MediaPlayer mp) {
                        messageList.get(position).setPlaying(false);
                        messageList.get(position).setIs_readed_local(1);
                        messageAdapter.notifyItemChanged(position);
                        //是否是自己发送的消息
                        for (int i = position + 1; i <= messageList.size() - 1; i++) {
                            boolean isRightVoice = NewMessageUtils.isMySendMessage(messageList.get(i));
                            LUtils.e("--------i -----" + i);
                            //如果不是接收的,是最后一条
                            if (isRightVoice) {
                                LUtils.e(isRightVoice + "-----------是自己发送的，开始找下一条-----------" + (messageList.size() - 1));
                                continue;
                            }
                            //如果不是接收的,是最后一条
                            if (i - 1 == messageList.size() - 1) {
                                LUtils.e(isRightVoice + "-----------已经是最后一条，停止循环-----------" + (messageList.size() - 1));
                                break;
                            }
                            //已经播放过该条语音i
                            if (messageList.get(i).getIs_readed_local() == 1 || messageList.get(i).isPlaying()) {
                                LUtils.e(messageList.get(i).getIs_readed_local() + "-----------已经播放过该条语音-----------" + messageList.get(i).isPlaying());
                                break;
                            }
                            LUtils.e("------------可以播放下一条----");
                            messageList.get(i).setPlaying(true);
                            messageList.get(i).setIs_readed_local(1);
                            messageAdapter.notifyItemChanged(i);
                            break;
                        }
                    }
                });
    }


    /**
     * 停止播放语音
     *
     * @param position
     */
    @Override
    public void stopPlayVoice(final int position) {
        if (MediaManager.isPlayer()) {
            MediaManager.release();
        }

    }

    /**
     * 质量日志通知安全详情
     */
    @Override
    public void toNoticeOrLogSafeQualityDetail(final int position) {
        switch (messageList.get(position).getMsg_type()) {
            case MessageType.MSG_SAFE_STRING:
            case MessageType.MSG_QUALITY_STRING:
                //质量安全
                ActivityQualityAndSafeDetailActivity.actionStart(mActivity, messageList.get(position), gnInfo);
                break;
            case MessageType.MSG_LOG_STRING:
                //日志
                LogDetailActivity.actionStart(mActivity, gnInfo, String.valueOf(messageList.get(position).getMsg_id()), "日志", true);
                break;
            case MessageType.MSG_NOTICE_STRING:
                //通知
                ActivityNoticeDetailActivity.actionStart(mActivity, gnInfo, (int) messageList.get(position).getMsg_id());
                break;
        }

    }

    /**
     * 发送名片回调
     */
    @Override
    public void onSendPostCard(int position, String text, boolean isSendPostCard) {
        if (position != -1) {
            //发送前临时显示的ui修改掉
            PersonWorkInfoBean bean = new Gson().fromJson(messageList.get(position).getMsg_text_other(), PersonWorkInfoBean.class);
            if (null != bean) {
                bean.setClick_type(0);
                messageList.get(position).setMsg_text_other(new Gson().toJson(bean));
                messageAdapter.notifyItemChanged(position);
            }
        }
        //招工信息->名片【点了发送名片时】->未实名提示【发起方未实时】->第一条消息
        if (null != personWorkInfoBean) {
            //发送招工信息
            HandlePostCardAndFindWorkMessage(messageUtils.getInfoBean(new Gson().toJson(personWorkInfoBean), MessageType.RECTUITMENT_STRING), false);
            if (isSendPostCard) {
                //名片消息
                HandlePostCardAndFindWorkMessage(messageUtils.getInfoBean(new Gson().toJson(personWorkInfoBean), MessageType.MSG_POSTCARD_STRING), false);
            }
            if (!TextUtils.isEmpty(messageList.get(position).getVerified()) && !messageList.get(position).getVerified().equals("3")) {
                //实名提示
                HandleMessage(messageUtils.getAuthBean(!TextUtils.isEmpty(personWorkInfoBean.getReal_name()) ? personWorkInfoBean.getReal_name() : ""), false);
            }
        }
        //文本消息
        if (!TextUtils.isEmpty(text)) {
            HandleMessage(messageUtils.getTextBean(text), false);

        }
    }


    /**
     * 发送招工信息
     */
    @Override
    public void onSendFindJob(int position, String text) {
        //发送前临时显示的ui修改掉
        PersonWorkInfoBean bean = new Gson().fromJson(messageList.get(position).getMsg_text_other(), PersonWorkInfoBean.class);
        if (null != bean) {
            bean.setClick_type(0);
            messageList.get(position).setMsg_text_other(new Gson().toJson(bean));
            messageAdapter.notifyItemChanged(position);
        }
        //发送招工信息
        HandlePostCardAndFindWorkMessage(messageUtils.getInfoBean(messageList.get(position).getMsg_text_other(), MessageType.RECTUITMENT_STRING), false);
        if (!TextUtils.isEmpty(messageList.get(position).getVerified()) && !messageList.get(position).getVerified().equals("3")) {
            //实名提示
            HandleMessage(messageUtils.getAuthBean(!TextUtils.isEmpty(messageList.get(position).getReal_name()) ? messageList.get(position).getReal_name() : ""), false);
        }

    }

    /**
     * 点击名片,招工,链接
     */
    @Override
    public void clickPostCard(int position) {
        LUtils.e(new Gson().toJson(messageList.get(position)));
        if (!TextUtils.isEmpty(messageList.get(position).getMsg_text_other())) {
            if (messageList.get(position).getMsg_type().equals(MessageType.MSG_POSTCARD_STRING)) {
                PersonWorkInfoBean info = new Gson().fromJson(messageList.get(position).getMsg_text_other(), PersonWorkInfoBean.class);

                if (!TextUtils.isEmpty(messageList.get(position).getUser_info().getUid())) {
                    X5WebViewActivity.actionStart(mActivity, NetWorkRequest.POSTCARD + "?role_type=" + (info.getRole_type() != 0 ? info.getRole_type() : UclientApplication.getRoler(mActivity)) + "&uid=" + info.getUid());
                }
            } else if (messageList.get(position).getMsg_type().equals(MessageType.RECTUITMENT_STRING)) {

                PersonWorkInfoBean info = new Gson().fromJson(messageList.get(position).getMsg_text_other(), PersonWorkInfoBean.class);
                X5WebViewActivity.actionStart(mActivity, NetWorkRequest.WORK + "/" + info.getPid());


            } else if (messageList.get(position).getMsg_type().equals(MessageType.MSG_LINK_STRING)) {
                Share info = new Gson().fromJson(messageList.get(position).getMsg_text_other(), Share.class);
                if (!TextUtils.isEmpty(info.getUrl())) {
                    X5WebViewActivity.actionStart(mActivity, info.getUrl());

                }


            }
        }
    }


    @Override
    public void AddMessageList(List<MessageBean> listMsg) {

    }

    @Override
    public void finishActivity() {

    }

    @Override
    public void userNameFlush(String name, String uid) {

    }

    @Override
    public void MsgUnderListReadCount(List<MessageBean> mEntity) {

    }

    @Override
    public void MsgUnderListReadCount11111111111(List<MessageBean> mEntity) {

    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.FIND_WORKER_CALLBACK) {
            setResult(Constance.FIND_WORKER_CALLBACK, getIntent());
            finish();
        }
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {
            //选择图片
            if (!SocketManager.SOCKET_OPEN.equals(SocketManager.getInstance(getApplicationContext()).socketState)) {
                CommonMethod.makeNoticeShort(mActivity, "请检查你的网络连接", CommonMethod.ERROR);
                return;
            }
            //选择相册回调
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
//            fileUpData(mSelected);
            for (String path : mSelected) {
                if (!TextUtils.isEmpty(path)) {
                    MessageBean messageBean = messageUtils.getPicBean(path);
                    messageBean.setPic_w_h(Utils.getImageWidthAndHeight(path));
                    //保存消息到本息并显示
                    ThreadPoolManager.getInstance().executeSaveSendMessage(messageBean, broadCastSuccessListener);
                    fileUpData(messageBean);
                }

            }


        } else if (requestCode == MultiImageSelectorFragment.REQUEST_CAMERA) {
            //拍照
            if (resultCode == Activity.RESULT_OK) {
                if (!SocketManager.SOCKET_OPEN.equals(SocketManager.getInstance(getApplicationContext()).socketState)) {
                    CommonMethod.makeNoticeShort(mActivity, "请检查你的网络连接", CommonMethod.ERROR);
                    return;
                }
                if (null != mTmpFile) {
                    MessageBean messageBean = messageUtils.getPicBean(mTmpFile.getAbsolutePath());
                    messageBean.setPic_w_h(Utils.getImageWidthAndHeight(mTmpFile.getAbsolutePath()));
                    //保存消息到本息并显示
                    ThreadPoolManager.getInstance().executeSaveSendMessage(messageBean, broadCastSuccessListener);
                    fileUpData(messageBean);
                }
            } else {
                while (mTmpFile != null && mTmpFile.exists()) {
                    boolean success = mTmpFile.delete();
                    if (success) {
                        mTmpFile = null;
                    }
                }
            }
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            //单聊
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
            return;
        } else if ((requestCode == Constance.REQUEST || requestCode == Constance.REQUESTCODE_SINGLECHAT) && resultCode == Constance.FLUSH_NICKNAME) {
            //修改备注回调
            String real_name = data.getStringExtra(Constance.COMMENT_NAME);
            String uid = data.getStringExtra(Constance.UID);
//            //跟新数据库内容
//            dbMsgUtil.updateNickName(gnInfo.getGroup_id(), gnInfo.getClass_type(), real_name, uid);
            //更新显示消息
            setRealName(real_name, uid);
            //单聊需要更新组名
            if (!TextUtils.isEmpty(real_name) && gnInfo.getClass_type().equals(WebSocketConstance.SINGLECHAT)) {
                gnInfo.setGroup_name(real_name);
                setTitle();
            }
        } else if (requestCode == Constance.PERSON & resultCode == Constance.PERSON) {
            PersonBean personBean = (PersonBean) data.getSerializableExtra(Constance.BEAN_ARRAY);
            if (personBean == null) {
                return;
            }
            addAtInfo(personBean);
            //选择@成员回调
            if (!data.getBooleanExtra(Constance.ATALL, false)) {
                int index = emotionMsgFragment.getEtMessage().getSelectionStart();
                Editable editable = emotionMsgFragment.getEtMessage().getText();
                editable.insert(index, personBean.getName() + " ");
                cursorEnd(emotionMsgFragment.getEtMessage());
            } else {
                int index = emotionMsgFragment.getEtMessage().getSelectionStart();
                Editable editable = emotionMsgFragment.getEtMessage().getText();
                editable.insert(index, "所有人 ");
                cursorEnd(emotionMsgFragment.getEtMessage());
            }
        } else if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) {
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) {
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        }
    }

    /**
     * 修改了昵称回调
     *
     * @param real_name
     * @param uid
     */
    public void setRealName(String real_name, String uid) {
        for (int i = 0; i < messageList.size(); i++) {
            if (messageList.get(i).getMsg_sender().equals(uid)) {
                messageList.get(i).getUser_info().setReal_name(real_name);
                messageAdapter.notifyItemChanged(i);
            }
        }
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        LUtils.e("onDestroy     NewMsgActivity");
        updateChatListUnread();
        updateChatListUnread();
        unregisterFinishActivity();
        if (MediaManager.isPlayer()) {
            MediaManager.release();
        }
        if (null != messageHanderThread) {
            messageHanderThread.quit();
        }
        if (null != timer) {
            timer.cancel();
        }
        dbMsgUtil.updateMessageFail();
        if (null != emotionMsgFragment) {
            String content = emotionMsgFragment.getEtMessage().getText().toString().trim();
            dbMsgUtil.saveMsgDraftText(gnInfo.getGroup_id(), gnInfo.getClass_type(), content);
        }

    }


    @Override
    public void onFinish(View view) {
        if (null != emotionMsgFragment && !emotionMsgFragment.isInterceptBackPress()) {
            super.onFinish(view);
        } else {
            mActivity.finish();
        }
    }

    @Override
    public void onBackPressed() {
        if (null != emotionMsgFragment && !emotionMsgFragment.isInterceptBackPress()) {
            mActivity.finish();
        } else {
            mActivity.finish();
        }
    }

    /**
     * 改变消息状态
     */
    @Override
    public void sendMsgFail(final String local_id) {
        if (TextUtils.isEmpty(local_id)) {
            return;
        }
        LUtils.e("----sendMsgFail-----------" + local_id);
        for (int i = messageList.size() - 1; i >= 0; i--) {
            if (null != messageList.get(i).getLocal_id() && messageList.get(i).getLocal_id().equals(local_id)) {

                messageList.get(i).setMsg_state(1);

                final int finalI = i;
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        messageAdapter.notifyItemChanged(finalI);
                    }
                });
                return;
            }
        }

    }
}
