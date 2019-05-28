package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGridImageViewAdapter;
import com.jizhi.jlongg.groupimageviews.NineGridMsgImageView;
import com.jizhi.jlongg.main.activity.procloud.LoadCloudPicActivity;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.util.GlideUtils;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.network.NetWorkRequest;

import java.util.ArrayList;
import java.util.List;

public class ViewHolderNotice extends MessageRecycleViewHolder {
    //    private Activity activity;
    //左右左侧图标
    private ImageView img_icon_left, img_icon_right;
    //左右右侧图标
    private ImageView img_arrow_left, img_arrow_right;
    //左右左侧标题
    private TextView tv_title_top_left, tv_title_top_right;
    //左右右侧标题
    private TextView tv_hintcontent_left, tv_hintcontent_right;
    //左右九宫格图片
    private NineGridMsgImageView ngl_images_left, ngl_images_right;
    //左右内容背景
    private RelativeLayout rea_bg_left, rea_bg_right;

    public ViewHolderNotice(View itemView, Activity activity, boolean isSignChat, MessageBroadCastListener messageBroadCastListener) {
        super(itemView);
        this.activity = activity;
        this.isSignChat = isSignChat;
        this.messageBroadCastListener = messageBroadCastListener;
        //初始化相同的view
        initAlickItemView();
        //初始view
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
        //左右内容背景
        rea_bg_left = itemView.findViewById(R.id.rea_bg_left);
        rea_bg_right = itemView.findViewById(R.id.rea_bg_right);
        //左右内容
        tv_text_left = itemView.findViewById(R.id.tv_text_left);
        tv_text_right = itemView.findViewById(R.id.tv_text_right);
        //左右左侧图标
        img_icon_left = itemView.findViewById(R.id.img_icon_left);
        img_icon_right = itemView.findViewById(R.id.img_icon_right);
        //左右右侧图标
        img_arrow_left = itemView.findViewById(R.id.img_arrow_left);
        img_arrow_right = itemView.findViewById(R.id.img_arrow_right);
        //左右左侧标题
        tv_title_top_left = itemView.findViewById(R.id.tv_title_top_left);
        tv_title_top_right = itemView.findViewById(R.id.tv_title_top_right);
        //左右右侧标题
        tv_hintcontent_left = itemView.findViewById(R.id.tv_hintcontent_left);
        tv_hintcontent_right = itemView.findViewById(R.id.tv_hintcontent_right);
        //左右九宫格图片
        ngl_images_left = itemView.findViewById(R.id.ngl_images_left);
        ngl_images_right = itemView.findViewById(R.id.ngl_images_right);
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(MessageBean message) {
        //设置显示左边还是右边,相同部分
        setItemAlickData(message);
        setNoticeBg(message);
        if (!NewMessageUtils.isMySendMessage(message)) {
            //左边文字
            tv_text_left.setText(!TextUtils.isEmpty(message.getMsg_text()) ? message.getMsg_text() : "");
            tv_text_left.setVisibility((!TextUtils.isEmpty(message.getMsg_text()) ? View.VISIBLE : View.GONE));
            ngl_images_left.setAdapter(NoticePictureAdapter);
            ngl_images_left.setImagesData(message.getMsg_src());
            rea_bg_left.setOnClickListener(onClickListener);
        } else {
            //右边文字
            tv_text_right.setText(!TextUtils.isEmpty(message.getMsg_text()) ? message.getMsg_text() : "");
            tv_text_right.setVisibility((!TextUtils.isEmpty(message.getMsg_text()) ? View.VISIBLE : View.GONE));
            ngl_images_right.setAdapter(NoticePictureAdapter);
            ngl_images_right.setImagesData(message.getMsg_src());
            rea_bg_right.setOnClickListener(onClickListener);
        }
    }

    /**
     * 设置通知质量等背景
     *
     * @param message
     */
    public void setNoticeBg(MessageBean message) {
        switch (message.getMsg_type()) {
            case MessageType.MSG_SAFE_STRING:
                if (!NewMessageUtils.isMySendMessage(message)) {
                    Utils.setBackGround(rea_bg_left, activity.getResources().getDrawable(R.drawable.meassge_safety_left_bg_normal));
                    Utils.setBackGround(img_icon_left, activity.getResources().getDrawable(R.drawable.icon_safety));
                    tv_title_top_left.setText(activity.getResources().getString(R.string.messsage_safety));
                    tv_title_top_left.setTextColor(activity.getResources().getColor(R.color.color_864bc1));
                    Utils.setBackGround(img_arrow_left, activity.getResources().getDrawable(R.drawable.arrow_right_safe));
                    tv_hintcontent_left.setTextColor(activity.getResources().getColor(R.color.color_a779d5));
                } else {
                    Utils.setBackGround(rea_bg_right, activity.getResources().getDrawable(R.drawable.meassge_safety_right_bg_normal));
                    Utils.setBackGround(img_icon_right, activity.getResources().getDrawable(R.drawable.icon_safety));
                    tv_title_top_right.setText(activity.getResources().getString(R.string.messsage_safety));
                    tv_title_top_right.setTextColor(activity.getResources().getColor(R.color.color_864bc1));
                    Utils.setBackGround(img_arrow_right, activity.getResources().getDrawable(R.drawable.arrow_right_safe));
                    tv_hintcontent_right.setTextColor(activity.getResources().getColor(R.color.color_a779d5));
                }
                break;

            case MessageType.MSG_QUALITY_STRING:
                if (!NewMessageUtils.isMySendMessage(message)) {
                    Utils.setBackGround(rea_bg_left, activity.getResources().getDrawable(R.drawable.message_quality_bg_normal));
                    Utils.setBackGround(img_icon_left, activity.getResources().getDrawable(R.drawable.icon_quality));
                    tv_title_top_left.setText(activity.getResources().getString(R.string.messsage_quality));
                    tv_title_top_left.setTextColor(activity.getResources().getColor(R.color.color_72b8c4));
                    Utils.setBackGround(img_arrow_left, activity.getResources().getDrawable(R.drawable.arrow_right_quality));
                    tv_hintcontent_left.setTextColor(activity.getResources().getColor(R.color.color_74bed1));
                } else {
                    Utils.setBackGround(rea_bg_right, activity.getResources().getDrawable(R.drawable.message_quality_right_bg_normal));
                    Utils.setBackGround(img_icon_right, activity.getResources().getDrawable(R.drawable.icon_quality));
                    tv_title_top_right.setText(activity.getResources().getString(R.string.messsage_quality));
                    tv_title_top_right.setTextColor(activity.getResources().getColor(R.color.color_72b8c4));
                    Utils.setBackGround(img_arrow_right, activity.getResources().getDrawable(R.drawable.arrow_right_quality));
                    tv_hintcontent_right.setTextColor(activity.getResources().getColor(R.color.color_74bed1));
                }

                break;
            case MessageType.MSG_NOTICE_STRING:
                if (!NewMessageUtils.isMySendMessage(message)) {
                    Utils.setBackGround(rea_bg_left, activity.getResources().getDrawable(R.drawable.meassge_inform_left_bg_normal));
                    Utils.setBackGround(img_icon_left, activity.getResources().getDrawable(R.drawable.icon_forme));
                    tv_title_top_left.setText(activity.getResources().getString(R.string.messsage_work_inform));
                    tv_title_top_left.setTextColor(activity.getResources().getColor(R.color.color_4b70c1));
                    Utils.setBackGround(img_arrow_left, activity.getResources().getDrawable(R.drawable.arrow_right_notice));
                    tv_hintcontent_left.setTextColor(activity.getResources().getColor(R.color.color_628ae0));
                } else {
                    Utils.setBackGround(rea_bg_right, activity.getResources().getDrawable(R.drawable.meassge_inform_right_bg_normal));
                    Utils.setBackGround(img_icon_right, activity.getResources().getDrawable(R.drawable.icon_forme));
                    tv_title_top_right.setText(activity.getResources().getString(R.string.messsage_work_inform));
                    tv_title_top_right.setTextColor(activity.getResources().getColor(R.color.color_4b70c1));
                    Utils.setBackGround(img_arrow_right, activity.getResources().getDrawable(R.drawable.arrow_right_notice));
                    tv_hintcontent_right.setTextColor(activity.getResources().getColor(R.color.color_628ae0));
                }
                break;
            case MessageType.MSG_LOG_STRING:
                if (!NewMessageUtils.isMySendMessage(message)) {
                    Utils.setBackGround(rea_bg_left, activity.getResources().getDrawable(R.drawable.meassge_log_left_bg_normal));
                    Utils.setBackGround(img_icon_left, activity.getResources().getDrawable(R.drawable.icon_logs));
                    tv_title_top_left.setText(activity.getResources().getString(R.string.messsage_work_log));
                    tv_title_top_left.setTextColor(activity.getResources().getColor(R.color.color_5da659));
                    Utils.setBackGround(img_arrow_left, activity.getResources().getDrawable(R.drawable.arrow_right_log));
                    tv_hintcontent_left.setTextColor(activity.getResources().getColor(R.color.color_85bf82));

                } else {
                    Utils.setBackGround(rea_bg_right, activity.getResources().getDrawable(R.drawable.meassge_log_right_bg_normal));
                    Utils.setBackGround(img_icon_right, activity.getResources().getDrawable(R.drawable.icon_logs));
                    tv_title_top_right.setText(activity.getResources().getString(R.string.messsage_work_log));
                    tv_title_top_right.setTextColor(activity.getResources().getColor(R.color.color_5da659));
                    Utils.setBackGround(img_arrow_right, activity.getResources().getDrawable(R.drawable.arrow_right_log));
                    tv_hintcontent_right.setTextColor(activity.getResources().getColor(R.color.color_85bf82));
                }
                break;
        }

    }

    private NineGridImageViewAdapter<String> NoticePictureAdapter = new NineGridImageViewAdapter<String>() {
        @Override
        public void onDisplayImage(Context context, ImageView imageView, String s) {
            new GlideUtils().glideImage(context,NetWorkRequest.IP_ADDRESS + s,imageView);
//            Glide.with(context).load(NetWorkRequest.IP_ADDRESS + s).into(imageView);

        }

        @Override
        public ImageView generateImageView(Context context) {
            return super.generateImageView(context);
        }

        @Override
        public void onItemImageClick(Context context, int index, List<String> list, ImageView imageView) {
            ArrayList<String> arrayList = new ArrayList<>();
            for (int i = 0; i < list.size(); i++) {
                arrayList.add(NetWorkRequest.CDNURL + list.get(i));
            }
            LoadCloudPicActivity.actionStart((Activity) context, arrayList, index);
        }
    };
}
