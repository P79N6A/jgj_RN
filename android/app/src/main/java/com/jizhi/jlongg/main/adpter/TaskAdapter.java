package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.hcs.uclient.utils.StrUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.task.TaskDetailActivity;
import com.jizhi.jlongg.main.bean.TaskDetail;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jongg.widget.HorizotalImageLayout;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * Created by Administrator on 2017/7/22 0022.
 */

public class TaskAdapter extends BaseAdapter {
    /**
     * 上下文
     */
    private Activity activity;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 列表数据
     */
    private List<TaskDetail> list;
    /**
     * 是否关闭
     */
    private boolean isClosed;
    private String group_id;

    public TaskAdapter(Activity context, List<TaskDetail> list, boolean isClosed, String group_id) {
        this.list = list;
        this.isClosed = isClosed;
        this.activity = context;
        this.group_id = group_id;
        inflater = LayoutInflater.from(context);
    }


    public int getCount() {
        return list == null ? 0 : list.size();
    }

    public Object getItem(int position) {
        return list.get(position);
    }

    public long getItemId(int position) {
        return position;
    }

    public View getView(final int position, View convertView, ViewGroup arg2) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.task_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(position, convertView, holder);
        return convertView;
    }

    private void bindData(final int position, View convertView, ViewHolder holder) {
        final TaskDetail bean = list.get(position);
        holder.publishUserIcon.setView(bean.getPub_user_info().getHead_pic(), bean.getPub_user_info().getReal_name(), position);
        holder.publishUserName.setText(NameUtil.setName(bean.getPub_user_info().getReal_name()));
        holder.publishTime.setText(bean.getCreate_time());
        holder.principalUserInfo.setVisibility(TextUtils.isEmpty(bean.getPrincipal_user_info().getReal_name()) ? View.GONE : View.VISIBLE);
        if (!TextUtils.isEmpty(bean.getTask_content())) { //任务内容不为空
            holder.taskContent.setVisibility(View.VISIBLE);
            holder.taskContent.setText(StrUtil.ToDBC(StrUtil.StringFilter(bean.getTask_content())));
        } else {
            holder.taskContent.setVisibility(View.GONE);
        }
        if (bean.getMsg_src() != null && bean.getMsg_src().size() > 0) { //显示任务的图片
            holder.taskImageLayout.setVisibility(View.VISIBLE);
            holder.taskImageLayout.createImages(bean.getMsg_src());
        } else {
            holder.taskImageLayout.setVisibility(View.GONE);
        }
        if (bean.getTask_status() == 1) { //已完成
            convertView.setAlpha(0.5F);
            holder.principalUserInfo.setText("由 " + NameUtil.setName(bean.getPrincipal_user_info().getReal_name()) + " 负责");
            holder.completeTimeLayout.setVisibility(View.GONE);

        } else { //未处理
            convertView.setAlpha(1.0F);
            holder.principalUserInfo.setText(Html.fromHtml("<font color='#666666'>由</font><font color='#628ae0'> "
                    + NameUtil.setName(bean.getPrincipal_user_info().getReal_name()) + " </font><font color='#666666'>负责</font>"));

            if (bean.getTask_level() == 1 && TextUtils.isEmpty(bean.getTask_finish_time())) { //如果完成期限的时间为空并且任务级别为1 则隐藏完成期限
                holder.completeTimeLayout.setVisibility(View.GONE);
            } else {
                holder.completeTimeLayout.setVisibility(View.VISIBLE);
                switch (bean.getTask_level()) { // 任务级别(1:一般；2：紧急；3：非常紧急)
                    case TaskDetail.COMMONLY:
                        holder.taskLevel.setText("");
                        break;
                    case TaskDetail.URGENT:
                        holder.taskLevel.setText("[紧急]");
                        holder.taskLevel.setTextColor(ContextCompat.getColor(activity, R.color.color_f9a00f));
                        break;
                    case TaskDetail.VERY_URGENT:
                        holder.taskLevel.setText("[非常紧急]");
                        holder.taskLevel.setTextColor(ContextCompat.getColor(activity, R.color.color_eb4e4e));
                        break;
                }
                switch (bean.getTask_finish_time_type()) { //0 没有截止时间 1 任务已过期 2 临近过期 3 有截止时间
                    case 0:
                        holder.completeTime.setTextColor(ContextCompat.getColor(activity, R.color.color_999999));
                        break;
                    case 1:
                        holder.completeTime.setTextColor(ContextCompat.getColor(activity, R.color.color_eb4e4e));
                        break;
                    case 2:
                        holder.completeTime.setTextColor(ContextCompat.getColor(activity, R.color.color_f9a00f));
                        break;
                    case 3:
                        holder.completeTime.setTextColor(ContextCompat.getColor(activity, R.color.color_83c76e));
                        break;
                }
                holder.completeTime.setText(!TextUtils.isEmpty(bean.getTask_finish_time()) ? "完成期限: " + bean.getTask_finish_time() : "");
            }
        }
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                TaskDetailActivity.actionStart(activity, bean.getTask_id(), group_id, activity.getIntent().getStringExtra(Constance.GROUP_NAME), isClosed);
            }
        });
    }

    class ViewHolder {

        public ViewHolder(View convertView) {
            publishUserIcon = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.publishUserIcon);
            publishUserName = (TextView) convertView.findViewById(R.id.publishUserName);
            publishTime = (TextView) convertView.findViewById(R.id.publishTime);
            principalUserInfo = (TextView) convertView.findViewById(R.id.principalUserInfo);
            completeTime = (TextView) convertView.findViewById(R.id.completeTime);
            taskContent = (TextView) convertView.findViewById(R.id.taskContent);
            taskLevel = (TextView) convertView.findViewById(R.id.taskLevel);
            completeTimeLayout = convertView.findViewById(R.id.completeTimeLayout);
            taskImageLayout = (HorizotalImageLayout) convertView.findViewById(R.id.taskImagesLayout);
        }

        /**
         * 发布者头像
         */
        RoundeImageHashCodeTextLayout publishUserIcon;
        /**
         * 发布者名称
         */
        TextView publishUserName;
        /**
         * 发布时间
         */
        TextView publishTime;
        /**
         * 负责人信息
         */
        TextView principalUserInfo;
        /**
         * 任务内容
         */
        TextView taskContent;
        /**
         * 整改时间
         */
        TextView completeTime;
        /**
         * 任务级别
         */
        TextView taskLevel;
        /**
         * 完成期限布局
         */
        View completeTimeLayout;
        /**
         * 任务图片
         */
        HorizotalImageLayout taskImageLayout;
    }

    public void updateList(List<TaskDetail> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addList(List<TaskDetail> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }

    public List<TaskDetail> getList() {
        return list;
    }

    public void setList(List<TaskDetail> list) {
        this.list = list;
    }
}
