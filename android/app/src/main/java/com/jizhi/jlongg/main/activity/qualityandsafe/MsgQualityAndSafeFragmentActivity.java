package com.jizhi.jlongg.main.activity.qualityandsafe;


import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.MsgQualityAndSafeFilterActivity;
import com.jizhi.jlongg.main.activity.PayHintActivity;
import com.jizhi.jlongg.main.activity.RectificationInstructionsActivity;
import com.jizhi.jlongg.main.activity.ReleaseQualityAndSafeActivity;
import com.jizhi.jlongg.main.activity.ReplyMsgQualityAndSafeActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.adpter.MainMangerViewPager;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.QuqlityAndSafeBean;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.NestRadioGroup;

import java.util.ArrayList;

import static com.jizhi.jlongg.R.id.tv_toact;


/**
 * CName:质量，安全列表，检查页父类 2.3.0
 * User: hcs
 * Date: 2017-07-13
 * Time: 09:40
 */

public class MsgQualityAndSafeFragmentActivity extends BaseActivity implements NestRadioGroup.OnCheckedChangeListener, View.OnClickListener {
    private MsgQualityAndSafeFragmentActivity mActivity;
    //当前选中的子项下标
    private int currentIndex;
    //子项pager
    private ViewPager mPageVp;
    /* Fragment 集合 */
    private ArrayList<Fragment> fragments;
    //消息类型
    private String msgType;
    //项目组班组信息
    private GroupDiscussionInfo gnInfo;
    //是否是会员
//    public int vip;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_quality_and_safe_230);
        initView();
        registerFinishActivity();
        getIntentData();
        setDefaultContent();
        iniFragment();
        registerReceiver();
        findViewById(R.id.lin_send).setOnClickListener(this);
        findViewById(R.id.right_image_filter).setOnClickListener(this);
        findViewById(R.id.right_image_statistics).setOnClickListener(this);

    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String msgType) {
        Intent intent = new Intent(context, MsgQualityAndSafeFragmentActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.MSG_TYPE, msgType);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = MsgQualityAndSafeFragmentActivity.this;
        mPageVp = (ViewPager) findViewById(R.id.mPageVp);
        ((NestRadioGroup) findViewById(R.id.guide_rg)).setOnCheckedChangeListener(this);
    }

    /**
     * 初始化Fragment
     */
    public void iniFragment() {
        QualityAndSafeQuestionFragment fragment1 = new QualityAndSafeQuestionFragment();
        QualityAndSafeCheckFragment fragment2 = new QualityAndSafeCheckFragment();
        fragments = new ArrayList<>();
        fragments.add(fragment1);
        fragments.add(fragment2);
        mPageVp.setAdapter(new MainMangerViewPager(getSupportFragmentManager(), fragments));
        mPageVp.setCurrentItem(currentIndex);
        mPageVp.setOnPageChangeListener(onPageChangeListener);

    }

    public int getCurrentIndex() {
        return currentIndex;
    }

    public void setCurrentIndex(int currentIndex) {
        this.currentIndex = currentIndex;
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
//        vip = gnInfo.getIs_senior();
        msgType = getIntent().getStringExtra(Constance.MSG_TYPE);
        if (TextUtils.isEmpty(msgType)) {
            CommonMethod.makeNoticeLong(mActivity, "消息类型错误", CommonMethod.SUCCESS);
            finish();
            return;
        }
        if (gnInfo.getIs_closed() == 1) {
            findViewById(R.id.img_close).setVisibility(View.VISIBLE);
            if (gnInfo.getClass_type().equals(WebSocketConstance.TEAM)) {
                Utils.setBackGround(findViewById(R.id.img_close), getResources().getDrawable(R.drawable.team_closed_icon));
            } else {
                Utils.setBackGround(findViewById(R.id.img_close), getResources().getDrawable(R.drawable.group_closed_icon));
            }
        }

        LUtils.e("---------------------:" + gnInfo.getIs_closed());
        if (gnInfo.getIs_closed() == 1) {
            findViewById(R.id.lin_send).setVisibility(View.GONE);
        }

    }

    /**
     * 设置缺省页
     */
    private void setDefaultContent() {
        TextView tv_toact = (TextView) findViewById(R.id.tv_toact);
        if (msgType.equals(MessageType.MSG_QUALITY_STRING)) {
            ((RadioButton) findViewById(R.id.rb_question)).setText(getString(R.string.quality_question));
            ((RadioButton) findViewById(R.id.rb_check)).setText(getString(R.string.quality_check));
            if (currentIndex == 0) {
                tv_toact.setText(getString(R.string.release_quality_question));
                return;
            }
            tv_toact.setText(getString(R.string.release_check));
        } else if (msgType.equals(MessageType.MSG_SAFE_STRING)) {
            ((RadioButton) findViewById(R.id.rb_question)).setText(getString(R.string.safe_question));
            ((RadioButton) findViewById(R.id.rb_check)).setText(getString(R.string.safe_check));
            if (currentIndex == 0) {
                tv_toact.setText(getString(R.string.release_safe_question));
                return;
            }
            tv_toact.setText(getString(R.string.release_check));
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.lin_send:
                //发布
                if (MessageUtils.isCloseGroupAndTeam(gnInfo, mActivity)) {
                    return;
                }
                switch (msgType) {
                    case MessageType.MSG_SAFE_STRING:
                        onClickSafe();
                        break;
                    case MessageType.MSG_QUALITY_STRING:
                        onClickQuality();
                        break;
                }
                break;
            case R.id.right_image_filter:
                //铃铛🔔
                ((ImageView) findViewById(R.id.right_image_filter)).setImageResource(R.drawable.icon_quality_msg);
                ReplyMsgQualityAndSafeActivity.actionStart(mActivity, gnInfo, msgType);
                break;
            case R.id.right_image_statistics:
                if (gnInfo.getIs_senior() == 0) {
                    if (msgType.equals(MessageType.MSG_QUALITY_STRING)) {
                        //质量统计
                        PayHintActivity.actionStart(mActivity, "质量统计", gnInfo.getGroup_id(), gnInfo.getIs_buyed(), NetWorkRequest.HELPDETAIL + 104);
                    } else if (msgType.equals(MessageType.MSG_SAFE_STRING)) {
                        //安全统计
                        PayHintActivity.actionStart(mActivity, "安全统计", gnInfo.getGroup_id(), gnInfo.getIs_buyed(), NetWorkRequest.HELPDETAIL + 103);
                    }
                    return;
                }
                //统计
                String uri = NetWorkRequest.STCHARTS + "group_id=" + gnInfo.getGroup_id() + "&class_type=" + gnInfo.getClass_type() + "&msg_type=" + msgType;
                X5WebViewActivity.actionStart(mActivity, uri);
                break;

        }
    }

    /**
     * 质量进度
     */
    public void onClickQuality() {
        if (currentIndex == 0) {
            ReleaseQualityAndSafeActivity.actionStart(mActivity, gnInfo, MessageType.MSG_QUALITY_STRING, null);
        } else {
            ReleaseCheckQualityAndSafeActivity.actionStart(mActivity, gnInfo, MessageType.MSG_QUALITY_STRING);
        }
    }

    /**
     * 安全隐患
     */
    public void onClickSafe() {
        if (currentIndex == 0) {
            ReleaseQualityAndSafeActivity.actionStart(mActivity, gnInfo, MessageType.MSG_SAFE_STRING, null);
        } else {
            ReleaseCheckQualityAndSafeActivity.actionStart(mActivity, gnInfo, MessageType.MSG_SAFE_STRING);
        }
    }

    @Override
    public void onCheckedChanged(NestRadioGroup group, int checkedId) {
        switch (checkedId) {
            case R.id.rb_question:
                if (currentIndex == 0 || gnInfo.getIs_closed() == 1) {
                    return;
                }
                findViewById(R.id.lin_send).setVisibility(View.VISIBLE);
                currentIndex = 0;
                findViewById(R.id.view_question_red_circle).setVisibility(View.GONE);
                mPageVp.setCurrentItem(currentIndex, true);
                if (msgType.equals(MessageType.MSG_QUALITY_STRING)) {
                    ((TextView) findViewById(tv_toact)).setText(getString(R.string.release_quality_question));
                } else if (msgType.equals(MessageType.MSG_SAFE_STRING)) {
                    ((TextView) findViewById(tv_toact)).setText(getString(R.string.release_safe_question));
                }
                break;
            case R.id.rb_check:
                if (currentIndex == 1 || gnInfo.getIs_closed() == 1) {
                    return;
                }
                if (gnInfo.getIs_senior() == 0) {
                    findViewById(R.id.lin_send).setVisibility(View.GONE);
                } else {
                    findViewById(R.id.lin_send).setVisibility(View.VISIBLE);
                }

                findViewById(R.id.view_check_red_circle).setVisibility(View.GONE);

                currentIndex = 1;
                mPageVp.setCurrentItem(currentIndex, true);
                ((TextView) findViewById(tv_toact)).setText(getString(R.string.release_check));

                break;
        }
    }

    ViewPager.OnPageChangeListener onPageChangeListener = new ViewPager.OnPageChangeListener() {
        @Override
        public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

        }

        @Override
        public void onPageSelected(int position) {
            resetTextView();
            switch (position) {
                case 0:
                    ((RadioButton) findViewById(R.id.rb_question)).setChecked(true);
                    if (msgType.equals(MessageType.MSG_QUALITY_STRING)) {
                        ((TextView) findViewById(R.id.tv_toact)).setText(getString(R.string.release_quality_question));
                    } else if (msgType.equals(MessageType.MSG_SAFE_STRING)) {
                        ((TextView) findViewById(R.id.tv_toact)).setText(getString(R.string.release_safe_question));
                    }
                    break;
                case 1:
                    ((RadioButton) findViewById(R.id.rb_check)).setChecked(true);
                    ((TextView) findViewById(R.id.tv_toact)).setText(getString(R.string.release_check));
                    break;
            }
            currentIndex = position;
        }

        @Override
        public void onPageScrollStateChanged(int state) {

        }
    };

    /**
     * 重置颜色
     */
    private void resetTextView() {
        switch (currentIndex) {
            case 0:
                ((RadioButton) findViewById(R.id.rb_question)).setChecked(false);
                break;
            case 1:
                ((RadioButton) findViewById(R.id.rb_question)).setChecked(false);
                break;
            default:
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);


        if (requestCode == Constance.REQUESTCODE_START && (resultCode == Constance.RESULTCODE_FINISH || resultCode == RectificationInstructionsActivity.FINISH)) {
            if (currentIndex == 0) {
                QualityAndSafeQuestionFragment questionFragment = (QualityAndSafeQuestionFragment) fragments.get(0);
                questionFragment.onClick(findViewById(R.id.tv_top_all));
            } else {
                QualityAndSafeCheckFragment checkFragment = (QualityAndSafeCheckFragment) fragments.get(1);
                checkFragment.onClick(findViewById(R.id.tv_top_alls));
            }
        } else if (requestCode == Constance.REQUESTCODE_START && resultCode == MsgQualityAndSafeFilterActivity.FINISHFILTE) {
            //筛选回调
            QuqlityAndSafeBean bean = (QuqlityAndSafeBean) data.getSerializableExtra(MsgQualityAndSafeFilterActivity.FILTERBEAN);
            if (bean != null) {
                if (currentIndex == 0) {
                    QualityAndSafeQuestionFragment questionFragment = (QualityAndSafeQuestionFragment) fragments.get(0);
                    questionFragment.onFilterRefresh(bean);
                } else {
                    QualityAndSafeCheckFragment checkFragment = (QualityAndSafeCheckFragment) fragments.get(1);
                    checkFragment.onFilterRefresh(bean);
                }
            }
        } else if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.SELECTED_ACTOR) {
            finish();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //查看订单
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //返回首页
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        } else if (requestCode == Constance.REQUEST_WEB && resultCode == Constance.REQUEST_WEB) {
            QualityAndSafeCheckFragment checkFragment = (QualityAndSafeCheckFragment) fragments.get(1);
            checkFragment.donateSeniorCloudSuccess();
            gnInfo.setIs_senior(1);
            //统计
            String uri = NetWorkRequest.STCHARTS + "group_id=" + gnInfo.getGroup_id() + "&class_type=" + gnInfo.getClass_type() + "&msg_type=" + msgType;
            X5WebViewActivity.actionStart(mActivity, uri);
        }
    }

    @Override
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }


    /**
     * 注册广播
     */
    private void registerReceiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(WebSocketConstance.RECIVEMESSAGE);
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(WebSocketConstance.RECIVEMESSAGE)) {
                //接收到群组消息回执
                MessageEntity bean = (MessageEntity) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                LUtils.e(gnInfo.getGroup_id() + "，，，，" + gnInfo.getClass_type() + "-----------------bean---------" + new Gson().toJson(bean));
                if (null == bean.getGroup_id() || bean.getGroup_id().equals("0")) {
                    return;
                }
                //是否是本组收到的消息
                if (!bean.getGroup_id().equals(gnInfo.getGroup_id()) || !bean.getClass_type().equals(gnInfo.getClass_type())) {
                    return;
                }
                if (MessageType.MESSAGE_TYPE_REPLY_QUALITY.equals(bean.getMsg_type()) || MessageType.MESSAGE_TYPE_REPLY_SAFE.equals(bean.getMsg_type())) {
                    //小铃铛🔔图片
                    getImageView(R.id.right_image_filter).setImageResource(R.drawable.icon_quality_msg_red);
                }
            }
        }
    }
}
