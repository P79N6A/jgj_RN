package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;

import java.io.Serializable;
import java.util.List;

/**
 * CName:单选
 * User: xuj
 * Date: 2017年6月7日
 * Time: 15:41:29
 */
public class SingleSelectedActivity extends BaseActivity {


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, List<SingleSelected> list, String title) {
        Intent intent = new Intent(context, SingleSelectedActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, (Serializable) list);
        intent.putExtra(Constance.TITLE, title);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview);

        final Intent intent = getIntent();
        final List<SingleSelected> list = (List<SingleSelected>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (list == null || list.size() == 0) {
            CommonMethod.makeNoticeShort(getApplicationContext(), "数据获取出错", CommonMethod.ERROR);
            finish();
            return;
        }
        getTextView(R.id.title).setText(intent.getStringExtra(Constance.TITLE));
        ListView listView = (ListView) findViewById(R.id.listView);
        listView.setAdapter(new SingleSelectedAdapter(this, list));

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                clearLastSelectedState(list);
                SingleSelected bean = list.get(position);
                bean.setSelected(true);
                intent.putExtra(Constance.BEAN_CONSTANCE, (Serializable) list);
                intent.putExtra("selectedValue", bean.getName());
                setResult(Constance.SUCCESS, intent);
                finish();
            }
        });
    }

    /**
     * 清空上次选择的状态
     *
     * @param list
     */
    private void clearLastSelectedState(List<SingleSelected> list) {
        for (SingleSelected bean : list) {
            if (bean.isSelected()) {
                bean.setSelected(false);
            }
        }
    }


    /**
     * 功能:单选适配器
     * 时间:2017年6月8日17:17:30
     * 作者:xuj
     */
    public class SingleSelectedAdapter extends BaseAdapter {
        /* 列表数据 */
        private List<SingleSelected> list;
        /* xml解析器 */
        private LayoutInflater inflater;
        private Context context;


        public SingleSelectedAdapter(Context context, List<SingleSelected> list) {
            super();
            this.list = list;
            this.context = context;
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


        @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder = null;
            if (convertView == null) {
                holder = new ViewHolder();
                convertView = inflater.inflate(R.layout.item_selected_single, null);
                holder.name = (TextView) convertView.findViewById(R.id.name);
                holder.selectedIcon = (ImageView) convertView.findViewById(R.id.selectedIcon);
                holder.background = convertView.findViewById(R.id.background);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(holder, position, convertView);
            return convertView;
        }


        private void bindData(ViewHolder holder, int position, View convertView) {
            SingleSelected bean = list.get(position);
            holder.selectedIcon.setVisibility(bean.isSelected() ? View.VISIBLE : View.GONE);
            holder.name.setText(bean.getName());
            holder.name.setGravity(Gravity.CENTER_VERTICAL);
            holder.name.setTextColor(ContextCompat.getColor(context, bean.isSelected() ? R.color.app_color : R.color.color_333333));
            holder.background.setVisibility(View.GONE);
        }

        class ViewHolder {
            /**
             * 菜单名称
             */
            TextView name;
            /**
             * 选中状态的图标
             */
            ImageView selectedIcon;
            View background;
        }

    }
}