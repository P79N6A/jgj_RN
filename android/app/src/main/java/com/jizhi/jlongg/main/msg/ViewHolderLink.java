package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.RequestOptions;
import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.PersonWorkInfoBean;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import org.w3c.dom.Text;

import java.util.List;

/**
 * 链接
 */
public class ViewHolderLink extends MessageRecycleViewHolder {

    private TextView link_title, link_context, link_title_right, link_context_right;
    private ImageView link_pic, link_pic_right;
    private RelativeLayout send_left, send_right;

    public ViewHolderLink(View itemView, Activity activity, boolean isSignChat, MessageBroadCastListener messageBroadCastListener) {
        super(itemView);
        this.activity = activity;
        this.isSignChat = isSignChat;
        this.messageBroadCastListener = messageBroadCastListener;
        initAlickItemView();
        initItemView();
    }

    @Override
    public void bindHolder(int position, List<MessageBean> list) {
        this.position = position;
        setItemData(list.get(position));
    }


    private void initItemView() {
        link_title = itemView.findViewById(R.id.link_title);
        link_context = itemView.findViewById(R.id.link_context);
        link_title_right = itemView.findViewById(R.id.link_title_right);
        link_context_right = itemView.findViewById(R.id.link_context_right);
        link_pic = itemView.findViewById(R.id.link_pic);
        link_pic_right = itemView.findViewById(R.id.link_pic_right);
        send_left = itemView.findViewById(R.id.send_left);
        send_right = itemView.findViewById(R.id.send_right);
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(MessageBean message) {
        setItemAlickData(message);
        if (!TextUtils.isEmpty(message.getMsg_text_other())) {
            Share share = new Gson().fromJson(message.getMsg_text_other(), Share.class);
            if (!NewMessageUtils.isMySendMessage(message)) {
                //左边
                send_left.setOnLongClickListener(onLongClickListener);
                send_left.setOnClickListener(onClickListener);
                img_head_left.setOnClickListener(onClickListener);
                show(share, link_title, link_context, link_pic);
            } else {
                img_head_right.setOnClickListener(onClickListener);
                send_right.setOnLongClickListener(onLongClickListener);
                send_right.setOnClickListener(onClickListener);
                //右边
                show(share, link_title_right, link_context_right, link_pic_right);
            }
            (itemView.findViewById(R.id.img_sendfail)).setOnClickListener(onClickListener);
        }

    }

    private void show(Share share, TextView link_title, TextView link_context, ImageView link_pic) {
        if (NonEmpty(share.getTitle())) {
            link_title.setVisibility(View.VISIBLE);
            link_title.setText(share.getTitle());
        } else {
            link_title.setVisibility(View.GONE);
        }
        if (NonEmpty(share.getDescribe())) {
            link_context.setVisibility(View.VISIBLE);
            link_context.setText(share.getDescribe());
        } else {
            link_context.setVisibility(View.GONE);
        }
        if (NonEmpty(share.getImgUrl())) {
            Glide.with(activity).applyDefaultRequestOptions(new RequestOptions().error(R.drawable.link)).load(share.getImgUrl()).into(link_pic);
        } else {
            link_pic.setImageResource(R.drawable.link);
        }
    }

    private boolean NonEmpty(String s) {
        return !TextUtils.isEmpty(s);
    }
}
