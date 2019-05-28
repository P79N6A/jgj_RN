package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.ViewGroup;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;

import java.util.List;

public class NewMessageAdapter extends RecyclerView.Adapter<MessageRecycleViewHolder> {
    private LayoutInflater mInflater;
    //是否是单聊
    protected boolean isSignChat;
    private List<MessageBean> list;
    private Activity activity;
    private MessageBroadCastListener messageBroadCastListener;

    public NewMessageAdapter(Activity activity, GroupDiscussionInfo gnInfo, List<MessageBean> list, MessageBroadCastListener messageBroadCastListener) {
        mInflater = LayoutInflater.from(activity);
        this.activity = activity;
        this.list = list;
        this.messageBroadCastListener = messageBroadCastListener;
        isSignChat = gnInfo.getClass_type().equals(WebSocketConstance.SINGLECHAT) ? true : false;
    }

    //尝试解决头像闪烁问题
    //要注意，使用上述代码的话，Adapter中的getItemId要重写成如下，如果仍用super.getItemId(position)，数据刷新会出错
    @Override
    public long getItemId(int position) {
//        return super.getItemId(position);
        return position;
    }

    @Override
    public int getItemCount() {
        return list.size();
    }

    @Override
    public int getItemViewType(int position) {
        return NewMessageUtils.getmsg_type_number(list.get(position).getMsg_type());

    }

    @Override
    public MessageRecycleViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        MessageRecycleViewHolder vh;
        switch (viewType) {
            case MessageType.MSG_NEW_INT://以下为新消息的类型
                vh = new ViewHolderNull(mInflater.inflate(R.layout.item_new_msg_tips, parent, false));
                break;
            case MessageType.MSG_TEXT_INT:
                //文字消息
                vh = new ViewHolderText(mInflater.inflate(R.layout.item_msg_text_new, parent, false), activity, isSignChat, messageBroadCastListener);
                break;
            case MessageType.MSG_VOICE_INT:
                //语音消息
                vh = new ViewHolderVoice(mInflater.inflate(R.layout.item_msg_voice, parent, false), activity, isSignChat, messageBroadCastListener);
                break;
            case MessageType.MSG_PIC_INT:
                //图片消息
                vh = new ViewHolderPicture(mInflater.inflate(R.layout.item_msg_picture_new, parent, false), activity, isSignChat, messageBroadCastListener);
                break;
            case MessageType.ADD_GROUP_FRIEND_INT:
            case MessageType.MSG_RECALL_INT:
            case MessageType.MSG_SIGNIN_INT:
                //加入班组，撤回等消息
                vh = new ViewHolderHint(mInflater.inflate(R.layout.item_msg_center, parent, false));
                break;
            case MessageType.MSG_FINDWORK_INT:
                //找工作，招聘消息
                vh = new ViewHolderFindJob(mInflater.inflate(R.layout.item_layout_msg_other, parent, false), activity);
                break;
            case MessageType.MSG_SAFE_INT:
            case MessageType.MSG_QUALITY_INT:
            case MessageType.MSG_LOG_INT:
            case MessageType.MSG_NOTICE_INT:
                //质量，安全，通知，日志
                vh = new ViewHolderNotice(mInflater.inflate(R.layout.item_msg_pic_new, parent, false), activity, isSignChat, messageBroadCastListener);
                break;
            case MessageType.MSG_FINDWORK_TEMP_INT:
                //临时找工作信息
                vh = new ViewHolderWorkInfo(mInflater.inflate(R.layout.item_layout_no_auth, parent, false), activity, isSignChat, messageBroadCastListener);
                break;
            case MessageType.MSG_POSTCARD_INT:
                //名片
                vh = new ViewHolderVisitingCard(mInflater.inflate(R.layout.send_idcard_layout, parent, false), activity, isSignChat, messageBroadCastListener);
                break;
            case MessageType.RECTUITMENT_INT:
                //找工作信息
                vh = new ViewHolderFindWork(mInflater.inflate(R.layout.send_findjob_layout, parent, false), activity, isSignChat, messageBroadCastListener);
                break;
            case MessageType.MSG_AUTH_INT:
                // 认证消息
                vh = new ViewHolderAuth(mInflater.inflate(R.layout.item_msg_auther, parent, false), activity);
                break;

            case MessageType.MSG_LINK_INT:
                // 链接消息
                vh = new ViewHolderLink(mInflater.inflate(R.layout.send_link_msg_lauyout, parent, false), activity, isSignChat, messageBroadCastListener);
                break;
            default:
                vh = new ViewHolderHint(mInflater.inflate(R.layout.item_msg_center, parent, false));
                break;
        }
        return vh;
    }

    @Override
    public void onBindViewHolder(MessageRecycleViewHolder holder, int position) {
        holder.bindHolder(position, list);
    }
}
