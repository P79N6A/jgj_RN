package com.jizhi.jlongg.emoji.fragment;

import android.Manifest;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.emoji.adapter.HorizontalRecyclerviewAdapter;
import com.jizhi.jlongg.emoji.adapter.ImageModel;
import com.jizhi.jlongg.emoji.adapter.NoHorizontalScrollerVPAdapter;
import com.jizhi.jlongg.emoji.emotionkeyboard.BarClickLintener;
import com.jizhi.jlongg.emoji.emotionkeyboard.EmotionKeyboard;
import com.jizhi.jlongg.emoji.emotionkeyboard.NoHorizontalScrollerViewPager;
import com.jizhi.jlongg.emoji.utils.EmotionUtils;
import com.jizhi.jlongg.emoji.utils.GlobalOnItemClickManagerUtils;
import com.jizhi.jlongg.emoji.utils.SharedPreferencedUtils;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by zejian
 * Time  16/1/6 下午5:26
 * Email shinezejian@163.com
 * Description:表情主界面
 */
public class EmotionMainFragment extends BaseFragment {

    //是否绑定当前Bar的编辑框的flag
    public static final String BIND_TO_EDITTEXT = "bind_to_edittext";
    //是否隐藏bar上的编辑框和发生按钮
    public static final String HIDE_BAR_EDIT_PIC = "hide bar's editText and btn";

    //当前被选中底部tab
    private static final String CURRENT_POSITION_FLAG = "CURRENT_POSITION_FLAG";
    private int CurrentPosition = 0;
    //底部水平tab
    private RecyclerView recyclerview_horizontal;
    private HorizontalRecyclerviewAdapter horizontalRecyclerviewAdapter;
    //表情面板
    private EmotionKeyboard mEmotionKeyboard;

    private EditText bar_edit_text;
    private ImageView bar_image_add_btn;
    private Button bar_btn_send;
    private LinearLayout rl_editbar_bg;

    //需要绑定的内容view
    private View contentView;

    //不可横向滚动的ViewPager
    private NoHorizontalScrollerViewPager viewPager;

    //是否绑定当前Bar的编辑框,默认true,即绑定。
    //false,则表示绑定contentView,此时外部提供的contentView必定也是EditText
    private boolean isBindToBarEditText = true;

    //是否隐藏bar上的编辑框和发生按钮,默认不隐藏
    private boolean isHidenBarEditPic = false;
    private BarClickLintener barClickLintener;

    private EmotionKeyboard.ClickKeyBoardClickListner clickKeyBoardClickListner;

    public void setClickKeyBoardClickListner(EmotionKeyboard.ClickKeyBoardClickListner clickKeyBoardClickListner) {
        this.clickKeyBoardClickListner = clickKeyBoardClickListner;
    }

    public void setBarClickLintener(BarClickLintener barClickLintener) {
        this.barClickLintener = barClickLintener;
    }

    List<Fragment> fragments = new ArrayList<>();

    public EditText getBar_edit_text() {
        return bar_edit_text;
    }

    View rootView;
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
         rootView = inflater.inflate(R.layout.fragment_main_emotion, container, false);
        isHidenBarEditPic = args.getBoolean(EmotionMainFragment.HIDE_BAR_EDIT_PIC);
        //获取判断绑定对象的参数
        isBindToBarEditText = args.getBoolean(EmotionMainFragment.BIND_TO_EDITTEXT);
        initView(rootView);
        mEmotionKeyboard = EmotionKeyboard.with(getActivity(), clickKeyBoardClickListner)
                    .setEmotionView(rootView.findViewById(R.id.ll_emotion_layout))//绑定表情面板
                    .bindToContent(contentView)//绑定内容view
                    .bindToEditText(!isBindToBarEditText ? ((EditText) contentView) : ((EditText) rootView.findViewById(R.id.bar_edit_text)))//判断绑定那种EditView
                    .bindToEmotionButton(rootView.findViewById(R.id.emotion_button))//绑定表情按钮
                    .build();
        initListener();
        initDatas();
        //创建全局监听
        GlobalOnItemClickManagerUtils globalOnItemClickManager = GlobalOnItemClickManagerUtils.getInstance(getActivity());

        if (isBindToBarEditText) {
            //绑定当前Bar的编辑框
            globalOnItemClickManager.attachToEditText(bar_edit_text);

        } else {
            // false,则表示绑定contentView,此时外部提供的contentView必定也是EditText
            globalOnItemClickManager.attachToEditText((EditText) contentView);
            mEmotionKeyboard.bindToEditText((EditText) contentView);
        }
        return rootView;
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
        LUtils.e("---------isHidenBarEditPic-------------:" + isHidenBarEditPic);
        viewPager = (NoHorizontalScrollerViewPager) rootView.findViewById(R.id.vp_emotionview_layout);
        recyclerview_horizontal = (RecyclerView) rootView.findViewById(R.id.recyclerview_horizontal);
        bar_edit_text = (EditText) rootView.findViewById(R.id.bar_edit_text);
        bar_image_add_btn = (ImageView) rootView.findViewById(R.id.bar_image_add_btn);
        bar_btn_send = (Button) rootView.findViewById(R.id.bar_btn_send);
        rl_editbar_bg = (LinearLayout) rootView.findViewById(R.id.rl_editbar_bg);
        if (isHidenBarEditPic) {//隐藏
            LUtils.e("---------isHidenBarEditPic------11-------:" );
            bar_edit_text.setVisibility(View.VISIBLE);
            bar_image_add_btn.setVisibility(View.GONE);
            rl_editbar_bg.setBackgroundResource(R.color.bg_edittext_color);
        } else {
            LUtils.e("---------isHidenBarEditPic------22-------:" );
            bar_edit_text.setVisibility(View.VISIBLE);
            bar_image_add_btn.setVisibility(View.VISIBLE);
            bar_btn_send.setVisibility(View.GONE);
        }
        rl_editbar_bg.setBackgroundResource(R.drawable.shape_bg_reply_edittext);
        bar_edit_text.setBackgroundResource(R.drawable.chat_room_edit_white);
        bar_btn_send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                barClickLintener.barBtnSendClick();
            }
        });
        bar_image_add_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Acp.getInstance(getActivity()).request(new AcpOptions.Builder()
                                        .setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE
                                                    , Manifest.permission.CAMERA)
                                        .build(),
                            new AcpListener() {
                                @Override
                                public void onGranted() {
                                    CameraPop.multiSelector(getActivity(), null, 9);
//                                                    barClickLintener.barImageAddClick();
                                }

                                @Override
                                public void onDenied(List<String> permissions) {
                                    CommonMethod.makeNoticeShort(getActivity(), getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                                }
                            });


            }
        });
        bar_edit_text.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {

                if (isHidenBarEditPic) {
                    if (s.length() > 0) {
                        Utils.setBackGround(bar_btn_send, getActivity().getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
                        bar_btn_send.setTextColor(getActivity().getResources().getColor(R.color.white));
                    } else {
                        Utils.setBackGround(bar_btn_send, getActivity().getResources().getDrawable(R.drawable.chat_room_edit));
                        bar_btn_send.setTextColor(getActivity().getResources().getColor(R.color.color_666666));
                    }
                } else {
                    if (s.length() > 0) {
                        bar_btn_send.setVisibility(View.VISIBLE);
                        bar_image_add_btn.setVisibility(View.GONE);
                        bar_btn_send.setTextColor(getActivity().getResources().getColor(R.color.white));
                        Utils.setBackGround(bar_btn_send, getActivity().getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
                    } else {
                        bar_btn_send.setTextColor(getResources().getColor(R.color.color_666666));
                        bar_btn_send.setVisibility(View.GONE);
                        bar_image_add_btn.setVisibility(View.VISIBLE);
                    }
                }


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

//    private void replaceFragment() {
//        //创建fragment的工厂类
//        FragmentFactory factory = FragmentFactory.getSingleFactoryInstance();
//        //创建修改实例
//        EmotiomComplateFragment f1 = (EmotiomComplateFragment) factory.getFragment(EmotionUtils.EMOTION_CLASSIC_TYPE);
//        fragments.add(f1);
//        Bundle b = null;
////        for (int i=0;i<1;i++){
////            b=new Bundle();
////            b.putString("Interge","Fragment-"+i);
////            Fragment1 fg= Fragment1.newInstance(Fragment1.class,b);
////            fragments.add(fg);
////        }
//
//        NoHorizontalScrollerVPAdapter adapter = new NoHorizontalScrollerVPAdapter(getActivity().getSupportFragmentManager(), fragments);
//        viewPager.setAdapter(adapter);
//    }

    private void replaceFragment() {
        //创建fragment的工厂类
        FragmentFactory factory = FragmentFactory.getSingleFactoryInstance();
        //创建修改实例
        EmotiomComplateFragment f1 = (EmotiomComplateFragment) factory.getFragment(EmotionUtils.EMOTION_CLASSIC_TYPE);
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
}

