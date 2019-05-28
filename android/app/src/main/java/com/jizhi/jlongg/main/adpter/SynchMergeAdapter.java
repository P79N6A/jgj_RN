package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.os.Build;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.SynchMerge;

import java.util.List;

/**
 * 功能:同步项目 适配器
 * 时间:2016-6-1 10:39
 * 作者:xuj
 */
public class SynchMergeAdapter extends BaseAdapter {


    private List<SynchMerge> list;
    /* xml解析器 */
    private LayoutInflater inflater;


    public SynchMergeAdapter(Activity context, List<SynchMerge> list) {
        this.list = list;
        inflater = LayoutInflater.from(context);
    }

    public void updateList(List<SynchMerge> list) {
        this.list = list;
        notifyDataSetChanged();
    }


    @Override
    public int getCount() {
//        return list == null ? 0 : list.size() > 2 ? 2 : list.size();
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
            convertView = inflater.inflate(R.layout.item_synch_merge, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    public void bindData(final ViewHolder holder, final int position) {
        final SynchMerge bean = list.get(position);
        StringBuilder builder = new StringBuilder();
        builder.append("<font color='#333333'>" + bean.getFrom_pro_name() + "</font><font color='#999999'>&nbsp;下&nbsp;</font>");
        builder.append("<font color='#333333'>" + bean.getFrom_team_name() + "</font>" + "<font color='#999999'>&nbsp;将会合并到你的&nbsp;</font>");
        builder.append("<font color='#333333'>" + bean.getTo_pro_name() + "</font>" + "<font color='#999999'>&nbsp;中</font>");
        holder.text.setText(Html.fromHtml(builder.toString()));
        holder.line.setVisibility(position == list.size() - 1 ? View.GONE : View.VISIBLE);
    }


    public class ViewHolder {
        public ViewHolder(View view) {
            text = (TextView) view.findViewById(R.id.text);
            line = view.findViewById(R.id.itemDiver);
        }

        private TextView text;

        private View line;
    }
}
