package com.jizhi.jlongg.main.adpter.check;

import android.app.Activity;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.CheckList;

import java.util.ArrayList;


/**
 * CName:显示检查项 适配器
 * User: xuj
 * Date: 2017年11月17日10:16:38
 * Time: 10:01:41
 */
public class ShowCheckListAdapter extends BaseAdapter {
    /**
     * 上下文
     */
    private Activity activity;
    /**
     * 列表数据
     */
    private ArrayList<CheckList> list;
    /**
     * true表示能编辑 在每行会显示删除的图标
     */
    private boolean isEditor;
    /**
     * 显示默认页
     */
    private int SHOW_EMPTY_CONTENT = 0;
    /**
     * 展示检查项
     */
    private int SHOW_CHECK_LIST = 1;
    /**
     * 默认数据页的高度
     */
    private int listViewHeadHeight;


    /**
     * 当isEditor为true的时候删除时的回调
     */
    private CheckListAdapter.RemoveCheckContentListener listener;


    public ShowCheckListAdapter(Activity context, ArrayList<CheckList> list, boolean isEditor, CheckListAdapter.RemoveCheckContentListener listener) {
        this.list = list;
        this.listener = listener;
        this.isEditor = isEditor;
        this.activity = context;
    }

    @Override
    public int getViewTypeCount() {
        return 2;
    }

    public int getCount() {
        if (getItemViewType(0) == SHOW_EMPTY_CONTENT) {
            return 1;
        }
        return list.size();
    }

    @Override
    public int getItemViewType(int position) {
        if (list == null || list.size() == 0) {
            return SHOW_EMPTY_CONTENT;
        }
        return SHOW_CHECK_LIST;
    }

    public CheckList getItem(int position) {
        return list.get(position);
    }

    public long getItemId(int position) {
        return position;
    }

    public View getView(final int position, View convertView, ViewGroup parent) {
        int itemType = getItemViewType(position);
        if (itemType == SHOW_EMPTY_CONTENT) {  //无数据时展示的页面
            convertView = LayoutInflater.from(activity).inflate(R.layout.default_check, parent, false);
            if (listViewHeadHeight != 0) {
                TextView defaultDesc = (TextView) convertView.findViewById(R.id.defaultDesc);
                defaultDesc.setText(R.string.no_check_plan);
                AbsListView.LayoutParams params = (AbsListView.LayoutParams) defaultDesc.getLayoutParams();
                params.height = parent.getHeight() - listViewHeadHeight;
                defaultDesc.setLayoutParams(params);
            }
            return convertView;
        }
        ViewHolder holder = null;
        if (convertView == null) {
            convertView = LayoutInflater.from(activity).inflate(R.layout.item_check_content_or_check_point, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(position, convertView, holder);
        return convertView;
    }

    private void bindData(final int position, View convertView, final ViewHolder holder) {
        final CheckList bean = getItem(position);
        if (isEditor) {
            holder.deleteCheckContentIcon.setVisibility(View.VISIBLE);
            holder.deleteIconLine.setVisibility(View.VISIBLE);
            holder.deleteCheckContentIcon.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (listener != null) {
                        list.remove(position);
                        notifyDataSetChanged();
                    }
                }
            });
        } else {
            holder.deleteIconLine.setVisibility(View.INVISIBLE);
            holder.deleteCheckContentIcon.setVisibility(View.INVISIBLE);
        }
        holder.checkContent.setText(bean.getPro_name());
        holder.divierLine.setVisibility(position == getCount() - 1 ? View.GONE : View.VISIBLE);
    }

    class ViewHolder {

        public ViewHolder(View convertView) {
            selectedIcon = (ImageView) convertView.findViewById(R.id.selectedIcon);
            checkContent = (TextView) convertView.findViewById(R.id.checkContent);
            divierLine = convertView.findViewById(R.id.divierLine);
            deleteIconLine = convertView.findViewById(R.id.deleteIconLine);
            deleteCheckContentIcon = convertView.findViewById(R.id.deleteCheckContentIcon);
            checkContent.setTextColor(ContextCompat.getColor(activity, R.color.color_333333));
        }

        /**
         * 删除检查内容图标
         */
        ImageView selectedIcon;
        /**
         * 检查内容名称
         */
        TextView checkContent;
        /**
         * 删除按钮图标
         */
        View deleteCheckContentIcon;
        /**
         * 分割线
         */
        View divierLine;
        /**
         * 删除按钮图标旁的小线
         */
        View deleteIconLine;
    }

    public CheckListAdapter.RemoveCheckContentListener getListener() {
        return listener;
    }

    public void setListener(CheckListAdapter.RemoveCheckContentListener listener) {
        this.listener = listener;
    }

    public ArrayList<CheckList> getList() {
        return list;
    }


    public void updateList(ArrayList<CheckList> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public int getListViewHeadHeight() {
        return listViewHeadHeight;
    }

    public void setListViewHeadHeight(int listViewHeadHeight) {
        this.listViewHeadHeight = listViewHeadHeight;
    }

    public boolean isEmptyData() {
        return getItemViewType(0) == SHOW_EMPTY_CONTENT ? true : false;
    }

}
