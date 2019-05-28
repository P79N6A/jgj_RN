package com.jizhi.jlongg.main.adpter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.LogGroupBean;

import java.util.List;


/**
 * 功能: 选择质量，安全地址adapter
 * 作者：胡常生
 * 时间: 2017年5月27日 11:10:12
 */
public class SelectFilterLogTypelAdapter extends BaseAdapter {


    /* 添加工人列表数据 */
    private List<LogGroupBean> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 上下文 */
    private BaseActivity context;


    public SelectFilterLogTypelAdapter(BaseActivity context, List<LogGroupBean> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.context = context;
    }

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<LogGroupBean> list) {
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


    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_select_release_address, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    private void bindData(ViewHolder holder, final int position) {
        LogGroupBean bean = list.get(position);
        holder.name.setText(bean.getCat_name());
        if (position == list.size() - 1) {
            holder.background.setVisibility(View.GONE);
        } else {
            holder.background.setVisibility(View.VISIBLE);
        }
        if (bean.isChecked()) {
            holder.img_hook.setVisibility(View.VISIBLE);
        } else {
            holder.img_hook.setVisibility(View.GONE);
        }

    }


    class ViewHolder {
        /* 人物名称 */
        TextView name;
        ImageView img_hook;
        View background;

        public ViewHolder(View convertView) {
            name = (TextView) convertView.findViewById(R.id.name);
            img_hook = (ImageView) convertView.findViewById(R.id.img_hook);
            background = (View) convertView.findViewById(R.id.background);
        }
    }
}
