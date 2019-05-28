package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.FaceToFaceMembersManagerAdapter;
import com.jizhi.jlongg.main.adpter.NumberKeyBoardAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * CName:面对面建群
 * User: xuj
 * Date: 2016-12-20
 * Time: 9:53:21
 */
public class FaceToFaceCreateTeamActivity extends BaseActivity implements View.OnClickListener {


    /**
     * 键盘GridView
     */
    private GridView numberGridView;
    /**
     * 数字1
     */
    private TextView firstNumber;
    /**
     * 数字2
     */
    private TextView secondNumber;
    /**
     * 数字3
     */
    private TextView threeNumber;
    /**
     * 数字4
     */
    private TextView fourNumber;
    /**
     * 循环定时器，加载群成员列表数据
     */
    private ScheduledExecutorService scheduledExecutorService;
    /**
     * 列表适配器
     */
    private FaceToFaceMembersManagerAdapter adapter;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, FaceToFaceCreateTeamActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.face_to_face_create_team);
        initView();
    }


    /**
     * 初始化View
     */
    private void initView() {
        setTextTitle(R.string.face_to_face_create_team);
        firstNumber = getTextView(R.id.firstNumber);
        secondNumber = getTextView(R.id.secondNumber);
        threeNumber = getTextView(R.id.threeNumber);
        fourNumber = getTextView(R.id.fourNumber);
        getButton(R.id.red_btn).setText("进入群聊");
        findViewById(R.id.head).setBackgroundColor(getResources().getColor(R.color.color_1e1e1e));
        setKeyBoardView();
    }

    /**
     * 设置键盘GridView数据
     */
    private void setKeyBoardView() {
        final List<String> keyboardList = getKeyBoardData();
        numberGridView = (GridView) findViewById(R.id.gridView);
        NumberKeyBoardAdapter adapter = new NumberKeyBoardAdapter(this, keyboardList);
        numberGridView.setAdapter(adapter);
        numberGridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String keyboard = keyboardList.get(position);
                if (TextUtils.isEmpty(keyboard)) {
                    return;
                }
                if (keyboard.equals("删除")) {
                    if (!TextUtils.isEmpty(fourNumber.getText().toString())) {  //删除第一个数字
                        fourNumber.setText("");
                        return;
                    }
                    if (!TextUtils.isEmpty(threeNumber.getText().toString())) { //删除第二个数字
                        threeNumber.setText("");
                        return;
                    }
                    if (!TextUtils.isEmpty(secondNumber.getText().toString())) { //删除第三个数字
                        secondNumber.setText("");
                        return;
                    }
                    if (!TextUtils.isEmpty(firstNumber.getText().toString())) { //删除第四个数字
                        firstNumber.setText("");
                        return;
                    }
                } else {
                    if (TextUtils.isEmpty(firstNumber.getText().toString())) { //设置第一个数字
                        firstNumber.setText(keyboard);
                        return;
                    }
                    if (TextUtils.isEmpty(secondNumber.getText().toString())) {//设置第二个数字
                        secondNumber.setText(keyboard);
                        return;
                    }
                    if (TextUtils.isEmpty(threeNumber.getText().toString())) {//设置第三个数字
                        threeNumber.setText(keyboard);
                        return;
                    }
                    if (TextUtils.isEmpty(fourNumber.getText().toString())) {//设置第四个数字
                        fourNumber.setText(keyboard);
                    }
                    if (!TextUtils.isEmpty(fourNumber.getText().toString())) { //如果不为4
                        byCodeGetMember(firstNumber.getText().toString() + secondNumber.getText().toString() + threeNumber.getText().toString() + fourNumber.getText().toString());
                    }
                }
            }
        });
    }

    /**
     * 开启动画
     */
    private void startAnimation() {
        findViewById(R.id.bottomText).setVisibility(View.VISIBLE);
        final TextView topText = (TextView) findViewById(R.id.topText);
        int moveDistance = topText.getHeight();
        numberGridView.setVisibility(View.GONE);
        ResizeAnimation animation = new ResizeAnimation(topText);
        animation.setParams(moveDistance, numberGridView.getHeight());
        animation.setDuration(500);
        animation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
            }

            @Override
            public void onAnimationEnd(Animation animation) {
                topText.setVisibility(View.GONE); //隐藏 和身边的朋友输入相同的数字进入同一个群聊 文字
                numberGridView.setVisibility(View.GONE); //隐藏键盘GridView
                findViewById(R.id.memebersLayout).setVisibility(View.VISIBLE);//显示成员列表
                startSchedueld();
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        topText.startAnimation(animation);
    }

    /**
     * 获取键盘数据
     *
     * @return
     */
    private List<String> getKeyBoardData() {
        List<String> number = new ArrayList<>();
        number.add("1");
        number.add("2");
        number.add("3");
        number.add("4");
        number.add("5");
        number.add("6");
        number.add("7");
        number.add("8");
        number.add("9");
        number.add("");
        number.add("0");
        number.add("删除");
        return number;
    }

    /**
     * 我们这里开启一个定时器每隔5秒去加载一下列表数据,如果有新的成员加入那么则重新获取列表数据
     */
    private void startSchedueld() {
        //用一个定时器  来完成图片切换
        scheduledExecutorService = Executors.newSingleThreadScheduledExecutor();
//        //通过定时器 来完成 每2秒钟切换一个图片
//        //经过指定的时间后，执行所指定的任务
//        //scheduleAtFixedRate(command, initialDelay, period, unit)
//        //command 所要执行的任务
//        //initialDelay 第一次启动时 延迟启动时间
//        //period  每间隔多次时间来重新启动任务
//        //unit 时间单位
        scheduledExecutorService.scheduleAtFixedRate(new Runnable() {
            @Override
            public void run() {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        String code = firstNumber.getText().toString() + secondNumber.getText().toString() + threeNumber.getText().toString() + fourNumber.getText().toString();
                        byCodeGetMember(code);
                    }
                });
            }
        }, 5, 5, TimeUnit.SECONDS);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (scheduledExecutorService != null) {
            LUtils.e("关闭面对面建群定时器");
            scheduledExecutorService.shutdown();
        }
    }

    /**
     * 面对面建群 根据验证码获取成员数量
     *
     * @param code
     */
    private void byCodeGetMember(String code) {
        String httpUrl = NetWorkRequest.FACE_TO_FACE_BY_CODE_GET_INFO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("code", code); //验证码标识
        CommonHttpRequest.commonRequest(FaceToFaceCreateTeamActivity.this, httpUrl, GroupMemberInfo.class, CommonHttpRequest.LIST, params,
                adapter == null ? true : false, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        ArrayList<GroupMemberInfo> memberInfos = (ArrayList<GroupMemberInfo>) object;
                        if (adapter == null) {
                            adapter = new FaceToFaceMembersManagerAdapter(FaceToFaceCreateTeamActivity.this, memberInfos);
                            GridView gridView = (GridView) findViewById(R.id.memebersGridView);
                            gridView.setAdapter(adapter);
                            startAnimation();
                        } else {
                            adapter.updateListView(memberInfos);
                        }
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {

                    }
                });

    }

    @Override
    public void onClick(View v) {
        //根据验证码创建或加入群聊
        String code = firstNumber.getText().toString() + secondNumber.getText().toString() + threeNumber.getText().toString() + fourNumber.getText().toString();
        MessageUtil.createGroupChat(this, null, code, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupDiscussionInfo groupDiscussionInfo = (GroupDiscussionInfo) object;
                //我们将新创建的班组存储在数据库中
                MessageUtil.addTeamOrGroupToLocalDataBase(FaceToFaceCreateTeamActivity.this, null, groupDiscussionInfo, true);
                Intent intent = getIntent();
                intent.putExtra(Constance.BEAN_CONSTANCE, groupDiscussionInfo);
                setResult(MessageUtil.WAY_CREATE_GROUP_CHAT, intent);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });

    }

    public class ResizeAnimation extends Animation {

        private int endHeight; // distance between start and end height
        /* 视图 */
        private View view;
        /* 和身边的朋友输入相同的数字进入同一个群聊文字高度  */
        private int viewHeight;


        /**
         * constructor, do not forget to use the setParams(int, int) method before
         * starting the animation
         *
         * @param v
         */
        public ResizeAnimation(View v) {
            this.view = v;
            this.viewHeight = v.getHeight();
        }

        @Override
        protected void applyTransformation(float interpolatedTime, Transformation t) {
            LinearLayout.LayoutParams textParams = (LinearLayout.LayoutParams) view.getLayoutParams();
            textParams.height = (int) (viewHeight - endHeight * interpolatedTime);
            view.setLayoutParams(textParams);
        }

        /**
         * set the starting and ending height for the resize animation
         * starting height is usually the views current height, the end height is the height
         * we want to reach after the animation is completed
         */
        public void setParams(int endHeight, int gridViewHeight) {
            this.endHeight = endHeight;
        }


        @Override
        public boolean willChangeBounds() {
            return true;
        }
    }


}
