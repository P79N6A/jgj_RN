package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
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
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;

/**
 * 同步项目 选择项目
 *
 * @author Xuj
 * @date 2018年5月5日14:22:56
 */
public class SyncSelecteProjectActivity extends BaseActivity {
    /**
     * 项目列表数据
     */
    private ArrayList<Project> list;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param selecteProId 已选的项目id
     */
    public static void actionStart(Activity context, String selecteProId) {
        Intent intent = new Intent(context, SyncSelecteProjectActivity.class);
        intent.putExtra(Constance.PRO_ID, selecteProId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview_default);
        initView();
        getProList();
    }

    private void initView() {
        setTextTitleAndRight(R.string.select_project, R.string.add_pro);
        ListView listView = (ListView) findViewById(R.id.listView);
        TextView rightTitle = getTextView(R.id.right_title);
        Drawable mClearDrawable = getResources().getDrawable(R.drawable.chat_add_small_icon);
        mClearDrawable.setBounds(0, 0, mClearDrawable.getIntrinsicWidth(), mClearDrawable.getIntrinsicHeight()); //设置清除的图片
        rightTitle.setCompoundDrawables(mClearDrawable, null, null, null);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                returnSelectedProject(list.get(position));
            }
        });
        rightTitle.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {//新增项目
                AddProjectActivity.actionStart(SyncSelecteProjectActivity.this);
            }
        });
    }

    /**
     * 选中项目返回
     *
     * @param bean 项目
     */
    private void returnSelectedProject(Project bean) {
        Intent intent = getIntent();
        intent.putExtra(Constance.PRO_ID, bean.getPid() + "");
        intent.putExtra(Constance.PRONAME, bean.getPro_name());
        setResult(2, intent);
        finish();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.RESULTWORKERS) {
            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            returnSelectedProject(project);
        }
    }


    /**
     * 获取与我相关的项目
     */
    public void getProList() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("is_sync", "1");
        String httpUrl = NetWorkRequest.QUERYPRO;
        CommonHttpRequest.commonRequest(this, httpUrl, Project.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<Project> proList = (ArrayList<Project>) object;
                list = proList;
                if (proList != null && proList.size() > 0) {
                    //设置已选的pid
                    String pid = getIntent().getStringExtra(Constance.PRO_ID);
                    if (!TextUtils.isEmpty(pid)) {
                        for (Project project : proList) {
                            if (pid.equals(project.getPid() + "")) {
                                project.setIsSelected(true);
                            }
                        }
                    }
                }
                ListView listView = (ListView) findViewById(R.id.listView);
                listView.setEmptyView(findViewById(R.id.defaultLayout));
                SelecteProjectAdapter adater = new SelecteProjectAdapter(SyncSelecteProjectActivity.this, proList);
                listView.setAdapter(adater);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 功能:新建班组、项目管理
     * 时间:2018-5-5 14:30:41
     * 作者:xuj
     */
    public class SelecteProjectAdapter extends BaseAdapter {

        /**
         * 项目列表数据
         */
        private List<Project> list;
        /**
         * xml数据解析器
         */
        private LayoutInflater inflater;


        public SelecteProjectAdapter(Context context, List<Project> list) {
            inflater = LayoutInflater.from(context);
            this.list = list;
        }

        @Override
        public int getCount() {
            return list == null ? 0 : list.size();
        }

        @Override
        public Project getItem(int position) {
            return list.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder;
            Project bean = getItem(position);
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.item_team_project, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            holder.proName.setText(bean.getPro_name());
            holder.icon.setVisibility(bean.isSelected() ? View.VISIBLE : View.GONE);
            holder.itemDiver.setVisibility(position == getCount() ? View.GONE : View.VISIBLE);
            return convertView;
        }

        class ViewHolder {

            public ViewHolder(View view) {
                proName = (TextView) view.findViewById(R.id.pro_name);
                icon = (ImageView) view.findViewById(R.id.icon);
                itemDiver = view.findViewById(R.id.itemDiver);
                proName.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.color_333333));
                view.findViewById(R.id.exist_pro_name).setVisibility(View.GONE);
            }

            /**
             * 项目名
             */
            TextView proName;
            /**
             * 图标
             */
            ImageView icon;
            /**
             * 分割线
             */
            View itemDiver;
        }

        public List<Project> getList() {
            return list;
        }

        public void setList(List<Project> list) {
            this.list = list;
        }
    }
}
