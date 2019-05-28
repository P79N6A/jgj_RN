package com.jizhi.jlongg.main.message;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.AnimationDrawable;
import android.media.MediaPlayer;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.MsgHeadLongClickListener;
import com.jizhi.jlongg.listener.MsgLongClickListener;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.activity.log.LogDetailActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.dialog.MsgItemLongClickDialog;
import com.jizhi.jlongg.main.listener.MessageOnClickListener;
import com.jizhi.jlongg.main.listener.MsgUploadListener;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MediaManager;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.WebSocket;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.ArrayList;
import java.util.List;


public class MessageAdapter extends MessageBaseAdapter {

    private List<MessageEntity> data;
    private Context context;
    private LayoutInflater mInflater;
    private MsgLongClickListener msgLongClickListener;
    private MsgUploadListener uploadListener;
    private MsgHeadLongClickListener msgHeadLongClickListener;
    protected boolean isClose;
    /*群组信息 */
    protected GroupDiscussionInfo gnInfo;

    public MessageAdapter(Context context, List<MessageEntity> data, MsgLongClickListener msgLongClickListener, MsgUploadListener uploadListener, MsgHeadLongClickListener msgHeadLongClickListener, GroupDiscussionInfo gnInfo) {
        this.context = context;
        mInflater = LayoutInflater.from(context);
        this.data = data;
        this.msgLongClickListener = msgLongClickListener;
        this.uploadListener = uploadListener;
        this.msgHeadLongClickListener = msgHeadLongClickListener;
        this.gnInfo = gnInfo;
        if (gnInfo.getClass_type().equals(WebSocketConstance.SINGLECHAT)) {
            //设置为单聊
            setSignChat(true);
            setGroup_id(gnInfo.getGroup_id());
            setUid(UclientApplication.getUid(context));
        } else if (gnInfo.getIs_closed() == 1) {
            setClose(true);
        }

    }

    public void setListData(List<MessageEntity> data) {
        this.data = data;

    }

    public void setClose(boolean close) {
        isClose = close;
    }

    //获取ListView的项个数
    public int getCount() {
        return data.size();
    }

    //获取项
    public Object getItem(int position) {
        return data.get(position);
//        return this.getView(position, null, this);
    }


    //获取项的ID
    public long getItemId(int position) {
        return position;
    }


    @Override
    public int getViewTypeCount() {
        return 13;
    }

    // 每个convert view都会调用此方法，获得当前所需要的view样式
    @Override
    public int getItemViewType(int position) {
        MessageEntity entity = data.get(position);
        switch (entity.getMsg_type_num()) {
            case MessageType.MSG_TEXT_INT:
                return MessageType.MSG_TEXT_INT;
            case MessageType.MSG_MENBERJOIN_INT:
                return MessageType.MSG_MENBERJOIN_INT;
            case MessageType.MSG_VOICE_INT:
                return MessageType.MSG_VOICE_INT;
            case MessageType.MSG_PIC_INT:
                return MessageType.MSG_PIC_INT;
            case MessageType.MSG_OTHER_INT:
                return MessageType.MSG_OTHER_INT;
            case MessageType.MSG_NOTICE_INT:
                return MessageType.MSG_NOTICE_INT;
            case MessageType.MSG_LOG_INT:
                return MessageType.MSG_LOG_INT;
            case MessageType.MSG_QUALITY_INT:
                return MessageType.MSG_QUALITY_INT;
            case MessageType.MSG_SAFE_INT:
                return MessageType.MSG_SAFE_INT;
            default:
                return -1;
        }
    }

    //获取View
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final MessageEntity entity = data.get(position);
        TextHolder vh_msg_text = null;
        MsgOtherHolder vh_msg_other = null;
        ImageHolder vh_img_holder = null;
        int type = getItemViewType(position);
        if (convertView == null) {
            switch (type) {
                case MessageType.MSG_TEXT_INT:
                    //文字消息
                    convertView = mInflater.inflate(R.layout.item_msg_text, null);
                    vh_msg_text = getTextView(convertView);
                    break;
                case MessageType.MSG_VOICE_INT:
                    //语音消息
                    convertView = mInflater.inflate(R.layout.item_msg_voice, null);
                    vh_msg_text = getVoiceView(convertView);
                    break;
                case MessageType.MSG_PIC_INT:
                    //图片消息
                    convertView = mInflater.inflate(R.layout.item_msg_picture, null);
                    vh_msg_text = getPictureView(convertView);
                    break;
                case MessageType.MSG_MENBERJOIN_INT:
                    //提示消息
                    convertView = mInflater.inflate(R.layout.item_msg_center, null);
                    vh_msg_text = new TextHolder();
                    vh_msg_text.tv_text_left = (TextView) convertView.findViewById(R.id.tv_text);
                    convertView.setTag(vh_msg_text);
                    break;
                //工作通知
                case MessageType.MSG_SAFE_INT:
                case MessageType.MSG_QUALITY_INT:
                case MessageType.MSG_LOG_INT:
                case MessageType.MSG_NOTICE_INT:
                    convertView = mInflater.inflate(R.layout.item_msg_pic, null);
                    vh_img_holder = geNoticeView(convertView);
                    convertView.setTag(vh_img_holder);
                    break;
                case MessageType.MSG_OTHER_INT:
                    //找工作，帮手带过来布局
                    convertView = mInflater.inflate(R.layout.item_layout_msg_other, null);
                    vh_msg_other = getOtherView(convertView);
                    break;
                default:
                    convertView = mInflater.inflate(R.layout.layout_null, null);
                    convertView.setTag(vh_msg_text);
                    break;
            }
        } else {
            switch (type) {
                case MessageType.MSG_TEXT_INT:
                case MessageType.MSG_MENBERJOIN_INT:
                case MessageType.MSG_VOICE_INT:
                case MessageType.MSG_PIC_INT:
                    vh_msg_text = (TextHolder) convertView.getTag();
                    break;
                case MessageType.MSG_OTHER_INT:
                    vh_msg_other = (MsgOtherHolder) convertView.getTag();
                    break;
                default:
                    vh_msg_text = (TextHolder) convertView.getTag();
                    break;
                case MessageType.MSG_SAFE_INT:
                case MessageType.MSG_NOTICE_INT:
                case MessageType.MSG_QUALITY_INT:
                case MessageType.MSG_LOG_INT:
                    //工作通知
                    vh_img_holder = (ImageHolder) convertView.getTag();
                    break;
            }
        }
        switch (type) {
            case MessageType.MSG_TEXT_INT:
                if (TextUtils.isEmpty(entity.getLocal_id()) || entity.getLocal_id().equals("null")) {
                    //设置左边内容
                    setTextLeft(vh_msg_text, entity, context, position);
                    toUserInfo(vh_msg_text.img_head_left, entity.getUid());
                    vh_msg_text.tv_text_left.setOnLongClickListener(new MessageAdapter.MessageOnLongClickListener(context, getListStr(entity, context), position));
                    if (null != msgHeadLongClickListener) {
                        onHeadLongCLickListener(vh_msg_text.img_head_left, entity);
                    }
                } else {
                    setTextRight(vh_msg_text, entity, context, position);
                    vh_msg_text.tv_text_right.setOnLongClickListener(new MessageOnLongClickListener(context, getListStr(entity, context), position));
                    vh_msg_text.img_sendfail.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            msgLongClickListener.MsgItemLongClickLisstener("重发", position);
                        }
                    });
                    vh_msg_text.tv_unread_right.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            startToReadInfoActivity(entity);
                        }
                    });
                    toUserInfo(vh_msg_text.img_head_right, entity.getUid());
                }
                break;
            case MessageType.MSG_PIC_INT:
                if (TextUtils.isEmpty(entity.getLocal_id()) || entity.getLocal_id().equals("null")) {
                    setPictureLeft(vh_msg_text, entity, context);
                    if (null != msgHeadLongClickListener) {
                        onHeadLongCLickListener(vh_msg_text.img_head_left, entity);
                    }
                    toUserInfo(vh_msg_text.img_head_left, entity.getUid());
                    final TextHolder finalVh_msg_text3 = vh_msg_text;
                    vh_msg_text.bimg_left.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            List<String> list = new ArrayList<>();
                            int index = 0;
                            for (int i = 0; i < data.size(); i++) {
                                if (data.get(i).getMsg_type_num() == MessageType.MSG_PIC_INT) {
                                    list.add(data.get(i).getMsg_src().get(0).toString());
                                    if (data.get(i).getMsg_src().get(0).toString().equals(entity.getMsg_src().get(0))) {
                                        index = list.size();
                                    }
                                }
                            }
                            showImageView(list, index, context);

                        }
                    });
                } else {
                    setPictureRight(vh_msg_text, entity, context);
                    vh_msg_text.bimg_right.setOnLongClickListener(new MessageAdapter.MessageOnLongClickListener(context, getListStr(entity, context), position));
//                    vh_msg_text.bimg_right.setPadding(0, 0, 0, 0);
                    setShowPicture(vh_msg_text, entity, context);
                    int under = entity.getUnread_user_num();
                    if (isSignChat) {
                        vh_msg_text.tv_unread_right.setVisibility(View.GONE);
                    } else {
                        vh_msg_text.tv_unread_right.setTextColor(context.getResources().getColor(R.color.color_628ae0));
                        if (under > 0) {
                            vh_msg_text.tv_unread_right.setVisibility(View.VISIBLE);
                            vh_msg_text.tv_unread_right.setText(context.getResources().getString(R.string.message_unread, under));
                        } else {
                            vh_msg_text.tv_unread_right.setVisibility(View.GONE);
                        }
                    }

                    vh_msg_text.img_sendfail.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            msgLongClickListener.MsgItemLongClickLisstener("重发", position);
                        }
                    });
                }
                vh_msg_text.tv_unread_right.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        startToReadInfoActivity(entity);
                    }
                });
                toUserInfo(vh_msg_text.img_head_right, entity.getUid());

                final TextHolder finalVh_msg_text4 = vh_msg_text;
                vh_msg_text.bimg_right.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        LUtils.e(new Gson().toJson(entity) + ",,,,,,,,,,,,,,,,,,");
                        List<String> list = new ArrayList<>();
                        int index = 0;
                        for (int i = 0; i < data.size(); i++) {
                            if (data.get(i).getMsg_type_num() == MessageType.MSG_PIC_INT) {
                                list.add(data.get(i).getMsg_src().get(0).toString());

                                if (data.get(i).getMsg_src().get(0).toString().equals(entity.getMsg_src().get(0))) {
                                    index = list.size();
                                }
                            }
                        }
                        showImageView(list, index, context);
                    }
                });
                break;

            case MessageType.MSG_VOICE_INT:
                if (TextUtils.isEmpty(entity.getLocal_id()) || entity.getLocal_id().equals("null")) {
                    setVoiceLeft(vh_msg_text, entity, context);
//                    playLeftVoice(vh_msg_text, entity, context);
                    final TextHolder finalVh_msg_text1 = vh_msg_text;
                    if (entity.isAutoPlay()) {
                        readlyPlayVoice(finalVh_msg_text1, position);
                    }
                    vh_msg_text.rea_voice_left.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            readlyPlayVoice(finalVh_msg_text1, position);


                        }
                    });
                    toUserInfo(vh_msg_text.img_head_left, entity.getUid(), context);
                    if (null != msgHeadLongClickListener) {
                        onHeadLongCLickListener(vh_msg_text.img_head_left, entity);
                    }
                } else {
                    setVoiceRight(vh_msg_text, entity, context);
                    //播放语音文件
                    final TextHolder finalVh_msg_text = vh_msg_text;
                    vh_msg_text.rea_voice_right.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            //播放语音文件
                            if (null == entity.getMsg_src() || entity.getMsg_src().size() == 0) {
                                CommonMethod.makeNoticeShort(context, "播放失败", CommonMethod.ERROR);
                                return;
                            }
                            if (null != entity.getMsg_src() && entity.getMsg_src().size() > 0) {
                                playVoice(position, finalVh_msg_text.voiceAnimationImage_right, R.drawable.message_voice_right_playing, R.drawable.icon_message_right_voice3, false);
                            } else {
                                CommonMethod.makeNoticeShort(context, "当前还没有语音信息", CommonMethod.ERROR);
                            }

                        }
                    });
                    toUserInfo(vh_msg_text.img_head_right, entity.getUid(), context);
                    vh_msg_text.rea_voice_right.setOnLongClickListener(new MessageOnLongClickListener(context, getListStr(entity, context), position));
                    vh_msg_text.img_sendfail.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            msgLongClickListener.MsgItemLongClickLisstener("重发", position);
                        }
                    });
                }
                break;

            case MessageType.MSG_MENBERJOIN_INT:
                vh_msg_text.tv_text_left.setText(entity.getMsg_text());
                break;
            case MessageType.MSG_OTHER_INT:
                setMessageOther(vh_msg_other, entity, context);
                break;
            case MessageType.MSG_SAFE_INT:
            case MessageType.MSG_QUALITY_INT:
            case MessageType.MSG_NOTICE_INT:
            case MessageType.MSG_LOG_INT:
                //左边
                setNoticeLeft(vh_img_holder, entity, context);
                if (TextUtils.isEmpty(entity.getLocal_id()) || entity.getLocal_id().equals("null")) {
                    if (null != msgHeadLongClickListener) {
                        onHeadLongCLickListener(vh_img_holder.img_head_left, entity);
                    }
                    toUserInfo(vh_img_holder.img_head_left, entity.getUid());
                    if (!TextUtils.isEmpty(gnInfo.getPro_name())) {
                        entity.setProName(gnInfo.getPro_name());
                        entity.setGroupName(gnInfo.getGroup_name());
                        vh_img_holder.rea_bg_left.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                startNotice(entity.getMsg_type_num(), entity);
                            }
                        });
                    }
                } else {
                    setNoticeRight(vh_img_holder, entity, context);
                    vh_img_holder.img_sendfail.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            msgLongClickListener.MsgItemLongClickLisstener("重发", position);
                        }
                    });
                    if (!TextUtils.isEmpty(gnInfo.getPro_name())) {
                        entity.setProName(gnInfo.getPro_name());
                        entity.setGroupName(gnInfo.getGroup_name());
                        vh_img_holder.rea_bg_right.setOnClickListener(new MessageOnClickListener(entity, context, gnInfo.getClass_type(), gnInfo.getIs_closed() == 1));
                        vh_img_holder.rea_bg_right.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                startNotice(entity.getMsg_type_num(), entity);
                            }
                        });
                    }
                    vh_img_holder.tv_unread_right.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            startToReadInfoActivity(entity);
                        }
                    });
                    toUserInfo(vh_img_holder.img_head_right, entity.getUid());
                }
                break;
        }
        setNoticeBg(type, entity, vh_img_holder, context);
        return convertView;
    }


    public void startNotice(int msg_type_num, MessageEntity entity) {
        switch (msg_type_num) {
            case MessageType.MSG_SAFE_INT:
            case MessageType.MSG_QUALITY_INT:
//                ActivityQualityAndSafeDetailActivity.actionStart((Activity) context, entity, gnInfo);
                break;
            case MessageType.MSG_LOG_INT:
                LogDetailActivity.actionStart((Activity) context, gnInfo, entity.getMsg_id() + "", "日志", true);
                break;
            case MessageType.MSG_NOTICE_INT:
                ActivityNoticeDetailActivity.actionStart(((BaseActivity) context), gnInfo, entity.getMsg_id());
                break;
        }
    }

    public void startActivity(MessageEntity finalEn) {
        ActivityNoticeDetailActivity.actionStart(((BaseActivity) context), gnInfo, finalEn.getMsg_id());
//        Intent intent = new Intent(context, ActivityNoticeDetailActivity.class);
//        LUtils.e("--------22----" + new Gson().toJson(gnInfo));
//        Bundle bundle = new Bundle();
//        bundle.putSerializable("msgEntity", finalEn);
//        bundle.putSerializable(Constance.BEAN_CONSTANCE, gnInfo);
//        if (!TextUtils.isEmpty(gnInfo.getIs_closed()) && gnInfo.getIs_closed().equals("1")) {
//            intent.putExtra(Constance.BEAN_BOOLEAN, true);
//        }
//        intent.putExtras(bundle);
//        ((Activity) context).startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 播放语音文件
     */
    private AnimationDrawable voiceAnimation;
    private ImageView teamImageView;
    private int tempDrawble2;

    /**
     * 播放语音
     *
     * @param voiceAnimationImage
     * @param drawble1
     * @param drawble2
     */
    public void playVoice(final int pos, final ImageView voiceAnimationImage, int drawble1, final int drawble2, final boolean isleftVoice) {
        String voicePath = NetWorkRequest.NETURL + data.get(pos).getMsg_src().get(0);
        if (voicePath != null) {

            //重置动画
            resetAnim();
            //重置数据状态
//            resetData();

            if (data.get(pos).isPlaying()) {
                LUtils.e("正在播放中" + pos);
                data.get(pos).setPlaying(false);
                MediaManager.release();//重置
            } else {
                LUtils.e("播放完毕");
                teamImageView = voiceAnimationImage;
                tempDrawble2 = drawble2;
                voiceAnimationImage.setImageResource(drawble1);
                voiceAnimation = (AnimationDrawable) voiceAnimationImage.getDrawable();
                voiceAnimation.start();
                //播放前重置。
                MediaManager.release();
                data.get(pos).setPlaying(true);
                MediaManager.playSound(voicePath,
                        new MediaPlayer.OnCompletionListener() {
                            @Override
                            public void onCompletion(MediaPlayer mp) {
                                data.get(pos).setPlaying(false);
                                voiceAnimationImage.setImageResource(drawble2);
                                voiceAnimation.stop();
                                if (isleftVoice) {
                                    msgHeadLongClickListener.playVoice(pos);
                                }
                            }
                        });
            }

        } else {
            CommonMethod.makeNoticeShort(context, "当前还没有语音信息", CommonMethod.ERROR);
        }
    }

    private void readlyPlayVoice(TextHolder finalVh_msg_text1, int position) {
        finalVh_msg_text1.red_circle.setVisibility(View.GONE);
        MessageEntity entity = data.get(position);
        MessageUtils.up_is_read_local(entity);
        uploadListener.UpVoiceRead(position);
        //播放语音文件
        if (null == entity || null == entity.getMsg_src() || entity.getMsg_src().size() == 0) {
            CommonMethod.makeNoticeShort(context, "播放失败", CommonMethod.ERROR);
            return;
        }
        //本地未读，需要改变本地未读状态 并且请求
        if (null == entity.getIs_readed() || entity.getIs_readed().equals("0")) {
            finalVh_msg_text1.red_circle.setVisibility(View.GONE);
            if (entity.getIs_readed().equals("0")) {
                updateReadInfo(entity.getMsg_id() + "");
            }

        }
        if (null != entity.getMsg_src() && entity.getMsg_src().size() > 0) {
            playVoice(position, finalVh_msg_text1.voiceAnimationImage_left, R.drawable.message_voice_left_playing, R.drawable.icon_message_left_voice3, true);
        } else {
            CommonMethod.makeNoticeShort(context, "当前还没有语音信息", CommonMethod.ERROR);
        }
    }

    protected void resetAnim() {
        if (voiceAnimation != null && voiceAnimation.isRunning()) {
            voiceAnimation.stop();
            if (null != teamImageView) {
                teamImageView.setImageResource(tempDrawble2);
            }
        }
//        resetData();
    }

    /**
     * 查看已读未读列表
     *
     * @param entity
     */
    private void startToReadInfoActivity(MessageEntity entity) {
        if (entity.getUnread_user_num() != 0) {
            Intent intent = new Intent(context, MessageReadInfoListActivity.class);
            intent.putExtra("group_id", entity.getGroup_id());
            intent.putExtra("msg_id", entity.getMsg_id() + "");
            intent.putExtra("class_type", entity.getClass_type());
            ((Activity) context).startActivityForResult(intent, Constance.REQUEST);
        }

    }

    /**
     * 更新消息已读未读
     */
    protected void updateReadInfo(String msgId) {
        WebSocket webSocket = SocketManager.getInstance(context.getApplicationContext()).getWebSocket();
        if (webSocket != null) {
            WebSocketMeassgeParameter msgParmeter = new WebSocketMeassgeParameter();
            msgParmeter.setAction(WebSocketConstance.MSGREAD);
            msgParmeter.setCtrl(WebSocketConstance.MESSAGE);
            msgParmeter.setMsg_id(msgId);
            webSocket.requestServerMessage(msgParmeter);
        }
    }

    /**
     * 长按或者点击事件
     */
    private void onHeadLongCLickListener(RoundeImageHashCodeTextLayout img_head_right, MessageEntity entity) {
        img_head_right.setOnLongClickListener(new MessageHeadOnLongClickListener(entity));

    }

    public class MessageHeadOnLongClickListener implements View.OnLongClickListener {
        private MessageEntity entity;

        public MessageHeadOnLongClickListener(MessageEntity entity) {
            this.entity = entity;
        }


        @Override
        public boolean onLongClick(View v) {
            msgHeadLongClickListener.MsgHeadLongClickLisstener(entity);

            return true;
        }
    }

    /**
     * 消息时间事件
     */
    private MsgItemLongClickDialog splitDiaLog;

    public class MessageOnLongClickListener implements View.OnLongClickListener {
        private Context context;
        private List<String> list;
        private int pos;

        public MessageOnLongClickListener(Context context, List<String> list, int pos) {
            this.list = list;
            this.context = context;
            this.pos = pos;
        }


        @Override
        public boolean onLongClick(View v) {
            if (null != splitDiaLog) {
                splitDiaLog.dismiss();
                splitDiaLog = null;
            }
            splitDiaLog = new MsgItemLongClickDialog(((BaseActivity) context), msgLongClickListener, list, pos);
            splitDiaLog.show();
            return false;
        }
    }

    /**
     * 查看个人资料
     */
    private void toUserInfo(View view, final String uid) {
        if (TextUtils.isEmpty(uid)) {
            return;
        }
        view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context, ChatUserInfoActivity.class);
                intent.putExtra(Constance.UID, uid);
                ((BaseActivity) context).startActivityForResult(intent, Constance.REQUESTCODE_SINGLECHAT);
            }
        });
    }


}
