package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.ViewGroup;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.util.NewMessageUtils;

import java.util.List;

public class ShakyMessageAdapter extends RecyclerView.Adapter<MessageRecycleViewHolder> {
    private LayoutInflater mInflater;
    private List<MessageBean> list;
    private Activity activity;

    public ShakyMessageAdapter(Activity activity, List<MessageBean> list) {
        mInflater = LayoutInflater.from(activity);
        this.activity = activity;
        this.list = list;
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
            case MessageType.MSG_ACTIVITY_INT:
                vh = new ViewHolderActivity(mInflater.inflate(R.layout.item_shaky, parent, false), activity);
                break;
            case MessageType.MSG_PRESENT_INT:
            case MessageType.LOCAL_GROUP_CHAT_INT:
            case MessageType.WORK_GROUP_CHAT_INT:
            case MessageType.MSG_POST_CENSO_INT:
                vh = new ViewHolderPatchIntegral(mInflater.inflate(R.layout.work_message_common_item, parent, false), activity);
               break;
            default:
                vh = new ViewHolderOther(mInflater.inflate(R.layout.item_layout_other, parent, false));
                break;
        }
        return vh;
    }

//    @Override
//    public void onBindViewHolder(ActivityRecycleViewHolder holder, int position) {
//
//    }

    @Override
    public void onBindViewHolder(MessageRecycleViewHolder holder, int position) {
        holder.bindHolder(position, list);
    }
}
