package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.FindPwdQuestion;

import java.util.List;


/**
 * 功能:找回密码 问题适配器
 * 时间:2018年6月11日17:01:38
 * 作者:xuj
 */
public class FindPwdQuestionAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<FindPwdQuestion> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 上下文
     */
    private Context context;
    /**
     * true表示是单选项
     */
    private boolean isSingleOption;
    /**
     * 选择选项回调
     */
    private SelecteQuestionCallBackListener listener;


    public FindPwdQuestionAdapter(Context context, List<FindPwdQuestion> list) {
        super();
        this.context = context;
        this.list = list;
        inflater = LayoutInflater.from(context);
    }

    public FindPwdQuestionAdapter(Context context, List<FindPwdQuestion> list, boolean isSingleOption, SelecteQuestionCallBackListener listener) {
        super();
        this.context = context;
        this.list = list;
        this.listener = listener;
        this.isSingleOption = isSingleOption;
        inflater = LayoutInflater.from(context);
    }

    public FindPwdQuestionAdapter(Context context, List<FindPwdQuestion> list, boolean isSingleOption) {
        super();
        this.context = context;
        this.list = list;
        this.isSingleOption = isSingleOption;
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

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.find_pwd_question_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, View convertView) {
        final FindPwdQuestion bean = list.get(position);
        holder.options.setText(bean.getOptions());
        if (bean.is_selected()) {
            holder.options.setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
            Utils.setBackGround(holder.itemLayout, context.getResources().getDrawable(R.drawable.draw_sk_eb4e4e_2radius));
            holder.selectedIcon.setImageResource(R.drawable.question_btn_pressed);
        } else {
            holder.options.setTextColor(ContextCompat.getColor(context, R.color.color_333333));
            Utils.setBackGround(holder.itemLayout, context.getResources().getDrawable(R.drawable.draw_sk_dbdbdb_2radius));
            holder.selectedIcon.setImageResource(R.drawable.question_btn_normal);
        }
        holder.itemLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isSingleOption) {
                    clearOptions();
                    if (listener != null) {
                        listener.callBack(bean);
                    }
                }
                bean.setIs_selected(!bean.is_selected());
                notifyDataSetChanged();
            }
        });
    }

    /**
     * 清空选择项
     */
    public void clearOptions() {
        if (getCount() == 0) return;
        for (FindPwdQuestion question : list) {
            if (question.is_selected()) {
                question.setIs_selected(false);
            }
        }
    }


    class ViewHolder {
        public ViewHolder(View convertView) {
            itemLayout = convertView.findViewById(R.id.itemLayout);
            options = (TextView) convertView.findViewById(R.id.options);
            selectedIcon = (ImageView) convertView.findViewById(R.id.selectedIcon);
        }

        /**
         *
         */
        View itemLayout;
        /**
         * 选项名称
         */
        TextView options;
        /**
         * 选项按钮
         */
        ImageView selectedIcon;
    }

    public boolean isSingleOption() {
        return isSingleOption;
    }

    public void setSingleOption(boolean singleOption) {
        isSingleOption = singleOption;
    }


    public interface SelecteQuestionCallBackListener {
        public void callBack(FindPwdQuestion question);
    }
}
