package com.jizhi.jlongg.main.dialog;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Report;
import com.jizhi.jlongg.main.util.CommonMethod;

import java.util.List;

/**
 * 工程类别、熟练度弹出框
 *
 * @author Xuj
 * @date 2017年5月9日20:01:58
 */
public class FamiliarityAndEndineerDialog extends Dialog implements OnItemClickListener, View.OnClickListener {
    /**
     * 上下文
     */
    private Context context;
    /**
     * 列表适配器
     */
    private TypeAdapter adapter;
    /**
     * 工种数据
     */
    private List<Report> list;
    /**
     * 类型   2为工程类别   3为熟练度
     */
    private String classType;
    /**
     * 最大的选中数
     */
    private int maxSelectedSize;
    /**
     * 选中了的描述
     */
    private TextView selectedTextDesc;
    /**
     * 标题
     */
    private TextView title;
    /**
     * 选中回调
     */
    private SelectedListener listener;

    public FamiliarityAndEndineerDialog(Context context, SelectedListener listener) {
        super(context, R.style.wheelViewDialog);
        this.context = context;
        this.listener = listener;
    }

    public List<Report> getList() {
        return list;
    }

    public void setList(List<Report> list) {
        this.list = list;
    }

    public int getMaxSelectedSize() {
        return maxSelectedSize;
    }

    public void setMaxSelectedSize(int maxSelectedSize) {
        this.maxSelectedSize = maxSelectedSize;
    }

    public String getClassType() {
        return classType;
    }

    public void setClassType(String classType) {
        this.classType = classType;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        DensityUtils.applyCompat(getWindow(), context);
        setContentView(R.layout.layout_project_type);
        selectedTextDesc = (TextView) findViewById(R.id.select_count);
        findViewById(R.id.btn_cancel).setOnClickListener(this);
        findViewById(R.id.btn_confirm).setOnClickListener(this);
        title = (TextView) findViewById(R.id.tv_context);
        setOnDismissListener(new OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialog) {
                if (listener != null) {
                    StringBuilder builder = new StringBuilder();
                    int i = 0;
                    for (Report report : list) {
                        if (report.isSeleted()) {
                            builder.append(i == 0 ? report.getName() : "," + report.getName());
                            i += 1;
                        }
                    }
                    listener.selectedCallBack(builder.toString(), classType);
                }
            }
        });
    }

    public void updateData() {
        if (adapter == null) {
            ListView listView = (ListView) findViewById(R.id.listView);
            adapter = new TypeAdapter(context);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(this);
        } else {
            adapter.notifyDataSetChanged();
        }
        selectedTextDesc.setText(Html.fromHtml("<font>你最多可选择" + maxSelectedSize + "个类别(还剩下</font><font color='#f75a23'>"
                + (maxSelectedSize - getSelectedSize()) + "</font><font>个)</font>"));
        if (classType.equals("2")) { //工程类别
            title.setText("选择工程类别");
        } else if (classType.equals("3")) { //熟练度
            title.setText("选择熟练度");
        }
    }


    @Override
    public void onItemClick(AdapterView<?> arg0, View view, int position, long arg3) {
        if (classType.equals("2")) { //工程类别
            handlerClickEndineer(position);
        } else { //熟练度
            handlerClickFamiliar(position);
            dismiss();
        }
    }

    /**
     * 处理工程类别点击事件
     */
    public void handlerClickEndineer(int position) {
        Report report = list.get(position);
        report.setIsSeleted(!report.isSeleted());
        if (getSelectedSize() > maxSelectedSize) {
            report.setIsSeleted(!report.isSeleted());
            CommonMethod.makeNoticeShort(context, "最多只能选择" + maxSelectedSize + "种类别", CommonMethod.ERROR);
            return;
        }
        selectedTextDesc.setText(Html.fromHtml("<font>你最多可选择" + maxSelectedSize + "个类别(还剩下</font><font color='#f75a23'>"
                + (maxSelectedSize - getSelectedSize()) + "</font><font>个)</font>"));
        adapter.notifyDataSetChanged();
    }

    /**
     * 处理熟练度点击事件
     */
    public void handlerClickFamiliar(int position) {
        for (Report re : list) {
            if (re.isSeleted()) { //清空上次所选的菜单
                re.setIsSeleted(false);
            }
        }
        Report report = list.get(position);
        report.setIsSeleted(!report.isSeleted());
        selectedTextDesc.setText(Html.fromHtml("<font>你最多可选择" + maxSelectedSize + "个类别(还剩下</font><font color='#f75a23'>"
                + (maxSelectedSize - getSelectedSize()) + "</font><font>个)</font>"));
        adapter.notifyDataSetChanged();
    }

    /**
     * 获取已选中的项目个数
     */
    private int getSelectedSize() {
        int count = 0;
        if (list != null && list.size() > 0) {
            for (Report r : list) {
                if (r.isSeleted()) {
                    count += 1;
                }
            }
        }
        return count;
    }

    @Override
    public void onClick(View v) {
        dismiss();
    }


    public class TypeAdapter extends BaseAdapter {

        private LayoutInflater inflater;

        public TypeAdapter(Context context) {
            inflater = LayoutInflater.from(context);
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
            ViewHolder holder;
            Report workType = list.get(position);
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.item_type_of_work, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            if (workType.isSeleted()) {
                holder.isSelected.setVisibility(View.VISIBLE);
                holder.typeName.setTextColor(ContextCompat.getColor(context, R.color.app_color));
            } else {
                holder.isSelected.setVisibility(View.GONE);
                holder.typeName.setTextColor(ContextCompat.getColor(context, R.color.gray_666666));
            }
            holder.typeName.setText(workType.getName());
            return convertView;
        }

        class ViewHolder {

            public ViewHolder(View convertView) {
                typeName = (TextView) convertView.findViewById(R.id.wtype);
                isSelected = convertView.findViewById(R.id.lin_gou);
            }

            /**
             * 名称
             */
            TextView typeName;
            /**
             * 是否选中
             */
            View isSelected;
        }
    }

    public interface SelectedListener {
        public void selectedCallBack(String selectedValue, String classType);
    }


}