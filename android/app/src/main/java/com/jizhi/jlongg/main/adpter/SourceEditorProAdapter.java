package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.listener.SourceMemberListener;

import java.util.List;

/**
 * 功能:数据来源人同步项目组编辑适配器
 * 时间:2016-11-10 11:31:12
 * 作者:xuj
 */
public class SourceEditorProAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<Project> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 点击删除按钮回调函数
     */
    private SourceMemberListener listener;


    public SourceEditorProAdapter(Context context, List<Project> list) {
        this.list = list;
        inflater = LayoutInflater.from(context);
    }

    public void updateList(List<Project> list) {
        this.list = list;
        notifyDataSetChanged();
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

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_source_editor_pro, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    public void bindData(final ViewHolder holder, final int position) {
        final Project bean = list.get(position);
        holder.proName.setText(bean.getPro_name());
        holder.title.setVisibility(position == 0 ? View.VISIBLE : View.GONE);
        holder.title.setText("以下是他同步给你且已关联的项目组:");
        holder.removeIcon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (listener != null) {
                    listener.removeSource(bean);
                }
            }
        });
    }


    public class ViewHolder {
        public ViewHolder(View view) {
            title = (TextView) view.findViewById(R.id.title);
            proName = (TextView) view.findViewById(R.id.proName);
            removeIcon = (ImageView) view.findViewById(R.id.removeIcon);
        }

        /* 同步标题只做第一条展示 */
        private TextView title;
        /* 项目组名称 */
        private TextView proName;
        /* 删除按钮 */
        private ImageView removeIcon;
    }

    public List<Project> getList() {
        return list;
    }

    public void setList(List<Project> list) {
        this.list = list;
    }

    public SourceMemberListener getListener() {
        return listener;
    }

    public void setListener(SourceMemberListener listener) {
        this.listener = listener;
    }
}
