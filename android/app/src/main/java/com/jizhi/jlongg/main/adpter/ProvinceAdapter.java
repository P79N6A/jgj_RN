package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.CityInfoMode;

import java.util.List;

/**
 * 城市 省级 适配器
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-19 下午4:05:25
 */
public class ProvinceAdapter extends BaseAdapter {
    /* 省数据 */
    private List<CityInfoMode> provinceList;
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 上下文 */
    private Context context;
    /* 城市名称 */
    private String provinceName;
    private boolean isRightLine = false;

    @Override
    public int getCount() {
        return provinceList == null ? 0 : provinceList.size();
    }

    public ProvinceAdapter(Context context, List<CityInfoMode> provinceList) {
        super();
        provinceName = "";
        this.context = context;
        this.provinceList = provinceList;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public Object getItem(int position) {
        return provinceList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_province, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.img_right = convertView.findViewById(R.id.img_right);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tv_name.setText(provinceList.get(position).getCity_name());
        if (!TextUtils.isEmpty(provinceName) && provinceList.get(position).getCity_name().equals(provinceName)) {
            Utils.setBackGround(convertView, context.getResources().getDrawable(R.color.gray_f3f3f3));
        } else {
            Utils.setBackGround(convertView, context.getResources().getDrawable(R.color.white));
        }
        if (isRightLine) {
            holder.img_right.setVisibility(View.VISIBLE);
        }
        return convertView;
    }

    public void notifyDataSetChanged(String provinceName) {
        this.provinceName = provinceName;
        isRightLine = true;
        notifyDataSetChanged();
    }

    class ViewHolder {
        TextView tv_name;
        View img_right;
    }

    public List<CityInfoMode> getProvinceList() {
        return provinceList;
    }

}
