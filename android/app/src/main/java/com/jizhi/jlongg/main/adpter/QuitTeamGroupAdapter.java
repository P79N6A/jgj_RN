package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;

import java.util.List;


/**
 * 功能:退出项目组班组
 * 时间:2018年5月11日15:36:21
 * 作者:xuj
 */
public class QuitTeamGroupAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<SingleSelected> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 上下文
     */
    private Context context;

    private SingleSelectedPopWindow.SingleSelectedListener listener;

    public QuitTeamGroupAdapter(Context context, List<SingleSelected> list, SingleSelectedPopWindow.SingleSelectedListener listener) {
        super();
        this.context = context;
        this.listener = listener;
        this.list = list;
        inflater = LayoutInflater.from(context);
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public SingleSelected getItem(int position) {
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
            convertView = inflater.inflate(R.layout.quit_or_delete_team_group_bottom_item, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView);
        return convertView;
    }

    private void bindData(final ViewHolder holder, int position, View convertView) {
        final SingleSelected singleSelected = getItem(position);
        holder.btn.setText(singleSelected.getName());
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) holder.rootView.getLayoutParams();
        params.topMargin = position == 0 ? DensityUtils.dp2px(context.getApplicationContext(), 20) : 0;
        params.bottomMargin = position == getCount() - 1 ? DensityUtils.dp2px(context.getApplicationContext(), 30) : 0;
        holder.rootView.setLayoutParams(params);
        holder.btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.getSingleSelcted(singleSelected);
                }
            }
        });
    }

    public List<SingleSelected> getList() {
        return list;
    }

    public void setList(List<SingleSelected> list) {
        this.list = list;
    }

    class ViewHolder {
        public ViewHolder(View convertView) {
            rootView = convertView.findViewById(R.id.rootView);
            btn = (TextView) convertView.findViewById(R.id.btn);
        }

        /* 用户名称*/
        TextView btn;
        /* */
        View rootView;
    }
}
