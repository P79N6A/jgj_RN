package com.jizhi.jlongg.main.message;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.widget.ImageView;

import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGridImageViewAdapter;
import com.jizhi.jlongg.groupimageviews.NineGridMsgImageView;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.ChatMsgEntity;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.GlideUtils;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.makeramen.roundedimageview.RoundedImageView;

import java.util.List;

import static com.jizhi.jlongg.R.string.messsage_safety;


/**
 * 通知质量详情
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2016-11-25 下午2:41:57
 */

public class ActivityNoticeDetail extends BaseActivity {
    private ActivityNoticeDetail mActivity;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notice_detail);
        mActivity = ActivityNoticeDetail.this;
        ChatMsgEntity msgEntity = (ChatMsgEntity) getIntent().getSerializableExtra("msgEntity");
        if (null == msgEntity) {
            finish();
        }
        setData(msgEntity);

    }

    /**
     * 设置显示内容数据
     *
     * @param msgEntity
     */
    private void setData(ChatMsgEntity msgEntity) {


        RoundedImageView img_head = findViewById(R.id.img_head);
        new GlideUtils().glideImage(mActivity, NetWorkRequest.IP_ADDRESS + msgEntity.getHead_pic(), img_head, R.drawable.friend_head, R.drawable.friend_head);
//        Picasso.with(mActivity).load(NetWorkRequest.IP_ADDRESS + msgEntity.getHead_pic()).placeholder(R.drawable.friend_head).error(R.drawable.friend_head).into(img_head);
        SetTitleName.setTitle(findViewById(R.id.tv_name), msgEntity.getUser_name());
        SetTitleName.setTitle(findViewById(R.id.tv_proName), "来自" + msgEntity.getGroupName() + "  " + msgEntity.getProName());
//        LUtils.e(msgEntity.getProName() + ",," + msgEntity.getGroupName() + "--------------------------" + new Gson().toJson(msgEntity));
        SetTitleName.setTitle(findViewById(R.id.tv_date), TimesUtils.getMessageTime(msgEntity.getDate()));
        SetTitleName.setTitle(findViewById(R.id.tv_content), msgEntity.getMsg_text());
        if (msgEntity.getMsg_type().equals(MessageType.MSG_SAFE_STRING)) {
            SetTitleName.setTitle(findViewById(R.id.title), getString(messsage_safety) + "详情");
            SetTitleName.setTitle(findViewById(R.id.tv_title), getString(R.string.messsage_safety));
        } else if (msgEntity.getMsg_type().equals(MessageType.MSG_QUALITY_STRING)) {
            SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.messsage_quality) + "详情");
            SetTitleName.setTitle(findViewById(R.id.tv_title), getString(R.string.messsage_quality));
        } else if (msgEntity.getMsg_type().equals(MessageType.MSG_NOTICE_STRING)) {
            SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.messsage_work_inform) + "详情");
            SetTitleName.setTitle(findViewById(R.id.tv_title), getString(R.string.messsage_work_inform));
        } else if (msgEntity.getMsg_type().equals(MessageType.MSG_LOG_STRING)) {
            SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.messsage_work_log) + "详情");
            SetTitleName.setTitle(findViewById(R.id.tv_title), getString(R.string.messsage_work_log));
        }
        NineGridMsgImageView ngl_images = (NineGridMsgImageView) findViewById(R.id.ngl_images);
        ngl_images.setAdapter(mAdapter);
        ngl_images.setImagesData(msgEntity.getMsg_src());
    }

    /**
     * 图片适配器
     */
    private NineGridImageViewAdapter<String> mAdapter = new NineGridImageViewAdapter<String>() {
        @Override
        public void onDisplayImage(Context context, ImageView imageView, String s) {
//            Picasso.with(context)
//                    .load(NetWorkRequest.IP_ADDRESS + "" + s)
//                    .placeholder(R.drawable.icon_message_fail_default)
//                    .into(imageView);
            new GlideUtils().glideImage(mActivity, NetWorkRequest.IP_ADDRESS + s, imageView, R.drawable.friend_head, R.drawable.friend_head);

        }


        @Override
        public void onItemImageClick(Context context, int index, List<String> list, ImageView imageView) {
            MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(imageView.getMeasuredWidth(), imageView.getMeasuredHeight());
            MessageImagePagerActivity.startImagePagerActivity((Activity) context, list, index, imageSize);
        }
    };


}
