package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.text.Html;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGridImageViewAdapter;
import com.jizhi.jlongg.groupimageviews.NineGridMsgImageView;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.dialog.DialogDelReply;
import com.jizhi.jlongg.main.message.MessageImagePagerActivity;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.GlideUtils;
import com.jizhi.jlongg.network.NetWorkRequest;

import java.util.List;


/**
 * 功能:同步账单适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class QuelityAndSafeDetailAdapter extends BaseAdapter {
    /* 列表数据 */
    private List<ReplyInfo> replyInfos;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 资源管理器 */
    private Resources res;
    private Context context;
    private ReplyContentClickListener replyContentClickListener;
    private DialogDelReply.DelSuccessClickListener delSuccessClickListener;
    private String msg_type;
    private int is_closed;

    public QuelityAndSafeDetailAdapter(Context context, String msg_type, List<ReplyInfo> replyInfos, ReplyContentClickListener replyContentClickListener, DialogDelReply.DelSuccessClickListener delSuccessClickListener,int is_closed) {
        super();
        this.replyInfos = replyInfos;
        inflater = LayoutInflater.from(context);
        this.context = context;
        this.msg_type = msg_type;
        res = context.getResources();
        this.replyContentClickListener = replyContentClickListener;
        this.delSuccessClickListener = delSuccessClickListener;
        this.is_closed=is_closed;
    }


    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<ReplyInfo> list) {
        this.replyInfos = list;
        notifyDataSetChanged();
    }


    @Override
    public int getCount() {
        return replyInfos == null ? 0 : replyInfos.size();
    }

    @Override
    public Object getItem(int position) {
        return replyInfos.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_detail_quality_and_safe, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, View convertView) {
        final ReplyInfo bean = replyInfos.get(position);
        if (bean.getIs_system_reply() == 1) {
            //系统回复内容
            holder.rea_content.setVisibility(View.GONE);
            holder.rea_system.setVisibility(View.VISIBLE);
            holder.tv_system_time.setText(bean.getCreate_time());
            holder.tv_system_name.setText(bean.getUser_info().getReal_name());
            holder.tv_system_content.setText(!TextUtils.isEmpty(bean.getReply_text()) ? bean.getReply_text() : "");
        } else {
            holder.rea_content.setVisibility(View.VISIBLE);
            holder.rea_system.setVisibility(View.GONE);
            holder.tv_name.setText(bean.getUser_info().getReal_name());
            holder.tv_time.setText(bean.getCreate_time());
            if (!TextUtils.isEmpty(bean.getReply_status_text())) {
                holder.tv_content.setText(bean.getReply_status_text());
                holder.tv_content.setVisibility(View.VISIBLE);
                DataUtil.setHtmlClick(holder.tv_content, context);
            } else {
                holder.tv_content.setVisibility(View.GONE);
            }
            if (!TextUtils.isEmpty(bean.getReply_text())) {
                holder.tv_content1.setText(bean.getReply_text());
                holder.tv_content1.setVisibility(View.VISIBLE);
                DataUtil.setHtmlClick(holder.tv_content1, context);
            } else {
                holder.tv_content1.setVisibility(View.GONE);
            }
            holder.tv_name.setTextColor(context.getResources().getColor(R.color.color_628ae0));
            holder.tv_name.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    toUserInfo(holder.tv_name, bean.getUser_info().getUid());
                }
            });
            if (null == bean.getMsg_src() || bean.getMsg_src().size() == 0) {
                holder.ngl_imagest.setVisibility(View.GONE);
            } else {
                holder.ngl_imagest.setVisibility(View.VISIBLE);
                holder.ngl_imagest.setAdapter(mAdapter);
                holder.ngl_imagest.setImagesData(bean.getMsg_src());
            }
            holder.rea_content.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (is_closed == 1) {
                        return;
                    }
                    if (bean.getOperate_delete() == 1) {
                        DialogDelReply dialogDelReply = new DialogDelReply((Activity) context, bean.getId() + "", msg_type, position, delSuccessClickListener);
                        dialogDelReply.showAtLocation(((Activity) context).findViewById(R.id.rootView), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);//这种方式无论有虚拟按键还是没有都可完全显示，因为它显示的在整个父布局中
                        BackGroundUtil.backgroundAlpha((Activity) context, 0.5f);
                    } else {
                        replyContentClickListener.replyContentClick(bean.getUser_info().getUid(), bean.getUser_info().getReal_name());
                    }


                }
            });
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

    class ViewHolder {
        public ViewHolder(View convertView) {
            tv_name = convertView.findViewById(R.id.tv_name);
            tv_time = convertView.findViewById(R.id.tv_time);
            line = convertView.findViewById(R.id.line);
            tv_content = convertView.findViewById(R.id.tv_content);
            tv_content1 = convertView.findViewById(R.id.tv_content1);
            ngl_imagest = convertView.findViewById(R.id.ngl_imagest);
            tv_system_name = convertView.findViewById(R.id.tv_system_name);
            rea_content = convertView.findViewById(R.id.rea_content);
            rea_system = convertView.findViewById(R.id.rea_system);
            tv_system_time = convertView.findViewById(R.id.tv_system_time);
            tv_system_content = convertView.findViewById(R.id.tv_system_content);

        }

        View line;
        /* 用户名称*/
        TextView tv_name;
        /* 时间 */
        TextView tv_time;
        /* 评论内容 */
        TextView tv_content;
        TextView tv_content1;
        /* 图片集 */
        NineGridMsgImageView ngl_imagest;

        /* 用户回复内容布局 */
        LinearLayout rea_content;
        /* 系统回复内容布局 */
        RelativeLayout rea_system;
        /* 系统回复名字 */
        TextView tv_system_name;
        /* 时间 */
        TextView tv_system_time;
        /* 时间 */
        TextView tv_system_content;
    }

    private NineGridImageViewAdapter<String> mAdapter = new NineGridImageViewAdapter<String>() {
        @Override
        public void onDisplayImage(Context context, ImageView imageView, String s) {
            new GlideUtils().glideImage(context, NetWorkRequest.IP_ADDRESS + s, imageView, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);
            LUtils.e(NetWorkRequest.IP_ADDRESS + s);

//            Glide.with(context).load(NetWorkRequest.IP_ADDRESS + s).placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(imageView);

        }


        @Override
        public void onItemImageClick(Context context, int index, List<String> list, ImageView imageView) {
            MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(imageView.getMeasuredWidth(), imageView.getMeasuredHeight());
            MessageImagePagerActivity.startImagePagerActivity((Activity) context, list, index, imageSize);
        }
    };

    public interface ReplyContentClickListener {
        public void replyContentClick(String uid, String name);
    }
}
