package com.jizhi.jlongg.activity.notebook;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.DateUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.NoteBookAdapter;
import com.jizhi.jlongg.main.adpter.NoteBookTodayAdapter;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.NoteBook;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.dialog.DialogTips;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.liaoinstan.springview.container.DefaultFooter;
import com.liaoinstan.springview.container.DefaultHeader;
import com.liaoinstan.springview.widget.SpringView;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 功能:记事本列表
 * 时间:2018/4/18 20.08
 * 作者:hcs
 */

public class NoteBookTodayListActivity extends BaseActivity {
    private NoteBookTodayListActivity mActivity;
    private ListView lv_msg, listView_serch;
    private boolean isFulsh;
    //滚动到顶部图标
    private ImageView btn_add;
    private int pg = 0;
    private List<NoteBook> msgList;
    private NoteBookTodayAdapter noteBookAdapter;
    private ClearEditText mClearEditText;
    private SpringView springView;
    //发布时间
//    private String publish_time;
    private int year, month, day;
    private TextView nomore;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notebook_list);
        initView();
        initSearch();
        registerReceiver();
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, int year, int month, int date, String weekday) {
        Intent intent = new Intent(context, NoteBookTodayListActivity.class);
        intent.putExtra(Constance.YEAR, year);
        intent.putExtra(Constance.MONTH, month);
        intent.putExtra(Constance.DATE, date);
        intent.putExtra("weekday", weekday);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = NoteBookTodayListActivity.this;
        TextView navigationTitle = getTextView(R.id.title);
//        publish_time = getIntent().getStringExtra("publish_time");
        year = getIntent().getIntExtra(Constance.YEAR, 0);
        month = getIntent().getIntExtra(Constance.MONTH, 0);
        day = getIntent().getIntExtra(Constance.DATE, 0);
//        publish_time = year + "年" + month + "月" + day + "月";
        String weekday = getIntent().getStringExtra("weekday");
        if (year != 0 && month != 0 && day != 0) {
            navigationTitle.setText(year + "年" + month + "月" + day + "日" + " " + weekday);
        } else {
            navigationTitle.setText("记事本");
        }

        findViewById(R.id.img_line).setVisibility(View.GONE);
        findViewById(R.id.rea_search).setVisibility(View.GONE);

        lv_msg = findViewById(R.id.listView);
        listView_serch = findViewById(R.id.listView_serch);
        btn_add = findViewById(R.id.btn_add);
        btn_add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SaveNoteBookActivity.actionStart(mActivity, null, year, month, day);
            }
        });
//        btn_add.setVisibility(View.GONE);
        View foodView = getLayoutInflater().inflate(R.layout.layout_fooder_default, null, false);
//        foodView.findViewById(R.id.img_line).setVisibility(View.VISIBLE);
        nomore=foodView.findViewById(R.id.nomore);
        lv_msg.addFooterView(foodView);
        findViewById(R.id.rightImage).setVisibility(View.GONE);

        springView = findViewById(R.id.springview);
        springView.setType(SpringView.Type.FOLLOW);
        springView.setHeader(new DefaultHeader(this));
        springView.setFooter(new DefaultFooter(this));
        springView.callFreshDelay();
        springView.setListener(new SpringView.OnFreshListener() {
            @Override
            public void onRefresh() {
                isFulsh = true;
                pg = 1;
                getNotiBookList(pg, "");
            }

            @Override
            public void onLoadmore() {
                isFulsh = false;
                pg += 1;
                getNotiBookList(pg, "");
            }
        });

    }

    public void initSearch() {
        mClearEditText = findViewById(R.id.filterEdit);
        mClearEditText.setHint("快速搜索关键字");
        mClearEditText.setImeOptions(EditorInfo.IME_ACTION_SEARCH);
        // 根据输入框输入值的改变来过滤搜索
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (TextUtils.isEmpty(s.toString())) {
                    lv_msg.setVisibility(View.VISIBLE);
                    listView_serch.setVisibility(View.GONE);
                    setLayoutDefaultState(View.GONE, false);
                  /*  if (null == noteBookAdapter || noteBookAdapter.getCount() == 0) {
                        findViewById(R.id.img_line).setVisibility(View.GONE);
                    } else {
                        findViewById(R.id.img_line).setVisibility(View.VISIBLE);
                    }*/
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        mClearEditText.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_SEARCH) {//按下手机键盘的搜索按钮的时候去 执行搜索的操作
                    hideSoftKeyboard();
                    getNotiBookList(1, mClearEditText.getText().toString().trim());
                }
                return false;
            }
        });

    }


    /**
     * 新增记事本单条记录
     */
    public void getNotiBookList(final int page, final String search_str) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("content_key", search_str);
        params.addBodyParameter("pg", page + "");
        params.addBodyParameter("pagesize", 20 + "");
        params.addBodyParameter("publish_time", year + "-" + (month < 10 ? "0" + month : month) + "-" + (day < 10 ? "0" + day : day));
        String httpUrl = NetWorkRequest.GET_NOTEBOOK_LIST;
        CommonHttpRequest.commonRequest(this, httpUrl, NoteBook.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                List<NoteBook> list = (List<NoteBook>) object;
                springView.onFinishFreshAndLoad();

                if (TextUtils.isEmpty(search_str)) {
                    lv_msg.setVisibility(View.VISIBLE);
                    listView_serch.setVisibility(View.GONE);
                    setVaues(list);
                } else {
                    //搜索
                    lv_msg.setVisibility(View.GONE);
                    findViewById(R.id.rea_search).setVisibility(View.VISIBLE);
                    listView_serch.setVisibility(list.size() == 0 ? View.GONE : View.VISIBLE);
                    setLayoutDefaultState(list.size() == 0 ? View.VISIBLE : View.GONE, true);

//                    if (list.size() > 0) {
//                        listView_serch.setAdapter(new NoteBookAdapter(mActivity, list, search_str));
//                    }

                }
//                if (list.size() == 0) {
//                    findViewById(R.id.img_line).setVisibility(View.GONE);
//                } else {
//                    findViewById(R.id.img_line).setVisibility(View.VISIBLE);
//                }
                if(!isFulsh){
                    if (list.size()<20&&msgList.size()!=0){
                        nomore.setVisibility(View.VISIBLE);
                    }else {
                        nomore.setVisibility(View.GONE);
                    }
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                springView.onFinishFreshAndLoad();
                if (TextUtils.isEmpty(search_str)) {
                    pg -= 1;
                    finish();
                }
            }
        });
    }

    /**
     * 设置数据
     *
     * @param list
     */
    public void setVaues(List<NoteBook> list) {
        if (null == msgList) {
            msgList = new ArrayList<>();
        }
        if (isFulsh) {
            msgList = list;
            noteBookAdapter = new NoteBookTodayAdapter(mActivity, msgList, new NoteBookTodayAdapter.ImportantClick() {
                @Override
                public void itemClickImpor(final int positon, final boolean isChcked) {
                    if (isChcked) {
                        putNoteBook(msgList.get(positon).getId(), isChcked, positon);
                        return;
                    }
                    new DialogTips(mActivity, new DiaLogTitleListener() {
                        @Override
                        public void clickAccess(int position) {
                            putNoteBook(msgList.get(positon).getId(), isChcked, positon);

                        }
                    }, "该记事本内容是标记为重要的，确认要取消标记为重要吗？", "确认", DialogTips.CLOSE_TEAM).show();
                }
            });
            lv_msg.setAdapter(noteBookAdapter);
            lv_msg.setSelection(0);
        } else {
            int seletionPositon = list.size() > 0 ? (list.size() + 1) : list.size();
            msgList.addAll(list);
            noteBookAdapter.notifyDataSetChanged();
            lv_msg.setSelection(seletionPositon);
            if (list.size() == 0) {
                pg -= 1;
            }
        }
        if (msgList.size() == 0) {
            setLayoutDefaultState(View.VISIBLE, false);
            lv_msg.setVisibility(View.GONE);
//            findViewById(R.id.rea_search).setVisibility(View.GONE);
            listView_serch.setVisibility(View.GONE);
        } else {
            setLayoutDefaultState(View.GONE, false);
            lv_msg.setVisibility(View.VISIBLE);
//            findViewById(R.id.rea_search).setVisibility(View.VISIBLE);
        }
    }

    /**
     * 更新记事本单条记录
     */
    public void putNoteBook(String id, final boolean is_import, final int position) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", id);
        params.addBodyParameter("is_import", is_import ? "1" : "0");
        CommonHttpRequest.commonRequest(this, NetWorkRequest.PUR_NOTEBOOK, UserInfo.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                msgList.get(position).setIs_import(is_import ? 1 : 0);
                noteBookAdapter.notifyDataSetChanged();
                Intent intent = new Intent(WebSocketConstance.FLUSH_NOTEBOOK);
                intent.putExtra(Constance.BEAN_BOOLEAN, true);
                LocalBroadcastManager.getInstance(mActivity).sendBroadcast(intent);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();

            }
        });
    }

    /**
     * 设置默认页
     *
     * @param visible
     */
    public void setLayoutDefaultState(int visible, boolean isSerach) {
        findViewById(R.id.layout_default).setVisibility(visible);
        if (isSerach) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                findViewById(R.id.img_default).setBackground(ContextCompat.getDrawable(mActivity, R.drawable.no_data));
            } else {
                findViewById(R.id.img_default).setBackgroundResource(R.drawable.no_data);
            }
            ((TextView) findViewById(R.id.tv_default)).setText("未搜索到相关内容");
            ((TextView) findViewById(R.id.tv_default)).setTextSize(14);
            ((TextView) findViewById(R.id.tv_default)).setTextColor(getResources().getColor(R.color.color_b9b9b9));
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                findViewById(R.id.img_default).setBackground(ContextCompat.getDrawable(mActivity, R.drawable.icon_notebook_default));
            } else {
                findViewById(R.id.img_default).setBackgroundResource(R.drawable.icon_notebook_default);
            }
            ((TextView) findViewById(R.id.tv_default)).setText("开始记录你的生活吧…");
            ((TextView) findViewById(R.id.tv_default)).setTextSize(18);
            ((TextView) findViewById(R.id.tv_default)).setTextColor(getResources().getColor(R.color.color_333333));
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUEST && resultCode == Constance.REQUEST) {
            Intent intent = new Intent(WebSocketConstance.FLUSH_NOTEBOOK);
            LocalBroadcastManager.getInstance(mActivity).sendBroadcast(intent);
            //删除，修改，增加
            springView.callFreshDelay();
        }
    }

    /**
     * 注册广播
     */
    private void registerReceiver() {
        IntentFilter filter = new IntentFilter(); //消息接收广播器
        filter.addAction(WebSocketConstance.FLUSH_NOTEBOOK); //刷新记事本列表

        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }

    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            switch (action) {
                case WebSocketConstance.FLUSH_NOTEBOOK: //刷新记事本列表
                    LUtils.e("刷新记事本");
                    //删除，修改，增加
                    if (!intent.getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
                        springView.callFreshDelay();
                    }
                    break;
            }
        }
    }

}
