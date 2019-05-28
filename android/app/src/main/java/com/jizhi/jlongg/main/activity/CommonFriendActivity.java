package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.SelectProjectPeopleAdapter;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.SetTitleName;

import java.io.Serializable;
import java.util.List;

/**
 * 功能: 共同好友
 * 时间:2018/1/19 1:19
 * 作者:hcs
 */
public class CommonFriendActivity extends BaseActivity {
    private CommonFriendActivity mActivity;
    private List<GroupMemberInfo> common_friends;


    /**
     * 清除星星图片内存
     */
    public void onFinish(View view) {
        finish();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_release_userinfo);
        mActivity = CommonFriendActivity.this;
        getIntentData();
        ListView listView = (ListView) findViewById(R.id.listView);
        findViewById(R.id.tv_commonfriend).setVisibility(View.VISIBLE);
        for (int i = 0; i < common_friends.size(); i++) {
            common_friends.get(i).setIs_active(1);
        }
        SelectProjectPeopleAdapter adapter = new SelectProjectPeopleAdapter(mActivity, common_friends);
        listView.setAdapter(adapter);
        findViewById(R.id.sidrbar).setVisibility(View.GONE);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                ChatUserInfoActivity.actionStart(mActivity, common_friends.get(position).getUid());
            }
        });
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, List<GroupMemberInfo> common_friends, String nick_name) {
        Intent intent = new Intent(context, CommonFriendActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, (Serializable) common_friends);
        intent.putExtra(Constance.NICKNAME, nick_name);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        common_friends = (List<GroupMemberInfo>) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        String name = getIntent().getStringExtra(Constance.NICKNAME);
        if (!TextUtils.isEmpty(name)) {
            SetTitleName.setTitle(findViewById(R.id.title), "我和" + name);
        } else {
            SetTitleName.setTitle(findViewById(R.id.title), "共同好友");
        }

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        }
    }
}


