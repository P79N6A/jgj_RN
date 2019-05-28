package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.EvaluateTag;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.HttpHandler;
import com.lidroid.xutils.http.RequestParams;

import java.util.List;

/**
 * 添加评价标签
 *
 * @author Xuj
 * @time 2018年4月28日10:39:39
 * @Version 1.0
 */

public class AddEvaluateTagActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 评价标签输入框
     */
    private EditText inputTagText;
    /**
     * 搜索框适配器
     */
    private SearchTagAdapter adapter;
    /**
     * 当前Http发送的对象
     */
    private HttpHandler httpHandler;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, AddEvaluateTagActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
        context.overridePendingTransition(R.anim.scan_login_open, 0);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_tag);
        initView();
    }

    private void initView() {
        setTextTitle(R.string.evaluation);
        inputTagText = getEditText(R.id.inputTagText);
        inputTagText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String message = s.toString();
                //如果大于0就去请求服务器
                if (message.length() > 1) {
                    searchTag(message);
                } else {
                    setAdapter(null);
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }

    /**
     * 查询标签
     *
     * @param tagName
     */
    private void searchTag(String tagName) {
        if (httpHandler != null && !httpHandler.isCancelled()) {
            httpHandler.cancel();
            httpHandler = null;
        }
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("tag_name", tagName);
        String httpUrl = NetWorkRequest.SEARCH_TAGS;
        httpHandler = CommonHttpRequest.commonRequest(this, httpUrl, EvaluateTag.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                List<EvaluateTag> list = (List<EvaluateTag>) object;
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }

    private void setAdapter(List<EvaluateTag> list) {
        if (adapter == null) {
            adapter = new SearchTagAdapter(this, list);
            ListView listView = (ListView) findViewById(R.id.listView);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    Intent intent = getIntent();
                    intent.putExtra(Constance.BEAN_STRING, adapter.getItem(position).getTag_name());
                    setResult(Constance.SUCCESS, intent);
                    finish();
                }
            });
        } else {
            adapter.updateList(list);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.addTagBtn: //添加评论标签
                String tagInfo = inputTagText.getText().toString().trim();
                if (TextUtils.isEmpty(tagInfo)) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "请输入标签信息", CommonMethod.ERROR);
                    return;
                }
                Intent intent = getIntent();
                intent.putExtra(Constance.BEAN_STRING, tagInfo);
                setResult(Constance.SUCCESS, intent);
                finish();
                break;
        }
    }

    @Override
    public void finish() {
        super.finish();
        if (httpHandler != null && !httpHandler.isCancelled()) {
            httpHandler.cancel();
            httpHandler = null;
        }
        overridePendingTransition(0, R.anim.scan_login_close);
    }


    class SearchTagAdapter extends BaseAdapter {
        /**
         * 列表数据
         */
        private List<EvaluateTag> list;
        /**
         * xml解析器
         */
        private LayoutInflater inflater;


        public SearchTagAdapter(Context context, List<EvaluateTag> list) {
            super();
            this.list = list;
            inflater = LayoutInflater.from(context);
        }


        public void updateList(List<EvaluateTag> list) {
            this.list = list;
            notifyDataSetChanged();
        }


        @Override
        public int getCount() {
            return list == null ? 0 : list.size();
        }

        @Override
        public EvaluateTag getItem(int position) {
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
                convertView = inflater.inflate(R.layout.search_tag_item, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(holder, position, convertView);
            return convertView;
        }

        private void bindData(final ViewHolder holder, final int position, View convertView) {
            final EvaluateTag bean = getItem(position);
            holder.firstLine.setVisibility(position == 0 ? View.VISIBLE : View.GONE);
            holder.tagName.setText(bean.getTag_name());
            holder.itemDiver.setVisibility(position == getCount() - 1 ? View.GONE : View.VISIBLE);
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                firstLine = convertView.findViewById(R.id.firstLine);
                tagName = (TextView) convertView.findViewById(R.id.tagName);
                itemDiver = convertView.findViewById(R.id.itemDiver);
            }

            /**
             * 标签名称
             */
            TextView tagName;
            /**
             * 分割线
             */
            View itemDiver;
            /**
             * 第一条数据时需要展示的线
             */
            View firstLine;
        }

        public List<EvaluateTag> getList() {
            return list;
        }

        public void setList(List<EvaluateTag> list) {
            this.list = list;
        }
    }

}
