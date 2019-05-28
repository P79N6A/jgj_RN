package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.VeinRecommendationAdapter;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;

/**
 * 功能:人脉 推荐
 * 时间:2018年1月18日9:50:503
 * 作者:xuj
 */

public class VeinRecommendationActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 当前筛选类型 	1,工人，2班组长，0全部，不传默认是0
     */
    private String type;
    /**
     * 列表适配器
     */
    private VeinRecommendationAdapter adapter;
    /**
     * 我的人脉小红点 当有人脉的时候 显示小红点
     */
    private View isNewFriend;
    /**
     * 分页编码
     */
    private int pgNum = 1;

    /**
     * true表示第一次加载列表数据
     */
    private boolean isFirstLoad = true;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, VeinRecommendationActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview);
        initView();
        getData();
        getFriendApplicationList();
    }

    private void initView() {
        setTextTitleAndRight(R.string.vein_resonce, R.string.more);
        type = SEE_ALL;
//        ImageView rightImageView = getImageView(R.id.rightImage);
//        rightImageView.setImageResource(R.drawable.red_dots);
//        rightImageView.setVisibility(View.VISIBLE);
//        rightImageView.setOnClickListener(this);

        View headView = getLayoutInflater().inflate(R.layout.vein_recommendation_head, null); //添加我的人脉
        isNewFriend = headView.findViewById(R.id.isNewFriend);
        ListView listView = (ListView) findViewById(R.id.listView);
        headView.findViewById(R.id.myVein).setOnClickListener(this);
        headView.findViewById(R.id.refresh_text).setOnClickListener(this);
        listView.addHeaderView(headView, null, false);
    }


    /**
     * 查询列表数据
     */
    public void getData() {
        String httpUrl = NetWorkRequest.RECOMMENDLIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("type", type + ""); //	1,工人，2班组长，0全部，不传默认是0
        params.addBodyParameter("pg", pgNum + "");  //页码
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //每页显示多少条数据
        CommonHttpRequest.commonRequest(this, httpUrl, UserInfo.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<UserInfo> list = (ArrayList<UserInfo>) object;
                setAdapter(list);
                if (isFirstLoad) {
                    isFirstLoad = false;
                    getMineSignInfo();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 查询我的签名信息
     */
    public void getMineSignInfo() {
        String httpUrl = NetWorkRequest.GET_SIGNUP;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        CommonHttpRequest.commonRequest(this, httpUrl, UserInfo.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                UserInfo userInfo = (UserInfo) object;
                /**
                 * 在“人脉资源”界面，用户进入的时候，判断用户是否编写了个性签名，未填写个性签名弹框提示：
                 * 你还未设置自己的个性签名，个性签名会让你的人气爆棚哦！【取消】【去设置】点击跳转到个性签名界面；
                 */
                if (TextUtils.isEmpty(userInfo.getSignature())) {
                    DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(VeinRecommendationActivity.this, null,
                            "你还未设置自己的个性签名，个性签名会让你的人气爆棚哦！", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                        @Override
                        public void clickLeftBtnCallBack() {

                        }

                        @Override
                        public void clickRightBtnCallBack() { //去设置按钮,点击跳转到个性签名界面
                            X5WebViewActivity.actionStart(VeinRecommendationActivity.this, NetWorkRequest.WEBURLS + "my/list");
                        }
                    });
                    dialogLeftRightBtnConfirm.setRightBtnText("去设置");
                    dialogLeftRightBtnConfirm.show();
                }
                if (adapter != null) {
                    adapter.setVerified(userInfo.getVerified() == 3 ? true : false);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    private void setAdapter(List<UserInfo> list) {
        if (adapter == null) {
            ListView listView = (ListView) findViewById(R.id.listView);
            adapter = new VeinRecommendationAdapter(this, list);
            listView.setEmptyView(findViewById(R.id.defaultLayout)); //设置无数据时展示的页面
            listView.setAdapter(adapter); //设置适配器
        } else {
            adapter.updateList(list);//替换数据
        }
        adapter.notifyDataSetChanged();
    }

    private final String SEE_FOREMAN = "2"; //查看班组长
    private final String SEE_WORKER = "1"; //查看工人
    private final String SEE_ALL = "0"; //查看全部


    private List<SingleSelected> getPopwindowItem() {
        List<SingleSelected> list = new ArrayList<>();
        list.add(new SingleSelected("只看班组长", false, false, SEE_FOREMAN));
        list.add(new SingleSelected("只看工人", false, false, SEE_WORKER));
        list.add(new SingleSelected("查看全部", false, false, SEE_ALL));
        list.add(new SingleSelected("取消", false, false, "", Color.parseColor("#999999")));
        return list;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title:
                SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getPopwindowItem(), new SingleSelectedPopWindow.SingleSelectedListener() {
                    @Override
                    public void getSingleSelcted(SingleSelected bean) {
                        switch (bean.getSelecteNumber()) {
                            case SEE_FOREMAN:  //只看班组长
                                type = bean.getSelecteNumber();
                                pgNum = 1;
                                getData();
                                break;
                            case SEE_WORKER:  //只看工人
                                type = bean.getSelecteNumber();
                                pgNum = 1;
                                getData();
                                break;
                            case SEE_ALL:  //查看全部
                                type = bean.getSelecteNumber();
                                pgNum = 1;
                                getData();
                                break;
                        }
                    }
                });
                popWindow.showAtLocation(findViewById(R.id.rootView), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.myVein: //我的人脉
                ContactsActivity.actionStart(this);
                break;
            case R.id.refresh_text: //换一批
                pgNum++;
                getData();
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) {//点击单聊
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (resultCode == Constance.CLICK_GROUP_CHAT) {
            setResult(Constance.CLICK_GROUP_CHAT, data);
            finish();
        } else if (resultCode == Constance.SEND_ADD_FRIEND_SUCCESS) { //发送添加好友后需要改变状态为已发送
            if (adapter != null && adapter.getCount() >= 0 && adapter.getClickItem() != -1) {
                adapter.getItem(adapter.getClickItem()).setSendAddFriend(true);
                adapter.notifyDataSetChanged();
            }
        } else {
            getFriendApplicationList();
        }
    }


    /**
     * 获取申请好友列表
     * 展示小红点使用
     */
    private void getFriendApplicationList() {
        MessageUtil.getTempFriend(this, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                UserInfo friendBean = (UserInfo) object;
                isNewFriend.setVisibility(friendBean != null && !TextUtils.isEmpty(friendBean.getReal_name()) ? View.VISIBLE : View.GONE);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }
}
