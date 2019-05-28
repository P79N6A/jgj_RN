package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.graphics.drawable.AnimationDrawable;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.bumptech.glide.load.resource.bitmap.RoundedCorners;
import com.bumptech.glide.request.RequestOptions;
import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.GlideApp;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.network.NetWorkRequest;

import java.util.List;

public class ViewHolderPicture extends MessageRecycleViewHolder {
    //    private Activity activity;
    //左右图片
//    protected SWImageView bimg_left, bimg_right;
    protected ImageView bimg_left, bimg_right;
    private RelativeLayout layout_spnner;

    public ViewHolderPicture(View itemView, Activity activity, boolean isSignChat, MessageBroadCastListener messageBroadCastListener) {
        super(itemView);
        this.activity = activity;
        this.messageBroadCastListener = messageBroadCastListener;
        this.isSignChat = isSignChat;
        initAlickItemView();
        initItemView();
    }

    @Override
    public void bindHolder(int position, List<MessageBean> list) {
        this.position = position;
        setItemData(list.get(position));
    }

    /**
     * 获取itemView
     */
    public void initItemView() {
        //左右图片
        bimg_left = itemView.findViewById(R.id.bimg_left);
        bimg_right = itemView.findViewById(R.id.bimg_right);
        layout_spnner = itemView.findViewById(R.id.layout_spnner);
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(final MessageBean message) {

        setItemAlickData(message);
        if (!NewMessageUtils.isMySendMessage(message)) {
            showPicture(message, bimg_left);
            bimg_left.setOnLongClickListener(onLongClickListener);
            bimg_left.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (message.getMsg_state() == 0) {
                        messageBroadCastListener.onPictureClick(position);

                    }
                }
            });
        } else {
            showPicture(message, bimg_right);
            bimg_right.setOnLongClickListener(onLongClickListener);
            bimg_right.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (message.getMsg_state() == 0) {
                        messageBroadCastListener.onPictureClick(position);
                    }
                }
            });
        }
        img_sendfail.setOnClickListener(onClickListener);
        setMessageState(message);
    }

    /**
     * 设置消息状态
     *
     * @param message
     */
    public void setMessageState(MessageBean message) {

        if (message.getMsg_state() == 2 && message.getMsg_src().get(0).contains("/storage/")) {
            //正在发送
            layout_spnner.setVisibility(View.VISIBLE);
            img_sendfail.setVisibility(View.GONE);
            spinner.setBackgroundResource(R.drawable.load_spinner); //将动画资源文件设置为ImageView的背景
            AnimationDrawable anim = (AnimationDrawable) spinner.getBackground(); //获取ImageView背景,此时已被编译成AnimationDrawable
            if (!anim.isRunning()) {
                anim.start();  //开始动画
            }
        } else if (message.getMsg_state() == 0 || !message.getMsg_src().get(0).contains("/storage/")) {
            //发送成功
            layout_spnner.setVisibility(View.GONE);
            img_sendfail.setVisibility(View.GONE);
        } else if (message.getMsg_state() == 1) {
            //发送失败
            layout_spnner.setVisibility(View.GONE);
            img_sendfail.setVisibility(View.VISIBLE);
        }
    }

    /**
     * 显示图片
     */
    public void showPicture(final MessageBean message, final ImageView imageView) {
        if (null != message.getPic_w_h() && message.getPic_w_h().size() == 2) {
            //如果图片带来了宽高信息就设置宽高
            RelativeLayout.LayoutParams linearParams = (RelativeLayout.LayoutParams) imageView.getLayoutParams();
            int width = Integer.parseInt(message.getPic_w_h().get(0));
            int height = Integer.parseInt(message.getPic_w_h().get(1));
            List<String> msg_w_h = Utils.getImageWidthAndHeight(width, height);
            linearParams.width = Integer.parseInt(msg_w_h.get(0));
            linearParams.height = Integer.parseInt(msg_w_h.get(1));
            imageView.setLayoutParams(linearParams);

        }
        if (message.getMsg_src() != null && message.getMsg_src().size() > 0) {
            String picPath = (message.getMsg_src().get(0).contains("/storage/") ? "file://" : NetWorkRequest.NETURL) + message.getMsg_src().get(0);
            LUtils.e(position + "-----picPath------" + picPath);
            RequestOptions options = RequestOptions.bitmapTransform(new RoundedCorners(10));
            GlideApp.with(activity).load(picPath).apply(options)
                    .placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(imageView);
        }
    }
}
