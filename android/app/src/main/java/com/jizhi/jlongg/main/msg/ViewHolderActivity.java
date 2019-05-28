package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.graphics.Color;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.application.GlideApp;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.custom.CornerTransform;
import com.jizhi.jlongg.network.NetWorkRequest;

import java.util.List;

public class ViewHolderActivity extends MessageRecycleViewHolder {
    private List<MessageBean> list;


    public ViewHolderActivity(View itemView, Activity activity) {
        super(itemView);
        this.activity = activity;
        initItemView();
    }

    @Override
    public void bindHolder(int position, List<MessageBean> list) {
        this.list = list;
        this.position = position;
        setItemData(list.get(position));
    }

    /**
     * 获取itemView
     */
    public void initItemView() {
        //左右内容
//        tv_text_left =itemView.findViewById(R.id.tv_text_left);
//        tv_text_right =  itemView.findViewById(R.id.tv_text_right);
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(final MessageBean message) {
        LUtils.e("----------活动消息-----------------" + message.getMsg_type());

        CornerTransform transformation = new CornerTransform(activity, DensityUtils.dp2px(activity, 5));
        ImageView img_pic = itemView.findViewById(R.id.img_pic);
        ((TextView) itemView.findViewById(R.id.tv_time)).setText(Utils.simpleMessageForDate(message.getSend_time()));
        if (!TextUtils.isEmpty(message.getTitle())) {
            ((TextView) itemView.findViewById(R.id.tv_content1)).setText(message.getTitle());
            ((TextView) itemView.findViewById(R.id.tv_content1)).setShadowLayer(5F, 5F, 5F, Color.BLACK);
        }
        if (!TextUtils.isEmpty(message.getDetail())) {
            ((TextView) itemView.findViewById(R.id.tv_content2)).setText(message.getDetail());
            itemView.findViewById(R.id.tv_content2).setVisibility(View.VISIBLE);
        } else {
            itemView.findViewById(R.id.tv_content2).setVisibility(View.GONE);
        }
        //只是绘制左上角和右上角圆角
        transformation.setExceptCorner(false, false, true, true);
        GlideApp.with(activity).
                asBitmap().
                load(null != message.getMsg_src() && message.getMsg_src().size() > 0 ? NetWorkRequest.NETURL + message.getMsg_src().get(0) : "http://pic22.nipic.com/20120727/9880981_174825125145_2.jpg").
                skipMemoryCache(true).
                diskCacheStrategy(DiskCacheStrategy.NONE)
                .placeholder(R.drawable.video_default_icon).error(R.drawable.video_default_icon).
                transform(transformation).into(img_pic);
        itemView.findViewById(R.id.layout_shaky).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (!TextUtils.isEmpty(message.getUrl())) {
                    if (message.getUrl().contains("http") || message.getUrl().contains("https")) {
                        X5WebViewActivity.actionStart(activity, message.getUrl(), true);
                    } else {
                        X5WebViewActivity.actionStart(activity, NetWorkRequest.WEBURLS + message.getUrl(), true);
                    }
                }
            }
        });
        itemView.findViewById(R.id.bottom_line).setVisibility(position == list.size() - 1 ? View.VISIBLE : View.GONE);

    }
}
