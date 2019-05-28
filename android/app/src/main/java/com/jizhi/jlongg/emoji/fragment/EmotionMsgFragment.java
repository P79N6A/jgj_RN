package com.jizhi.jlongg.emoji.fragment;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.Toast;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.emoji.adapter.HorizontalRecyclerviewAdapter;
import com.jizhi.jlongg.emoji.adapter.ImageModel;
import com.jizhi.jlongg.emoji.adapter.NoHorizontalScrollerVPAdapter;
import com.jizhi.jlongg.emoji.emotionkeyboard.BarClickLintener;
import com.jizhi.jlongg.emoji.emotionkeyboard.EmotionKeyboard;
import com.jizhi.jlongg.emoji.emotionkeyboard.NoHorizontalScrollerViewPager;
import com.jizhi.jlongg.emoji.utils.EmotionUtils;
import com.jizhi.jlongg.emoji.utils.GlobalOnItemClickManagerMsgUtils;
import com.jizhi.jlongg.emoji.utils.SharedPreferencedUtils;
import com.jizhi.jlongg.main.activity.AtMemberListActivity;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.recoed.manager.AudioRecordMessageButton.AudioRecordMessageButton;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.jizhi.jongg.widget.ChatPrimaryMenuBase;
import com.lidroid.xutils.view.annotation.ViewInject;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import me.nereo.multi_image_selector.MultiImageSelectorFragment;
import me.nereo.multi_image_selector.utils.FileUtils;

/**
 * Created by zejian
 * Time  16/1/6 下午5:26
 * Email shinezejian@163.com
 * Description:表情主界面
 */
public class EmotionMsgFragment extends BaseFragmentMsg implements View.OnClickListener {

    //是否绑定当前Bar的编辑框的flag
    public static final String BIND_TO_EDITTEXT = "bind_to_edittext";
    //当前被选中底部tab
    private static final String CURRENT_POSITION_FLAG = "CURRENT_POSITION_FLAG";
    private int CurrentPosition = 0;
    //底部水平tab
    private RecyclerView recyclerview_horizontal;
    private HorizontalRecyclerviewAdapter horizontalRecyclerviewAdapter;
    //表情面板
    private EmotionKeyboard mEmotionKeyboard;
    /**
     * 键盘管理
     */
    protected InputMethodManager inputManager;

    //需要绑定的内容view
    private View contentView;

    //不可横向滚动的ViewPager
    private NoHorizontalScrollerViewPager viewPager;

    //是否绑定当前Bar的编辑框,默认true,即绑定。
    //false,则表示绑定contentView,此时外部提供的contentView必定也是EditText
    private boolean isBindToBarEditText = true;
    /**
     * 文字文本框
     */
    public EditText etMessage;
    /**
     * 按住说话
     */
    private View buttonSetModeKeyboard;
    /**
     * 语音按钮
     */
    private View buttonSetModeVoice;
    /**
     * 录音按钮
     */
    private AudioRecordMessageButton buttonPressToSpeak;
    /**
     * 发送消息
     */
    @ViewInject(R.id.btn_sendTextmsg)
    private Button btn_sendTextmsg;
    private RadioButton btn_pic;
    private ImageView btn_more;
    private ImageView emotion_button;
    /**
     * 底部拍照布局
     */
    public LinearLayout lin_msg_bottom;

    public void setClickKeyBoardClickListner(EmotionKeyboard.ClickKeyBoardClickListner clickKeyBoardClickListner) {
        this.clickKeyBoardClickListner = clickKeyBoardClickListner;
    }

    /**
     * 聊天主按钮回调
     */

    private EmotionKeyboard.ClickKeyBoardClickListner clickKeyBoardClickListner;
    protected ChatPrimaryMenuBase.EaseChatPrimaryMenuListener listener;
    /*群组信息 */
    protected GroupDiscussionInfo gnInfo;


    List<Fragment> fragments = new ArrayList<>();

    /**
     * set primary menu listener
     *
     * @param listener
     */
    public void setChatPrimaryMenuListener(ChatPrimaryMenuBase.EaseChatPrimaryMenuListener listener, GroupDiscussionInfo gnInfo) {
        this.listener = listener;
        this.gnInfo = gnInfo;
    }

    public EditText getEtMessage() {
        return etMessage;
    }


    /**
     * 创建与Fragment对象关联的View视图时调用
     *
     * @param inflater
     * @param container
     * @param savedInstanceState
     * @return
     */
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_msg_emotion, container, false);
//        isHidenBarEditPic = args.getBoolean(EmotionMsgFragment.HIDE_BAR_EDIT_PIC);
        //获取判断绑定对象的参数
        isBindToBarEditText = args.getBoolean(EmotionMsgFragment.BIND_TO_EDITTEXT);

        initView(rootView);
        mEmotionKeyboard = EmotionKeyboard.with(getActivity(), clickKeyBoardClickListner)
                .setEmotionView(rootView.findViewById(R.id.ll_emotion_layout))//绑定表情面板
                .bindToLayoutView(rootView)
                .bindToContent(contentView)//绑定内容view
                .bindToEditText(!isBindToBarEditText ? ((EditText) contentView) : ((EditText) rootView.findViewById(R.id.et_message)))//判断绑定那种EditView
                .bindToEmotionButton(emotion_button)//绑定表情按钮
                .build();
        initListener();
        initDatas();
        //创建全局监听
        GlobalOnItemClickManagerMsgUtils globalOnItemClickManager = GlobalOnItemClickManagerMsgUtils.getInstance(getActivity());

        if (isBindToBarEditText) {
            //绑定当前Bar的编辑框
            globalOnItemClickManager.attachToEditText(etMessage);

        } else {
            // false,则表示绑定contentView,此时外部提供的contentView必定也是EditText
            globalOnItemClickManager.attachToEditText((EditText) contentView);
            mEmotionKeyboard.bindToEditText((EditText) contentView);
        }
        return rootView;
    }

    /**
     * 还原表情按钮图片
     */
    public void setImageButtonBck() {
        emotion_button.setImageResource(R.drawable.icon_emoji);

    }

    /**
     * 键盘弹出
     */
    public void keyBoradShow() {
        mEmotionKeyboard.keyBoradShow();
    }


    /**
     * 绑定内容view
     *
     * @param contentView
     * @return
     */
    public void bindToContentView(View contentView) {
        this.contentView = contentView;
    }


    /**
     * 初始化view控件
     */
    protected void initView(View rootView) {
        inputManager = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
        viewPager = rootView.findViewById(R.id.vp_emotionview_layout);
        recyclerview_horizontal = rootView.findViewById(R.id.recyclerview_horizontal);
        etMessage = rootView.findViewById(R.id.et_message);
        buttonSetModeKeyboard = rootView.findViewById(R.id.btn_set_mode_keyboard);
        buttonSetModeVoice = rootView.findViewById(R.id.btn_set_mode_voice);
        buttonPressToSpeak = rootView.findViewById(R.id.btn_press_to_speak);
        btn_sendTextmsg = rootView.findViewById(R.id.btn_sendTextmsg);
        emotion_button = rootView.findViewById(R.id.emotion_button);
        lin_msg_bottom = rootView.findViewById(R.id.lin_msg_bottom);
        btn_pic = rootView.findViewById(R.id.btn_pic);
        btn_more = rootView.findViewById(R.id.btn_more);
        buttonSetModeKeyboard.setOnClickListener(this);
        buttonSetModeVoice.setOnClickListener(this);
        btn_sendTextmsg.setOnClickListener(this);
        btn_sendTextmsg.setOnClickListener(this);
        btn_pic.setOnClickListener(this);
        rootView.findViewById(R.id.btn_camera).setOnClickListener(this);
        rootView.findViewById(R.id.btn_info).setOnClickListener(this);
        rootView.findViewById(R.id.btn_more).setOnClickListener(this);
        etMessage.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (TextUtils.isEmpty(s)) {
                    btn_sendTextmsg.setVisibility(View.GONE);
                    btn_more.setVisibility(View.VISIBLE);
                } else {
                    btn_sendTextmsg.setVisibility(View.VISIBLE);
                    btn_more.setVisibility(View.GONE);
                }
                if (before != 1 && start < s.length() && String.valueOf(s.charAt(start)).equals("@") && count == 1) {
                    if (!gnInfo.getClass_type().equals(WebSocketConstance.SINGLECHAT)) {
                        Intent intent = new Intent(getActivity(), AtMemberListActivity.class);
                        intent.putExtra(Constance.GROUP_ID, gnInfo.getGroup_id());
                        intent.putExtra("mySelfGroup", gnInfo.getCan_at_all());
                        intent.putExtra(Constance.CLASSTYPE, gnInfo.getClass_type());
                        getActivity().startActivityForResult(intent, Constance.PERSON);

                        LUtils.e("-------gnInfo.getCan_at_all()--------------" + gnInfo.getCan_at_all());

                    }


                }
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });

        //录音完成后的监听
        buttonPressToSpeak.setAudioFinishRecorderListener(new AudioRecordMessageButton.AudioFinishRecorderListener() { //录音结束回调
            @Override
            public void onFinished(float seconds, String filePath) {
                if (seconds < 1) {
                    return;
                }
                listener.onVoicefinish(seconds, filePath);
            }
        });
    }

    /**
     * 初始化监听器
     */
    protected void initListener() {

    }

    /**
     * 数据操作,这里是测试数据，请自行更换数据
     */
    protected void initDatas() {
        replaceFragment();
        List<ImageModel> list = new ArrayList<>();
        for (int i = 0; i < fragments.size(); i++) {
            if (i == 0) {
                ImageModel model1 = new ImageModel();
                model1.icon = getResources().getDrawable(R.drawable.icon_emoji);
                model1.flag = "经典笑脸";
                model1.isSelected = true;
                list.add(model1);
            } else {
                ImageModel model = new ImageModel();
                model.icon = getResources().getDrawable(R.drawable.icon_emoji);
                model.flag = "其他笑脸" + i;
                model.isSelected = false;
                list.add(model);
            }
        }

        //记录底部默认选中第一个
        CurrentPosition = 0;
        SharedPreferencedUtils.setInteger(getActivity(), CURRENT_POSITION_FLAG, CurrentPosition);

        //底部tab
        horizontalRecyclerviewAdapter = new HorizontalRecyclerviewAdapter(getActivity(), list);
        recyclerview_horizontal.setHasFixedSize(true);//使RecyclerView保持固定的大小,这样会提高RecyclerView的性能
        recyclerview_horizontal.setAdapter(horizontalRecyclerviewAdapter);
        recyclerview_horizontal.setLayoutManager(new GridLayoutManager(getActivity(), 1, GridLayoutManager.HORIZONTAL, false));
        //初始化recyclerview_horizontal监听器
        horizontalRecyclerviewAdapter.setOnClickItemListener(new HorizontalRecyclerviewAdapter.OnClickItemListener() {
            @Override
            public void onItemClick(View view, int position, List<ImageModel> datas) {
                //获取先前被点击tab
                int oldPosition = SharedPreferencedUtils.getInteger(getActivity(), CURRENT_POSITION_FLAG, 0);
                //修改背景颜色的标记
                datas.get(oldPosition).isSelected = false;
                //记录当前被选中tab下标
                CurrentPosition = position;
                datas.get(CurrentPosition).isSelected = true;
                SharedPreferencedUtils.setInteger(getActivity(), CURRENT_POSITION_FLAG, CurrentPosition);
                //通知更新，这里我们选择性更新就行了
                horizontalRecyclerviewAdapter.notifyItemChanged(oldPosition);
                horizontalRecyclerviewAdapter.notifyItemChanged(CurrentPosition);
                //viewpager界面切换
                viewPager.setCurrentItem(position, false);
            }

            @Override
            public void onItemLongClick(View view, int position, List<ImageModel> datas) {
            }
        });


    }

    private void replaceFragment() {
        //创建fragment的工厂类
        FragmentMsgFactory factory = FragmentMsgFactory.getSingleFactoryInstance();
        //创建修改实例
        EmotiomComplateMsgFragment f1 = (EmotiomComplateMsgFragment) factory.getFragment(EmotionUtils.EMOTION_CLASSIC_TYPE);
        fragments.add(f1);
        NoHorizontalScrollerVPAdapter adapter = new NoHorizontalScrollerVPAdapter(getActivity().getSupportFragmentManager(), fragments);
        viewPager.setAdapter(adapter);
    }


    /**
     * 是否拦截返回键操作，如果此时表情布局未隐藏，先隐藏表情布局
     *
     * @return true则隐藏表情布局，拦截返回键操作
     * false 则不拦截返回键操作
     */
    public boolean isInterceptBackPress() {
        return mEmotionKeyboard.interceptBackPress();
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btn_set_mode_voice) {
            Acp.getInstance(getContext()).request(new AcpOptions.Builder()
                            .setPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.RECORD_AUDIO
                                    , Manifest.permission.CAMERA)
                            .build(),
                    new AcpListener() {
                        @Override
                        public void onGranted() {
                            setModeVoice();
                        }

                        @Override
                        public void onDenied(List<String> permissions) {
                            //已经禁止提示了
                            CommonMethod.makeNoticeShort(getContext(), getContext().getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                        }
                    });

        } else if (id == R.id.btn_pic) {
            Acp.getInstance(getActivity()).request(new AcpOptions.Builder()
                            .setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE
                                    , Manifest.permission.CAMERA)
                            .build(),
                    new AcpListener() {
                        @Override
                        public void onGranted() {
                            CameraPop.multiSelector(getActivity(), null, 9, false);
                        }

                        @Override
                        public void onDenied(List<String> permissions) {
                            CommonMethod.makeNoticeShort(getActivity(), getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                        }
                    });
        } else if (id == R.id.btn_sendTextmsg) {
            String textMsg = etMessage.getText().toString();
            if (!TextUtils.isEmpty(textMsg)) {
                etMessage.setText("");
                if (null != listener) {
                    listener.onSendTextmsg(textMsg);

                }

            }
        } else if (id == R.id.btn_set_mode_keyboard) {
            setModeKeyboard();
        } else if (id == R.id.btn_camera) {
            if (null != listener) {
                listener.onCamera();

            }
        } else if (id == R.id.btn_info) {
            clickKeyBoardClickListner.ClickShareInfo();
        } else if (id == R.id.btn_more) {
            if (null != clickKeyBoardClickListner) {
                setModeKeyboard();
                setImageButtonBck();
                clickKeyBoardClickListner.ClickMoreButtom();
            }
        }
    }


    /**
     * show voice icon when speak bar is touched
     */

    protected void setModeVoice() {
        buttonSetModeVoice.setVisibility(View.GONE);
        buttonSetModeKeyboard.setVisibility(View.VISIBLE);
        buttonPressToSpeak.setVisibility(View.VISIBLE);
        etMessage.setVisibility(View.GONE);
        btn_sendTextmsg.setVisibility(View.GONE);
        //此处需要隐藏表情
        hideKeyboard();
        isInterceptBackPress();
    }

    /**
     * show keyboard
     */
    protected void setModeKeyboard() {
        buttonSetModeVoice.setVisibility(View.VISIBLE);
        buttonSetModeKeyboard.setVisibility(View.GONE);
        buttonPressToSpeak.setVisibility(View.GONE);
        etMessage.setVisibility(View.VISIBLE);
        if (TextUtils.isEmpty(etMessage.getText().toString().trim())) {
            btn_sendTextmsg.setVisibility(View.GONE);
        } else {
            btn_sendTextmsg.setVisibility(View.VISIBLE);
        }
    }

    /**
     * hide keyboard
     */
    public void hideKeyboard() {
        if (getActivity().getWindow().getAttributes().softInputMode != WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN) {
            if (getActivity().getCurrentFocus() != null)
                inputManager.hideSoftInputFromWindow(getActivity().getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
        }
    }
}


