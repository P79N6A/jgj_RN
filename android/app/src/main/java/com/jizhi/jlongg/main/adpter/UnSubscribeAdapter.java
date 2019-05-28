package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.UnSubscribe;

import java.util.List;


/**
 * 功能:注销原因适配器
 * 时间:2018年6月7日9:53:34
 * 作者:xuj
 */
public class UnSubscribeAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<UnSubscribe> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;


    public UnSubscribeAdapter(Context context, List<UnSubscribe> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public UnSubscribe getItem(int position) {
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
            convertView = inflater.inflate(R.layout.un_subscribe_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, View convertView) {
        final UnSubscribe unSubscribe = getItem(position);
//        holder.itemDiver.setVisibility(position == getCount() - 1 ? View.GONE : View.VISIBLE);
//        holder.otherEdit.setVisibility(position == getCount() - 1 ? View.VISIBLE : View.GONE);
        holder.unSubscribeReasonText.setText(unSubscribe.getName());
        holder.selecteIcon.setImageResource(unSubscribe.is_selected() ? R.drawable.un_subscrite_pressed : R.drawable.un_subscrite_normal);
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                unSubscribe.setIs_selected(!unSubscribe.is_selected());
                notifyDataSetChanged();
            }
        });
    }


    class ViewHolder {
        public ViewHolder(View convertView) {
            itemDiver = convertView.findViewById(R.id.itemDiver);
            unSubscribeReasonText = (TextView) convertView.findViewById(R.id.unSubscribeReasonText);
            selecteIcon = (ImageView) convertView.findViewById(R.id.selecteIcon);
        }

        /**
         * 分割线
         */
        View itemDiver;
        /**
         * 注销原因
         */
        TextView unSubscribeReasonText;
        /**
         * 选择状态
         */
        ImageView selecteIcon;
    }

}
