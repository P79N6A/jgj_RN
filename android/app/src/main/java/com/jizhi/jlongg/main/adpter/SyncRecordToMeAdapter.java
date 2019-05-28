package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.StatisticalWorkSecondActivity;
import com.jizhi.jlongg.main.bean.SyncDetailInfo;

import java.util.List;


/**
 * 功能:记工记账适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class SyncRecordToMeAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<SyncDetailInfo> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 是否正在编辑同步
     */
    private boolean isEditor;
    /**
     * 上下文
     */
    private Activity context;
    /**
     * 取消同步回调
     */
    private SyncRecordAccountAdapter.CancelSynListener listener;


    public SyncRecordToMeAdapter(Activity context, List<SyncDetailInfo> list, SyncRecordAccountAdapter.CancelSynListener listener) {
        super();
        this.context = context;
        this.list = list;
        this.listener = listener;
        inflater = LayoutInflater.from(context);
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public SyncDetailInfo getItem(int position) {
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
            convertView = inflater.inflate(R.layout.sync_record_to_me_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, View convertView) {
        final SyncDetailInfo syncDetailInfo = getItem(position);
        holder.deleteBtn.setVisibility(isEditor ? View.VISIBLE : View.GONE);
        holder.clickNextIcon.setVisibility(isEditor ? View.GONE : View.VISIBLE);
        holder.itemDiver.setVisibility(getCount() - 1 == position ? View.GONE : View.VISIBLE);
        holder.proName.setText(syncDetailInfo.getPro_name());
        holder.deleteBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.cancelSync(syncDetailInfo.getSync_id() + "");
                }
            }
        });
        if (position != 0) {
            if (syncDetailInfo.getUid().equals(getItem(position - 1).getUid())) {
                holder.syncName.setVisibility(View.GONE);
                holder.itemDiverBackground.setVisibility(View.GONE);
            } else {
                holder.syncName.setVisibility(View.VISIBLE);
                holder.itemDiverBackground.setVisibility(View.VISIBLE);
                holder.syncName.setText(Html.fromHtml("<strong><font color='#333333'>" + syncDetailInfo.getReal_name() + "</font></strong><font color='#999999'>&nbsp;&nbsp;同步给我的记工</font>"));
            }
        } else {
            holder.syncName.setVisibility(View.VISIBLE);
            holder.itemDiverBackground.setVisibility(View.GONE);
            holder.syncName.setText(Html.fromHtml("<strong><font color='#333333'>" + syncDetailInfo.getReal_name() + "</font></strong><font color='#999999'>&nbsp;&nbsp;同步给我的记工</font>"));
        }
        holder.itemLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isEditor()) {
                    return;
                }
                StatisticalWorkSecondActivity.actionStart(context,
                        null, null, syncDetailInfo.getPid() + "", syncDetailInfo.getPro_name(),
                        null, null, null, StatisticalWorkSecondActivity.TYPE_FROM_PROJECT, syncDetailInfo.getPid() + "",
                        "project", false, true, syncDetailInfo.getUid(), true, false);
            }
        });
        Utils.setBackGround(convertView, context.getResources().getDrawable(isEditor ? R.color.white : R.drawable.listview_selector_white_gray));
    }


    class ViewHolder {
        public ViewHolder(View convertView) {
            clickNextIcon = (ImageView) convertView.findViewById(R.id.clickNextIcon);
            proName = (TextView) convertView.findViewById(R.id.proName);
            deleteBtn = (TextView) convertView.findViewById(R.id.deleteBtn);
            itemDiver = convertView.findViewById(R.id.itemDiver);
            syncName = convertView.findViewById(R.id.sync_name);
            itemDiverBackground = convertView.findViewById(R.id.itemDiverBackground);
            itemLayout = convertView.findViewById(R.id.item_layout);
        }

        /**
         * 项目名称
         */
        TextView proName;
        /**
         * 删除按钮
         */
        TextView deleteBtn;
        /**
         * 点击下一页按钮图标
         */
        ImageView clickNextIcon;
        /**
         * 分割线
         */
        View itemDiver;
        /**
         * 同步人名称
         */
        TextView syncName;
        /**
         * 背景分割线
         */
        View itemDiverBackground;
        /**
         * 行布局
         */
        View itemLayout;

    }

    public void updateList(List<SyncDetailInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addList(List<SyncDetailInfo> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }

    public boolean isEditor() {
        return isEditor;
    }

    public void setEditor(boolean editor) {
        isEditor = editor;
    }
}
