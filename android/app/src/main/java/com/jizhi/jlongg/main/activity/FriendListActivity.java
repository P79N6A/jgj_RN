package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.CallPhoneUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.FriendAdapter;
import com.jizhi.jlongg.main.bean.FriendBean;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.PinYin2Abbreviation;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * 功能: 好友列表
 * 时间:2016/3/11 11:19
 * 作者: xuj
 */
public class FriendListActivity extends BaseActivity implements Runnable {
    /**
     * listView
     */
    @ViewInject(R.id.listview)
    private ListView listView;

    /**
     * 右侧 a.b.c.d搜索框
     */
    @ViewInject(R.id.sidrbar)
    private SideBar sideBar;

    /**
     * 模糊搜索框中间显示的文字
     */
    @ViewInject(R.id.center_text)
    private TextView center_text;

    private FriendAdapter adapter;

    private List<FriendBean> list;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.friend_list);
        ViewUtils.inject(this);//Xutil必须调用的一句话
        init();
    }


    public void init() {
        startRunnable();
        sideBar.setTextView(center_text);
        // 设置右侧触摸监听
        sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() {
            @Override
            public void onTouchingLetterChanged(String s) {
                if (adapter != null) {
                    //该字母首次出现的位置
                    int position = adapter.getPositionForSection(s.charAt(0));
                    if (position != -1) {
                        listView.setSelection(position);
                    }
                }
            }
        });
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                FriendBean friend = list.get(position);
                CallPhoneUtil.callPhone(FriendListActivity.this, friend.getTelph());
            }
        });
    }


    public void startRunnable() {
        new Thread(this).start();
    }

    private String friend_number;

    @Override
    public void run() {
        Intent intent = getIntent();
        friend_number = intent.getStringExtra(Constance.BEAN_STRING); //好友个数
        list = (List<FriendBean>) intent.getSerializableExtra(Constance.BEAN_ARRAY);
        mHandler.sendEmptyMessage(Constance.LOADING);
        List<FriendBean> tempList = list;
        for (FriendBean bean : tempList) {
            bean.setSortLetters(PinYin2Abbreviation.getPingYin(bean.getFriendname().substring(0, 1)).toUpperCase());
        }
        mHandler.sendEmptyMessage(Constance.SUCCESS);
    }

    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case Constance.SUCCESS:
                    Collections.sort(list, new SortList());
                    adapter = new FriendAdapter(FriendListActivity.this, list);
                    listView.setAdapter(adapter);
                    closeDialog();
                    break;
                case Constance.LOADING:
                    CustomProgress customProgress = new CustomProgress(FriendListActivity.this);
                    customProgress.show(FriendListActivity.this, "正在为你加载好友列表!", false);
                    SetTitleName.setTitle(findViewById(R.id.title), String.format(getString(R.string.friend_size), friend_number));
                    break;
                default:
                    break;
            }
            super.handleMessage(msg);
        }
    };


    public class SortList implements Comparator<FriendBean> {
        @Override
        public int compare(FriendBean lhs, FriendBean rhs) {
            if (TextUtils.isEmpty(lhs.getSortLetters())) {
                return -1;
            }
            if (TextUtils.isEmpty(rhs.getSortLetters())) {
                return -1;
            }
            char a = lhs.getSortLetters().charAt(0);
            char b = rhs.getSortLetters().charAt(0);
            return a - b;
        }
    }

}
