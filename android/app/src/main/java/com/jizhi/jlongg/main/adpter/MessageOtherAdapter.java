package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.ChatMsgEntity;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.message.ActivityNoticeDetailActivity;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jongg.widget.HorizotalImageLayout;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;


/**
 * 其他聊天适配器
 */
public class MessageOtherAdapter extends BaseExpandableListAdapter {
    private List<MessageEntity> listMsg;
    private LayoutInflater inflater;
    private Context context;
    private String proName;
    private String groupName;
    private String classType;
    private GroupDiscussionInfo gnInfo;

    public MessageOtherAdapter(Context context, List<MessageEntity> listMsg, GroupDiscussionInfo gnInfo) {
        this.context = context;
        inflater = LayoutInflater.from(context);
        this.listMsg = listMsg;
        this.gnInfo = gnInfo;
    }

    public MessageOtherAdapter(Context context, List<MessageEntity> listMsg, String proName, String groupName, String classType) {
        this.context = context;
        inflater = LayoutInflater.from(context);
        this.listMsg = listMsg;
        this.proName = proName;
        this.groupName = groupName;
        this.classType = classType;
    }

    @Override
    public int getGroupCount() {
        return listMsg == null ? 0 : listMsg.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return listMsg.get(groupPosition).getList().size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return listMsg.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        return listMsg.get(groupPosition).getList().get(childPosition);
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return childPosition;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        final GroupHolder holder;
        if (convertView == null) {
            holder = new GroupHolder();
            convertView = inflater.inflate(R.layout.item_message_other_group, null);
            holder.tv_date = (TextView) convertView.findViewById(R.id.tv_date);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        holder.tv_date.setText(listMsg.get(groupPosition).getFmt_date());
        return convertView;
    }

    @Override
    public View getChildView(final int groupPosition, final int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
        final ChildHolder childHolder;
        final ChatMsgEntity msgEntity = listMsg.get(groupPosition).getList().get(childPosition);
        if (convertView == null) {
            childHolder = new ChildHolder();
            convertView = inflater.inflate(R.layout.item_message_other_child, null);
            childHolder.img_head = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.img_head);
            childHolder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            childHolder.tv_date = (TextView) convertView.findViewById(R.id.tv_date);
            childHolder.tv_content = (TextView) convertView.findViewById(R.id.tv_content);
            childHolder.ngl_images = (HorizotalImageLayout) convertView.findViewById(R.id.ngl_images);
            convertView.setTag(childHolder);
        } else {
            childHolder = (ChildHolder) convertView.getTag();
        }
        childHolder.img_head.setView(msgEntity.getHead_pic(), msgEntity.getUser_name(), 0);
        childHolder.tv_name.setText(NameUtil.setName(msgEntity.getUser_name()));
        childHolder.tv_date.setText(msgEntity.getSend_time());
        msgEntity.setMsg_type_num(listMsg.get(groupPosition).getMsg_type_num());
        MessageEntity en = null;
        if (!TextUtils.isEmpty(gnInfo.getPro_name())) {
            msgEntity.setProName(gnInfo.getPro_name());
            msgEntity.setGroupName(gnInfo.getGroup_name());
            en = new MessageEntity();
            en.setClass_type(msgEntity.getClass_type());
            en.setDate(msgEntity.getDate());
            en.setFrom_group_name(msgEntity.getFrom_group_name());
            en.setGroup_id(msgEntity.getGroup_id());
            en.setHead_pic(msgEntity.getHead_pic());
            en.setMsg_src(msgEntity.getMsg_src());
            en.setMsg_text(msgEntity.getMsg_text());
            en.setMsg_type(msgEntity.getMsg_type());
            en.setMsg_type_num(msgEntity.getMsg_type_num());
            en.setUid(msgEntity.getUid());
            en.setUser_name(msgEntity.getUser_name());
            en.setMsg_id(Integer.parseInt(msgEntity.getMsg_id()));
            if (null != msgEntity.getMsg_type() && msgEntity.getMsg_type().equals(MessageType.MSG_LOG_STRING)) {
                en.setTechno_quali_log(msgEntity.getTechno_quali_log());
                en.setWeat_am(msgEntity.getWeat_am());
                en.setWeat_pm(msgEntity.getWeat_pm());
                en.setWind_am(msgEntity.getWind_am());
                en.setWind_pm(msgEntity.getWind_pm());
                en.setTemp_am(msgEntity.getTemp_am());
                en.setTemp_pm(msgEntity.getTemp_pm());
            }
        }
        if (!TextUtils.isEmpty(msgEntity.getMsg_text())) {
            childHolder.tv_content.setVisibility(View.VISIBLE);
            childHolder.tv_content.setText(msgEntity.getMsg_text());
        } else {
            childHolder.tv_content.setVisibility(View.GONE);
        }
        if (msgEntity.getMsg_src().size() == 0) {
            childHolder.ngl_images.setVisibility(View.GONE);
            childHolder.tv_content.setMaxLines(2);
        } else {
            childHolder.tv_content.setMaxLines(2);
            childHolder.ngl_images.setVisibility(View.VISIBLE);
            childHolder.ngl_images.createImages(msgEntity.getMsg_src(), DensityUtils.dp2px(context, 20));

        }
        final MessageEntity finalEn = en;
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ActivityNoticeDetailActivity.actionStart(((Activity) context), gnInfo, finalEn.getMsg_id() );
            }
        });
        return convertView;
    }

    public void startActivity(MessageEntity finalEn) {
        ActivityNoticeDetailActivity.actionStart(((Activity) context), gnInfo, finalEn.getMsg_id() );
//        Intent intent = new Intent(context, ActivityNoticeDetailActivity.class);
//        LUtils.e("--------22----" + new Gson().toJson(gnInfo));
//        Bundle bundle = new Bundle();
//        bundle.putSerializable("msgEntity", finalEn);
//        bundle.putSerializable(Constance.BEAN_CONSTANCE, gnInfo);
//        intent.putExtra("isExample", ((Activity) context).getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false));
//        if (!TextUtils.isEmpty(gnInfo.getIs_closed()) && gnInfo.getIs_closed().equals("1")) {
//            intent.putExtra(Constance.BEAN_BOOLEAN, true);
//        }
//        intent.putExtras(bundle);
//        ((Activity) context).startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return false;
    }


    class GroupHolder {
        /* 日期 */
        TextView tv_date;
    }

    class ChildHolder {
        RoundeImageHashCodeTextLayout img_head;
        TextView tv_name;
        TextView tv_date;
        TextView tv_content;
        HorizotalImageLayout ngl_images;
        LinearLayout lin;
    }
}
