package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.RemberInfoTargetNameBean;

import java.util.List;


/**
 * 功能:记工流水筛选项目适配器
 * 时间:2016-5-9 16:30
 * 作者:xuj
 */
public class RemberWorkerInfoTargerNameAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<RemberInfoTargetNameBean> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    private ItemClickListener itemClickListener;


    public RemberWorkerInfoTargerNameAdapter(Context context, List<RemberInfoTargetNameBean> list, ItemClickListener itemClickListener) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.itemClickListener = itemClickListener;
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
        final RemberInfoTargetNameBean bean = list.get(position);
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_rember_info_target_name, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(bean.getName());
        holder.img_gou.setVisibility(bean.isSelect() ? View.VISIBLE : View.INVISIBLE);
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemClickListener.itemClick(position);
            }
        });
        return convertView;
    }


    public List<RemberInfoTargetNameBean> getList() {
        return list;
    }

    public void setList(List<RemberInfoTargetNameBean> list) {
        this.list = list;
    }

    public void updateList(List<RemberInfoTargetNameBean> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    class ViewHolder {
        public ViewHolder(View convertView) {
            tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            img_gou = (ImageView) convertView.findViewById(R.id.img_gou);
        }

        /* 名称*/
        TextView tv_name;
        /* 内容 */
        ImageView img_gou;
    }

    public interface ItemClickListener {
        void itemClick(int posotion);
    }
}
