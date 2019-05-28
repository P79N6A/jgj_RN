package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.os.Build;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseExpandableListAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.ReleaseQualityAndSafeActivity;
import com.jizhi.jlongg.main.activity.qualityandsafe.QualityAndSafeResultActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.QualityAndsafeCheckMsgBean;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.message.ActivityQualityAndSafeDetailActivity;
import com.jizhi.jlongg.main.message.MessageImagePagerActivity;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jongg.widget.WrapGridview;

import java.util.List;


/**
 * 其他聊天适配器
 */
public class MsgQualityAndSafeCheckDetailsAdapter extends BaseExpandableListAdapter {
    private List<QualityAndsafeCheckMsgBean> list;
    private LayoutInflater inflater;
    private Context context;
    private String inspect_name, pu_inpsid, pro_name;
    private DelReplayInspectInfoListener delReplayInspectInfoListener;


    public MsgQualityAndSafeCheckDetailsAdapter(Context context, List<QualityAndsafeCheckMsgBean> list, DelReplayInspectInfoListener delReplayInspectInfoListener, String pu_inpsid, String pro_name) {
        this.context = context;
        this.list = list;
        this.pu_inpsid = pu_inpsid;
        this.delReplayInspectInfoListener = delReplayInspectInfoListener;
        this.pro_name = pro_name;
        inflater = LayoutInflater.from(context);
    }

    public String getInspect_name() {
        return inspect_name;
    }

    public void setInspect_name(String inspect_name) {
        this.inspect_name = inspect_name;
    }

    @Override
    public int getGroupCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return list.get(groupPosition).getReply_list().size();
    }


    @Override
    public Object getGroup(int groupPosition) {
        return list.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        return list.get(groupPosition).getReply_list().get(childPosition);
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

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        final GroupHolder holder;
        QualityAndsafeCheckMsgBean bean = list.get(groupPosition);
        if (convertView == null) {
            holder = new GroupHolder();
            convertView = inflater.inflate(R.layout.item_message_quality_and_safe_check_detail_group, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.tv_state = (TextView) convertView.findViewById(R.id.tv_state);
            holder.img_arrow = (ImageView) convertView.findViewById(R.id.img_arrow);
            holder.line = (View) convertView.findViewById(R.id.itemDiver);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        holder.tv_name.setText(bean.getText());
        if (bean.getStatu() == 1) {
            holder.tv_state.setText("[整改]");
            holder.tv_state.setTextColor(context.getResources().getColor(R.color.app_color));
            holder.tv_state.setVisibility(View.VISIBLE);
        } else if (bean.getStatu() == 2) {
            holder.tv_state.setText("[未涉及]");
            holder.tv_state.setTextColor(context.getResources().getColor(R.color.color_333333));
            holder.tv_state.setVisibility(View.VISIBLE);
        } else if (bean.getStatu() == 3) {
            holder.tv_state.setText("[通过]");
            holder.tv_state.setTextColor(context.getResources().getColor(R.color.color_83c76e));
            holder.tv_state.setVisibility(View.VISIBLE);
        } else {
            holder.tv_state.setText("");
            holder.tv_state.setVisibility(View.GONE);
        }
        if (isExpanded) {
            Utils.setBackGround(holder.img_arrow, context.getDrawable(R.drawable.icon_arrow_up));
            //子类不为空并且uid不为空或者状态为初始化
            if (bean.getReply_list().size() > 0 && (TextUtils.isEmpty(bean.getReply_list().get(0).getUid()) || list.get(groupPosition).getReply_list().get(0).getStatu() != 0)) {
                holder.line.setVisibility(View.GONE);
            } else {
                holder.line.setVisibility(View.VISIBLE);
            }

        } else {
            Utils.setBackGround(holder.img_arrow, context.getDrawable(R.drawable.icon_arrow_down));
            holder.line.setVisibility(View.VISIBLE);

        }
        return convertView;
    }


    @Override
    public View getChildView(final int groupPosition, final int childPosition,
                             boolean isLastChild, View convertView, ViewGroup parent) {
        final ChildHolder childHolder;
        final ReplyInfo replyInfo = list.get(groupPosition).getReply_list().get(childPosition);
        if (convertView == null) {

            childHolder = new ChildHolder();
            convertView = inflater.inflate(R.layout.item_message_quality_and_safe_check_detail_child, null);
            childHolder.lin_state_not = (LinearLayout) convertView.findViewById(R.id.lin_state_not);
            childHolder.rea_question_and_delete = (RelativeLayout) convertView.findViewById(R.id.rea_question_and_delete);
            childHolder.btn_involved = (Button) convertView.findViewById(R.id.btn_involved);
            childHolder.btn_rectification = (Button) convertView.findViewById(R.id.btn_rectification);
            childHolder.btn_pass = (Button) convertView.findViewById(R.id.btn_pass);
            childHolder.lin_del = (LinearLayout) convertView.findViewById(R.id.lin_del);
            childHolder.tv_content = (TextView) convertView.findViewById(R.id.tv_content);
            childHolder.tv_detail = (TextView) convertView.findViewById(R.id.tv_detail);
            childHolder.ngl_images = (WrapGridview) convertView.findViewById(R.id.ngl_images);
            convertView.setTag(childHolder);
        } else {
            childHolder = (ChildHolder) convertView.getTag();
        }

//            LinearLayout lin_state_not;//无状态的时候  未涉及整改通过
//            RelativeLayout rea_question_and_delete;//状态为整改的时候显示删除结果和查看详情

        // 0：未处理 1整改 2未涉及  3通过
        if (replyInfo.getStatu() == 0) {
            childHolder.lin_state_not.setVisibility(View.VISIBLE);
            childHolder.rea_question_and_delete.setVisibility(View.GONE);

        } else if (replyInfo.getStatu() == 1) {
            childHolder.rea_question_and_delete.setVisibility(View.VISIBLE);
            childHolder.lin_state_not.setVisibility(View.GONE);
            // 删除检查结果：仅限检查执行人操作
            if (list.get(groupPosition).getPrincipal_uid().equals(UclientApplication.getUid(context))) {
                childHolder.lin_del.setVisibility(View.VISIBLE);
            } else {
                childHolder.lin_del.setVisibility(View.GONE);
            }
            childHolder.tv_detail.setVisibility(View.VISIBLE);
        } else {
            childHolder.rea_question_and_delete.setVisibility(View.GONE);
            childHolder.lin_state_not.setVisibility(View.GONE);
            // 删除检查结果：仅限检查执行人操作
            if (list.get(groupPosition).getPrincipal_uid().equals(UclientApplication.getUid(context))) {
                childHolder.rea_question_and_delete.setVisibility(View.VISIBLE);
                childHolder.lin_del.setVisibility(View.VISIBLE);
                childHolder.tv_detail.setVisibility(View.GONE);
            } else {
                childHolder.lin_del.setVisibility(View.GONE);
            }
        }
        if (!TextUtils.isEmpty(replyInfo.getText())) {
            childHolder.tv_content.setText(replyInfo.getText());
            childHolder.tv_content.setVisibility(View.VISIBLE);
        } else {
            childHolder.tv_content.setVisibility(View.GONE);
        }

        if (null != replyInfo.getMsg_src() && replyInfo.getMsg_src().size() > 0) {
            ShowSquaredImageAdapter squaredImageAdapter = new ShowSquaredImageAdapter(context, replyInfo.getMsg_src());
            childHolder.ngl_images.setAdapter(squaredImageAdapter);
            childHolder.ngl_images.setVisibility(View.VISIBLE);
        } else {
            childHolder.ngl_images.setVisibility(View.GONE);
        }

        setOnClickListener(childHolder.btn_involved, groupPosition);
        setOnClickListener(childHolder.btn_rectification, groupPosition);
        setOnClickListener(childHolder.btn_pass, groupPosition);
        setOnClickListener(childHolder.lin_del, groupPosition);
        setOnClickListener(childHolder.tv_detail, groupPosition);

        childHolder.ngl_images.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                //imagesize是作为loading时的图片size
                MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(childHolder.ngl_images.getMeasuredWidth(), childHolder.ngl_images.getMeasuredHeight());
                MessageImagePagerActivity.startImagePagerActivity((Activity) context, replyInfo.getMsg_src(), position, imageSize);
            }
        });
        return convertView;
    }

    public void setOnClickListener(View id, final int position) {
        id.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                switch (v.getId()) {
                    case R.id.btn_involved://未涉及
                        QualityAndSafeResultActivity.actionStart((Activity) context, list.get(position), "1", position);
                        break;
                    case R.id.btn_rectification://整改
                        GroupDiscussionInfo gnInfo = new GroupDiscussionInfo();
                        gnInfo.setClass_type(list.get(position).getClass_type());
                        gnInfo.setGroup_id(list.get(position).getGroup_id());
//                        gnInfo.setInsp_id(list.get(position).getInsp_id());
                        gnInfo.setAll_pro_name(pro_name);
//                        gnInfo.setPu_inpsid(pu_inpsid);
                        String text = "检查大项:" + getInspect_name() + "\n" + "检查分项:" + list.get(position).getText() + "\n" + "检查结果:未通过";
                        ReleaseQualityAndSafeActivity.actionStarts((Activity) context, gnInfo, list.get(position).getMsg_type(), text, position);
                        break;
                    case R.id.btn_pass://通过
                        QualityAndSafeResultActivity.actionStart((Activity) context, list.get(position), "2", position);
                        break;
                    case R.id.lin_del://删除结果
                        delReplayInspectInfoListener.delReplayInspectInfoClick(position);
                        break;
                    case R.id.tv_detail://查看问题详情
                        if (null != list.get(position).getReply_list() && list.get(position).getReply_list().size() > 0) {
                            gnInfo = new GroupDiscussionInfo();
                            gnInfo.setClass_type(list.get(position).getClass_type());
                            gnInfo.setGroup_id(list.get(position).getGroup_id());
                            gnInfo.setIs_closed(0);
                            MessageBean messageEntity = new MessageBean();
                            messageEntity.setMsg_id(Integer.parseInt(list.get(position).getReply_list().get(0).getQuality_id()));
                            messageEntity.setGroup_id(list.get(position).getGroup_id());
                            messageEntity.setClass_type(WebSocketConstance.TEAM);
                            messageEntity.setMsg_type(list.get(position).getMsg_type());
                            ActivityQualityAndSafeDetailActivity.actionStart((Activity) context, messageEntity, gnInfo);
                        }
                        break;
                    case R.id.lin_top:
                        break;
                }
            }
        });
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return false;
    }


    class GroupHolder {
        /* 日期 */
        TextView tv_name;
        TextView tv_state;
        ImageView img_arrow;
        View line;
    }

    class ChildHolder {
        LinearLayout lin_state_not;//无状态的时候  未涉及整改通过
        RelativeLayout rea_question_and_delete;//状态为整改的时候显示删除结果和查看详情
        Button btn_involved;//未涉及
        Button btn_rectification;//整改
        Button btn_pass;//通过
        LinearLayout lin_del;//删除结果
        TextView tv_content;
        TextView tv_detail;
        WrapGridview ngl_images;
    }

    public interface DelReplayInspectInfoListener {
        public void delReplayInspectInfoClick(int position);
    }
}
