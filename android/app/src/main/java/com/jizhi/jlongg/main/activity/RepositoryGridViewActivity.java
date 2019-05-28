package com.jizhi.jlongg.main.activity;

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
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.umeng.analytics.MobclickAgent;

import java.util.List;

/**
 * 知识库主页(9宫格)
 *
 * @author Xuj
 * @time 2017年7月21日9:58:48
 * @Version 1.3.0
 */
public class RepositoryGridViewActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 启动当前Activity
     *
     * @param context
     * @param classType
     */
    public static void actionStart(Activity context, String classType) {
        Intent intent = new Intent(context, RepositoryGridViewActivity.class);
        intent.putExtra(Constance.CLASSTYPE, classType);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.repository_gridview);
        initView();
    }

    private void initView() {
        setTextTitle(R.string.repository);
        final View leftView = findViewById(R.id.leftImage); //隐藏搜索图标
        final View rightView = findViewById(R.id.rightImage); //隐藏收藏图标
        leftView.setVisibility(View.GONE);
        rightView.setVisibility(View.GONE);
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) leftView.getLayoutParams();
        params.rightMargin = DensityUtils.dp2px(getApplicationContext(), 5);
        params.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
        leftView.setLayoutParams(params);
        //加载知识库标题数据
        RepositoryUtil.loadRepositoryData(RepositoryUtil.ROOT_DIR_INDEX, null, this, new RepositoryUtil.LoadRepositoryListener() {
            @Override
            public void loadRepositorySuccess(final List<Repository> list) {
                View defaultView = findViewById(R.id.defaultLayout);
                if (list == null || list.size() == 0) {
                    defaultView.setVisibility(View.VISIBLE);
                    return;
                }
                defaultView.setVisibility(View.GONE); //隐藏无数据时展示的页面
                leftView.setVisibility(View.VISIBLE); //显示搜索图标
                GridView gridView = (GridView) findViewById(R.id.gridView);
                RepositoryGridAdapter adapter = new RepositoryGridAdapter(RepositoryGridViewActivity.this, list);
                gridView.setAdapter(adapter);
                gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                    @Override
                    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                        Repository repository = list.get(position);
                        switch (repository.getType()) {
                            case 0: //文件
                                RepositoryDetailActivity.actionStart(RepositoryGridViewActivity.this, repository.getFile_name(), repository.getId());
                                break;
                            case 1: //表示收藏夹
                                if (!IsSupplementary.accessLogin(RepositoryGridViewActivity.this)) { //是否已经登录
                                    return;
                                }
                                RepositoryCollectionActivity.actionStart(RepositoryGridViewActivity.this);
                                break;
                            case 2: //资料那些事
                                X5WebViewActivity.actionStart(RepositoryGridViewActivity.this,
                                        NetWorkRequest.WEBURLS + "dynamic/topic?topic_name=%E8%B5%84%E6%96%99%E9%82%A3%E4%BA%9B%E4%BA%8B");
                                break;
                            case 3: //已下载的知识库
                                RepositoryDownLoadActivity.actionStart(RepositoryGridViewActivity.this);
                                break;
                        }
                    }
                });
            }

            @Override
            public void loadRepositoryError() {

            }
        }, 1);
        MobclickAgent.onEvent(this, "click_repository_module"); //U盟点击知识库模块统计
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.leftImage: //搜索按钮
                RepositorySearchingActivity.actionStart(this);
                break;
            case R.id.title: //查看帮助
                String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
                if (TextUtils.isEmpty(classType)) {
                    classType = WebSocketConstance.GROUP;
                }
                HelpCenterUtil.actionStartHelpActivity(this, classType.equals(WebSocketConstance.TEAM) ? 190 : 198);
                break;
        }
    }


    /**
     * 知识库
     *
     * @author xuj
     * @version 1.0
     * @time 2017年7月13日15:05:48
     */
    @SuppressLint("DefaultLocale")
    public class RepositoryGridAdapter extends BaseAdapter {

        /**
         * xml解析器
         */
        private LayoutInflater inflater;
        /**
         * 列表数据
         */
        private List<Repository> list;

        public RepositoryGridAdapter(Context mContext, List<Repository> list) {
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
                convertView = inflater.inflate(R.layout.repository_gridview_item, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(position, convertView, holder);
            return convertView;
        }

        private void bindData(final int position, View convertView, ViewHolder holder) {
            final Repository bean = list.get(position);
            ImageLoader.getInstance().displayImage(NetWorkRequest.IP_ADDRESS + bean.getFile_path(), holder.repositoryIcon, UtilImageLoader.loadRepository(RepositoryGridViewActivity.this));
            holder.repositoryName.setText(bean.getFile_name());
        }

        class ViewHolder {

            public ViewHolder(View convertView) {
                repositoryIcon = (ImageView) convertView.findViewById(R.id.repositoryIcon);
                repositoryName = (TextView) convertView.findViewById(R.id.fileName);
            }

            /**
             * 知识库图标
             */
            ImageView repositoryIcon;
            /**
             * 知识库名称
             */
            TextView repositoryName;
        }

    }
}
