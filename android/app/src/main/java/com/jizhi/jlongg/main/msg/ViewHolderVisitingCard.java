package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.text.Html;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.PersonWorkInfoBean;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 名片信息
 */
public class ViewHolderVisitingCard extends MessageRecycleViewHolder {

    /**
     * 聊天消息在左边或右边
     */
    private RelativeLayout layout_left, layout_right;
    /**
     * 发消息的人头像
     */
    private RoundeImageHashCodeTextLayout img_head_left, img_head_right;

    /**
     * 消息内容名片中的头像
     */
    private RoundeImageHashCodeTextLayout img_head, img_head_context;

    /**
     * 名片中的人名
     */
    private TextView name, name_right;

    /**
     * 实名和认证
     */
    private ImageView auth_left, verify_left, auth_right, verify_right;

    /**
     * 名片描述信息，民族、工种、工作年限、队伍信息等
     */
    private TextView textOne, textTwo, textOne_right, textTwo_right;
    private RelativeLayout send_left, send_right;

    public ViewHolderVisitingCard(View itemView, Activity activity, boolean isSignChat, MessageBroadCastListener messageBroadCastListener) {
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
        layout_left = itemView.findViewById(R.id.layout_left);
        layout_right = itemView.findViewById(R.id.layout_right);
        img_head_left = itemView.findViewById(R.id.img_head_left);
        img_head_right = itemView.findViewById(R.id.img_head_right);
        img_head = itemView.findViewById(R.id.img_head);
        img_head_context = itemView.findViewById(R.id.img_head_context);
        name = itemView.findViewById(R.id.name);
        name_right = itemView.findViewById(R.id.name_right);
        auth_left = itemView.findViewById(R.id.auth_left);
        verify_left = itemView.findViewById(R.id.verify_left);
        auth_right = itemView.findViewById(R.id.auth_right);
        verify_right = itemView.findViewById(R.id.verify_right);
        textOne = itemView.findViewById(R.id.textOne);
        textOne = itemView.findViewById(R.id.textOne);
        textTwo = itemView.findViewById(R.id.textTwo);
        textTwo = itemView.findViewById(R.id.textTwo);
        textOne_right = itemView.findViewById(R.id.textOne_right);
        textTwo_right = itemView.findViewById(R.id.textTwo_right);
        send_left = itemView.findViewById(R.id.send_left);
        send_right = itemView.findViewById(R.id.send_right);
    }

    /**
     * 设置item显示数据
     */
    public void setItemData(MessageBean message) {
        setItemAlickData(message);
        if (!TextUtils.isEmpty(message.getMsg_text_other())) {
            PersonWorkInfoBean info = new Gson().fromJson(message.getMsg_text_other(), PersonWorkInfoBean.class);
            if (!NewMessageUtils.isMySendMessage(message)) {
                send_left.setOnLongClickListener(onLongClickListener);
                send_left.setOnClickListener(onClickListener);
                img_head_left.setOnClickListener(onClickListener);
                //左边消息
                showData(info, layout_left, layout_right, img_head_left, img_head, name, auth_left, verify_left, textOne, textTwo);

            } else {
                img_head_right.setOnClickListener(onClickListener);
                send_right.setOnLongClickListener(onLongClickListener);
                send_right.setOnClickListener(onClickListener);

                //右边消息
                showData(info, layout_right, layout_left, img_head_right, img_head_context, name_right, auth_right, verify_right, textOne_right, textTwo_right);
            }
            (itemView.findViewById(R.id.img_sendfail)).setOnClickListener(onClickListener);
        }

    }

    private boolean NonEmpty(String s) {
        return !TextUtils.isEmpty(s);
    }

    private void showData(PersonWorkInfoBean info, RelativeLayout layoutVisible, RelativeLayout layoutInVisible,
                          RoundeImageHashCodeTextLayout img_head_send_person, RoundeImageHashCodeTextLayout img_head,
                          TextView name, ImageView auth, ImageView verify, TextView textOne, TextView textTwo) {

        layoutVisible.setVisibility(View.VISIBLE);
        layoutInVisible.setVisibility(View.GONE);
        //img_head_send_person.setView(info.getHead_pic(), info.getReal_name(), 0);
        img_head.setView(info.getHead_pic(), info.getReal_name(), 0);
        name.setText(info.getReal_name());
        if (NonEmpty(info.getVerified()) &&
                Integer.parseInt(info.getVerified()) == 3) {
            auth.setVisibility(View.VISIBLE);
            Log.i("显示---", info.getVerified());
        } else {
            auth.setVisibility(View.INVISIBLE);
        }
        if ((NonEmpty(info.getGroup_verified()) &&
                Integer.parseInt(info.getGroup_verified()) == 1 ||
                NonEmpty(info.getPerson_verified()) &&
                        Integer.parseInt(info.getPerson_verified()) == 1)) {
            verify.setVisibility(View.VISIBLE);
        } else {
            verify.setVisibility(View.INVISIBLE);
        }
        //乌兹别克族 工龄 20 年 队伍 150 人
        String s = "";
        if (!TextUtils.isEmpty(info.getNationality()) && !info.getNationality().equals("族")) {
            s = "<font color='#666666'>" + info.getNationality() + "</font>";
        }
        if (!TextUtils.isEmpty(info.getWork_year()) && !info.getWork_year().equals("0")) {
            s = s + "&nbsp;<font color='#666666'>工龄&nbsp;</font><font color='#EB4E4E'>" + info.getWork_year() + "&nbsp;</font><font color='#666666'>年</font>";
        }
        if (!TextUtils.isEmpty(info.getScale()) && !info.getScale().equals("0")) {
            s = s + "&nbsp;<font color='#666666'>队伍&nbsp;</font>" + "<font color='#EB4E4E'>" + info.getScale() + "&nbsp;</font>" + "<font color='#666666'>人</font>";
        }
        if (!s.equals("")) {
            textOne.setVisibility(View.VISIBLE);
            textOne.setText(Html.fromHtml(s));
        } else {
            textOne.setVisibility(View.GONE);
        }
//                 textOne.setText(Html.fromHtml("<font color='#666666'>"+info.getNationality()+"</font>" +
//                         "&nbsp;<font color='#666666'>工龄&nbsp;</font><font color='#EB4E4E'>"+info.getWork_year()+"&nbsp;年</font>"
//                 +"&nbsp;<font color='#666666'>队伍&nbsp;</font>"+"<font color='#EB4E4E'>"+info.getScale()+"&nbsp;</font>"+"<font color='#666666'>人</font>"));


        //合并后的工种
        List<String> work_type = MessageUtils.getWork_type(info);
        StringBuffer buffer = new StringBuffer();
        if (null != work_type && !work_type.isEmpty()) {
            textTwo.setVisibility(View.VISIBLE);
            for (int i = 0; i < work_type.size(); i++) {
                buffer.append(work_type.get(i));
                if (i < work_type.size() - 1) {
                    buffer.append(" | ");
                }
            }
            textTwo.setText(buffer);
        } else {
            textTwo.setVisibility(View.GONE);
        }
    }
}
