package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.check.CheckHistoryActivity;
import com.jizhi.jlongg.main.activity.check.CheckResultActivity;
import com.jizhi.jlongg.main.activity.check.ReleaseRectificationNoticeActivity;
import com.jizhi.jlongg.main.activity.task.TaskDetailActivity;
import com.jizhi.jlongg.main.bean.CheckPlanListBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.dialog.DialogChangeCheckResult;
import com.jizhi.jlongg.main.dialog.DialogSelecteAddress;
import com.jizhi.jlongg.main.message.ActivityQualityAndSafeDetailActivity;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jongg.widget.WrapGridview;

import java.util.List;

import static com.jizhi.jlongg.R.id.lin_state;
import static com.jizhi.jlongg.R.id.lin_top;
import static com.jizhi.jlongg.R.id.tv_state;


/**
 * 其他聊天适配器
 */
public class CheckProjectAdapter extends BaseExpandableListAdapter {
    private List<CheckPlanListBean> list;
    private LayoutInflater inflater;
    private Context context;
    private CheckProjectItemClickListener checkProjectItemClickListener;
    private GroupDiscussionInfo gnInfo;
    private String plan_id;//检查计划id
    private String pro_id;//检查项id
    private String ed_text;//整改需要的文字

    public CheckProjectAdapter(Context context, List<CheckPlanListBean> list, GroupDiscussionInfo gnInfo, CheckProjectItemClickListener checkProjectItemClickListener, String plan_id, String pro_id) {
        this.context = context;
        this.list = list;
        this.gnInfo = gnInfo;
        this.plan_id = plan_id;
        this.pro_id = pro_id;
        this.checkProjectItemClickListener = checkProjectItemClickListener;
        inflater = LayoutInflater.from(context);
    }

    public void setEd_text(String ed_text) {
        this.ed_text = ed_text;
    }

    @Override
    public int getGroupCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return list.get(groupPosition).getDot_list().size();
    }


    @Override
    public Object getGroup(int groupPosition) {
        return list.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        return list.get(groupPosition).getDot_list().get(childPosition);
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
        CheckPlanListBean checkPlanListBean = list.get(groupPosition);
        if (convertView == null) {
            holder = new GroupHolder();
            convertView = inflater.inflate(R.layout.item_check_project_group, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.tv_state = (TextView) convertView.findViewById(tv_state);
            holder.img_arrow = (ImageView) convertView.findViewById(R.id.img_arrow);
            holder.line_10 = (View) convertView.findViewById(R.id.line_10);
            holder.line_1 = (View) convertView.findViewById(R.id.line_1);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        holder.tv_name.setText(checkPlanListBean.getContent_name());
        if (checkPlanListBean.getStatus() == 0) {
            //0：未检查
            holder.tv_state.setText("[未检查]");
            holder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
        } else if (checkPlanListBean.getStatus() == 1) {
            //1：待整改
            holder.tv_state.setText("[待整改]");
            holder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
        } else if (checkPlanListBean.getStatus() == 2) {
            // 2：不用检查
            holder.tv_state.setText("[不用检查]");
            holder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
        } else if (checkPlanListBean.getStatus() == 3) {
            //3：完成
            holder.tv_state.setText("[通过]");
            holder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_83c76e));
        } else {
            holder.tv_state.setText("");
            holder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
        }

        if (isExpanded) {
            Utils.setBackGround(holder.img_arrow, ContextCompat.getDrawable(context, R.drawable.icon_arrow_down));
            holder.line_10.setVisibility(View.GONE);
            holder.line_1.setVisibility(View.VISIBLE);
        } else {
            Utils.setBackGround(holder.img_arrow, ContextCompat.getDrawable(context, R.drawable.icon_arrow_up));
            holder.line_10.setVisibility(View.VISIBLE);
            holder.line_1.setVisibility(View.GONE);

        }
        return convertView;
    }

    @Override
    public View getChildView(final int groupPosition, final int childPosition,
                             boolean isLastChild, View convertView, ViewGroup parent) {
        final ChildHolder childHolder;
        final CheckPlanListBean checkPlanListBean = list.get(groupPosition).getDot_list().get(childPosition);
        if (convertView == null) {
            childHolder = new ChildHolder();
            convertView = inflater.inflate(R.layout.item_check_project_child, null);
            childHolder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            childHolder.tv_state = (TextView) convertView.findViewById(tv_state);
            childHolder.img_arrow = (ImageView) convertView.findViewById(R.id.img_arrow);
            childHolder.line_10 = (View) convertView.findViewById(R.id.line_10);
            childHolder.line_1 = (View) convertView.findViewById(R.id.line_1);
            childHolder.btn_check = (Button) convertView.findViewById(R.id.btn_check);
            childHolder.btn_rectification = (Button) convertView.findViewById(R.id.btn_rectification);
            childHolder.btn_pass = (Button) convertView.findViewById(R.id.btn_pass);
            childHolder.lin_state = (LinearLayout) convertView.findViewById(lin_state);
            childHolder.tv_detail = (TextView) convertView.findViewById(R.id.tv_detail);
            childHolder.rb_change_result = (RadioButton) convertView.findViewById(R.id.rb_change_result);
            childHolder.rb_check_history = (RadioButton) convertView.findViewById(R.id.rb_check_history);
            childHolder.rea_detail_changeresult_history = (RelativeLayout) convertView.findViewById(R.id.rea_detail_changeresult_history);
            childHolder.lin_top = (LinearLayout) convertView.findViewById(lin_top);
            childHolder.tv_content = (TextView) convertView.findViewById(R.id.tv_content);
            childHolder.ngl_images = (WrapGridview) convertView.findViewById(R.id.ngl_images);
            childHolder.rea_childview = (RelativeLayout) convertView.findViewById(R.id.rea_childview);
            convertView.setTag(childHolder);
        } else {
            childHolder = (ChildHolder) convertView.getTag();
        }
        childHolder.tv_name.setText(checkPlanListBean.getDot_name());
        if (checkPlanListBean.getStatus() == 0) {
            //0：未检查
            childHolder.tv_state.setText("[未检查]");
            childHolder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
        } else if (checkPlanListBean.getStatus() == 1) {
            //1：待整改
            childHolder.tv_state.setText("[待整改]");
            childHolder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
        } else if (checkPlanListBean.getStatus() == 2) {
            // 2：不用检查
            childHolder.tv_state.setText("[不用检查]");
            childHolder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
        } else if (checkPlanListBean.getStatus() == 3) {
            //3：通过
            childHolder.tv_state.setText("[通过]");
            childHolder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_83c76e));
        } else {
            childHolder.tv_state.setText("");
            childHolder.tv_state.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
        }
        if (null != checkPlanListBean.getDot_status_list() && checkPlanListBean.getDot_status_list().size() > 0) {
            if (!TextUtils.isEmpty(checkPlanListBean.getDot_status_list().get(0).getComment())) {
                childHolder.tv_content.setText(checkPlanListBean.getDot_status_list().get(0).getComment());
                childHolder.tv_content.setVisibility(View.VISIBLE);
            } else {
                childHolder.tv_content.setVisibility(View.GONE);
            }

            if (null != checkPlanListBean.getDot_status_list().get(0).getImgs() && checkPlanListBean.getDot_status_list().get(0).getImgs().size() > 0) {
                CheckHistoryImageAdapter squaredImageAdapter = new CheckHistoryImageAdapter(context, checkPlanListBean.getDot_status_list().get(0).getImgs());
                childHolder.ngl_images.setAdapter(squaredImageAdapter);
                childHolder.ngl_images.setVisibility(View.VISIBLE);
            } else {
                childHolder.ngl_images.setVisibility(View.GONE);
            }
        } else {
            childHolder.tv_content.setVisibility(View.GONE);
            childHolder.ngl_images.setVisibility(View.GONE);
        }

        if (checkPlanListBean.isChild_isExpanded()) {
            Utils.setBackGround(childHolder.img_arrow, ContextCompat.getDrawable(context, R.drawable.icon_arrow_down));
            childHolder.lin_top.setVisibility(View.VISIBLE);
            int is_operate = checkPlanListBean.getIs_operate();
            if (null != checkPlanListBean.getDot_status_list() && null != gnInfo && gnInfo.is_closed != 1) {
                if (checkPlanListBean.getStatus() == 0 && is_operate == 1) {
                    //1：未检查并且有权限 显示底部三个按钮
                    childHolder.lin_state.setVisibility(View.VISIBLE);
                    childHolder.lin_top.setVisibility(View.GONE);
                    childHolder.rea_detail_changeresult_history.setVisibility(View.GONE);
                } else if (checkPlanListBean.getStatus() == 0 && is_operate == 0) {
                    //1：未检查并且没有权限
                    childHolder.lin_state.setVisibility(View.GONE);
                    childHolder.lin_top.setVisibility(View.GONE);
                    childHolder.rea_detail_changeresult_history.setVisibility(View.GONE);
                } else if (checkPlanListBean.getStatus() == 1) {
                    //0：待整改 显示底部三个按钮
                    childHolder.rea_detail_changeresult_history.setVisibility(View.VISIBLE);
                    childHolder.lin_top.setVisibility(View.GONE);
                    childHolder.lin_state.setVisibility(View.GONE);
                    if (is_operate == 1) {
                        //有操作权限的人三个按钮都显示
                        childHolder.tv_detail.setVisibility(View.VISIBLE);
                        childHolder.rb_check_history.setVisibility(View.VISIBLE);
                        childHolder.rb_change_result.setVisibility(View.VISIBLE);
                    } else {
                        //没有操作权限的人只显示操作记录
                        childHolder.tv_detail.setVisibility(View.VISIBLE);
                        childHolder.rb_change_result.setVisibility(View.GONE);
                        childHolder.rb_check_history.setVisibility(View.VISIBLE);
                    }
                } else {
                    // 2：不用检查 3：通过
                    childHolder.rea_detail_changeresult_history.setVisibility(View.VISIBLE);
                    childHolder.lin_state.setVisibility(View.GONE);
                    if (is_operate == 1) {
                        //有操作权限的人三个按钮都显示
                        childHolder.tv_detail.setVisibility(View.GONE);
                        childHolder.rb_check_history.setVisibility(View.VISIBLE);
                        childHolder.rb_change_result.setVisibility(View.VISIBLE);
                    } else {
                        //没有操作权限的人只显示操作记录
                        childHolder.tv_detail.setVisibility(View.GONE);
                        childHolder.rb_change_result.setVisibility(View.GONE);
                        childHolder.rb_check_history.setVisibility(View.VISIBLE);
                    }
                    if (null != checkPlanListBean && null != checkPlanListBean.getDot_status_list() && checkPlanListBean.getDot_status_list().size() > 0
                            && null != checkPlanListBean.getDot_status_list().get(0).getImgs()
                            && (!TextUtils.isEmpty(checkPlanListBean.getDot_status_list().get(0).getComment()) || (!TextUtils.isEmpty(checkPlanListBean.getDot_status_list().get(0).getComment()) || checkPlanListBean.getDot_status_list().get(0).getImgs().size() > 0))) {
                        LUtils.e("----------显示顶部---------");
                        //有检查内容或者检查图片才显示检查结果布局
                        childHolder.lin_top.setVisibility(View.VISIBLE);
                    } else {
                        childHolder.lin_top.setVisibility(View.GONE);
                        LUtils.e("----------隐藏顶部----------");
                    }
                }
            }
        } else {
            Utils.setBackGround(childHolder.img_arrow, ContextCompat.getDrawable(context, R.drawable.icon_arrow_up));
            childHolder.lin_top.setVisibility(View.GONE);
            childHolder.rea_detail_changeresult_history.setVisibility(View.GONE);
            childHolder.lin_state.setVisibility(View.GONE);
        }

        if (list.get(groupPosition).getDot_list().size() == 0 || childPosition == list.get(groupPosition).getDot_list().size() - 1) {
            childHolder.line_10.setVisibility(View.VISIBLE);
            childHolder.line_1.setVisibility(View.GONE);
        } else {
            childHolder.line_10.setVisibility(View.GONE);
            childHolder.line_1.setVisibility(View.VISIBLE);

        }
        childHolder.rea_childview.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                checkProjectItemClickListener.childViewTopClick(groupPosition, childPosition);
            }
        });
        //处理通过跟不用检查和数据
        CheckPlanListBean bean = new CheckPlanListBean();
        bean.setPlan_id(plan_id);
        bean.setPro_id(pro_id);
        bean.setContent_id(list.get(groupPosition).getContent_id());
        bean.setDot_id(list.get(groupPosition).getDot_list().get(childPosition).getDot_id());

        setOnClickListener(childHolder.btn_check, bean, groupPosition, childPosition, checkPlanListBean.getStatus());
        setOnClickListener(childHolder.btn_pass, bean, groupPosition, childPosition, checkPlanListBean.getStatus());
        setOnClickListener(childHolder.btn_rectification, bean, groupPosition, childPosition, checkPlanListBean.getStatus());
        setOnClickListener(childHolder.tv_detail, bean, groupPosition, childPosition, checkPlanListBean.getStatus());
        setOnClickListener(childHolder.rb_change_result, bean, groupPosition, childPosition, checkPlanListBean.getStatus());
        setOnClickListener(childHolder.rb_check_history, bean, groupPosition, childPosition, checkPlanListBean.getStatus());
        return convertView;
    }

    public void setOnClickListener(View id, final CheckPlanListBean bean, final int group_positon, final int child_positon, final int status) {
        id.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                switch (v.getId()) {
                    case R.id.btn_check://不用检查
                        CheckResultActivity.actionStart((Activity) context, bean, 2, group_positon, child_positon);
                        break;
                    case R.id.btn_pass://通过
                        CheckResultActivity.actionStart((Activity) context, bean, 3, group_positon, child_positon);
                        break;
                    case R.id.btn_rectification://整改
                        ClickRectification();
                        break;
                    case R.id.tv_detail://查看问题详情
                        if (!TextUtils.isEmpty(list.get(group_positon).getDot_list().get(child_positon).getDot_status_list().get(0).getMsg_type())) {
                            if (list.get(group_positon).getDot_list().get(child_positon).getDot_status_list().get(0).getMsg_type().equals(MessageType.MSG_QUALITY_STRING) || list.get(group_positon).getDot_list().get(child_positon).getDot_status_list().get(0).getMsg_type().equals(MessageType.MSG_SAFE_STRING)) {
                                gnInfo.setClass_type(WebSocketConstance.TEAM);
                                gnInfo.setIs_closed(0);
                                MessageBean messageEntity = new MessageBean();
                                messageEntity.setMsg_id(list.get(group_positon).getDot_list().get(child_positon).getDot_status_list().get(0).getMsg_id());
                                messageEntity.setGroup_id(gnInfo.getGroup_id());
                                messageEntity.setClass_type(WebSocketConstance.TEAM);
                                messageEntity.setMsg_type((list.get(group_positon).getDot_list().get(child_positon).getDot_status_list().get(0).getMsg_type()));
                                ActivityQualityAndSafeDetailActivity.actionStart((Activity) context, messageEntity, gnInfo);
                            } else if ((list.get(group_positon).getDot_list().get(child_positon).getDot_status_list().get(0).getMsg_type().equals(MessageType.MSG_TASK_STRING))) {
                                TaskDetailActivity.actionStart((Activity) context, list.get(group_positon).getDot_list().get(child_positon).getDot_status_list().get(0).getMsg_id() + "", gnInfo.getGroup_id(), gnInfo.getGroup_name(), false);
                            }
                        }
                        break;
                    case R.id.rb_change_result://修改结果
                        DialogChangeCheckResult dialogChangeCheckResult = new DialogChangeCheckResult(context, status, new DialogSelecteAddress.TipsClickListener() {
                            @Override
                            public void clickConfirm(int position) {
                                //1:不用整改 2：通过 3：待整该
                                if (position == 1) {
                                    CheckResultActivity.actionStart((Activity) context, bean, 2, group_positon, child_positon);
                                } else if (position == 2) {
                                    CheckResultActivity.actionStart((Activity) context, bean, 3, group_positon, child_positon);
                                } else if (position == 3) {
                                    ClickRectification();
                                }
                            }
                        });
                        dialogChangeCheckResult.show();
                        break;
                    case R.id.rb_check_history://历史记录
                        CheckHistoryActivity.actionStart((Activity) context, bean);
                        break;
                }
            }

            private void ClickRectification() {
                if (TextUtils.isEmpty(ed_text)) {
                    ed_text = "";
                }
                LUtils.e("-----ed_text------------" + ed_text);
                String status_text = "";
                if (status == 0) {
                    //0：未检查
                    status_text = "未检查";
                } else if (status == 1) {
                    //1：待整改
                    status_text = "待整改";
                } else if (status == 2) {
                    // 2：不用检查
                    status_text = "不用检查";
                } else if (status == 3) {
                    //3：通过
                    status_text = "通过";
                } else {
                    status_text = "";
                }
                String text = ed_text + "检查内容：" + list.get(group_positon).getContent_name()
                        + "\n" + list.get(group_positon).getDot_list().get(child_positon).getDot_name()
                        + "   " + status_text + "\n";

                LUtils.e("-----text------------" + text);
                ReleaseRectificationNoticeActivity.actionStart((Activity) context, bean, gnInfo, group_positon, child_positon, text);
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
        View line_10;
        View line_1;
    }

    class ChildHolder {
        /* 日期 */
        TextView tv_name;
        TextView tv_state;
        ImageView img_arrow;
        View line_10;
        View line_1;
        Button btn_check;//不用检查
        Button btn_rectification;//待整改
        Button btn_pass;//通过
        LinearLayout lin_state;//无状态的时候  不用检查，待整改，通过布局
        TextView tv_detail;//查看详情
        RadioButton rb_change_result, rb_check_history;//查看详情检查记录
        RelativeLayout rea_detail_changeresult_history;//状态为整改的时候显示修改结果和查看详情
        LinearLayout lin_top;//顶部布局，内容图片等
        TextView tv_content;//内容
        WrapGridview ngl_images;//图片
        RelativeLayout rea_childview;//第二层顶部布局
    }

    public interface CheckProjectItemClickListener {
        void childViewTopClick(int group_position, int child_position);
    }
}
