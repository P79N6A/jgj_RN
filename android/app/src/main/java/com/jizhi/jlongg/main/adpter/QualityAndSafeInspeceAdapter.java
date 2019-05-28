package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.InspectQualityList;
import com.jizhi.jlongg.main.bean.Sign;
import com.jizhi.jlongg.main.util.CommonMethod;

import java.util.List;


/**
 * CName:检查大项适配器 2.3.0
 * User: hcs
 * Date: 2017-07-14
 * Time: 11:40
 */
public class QualityAndSafeInspeceAdapter extends BaseAdapter {
    private List<InspectQualityList> list;
    private LayoutInflater inflater;
    private Context context;
    private OnCheckChangeListener onCheckChangeListener;

    public QualityAndSafeInspeceAdapter(Context context, List<InspectQualityList> list, OnCheckChangeListener onCheckChangeListener) {
        this.context = context;
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.onCheckChangeListener = onCheckChangeListener;
    }


    public void update(List<Sign> messageBillData) {
        notifyDataSetChanged();
    }


    @Override
    public int getCount() {
        return list.size();
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
        Holder holder;
        if (convertView == null) {
            holder = new Holder();
            convertView = inflater.inflate(R.layout.item_release_check_anqlity_and_safe, null);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.ck_check = (CheckBox) convertView.findViewById(R.id.ck_check);
            convertView.setTag(holder);
        } else {
            holder = (Holder) convertView.getTag();
        }
        final InspectQualityList inspectQualityList = list.get(position);
        holder.tv_name.setText(inspectQualityList.getText() + " (" + inspectQualityList.getChild_num() + ")");
        if (inspectQualityList.getChild_num() != 0) {
            holder.ck_check.setVisibility(View.VISIBLE);
            if (inspectQualityList.isCheck()) {
                holder.ck_check.setChecked(true);
            } else {
                holder.ck_check.setChecked(false);
            }
        } else {
            holder.ck_check.setVisibility(View.GONE);
        }
        holder.ck_check.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                onCheckChangeListener.checkChangeListener(isChecked, position);

            }
        });
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (inspectQualityList.getChild_num() == 0) {
                    CommonMethod.makeNoticeLong(context, "该检查大项未中包括具体检查分项，不能加入检查计划", CommonMethod.ERROR);
                }

            }
        });
        return convertView;
    }


    class Holder {
        /* 日期 */
        TextView tv_name;
        CheckBox ck_check;
    }

    public interface OnCheckChangeListener {
        public void checkChangeListener(boolean isCheck, int position);
    }

}
