package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.View;
import android.widget.AbsListView;
import android.widget.LinearLayout;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.SynchStatementProListAdapter;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.ReleaseProjectInfo;
import com.jizhi.jlongg.main.bean.SynBill;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DiaLogNoMoreProject;
import com.jizhi.jlongg.main.dialog.PopSyschMore;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.listener.EditorSyncPersonListener;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetColor;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;
import com.lidroid.xutils.view.annotation.ViewInject;

import java.io.Serializable;
import java.util.List;

/**
 * CName:同步账单项目列表界面
 * User: hcs
 * Date: 2016-05-09
 * Time: 15:26
 */
public class SynchProjectListActivity extends BaseActivity implements DiaLogTitleListener, EditorSyncPersonListener, SwipeRefreshLayout.OnRefreshListener,
        AbsListView.OnScrollListener, View.OnClickListener {
    /* 列表适配器 */
    private SynchStatementProListAdapter adapter;


    @ViewInject(R.id.default_layout)
    private LinearLayout defaultLayout;
    /* listView */
    @ViewInject(R.id.listView)
    private ListView listView;
    /* 下拉刷新控件 */
    @ViewInject(R.id.swipe_layout)
    private SwipeRefreshLayout mSwipeLayout;
    /* 分页编码 */
    private int page;
    /* 是否还有更多数据 */
    private boolean haveCasheData = true;
    /* 加载更多数据 */
    private View footView;
    /* 滑动最后一条数据的下标 */
    private int scrollLastItem;
    /* 用户对象 */
    private SynBill synchBill;
    /* 没有更多dialog */
    private DiaLogNoMoreProject dialog;
    /* 更多dialog */
    private PopSyschMore moreDialog = null;


//    private boolean isEditor;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_synstate_prolist);
        ViewUtils.inject(this);
        initView();
        autoRefreshData();
    }

    private void initView() {
        synchBill = (SynBill) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        String title = String.format(getString(R.string.synstateprolisttitle), synchBill.getReal_name());
        getTextView(R.id.title).setText(title);
        getTextView(R.id.right_title).setText("更多");
        mSwipeLayout.setOnRefreshListener(this); //设置下拉刷新回调
        new SetColor(mSwipeLayout); //设置下拉刷新滚动颜色
        listView.setOnScrollListener(this);//listView 滚动事件监听
        footView = loadMoreDataView();// listView 底部加载对话框
        footView.setVisibility(View.GONE);
    }

    /**
     * 自动下拉刷新
     */
    public void autoRefreshData() {
        mSwipeLayout.post(new Runnable() {
            @Override
            public void run() {
                mSwipeLayout.setRefreshing(true);
                page = 1;
                onRefresh();
            }
        });
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void showNoMoreDialog(String string_resource) {
        if (dialog == null) {
            dialog = new DiaLogNoMoreProject(this, string_resource, true);
        }
        dialog.show();
    }

    //关闭同步
    @Override
    public void clickAccess(int position) {
        closeSynch(position);
    }

    //编辑此人
    @Override
    public void SynchMoreEditClick() {
        Intent intent = new Intent(getApplicationContext(), EditSynchPersonActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, synchBill);
        startActivityForResult(intent, Constance.REQUESTCODE_CHANGFSYNCHOBJECT);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_CHANGFSYNCHOBJECT && resultCode == Constance.EDITOR_SUCCESS) { //编辑回调
            synchBill = (SynBill) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            String title = String.format(getString(R.string.synstateprolisttitle), synchBill.getReal_name());
            getTextView(R.id.title).setText(title);
//            isEditor = true;
        } else if (requestCode == Constance.REQUESTCODE_SYNCHPRO && resultCode == Constance.SYNC_SUCCESS) { //同步项目
//            isEditor = true;
            autoRefreshData();
        }
    }


    /**
     * 删除此人
     */
    @Override
    public void SynchMoreDeleteClick() {
        if (adapter != null) {
            List list = adapter.getList();
            if (null != list && list.size() > 0) {
                showNoMoreDialog(getString(R.string.sorry_delete_fail));
                return;
            }
        }
        delUserSynch();
    }

    /**
     * 删除此人
     */
    public void delUserSynch() {
        String url = NetWorkRequest.DELETESERDYNC;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("uid", String.valueOf(synchBill.getTarget_uid()));
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, url,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        CommonListJson<BaseNetBean> bean = CommonListJson.fromJson(responseInfo.result, BaseNetBean.class);
                        if (bean.getState() == 1) {
                            setResult(Constance.DELETE_SUCCESS, getIntent());
                            finish();
                        } else {
                            DataUtil.showErrOrMsg(SynchProjectListActivity.this, bean.getErrno(), bean.getErrmsg());
                        }
                        closeDialog();
                    }
                });
    }


    @Override
    public void onRefresh() {
        page = 1;
        getListData();
    }


    /**
     * 项目参数
     *
     * @return
     */
    public RequestParams params() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("uid", String.valueOf(synchBill.getTarget_uid()));
        params.addBodyParameter("pg", String.valueOf(page));
        params.addBodyParameter("synced", "1");//1：已同步的项目列表 0：未同步的项目列表
        params.addBodyParameter("pagesize", String.valueOf(Constance.PAGE_SIZE));
        return params;
    }


    private void initAdapter(List<ReleaseProjectInfo> list) {
        if (adapter == null) {
            adapter = new SynchStatementProListAdapter(SynchProjectListActivity.this, list, this);
            listView.setAdapter(adapter);
        } else {
            if (page == 1) {
                adapter.updateList(list);
            } else {
                adapter.addList(list);
            }
            adapter.notifyDataSetChanged();
        }
    }


    /**
     * 查询项目列表
     */
    public void getListData() {
        String url = NetWorkRequest.SYNCEDPRO;
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, url,
                params(), new RequestCallBack<String>() {
                    @Override
                    public void onFailure(HttpException arg0, String msg) {
                        printNetLog(msg, SynchProjectListActivity.this);
                        if (page == 1) {
                            mSwipeLayout.setRefreshing(false);
                        } else {
                            footView.setVisibility(View.GONE);
                            page -= 1;
                        }
                    }

                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        boolean isFail = false;
                        try {
                            CommonListJson<ReleaseProjectInfo> bean = CommonListJson.fromJson(responseInfo.result, ReleaseProjectInfo.class);
                            if (bean.getState() != 0) {
                                List<ReleaseProjectInfo> list = bean.getValues();
                                if (list != null && list.size() > 0) {
                                    initAdapter(list);
                                    haveCasheData = list.size() < Constance.PAGE_SIZE ? false : true;
                                    if (page == 1) {
                                        defaultLayout.setVisibility(View.GONE);
                                    }
                                } else {
                                    haveCasheData = false;
                                    if (page == 1) {
                                        defaultLayout.setVisibility(View.VISIBLE);
                                    }
                                }
                            } else {
                                DataUtil.showErrOrMsg(SynchProjectListActivity.this, bean.getErrno(), bean.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(SynchProjectListActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                            isFail = true;
                        } finally {
                            initFoot();
                            if (page == 1) {
                                mSwipeLayout.setRefreshing(false);
                            }
                            if (isFail) {
                                page -= 1;
                            }
                        }
                    }
                });
    }

    public void initFoot() {
        int count = listView.getFooterViewsCount();
        if (haveCasheData) {
            if (count == 0) {
                listView.addFooterView(footView, null, false);
                footView.setVisibility(View.GONE);
            }
        } else {
            if (count > 0) {
                listView.removeFooterView(footView);
            }
        }
    }


    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
        scrollLastItem = firstVisibleItem + visibleItemCount - 1;
    }

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        if (scrollLastItem < Constance.PAGE_SIZE + listView.getHeaderViewsCount()) {
            return;
        }
        if (scrollLastItem == adapter.getList().size() + listView.getHeaderViewsCount() && scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE && haveCasheData) {
            if (footView.getVisibility() == View.GONE) {// 是否还有缓存数据
                page += 1;
                footView.setVisibility(View.VISIBLE);
                getListData();
            }
        }
    }

//    public void onFinish(View view) {
//        if (isEditor) {
//            Intent intent = new Intent();
//            intent.putExtra(Constance.BEAN_CONSTANCE, synchBill);
//            setResult(Constance.RESULTCODE_CHANGFSYNCHOBJECT, intent);
//        }
//        finish();
//    }
//
//    @Override
//    public void onBackPressed() {
//        if (isEditor) {
//            Intent intent = new Intent();
//            intent.putExtra(Constance.BEAN_CONSTANCE, synchBill);
//            setResult(Constance.RESULTCODE_CHANGFSYNCHOBJECT, intent);
//        }
//        super.onBackPressed();
//    }

    /**
     * 关闭同步
     */
    public void closeSynch(final int position) {
        ReleaseProjectInfo info = adapter.getList().get(position);
        String url = NetWorkRequest.CLOSESYNCH;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("tag_id", String.valueOf(info.getTag_id()));
        params.addBodyParameter("sync_id", String.valueOf(info.getSync_id()));
        params.addBodyParameter("uid", String.valueOf(synchBill.getTarget_uid()));
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, url, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<ReleaseProjectInfo> bean = CommonListJson.fromJson(responseInfo.result, ReleaseProjectInfo.class);
                    if (bean.getState() == 1) {
                        List list = adapter.getList();
                        list.remove(position);
                        if (list.size() == 0) {
                            defaultLayout.setVisibility(View.VISIBLE);
                        }
                        adapter.closeDialog();
                        adapter.notifyDataSetChanged();
//                                isEditor = true;
                    } else {
                        DataUtil.showErrOrMsg(SynchProjectListActivity.this, bean.getErrno(), bean.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }
        });
    }

    /**
     * 查询已同步项目的接口
     */
    public void addProject() {
        String url = NetWorkRequest.SYNCEDPRO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("uid", String.valueOf(synchBill.getTarget_uid()));
        params.addBodyParameter("pg", "1");
        params.addBodyParameter("synced", "0");//1：已同步的项目列表 0：未同步的项目列表
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, url, params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<ReleaseProjectInfo> bean = CommonListJson.fromJson(responseInfo.result, ReleaseProjectInfo.class);
                            closeDialog();
                            if (bean.getState() != 0) {
                                if (bean.getValues() != null && bean.getValues().size() > 0) {
                                    Intent intent = new Intent(getApplicationContext(), SynchSatementAddProjectActivity.class);
                                    intent.putExtra(Constance.BEAN_CONSTANCE, (Serializable) bean.getValues());
                                    intent.putExtra(Constance.UID, synchBill.getTarget_uid());
                                    intent.putExtra(Constance.USERNAME, synchBill.getReal_name());
                                    startActivityForResult(intent, Constance.REQUESTCODE_SYNCHPRO);
                                } else {
                                    showNoMoreDialog(getString(R.string.sorry_no_pro_add));
                                }
                            } else {
                                if (bean.getErrno().equals("50009")) {
                                    showNoMoreDialog(getString(R.string.sorry_no_pro_add));
                                } else {
                                    DataUtil.showErrOrMsg(SynchProjectListActivity.this, bean.getErrno(), bean.getErrmsg());
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }
                }
        );
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //更多
                if (moreDialog == null) {
                    moreDialog = new PopSyschMore(getApplicationContext(), this);
                }
                moreDialog.showAsDropDown(findViewById(R.id.right_title));
                break;
            case R.id.btn_submit: //新增项目
                addProject();
                break;
            case R.id.sync_btn://新增项目
                addProject();
                break;
        }

    }
}
