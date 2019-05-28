package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.ReleaseProjectInfo;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;

import java.util.List;

/**
 * 功能:添加同步项目列表Adapter
 * 时间:2016-4-18 18:34
 * 作者:xuj
 */
public class SynchStatementProListAdapter extends BaseAdapter {
    private List<ReleaseProjectInfo> list;
    private LayoutInflater inflater;
    private BaseActivity activity;
    private DiaLogTitleListener listener;


    public SynchStatementProListAdapter(BaseActivity activity, List<ReleaseProjectInfo> list, DiaLogTitleListener listener) {
        this.activity = activity;
        this.list = list;
        inflater = LayoutInflater.from(activity);
        this.listener = listener;
    }

    public void addList(List<ReleaseProjectInfo> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }


    public void updateList(List<ReleaseProjectInfo> list) {
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
        final ViewHolder holder;
        final ReleaseProjectInfo bean = list.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_synch_pro_list, null);
            holder.tv_close_synch = (TextView) convertView.findViewById(R.id.tv_close_synch);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.line = convertView.findViewById(R.id.itemDiver);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(bean.getPro_name());
        holder.line.setVisibility(position == list.size() - 1 ? View.GONE : View.VISIBLE);
        holder.tv_close_synch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                closeSynch(activity, position);
            }
        });
        if (position == list.size() - 1) {
            holder.line.setVisibility(View.GONE);
        } else {
            holder.line.setVisibility(View.VISIBLE);
        }
        return convertView;
    }

    class ViewHolder {
        TextView tv_name;
        TextView tv_close_synch;
        View line;
    }

    private DialogOnlyTitle closeSynchDialog;

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void closeSynch(final BaseActivity activity, final int position) {
        if (closeSynchDialog == null) {
            closeSynchDialog = new DialogOnlyTitle(activity, listener, position, String.format(activity.getString(R.string.synch_desc), list.get(position).getPro_name()));
        } else {
            closeSynchDialog.updateContent(String.format(activity.getString(R.string.synch_desc), list.get(position).getPro_name()), position);
        }
        closeSynchDialog.show();

    }


    public void closeDialog() {
        if (closeSynchDialog != null) {
            closeSynchDialog.dismiss();
        }
    }

    public List<ReleaseProjectInfo> getList() {
        return list;
    }

    public void setList(List<ReleaseProjectInfo> list) {
        this.list = list;
    }
}
