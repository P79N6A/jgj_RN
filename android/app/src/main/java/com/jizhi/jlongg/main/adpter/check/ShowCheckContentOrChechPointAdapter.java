package com.jizhi.jlongg.main.adpter.check;

import android.app.Activity;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.CheckPoint;

import java.util.List;

/**
 * CName:添加检查内容适配器
 * User: xuj
 * Date: 2017年11月17日10:16:38
 * Time: 10:01:41
 */
public class ShowCheckContentOrChechPointAdapter extends BaseAdapter {
    /**
     * 上下文
     */
    private Activity activity;
    /**
     * 列表数据
     */
    private List<CheckPoint> list;
    /**
     * true表示能编辑 在每行会显示删除的图标
     */
    private boolean isEditor;
    /**
     * 当isEditor为true的时候删除时的回调
     */
    private CheckListAdapter.RemoveCheckContentListener listener;


    public ShowCheckContentOrChechPointAdapter(Activity context, List<CheckPoint> list, boolean isEditor) {
        this.list = list;
        this.isEditor = isEditor;
        this.activity = context;
    }

    public int getCount() {
        return list == null ? 0 : list.size();
    }

    public CheckPoint getItem(int position) {
        return list.get(position);
    }

    public long getItemId(int position) {
        return position;
    }

    public View getView(final int position, View convertView, ViewGroup parent) {
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
        final CheckPoint bean = getItem(position);
        if (isEditor) {
            holder.deleteCheckContentIcon.setVisibility(View.VISIBLE);
            holder.deleteIconLine.setVisibility(View.VISIBLE);
            holder.deleteCheckContentIcon.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (listener != null) {
                        listener.isRemoveAll();
                    }
                }
            });
        } else {
            holder.deleteIconLine.setVisibility(View.INVISIBLE);
            holder.deleteCheckContentIcon.setVisibility(View.INVISIBLE);
        }

        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) holder.checkContent.getLayoutParams();
        int peddingTopBottom = (int) activity.getResources().getDimension(R.dimen.check_padding);
        params.topMargin = peddingTopBottom;
        params.bottomMargin = peddingTopBottom;
        holder.checkContent.setLayoutParams(params);
        holder.checkContent.setText(bean.getDot_name());
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

    public List<CheckPoint> getList() {
        return list;
    }

    public void setList(List<CheckPoint> list) {
        this.list = list;
    }
}
