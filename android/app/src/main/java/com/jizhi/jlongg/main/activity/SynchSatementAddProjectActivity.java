package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.SynchStatementAddproAdapter;
import com.jizhi.jlongg.main.bean.ReleaseProjectInfo;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DiaLogNoMoreProject;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;
import com.lidroid.xutils.view.annotation.ViewInject;

import java.util.List;

/**
 * CName:同步账单项目列表界面
 * User: hcs
 * Date: 2016-05-09
 * Time: 15:26
 */
public class SynchSatementAddProjectActivity extends BaseActivity {
    @ViewInject(R.id.listView)
    private ListView listView;
    /* 列表适配器 */
    private SynchStatementAddproAdapter adapter;
    /* 同步人id */
    private int uid;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_synstate_add_project);
        ViewUtils.inject(this);
        initView();
    }

    private void initView() {
        Intent intent = getIntent();
        uid = intent.getIntExtra(Constance.UID, 0);
        final List<ReleaseProjectInfo> list = (List<ReleaseProjectInfo>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (list == null) {
            finish();
            return;
        }
        String userName = intent.getStringExtra(Constance.USERNAME);
        getTextView(R.id.title).setText(String.format(getString(R.string.sync_person), userName));
        getTextView(R.id.right_title).setText(getString(R.string.synch));
        adapter = new SynchStatementAddproAdapter(this, list);
        listView.setAdapter(adapter);
        findViewById(R.id.right_title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                StringBuffer sb = new StringBuffer();
                for (int i = 0; i < list.size(); i++) {
                    if (list.get(i).isSelected()) {
                        sb.append(uid + "," + list.get(i).getPid() + "," + list.get(i).getPro_name() + ";");
                    }
                }
                if (!sb.toString().trim().equals("")) {
                    String content = sb.substring(0, sb.toString().length() - 1);
                    syncPro(content);
                } else {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "请选择要同步的项目", CommonMethod.ERROR);
                }
            }
        });
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                ReleaseProjectInfo bean = list.get(position);
                bean.setSelected(!bean.isSelected());
                adapter.notifyDataSetChanged();
            }
        });
    }

    /**
     * 同步项目
     */
    public void syncPro(String pro_info) {
        String url = NetWorkRequest.SYNCPRO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("pro_info", pro_info);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, url, params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<ReleaseProjectInfo> bean = CommonListJson.fromJson(responseInfo.result, ReleaseProjectInfo.class);
                            if (bean.getState() != 0) {
                                DiaLogNoMoreProject dialog = new DiaLogNoMoreProject(SynchSatementAddProjectActivity.this, getString(R.string.syn_desc), false);
                                dialog.show();
                            } else {
                                DataUtil.showErrOrMsg(SynchSatementAddProjectActivity.this, bean.getErrno(), bean.getErrmsg());
                            }
                        } catch (Exception e) {
                            CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }
                }
        );
    }
}
