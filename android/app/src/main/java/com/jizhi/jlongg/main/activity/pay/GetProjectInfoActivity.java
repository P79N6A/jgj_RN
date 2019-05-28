package com.jizhi.jlongg.main.activity.pay;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.ProductInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;

import java.io.Serializable;
import java.util.List;

/**
 * 获取项目信息
 */

public class GetProjectInfoActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview);
        initView();
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, List<ProductInfo> infos, String groupId) {
        Intent intent = new Intent(context, GetProjectInfoActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.BEAN_CONSTANCE, (Serializable) infos);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    private void initView() {
        setTextTitle(R.string.selecte_service_pro);
        Intent intent = getIntent();
        final List<ProductInfo> list = (List<ProductInfo>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (list == null || list.size() == 0) {
            CommonMethod.makeNoticeShort(getApplicationContext(), "获取服务项目出错", CommonMethod.ERROR);
            finish();
            return;
        }
        String groupId = intent.getStringExtra(Constance.GROUP_ID);
        if (!TextUtils.isEmpty(groupId)) {
            for (ProductInfo info : list) {
                if (info.getGroup_id().equals(groupId)) { //如果id相同的则需要设置为已选中
                    info.setIs_selected(1);
                    break;
                }
            }
        }
        ProjectAdapter adapter = new ProjectAdapter(GetProjectInfoActivity.this, list);
        ListView listView = (ListView) findViewById(R.id.listView);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                Intent intent = new Intent();
                intent.putExtra(Constance.BEAN_CONSTANCE, list.get(position));
                setResult(Constance.GET_PROJECT_INFO, intent);
                finish();
            }
        });
    }

    /**
     * 项目适配器
     *
     * @author xuj
     * @version 1.0
     * @time 2017年7月13日15:05:48
     */
    @SuppressLint("DefaultLocale")
    public class ProjectAdapter extends BaseAdapter {

        /**
         * xml解析器
         */
        private LayoutInflater inflater;
        /**
         * 列表数据
         */
        private List<ProductInfo> list;

        public ProjectAdapter(Context mContext, List<ProductInfo> list) {
            this.list = list;
            inflater = LayoutInflater.from(mContext);
        }


        public int getCount() {
            return list == null ? 0 : list.size();
        }

        public Object getItem(int position) {
            return list.get(position);
        }

        public long getItemId(int position) {
            return position;
        }

        public View getView(final int position, View convertView, ViewGroup arg2) {
            final ViewHolder holder;
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.project_info_item, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(position, convertView, holder);
            return convertView;
        }

        private void bindData(final int position, View convertView, ViewHolder holder) {
            final ProductInfo bean = list.get(position);
            holder.groupName.setText(bean.getGroup_name());
            holder.isSelected.setVisibility(bean.getIs_selected() == 1 ? View.VISIBLE : View.INVISIBLE);
            holder.isClosed.setVisibility(bean.getIs_closed() == 1 ? View.VISIBLE : View.GONE);
        }

        class ViewHolder {

            public ViewHolder(View convertView) {
                isSelected = (ImageView) convertView.findViewById(R.id.isSelected);
                groupName = (TextView) convertView.findViewById(R.id.groupName);
                isClosed = (TextView) convertView.findViewById(R.id.isClosed);
                line = convertView.findViewById(R.id.payBtn);
            }


            ImageView isSelected;
            /**
             * 项目名称
             */
            TextView groupName;
            /**
             * 项目是否已关闭
             */
            TextView isClosed;
            /**
             * 横线
             */
            View line;
        }
    }
}
