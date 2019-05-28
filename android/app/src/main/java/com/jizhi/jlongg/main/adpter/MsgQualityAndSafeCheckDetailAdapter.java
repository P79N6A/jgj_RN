package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.os.Build;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.ReleaseQualityAndSafeActivity;
import com.jizhi.jlongg.main.activity.qualityandsafe.QualityAndSafeResultActivity;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.QualityAndsafeCheckMsgBean;
import com.jizhi.jlongg.main.message.ActivityQualityAndSafeDetailActivity;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jongg.widget.WrapGridview;

import java.util.List;

import static com.jizhi.jlongg.R.id.tv_state;


/**
 * CName:质量，安全检查列表页单个大项详情页Adapter 2.3.0
 * User: hcs
 * Date: 2017-07-18
 * Time: 15:32
 */

public class MsgQualityAndSafeCheckDetailAdapter extends BaseAdapter {
    private List<QualityAndsafeCheckMsgBean> list;
    private LayoutInflater inflater;
    private Context context;
    private String inspect_name;
    private int position = -1;

    public String getInspect_name() {
        return inspect_name;
    }

    public void setInspect_name(String inspect_name) {
        this.inspect_name = inspect_name;
    }

    public MsgQualityAndSafeCheckDetailAdapter(Context context, List<QualityAndsafeCheckMsgBean> list) {
        this.context = context;
        this.list = list;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public Object getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @SuppressWarnings("deprecation")
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        final QualityAndsafeCheckMsgBean msgEntity = list.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_message_quality_and_safe_check_detail, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.tv_state = (TextView) convertView.findViewById(tv_state);
            holder.img_arrow = (ImageView) convertView.findViewById(R.id.img_arrow);
            holder.lin_btn = (RelativeLayout) convertView.findViewById(R.id.lin_btn);
            holder.btn_involved = (Button) convertView.findViewById(R.id.btn_involved);
            holder.btn_rectification = (Button) convertView.findViewById(R.id.btn_rectification);
            holder.btn_pass = (Button) convertView.findViewById(R.id.btn_pass);
            holder.lin_del = (LinearLayout) convertView.findViewById(R.id.lin_del);
            holder.lin_top = (LinearLayout) convertView.findViewById(R.id.lin_top);
            holder.tv_content = (TextView) convertView.findViewById(R.id.tv_content);
            holder.tv_detail = (TextView) convertView.findViewById(R.id.tv_detail);
            holder.ngl_images = (WrapGridview) convertView.findViewById(R.id.ngl_images);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(msgEntity.getText());
        if (null != msgEntity.getReply_list() && msgEntity.getReply_list().size() > 0) {
            if (!TextUtils.isEmpty(msgEntity.getReply_list().get(0).getText())) {
                holder.tv_content.setText(msgEntity.getReply_list().get(0).getText());
                holder.tv_content.setVisibility(View.VISIBLE);
            } else {
                holder.tv_content.setVisibility(View.GONE);
            }

            if (null != msgEntity.getReply_list().get(0).getMsg_src() && msgEntity.getReply_list().get(0).getMsg_src().size() > 0) {
                ShowSquaredImageAdapter squaredImageAdapter = new ShowSquaredImageAdapter(context, msgEntity.getReply_list().get(0).getMsg_src());
                holder.ngl_images.setAdapter(squaredImageAdapter);
                holder.ngl_images.setVisibility(View.VISIBLE);
            } else {
                holder.ngl_images.setVisibility(View.GONE);
            }
            // 0：未处理 1整改 2未涉及  3通过
            if (msgEntity.getReply_list().get(0).getStatu() == 0) {
                holder.btn_involved.setVisibility(View.VISIBLE);
                holder.btn_rectification.setVisibility(View.VISIBLE);
                holder.btn_pass.setVisibility(View.VISIBLE);
                holder.lin_del.setVisibility(View.GONE);
                holder.tv_state.setText("");
            } else {
                holder.btn_involved.setVisibility(View.GONE);
                holder.btn_rectification.setVisibility(View.GONE);
                holder.btn_pass.setVisibility(View.GONE);
                holder.lin_del.setVisibility(View.VISIBLE);
                if (msgEntity.getReply_list().get(0).getStatu() == 1) {
                    holder.tv_state.setText("[整改]");
                    holder.tv_state.setTextColor(context.getResources().getColor(R.color.app_color));
                    holder.tv_detail.setVisibility(View.VISIBLE);
                } else if (msgEntity.getReply_list().get(0).getStatu() == 2) {
                    holder.tv_state.setText("[未涉及]");
                    holder.tv_state.setTextColor(context.getResources().getColor(R.color.color_333333));
                    holder.tv_detail.setVisibility(View.GONE);
                } else if (msgEntity.getReply_list().get(0).getStatu() == 3) {
                    holder.tv_state.setText("[通过]");
                    holder.tv_state.setTextColor(context.getResources().getColor(R.color.color_83c76e));
                    holder.tv_detail.setVisibility(View.GONE);
                }
            }
        }
        setOnClickListener(holder.btn_involved, position);
        setOnClickListener(holder.btn_rectification, position);
        setOnClickListener(holder.btn_pass, position);
        setOnClickListener(holder.lin_del, position);
        setOnClickListener(holder.tv_detail, position);
        setOnClickListener(holder.lin_top, position);
        if (msgEntity.isExpand()) {
            holder.lin_btn.setVisibility(View.VISIBLE);
            Utils.setBackGround(holder.img_arrow, context.getDrawable(R.drawable.icon_arrow_up));
        } else {
            holder.lin_btn.setVisibility(View.GONE);
            Utils.setBackGround(holder.img_arrow, context.getDrawable(R.drawable.icon_arrow_down));
        }
        return convertView;
    }

    class ViewHolder {
        TextView tv_name;
        TextView tv_state;
        ImageView img_arrow;
        RelativeLayout lin_btn;//按钮布局
        Button btn_involved;//未涉及
        Button btn_rectification;//整改
        Button btn_pass;//通过
        LinearLayout lin_del;//删除结果
        LinearLayout lin_top;//删除结果
        TextView tv_content;
        TextView tv_detail;
        WrapGridview ngl_images;
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
                        String text = "检查大项:" + getInspect_name() + "\n" + "检查小项:" + list.get(position).getText() + "\n" + "检查结果：未通过";
                        ReleaseQualityAndSafeActivity.actionStart((Activity) context, gnInfo, list.get(position).getMsg_type(), text);
                        break;
                    case R.id.btn_pass://通过
                        QualityAndSafeResultActivity.actionStart((Activity) context, list.get(position), "2", position);
                        break;
                    case R.id.lin_del://删除结果
                        CommonMethod.makeNoticeLong(context, "删除结果:" + position, CommonMethod.SUCCESS);
                        break;
                    case R.id.tv_detail://查看问题详情
                        CommonMethod.makeNoticeLong(context, "查看问题详情:" + position, CommonMethod.SUCCESS);
                        gnInfo = new GroupDiscussionInfo();
                        gnInfo.setClass_type(list.get(position).getClass_type());
                        gnInfo.setGroup_id(list.get(position).getGroup_id());
                        gnInfo.setIs_closed(0);
                        MessageBean messageEntity = new MessageBean();
                        messageEntity.setMsg_id(99);
                        messageEntity.setGroup_id(list.get(position).getGroup_id());
                        ActivityQualityAndSafeDetailActivity.actionStart((Activity) context, messageEntity, gnInfo);
                        break;
                    case R.id.lin_top:
                        if (list.get(position).isExpand()) {
                            list.get(position).setExpand(false);
                            notifyDataSetChanged();
                            return;
                        }
                        for (int i = 0; i < list.size(); i++) {
                            if (i == position) {
                                list.get(i).setExpand(true);
                            } else {
                                list.get(i).setExpand(false);
                            }
                        }
                        notifyDataSetChanged();
                        break;
                }
            }
        });
    }

}
