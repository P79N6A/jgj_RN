package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.graphics.drawable.AnimationDrawable;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.ScreenUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.AccountPhotoGridAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.DiffBill;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.CheckBillDialog;
import com.jizhi.jlongg.main.dialog.WheelViewAboutMyProject;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.DownFile;
import com.jizhi.jlongg.main.util.FindInterface;
import com.jizhi.jlongg.main.util.MediaManager;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.VoiceImage;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

/**
 * 功能: 编辑记账 基类
 * 作者：Xuj
 * 时间: 2016-7-20 14:42
 */
public class EditorAccountAbstractActivity extends BaseActivity implements VoiceImage.AudioFinishRecorderListener, View.OnClickListener {
    /**
     * 参数对象
     */
    public RequestParams params;
    /**
     * 图片适配器
     */
    public AccountPhotoGridAdapter adapter;
    /**
     * 项目列表数据
     */
    public List<Project> projectList;
    /**
     * 与我相关项目的WheelView
     */
    public WheelViewAboutMyProject addProject;
    /**
     * 图片数据
     */
    public List<ImageItem> photos;
    /**
     * 项目ID
     */
    public int pid;
    /**
     * 用户id
     */
    public String uid;
    /**
     * 语音路径
     */
    public String voicePath;
    /**
     * 语音长度
     */
    public int voiceLength;
    /**
     * 语音控件宽度
     */
    public int voiceWidth;
    /**
     * 语音控件最大宽度
     */
    public int voiceMaxWidth;
    /**
     * 项目名称
     */
    public TextView recordProject;
    /**
     * 拍照文字
     */
    public TextView textPhoto;
    /**
     * 语音文字
     */
    public TextView voiceText;
    /**
     * 备注信息
     */
    public EditText ed_remark;
    /**
     * 语音时长
     */
    public TextView voiceTime;
    /**
     * 语音红条
     */
    public ImageView voiceRedItemImage;
    /**
     * 语音播放动画图片
     */
    public ImageView voiceAnimationImage;
    /**
     * 语音布局
     */
    public RelativeLayout voiceLayout;
    /**
     * 是否修改过语音
     */
    public boolean isChangedVoice;
    /**
     * 语音按钮
     */
    public VoiceImage voiceButton;
    /**
     * 语音播放动画
     */
    public AnimationDrawable voiceAnimation;
    /**
     * 差帐对象
     */
    public DiffBill diffBill;
    /**
     * 差帐对话框
     */
    public CheckBillDialog diaglog;
    public String workType;
    public EditorAccountAbstractActivity editorAccountAbstractActivity = EditorAccountAbstractActivity.this;
    /* 修改记账的id */
    public String record_id;
    /* 是否是推送的消息 */
    public boolean isPush;
    /* 记账对象类型 */
    public String roleType;
    public boolean isGroupBill;
    public boolean isChangeData;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        LUtils.e("-----------------onCreateBase----------");
        Bundle bun = getIntent().getExtras();
        if (bun != null) {
            LUtils.e("------------------bundle--not-null----------");
            Set<String> keySet = bun.keySet();
            for (String key : keySet) {
                if (!TextUtils.isEmpty(key) && key.equals("record_id")) {
                    record_id = bun.getString(key);
                    isPush = true;
                } else if (!TextUtils.isEmpty(key) && key.equals("role")) {
                    roleType = bun.getString(key);
                    isPush = true;
                }

                LUtils.e(isPush + ":-----11-----key:" + key + ",,,value:" + bun.getString(key));
            }
        } else {
            LUtils.e("------------------bundle---null----------");
        }
        if (!isPush) {
            LUtils.e("---------------isPush----------" + isPush);
            record_id = getIntent().getIntExtra(Constance.BEAN_INT, -1) + "";
            String role = getIntent().getStringExtra(Constance.enum_parameter.ROLETYPE.toString());
            if (!TextUtils.isEmpty(role)) {
                //班组内的记账
                roleType = role.equals(Constance.ROLETYPE_WORKER) ? Constance.ROLETYPE_FM : Constance.ROLETYPE_WORKER;
                isGroupBill = true;
            } else {
                roleType = UclientApplication.getRoler(this);
            }
        }
    }

    /**
     * 点击语音播放动画
     *
     * @param seconds  时常
     * @param filePath 语音路径
     */
    @Override
    public void onFinished(float seconds, String filePath) {
        isChangeData=true;
        if (voiceAnimation != null && voiceAnimation.isRunning()) {
            voiceAnimation.stop();
        }
        voiceLength = Math.round(seconds); //语音长度
        voiceTime.setText(voiceLength + "\"");
        ScreenUtils.setViewWidthLength(voiceRedItemImage, voiceMaxWidth, voiceWidth, voiceLength);
        voiceLayout.setVisibility(View.VISIBLE);
        voiceAnimationImage.setVisibility(View.VISIBLE);
        voiceText.setVisibility(View.GONE);
        voicePath = filePath;
        //修改 语音了
        isChangedVoice = true;
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
    }

    /**
     * 设置项目名称
     *
     * @param projectName 项目名称
     */
    public void setProjectInfo(String projectName) {
        if (recordProject != null) {
            recordProject.setText(projectName);
        }
    }

    /**
     * 设置图片默认值
     */
    public void loadDefaultPhotoGridViewData() {
        if (photos == null) {
            photos = new ArrayList<ImageItem>();
        }
        photos.add(CameraPop.initPhotos());
    }

    /**
     * 是否有语音消息
     */
    public void isHasVoice(String voicePath) {
        if (!TextUtils.isEmpty(voicePath)) {
            voiceLayout.setVisibility(View.VISIBLE);
            voiceAnimationImage.setVisibility(View.VISIBLE);
            voiceText.setVisibility(View.GONE);
            voiceTime.setText(voiceLength + "\"");
        }
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        isChangeData = true;
        if (resultCode == Constance.EDITOR_PROJECT_SUCCESS) {//编辑项目回调
            List<Project> mProjectList = (List<Project>) data.getSerializableExtra(Constance.BEAN_ARRAY);
            projectList = mProjectList;
            pid = 0;
//            addProject.setCurrentIndex(0);
            setProjectInfo(null);
        } else if (resultCode == Constance.RESULTWORKERS) {//添加项目回调
            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            pid = project.getPid();
            setProjectInfo(project.getPro_name());
            List<Project> list = projectList;
            if (list == null) {
                list = new ArrayList<Project>();
            }
            int size = list.size();
            for (int i = 0; i < size; i++) {
                if (list.get(i).getPid() == pid) {
                    list.remove(i);
                    break;
                }
            }
            list.add(0, project);
//            addProject.setCurrentIndex(0);
        } else if (resultCode == RESULT_OK) { //拍照回调
            List<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
            List<ImageItem> netImages = null; //网络图片
            int size = photos.size();
            for (int i = 0; i < size - 1; i++) {
                ImageItem item = photos.get(i + 1);
                if (item.isNetPicture) {
                    if (netImages == null) {
                        netImages = new ArrayList<ImageItem>();
                    }
                    netImages.add(item);
                }
            }
            photos.clear();
            loadDefaultPhotoGridViewData();
            if (netImages != null && netImages.size() > 0) {
                photos.addAll(netImages);
            }
            ImageItem bean = null;
            for (String item : mSelected) {
                bean = new ImageItem();
                bean.isNetPicture = false;
                bean.imagePath = item;
                photos.add(bean);
            }
            adapter.notifyDataSetChanged();
            initPictureDesc();
        }
    }

    /**
     * 初始化图片描述
     */
    public void initPictureDesc() {
        if (photos == null) {
            return;
        }
        if (photos.size() == 1) {
            textPhoto.setVisibility(View.VISIBLE);
        } else {
            textPhoto.setVisibility(View.GONE);
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.voiceRedItemImage: //语音布局
                isChangeData=true;
                System.out.println("-------voicePath---------" + voicePath);
                if (!TextUtils.isEmpty(voicePath)) {
                    voiceAnimationImage.setImageResource(R.drawable.voice_playing);
                    voiceAnimation = (AnimationDrawable) voiceAnimationImage.getDrawable();
                    voiceAnimation.start();
                    MediaManager.playSound(voicePath,
                                new MediaPlayer.OnCompletionListener() {
                                    @Override
                                    public void onCompletion(MediaPlayer mp) {
                                        voiceAnimationImage.setImageResource(R.drawable.voice_ripple3);
                                        voiceAnimation.stop();
                                    }
                                });
                } else {
                    CommonMethod.makeNoticeShort(this, "当前还没有语音信息", CommonMethod.ERROR);
                }
                break;
            case R.id.voiceRemoveImage: //删除图片
                isChangeData=true;
                LUtils.e("-----------------------");
                MediaManager.release();
                if (voiceAnimation != null && voiceAnimation.isRunning()) {
                    voiceAnimation.stop();
                }
                voicePath = null;
                voiceLength = 0;
                //修改 语音了
                isChangedVoice = true;
                voiceLayout.setVisibility(View.GONE);
                voiceText.setVisibility(View.VISIBLE);
                break;
        }
    }


    public void upLoadImage() {
        List<String> tempPhoto = null;
        if (null != photos && photos.size() > 0) {
            if (tempPhoto == null) {
                tempPhoto = new ArrayList<String>();
            }
            int size = photos.size();
            for (int i = 0; i < size; i++) {
                ImageItem item = photos.get(i);
                if (!item.isNetPicture && !TextUtils.isEmpty(item.imagePath)) {
                    tempPhoto.add(photos.get(i).imagePath);
                }
            }
            if (tempPhoto.size() > 0) {
                RequestParamsToken.compressImageAndUpLoad(params, tempPhoto, EditorAccountAbstractActivity.this);
            }
        }
    }

    /**
     * 初始化语音
     *
     * @param mVoicePath
     */
    public void initVoice(String mVoicePath) {
        voiceWidth = ScreenUtils.getViewWidthLength(voiceRedItemImage);
        voiceMaxWidth = ScreenUtils.getViewWidthLength(voiceLayout);
        //没有修改过语音
        if (!TextUtils.isEmpty(mVoicePath)) {
            DownFile.downVoiceFile(NetWorkRequest.NETURL + mVoicePath, Constance.VOICEPATH + "/" + UUID.randomUUID().toString() + ".amr", new FindInterface.SendString() {
                @Override
                public void sendString(String str) {
                    if (!str.equals("onFailure")) {//下载成功
                        voicePath = str;
                        ScreenUtils.setViewWidthLength(voiceRedItemImage, voiceMaxWidth, voiceWidth, voiceLength);
                        isHasVoice(str);
                    }
                }
            });
        }
        voiceButton.setAudioFinishRecorderListener(this);
        voiceRedItemImage.setOnClickListener(this);
    }

    /**
     * 动态计算金额
     */
    public class MoneyAnimation extends Animation {
        /**
         * 浮动view
         */
        private TextView floatTextView;
        /**
         * 总金额
         */
        private String totalMoney = null;

        public MoneyAnimation(TextView floatTextView, String totalMoney) {
            this.floatTextView = floatTextView;
            this.totalMoney = totalMoney;
        }

        @Override
        protected void applyTransformation(float interpolatedTime, Transformation t) {
            super.applyTransformation(interpolatedTime, t);
            if (interpolatedTime < 1.0f) {
                floatTextView.setText(Utils.m2(interpolatedTime * Float.parseFloat(totalMoney)));
            } else {
                floatTextView.setText(totalMoney);
            }
        }
    }

    /**
     * 开启金额的动画
     *
     * @param floatTextView
     */
    public void startMoneyAnimation(TextView floatTextView, String money) {
        if (TextUtils.isEmpty(money)) { //如果金额为空则不用开启动画
            return;
        }
        if (money.equals("0.00")) {
            floatTextView.setText("0.00");
            return;
        }
        MoneyAnimation animation = new MoneyAnimation(floatTextView, money);
        animation.setDuration(300); //设置动画时间为1秒
        floatTextView.startAnimation(animation);
    }

    public void mpporClicks(DiffBill diffBill, String type) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", diffBill.getId() + "");
        params.addBodyParameter("main_set_amount", (diffBill.getSecond_set_amount()) + "");
        if (type.equals(AccountUtil.HOUR_WORKER)) {
            // 1:点工
            params.addBodyParameter("main_manhour", (diffBill.getSecond_manhour()) + "");
            params.addBodyParameter("main_overtime", (diffBill.getSecond_overtime()) + "");
        } else if (type.equals(AccountUtil.CONSTRACTOR)) {
            //2:包工
            params.addBodyParameter("main_manhour", (diffBill.getSecond_set_unitprice()) + "");
            params.addBodyParameter("main_overtime", (diffBill.getSecond_set_quantities()) + "");
        } else {
            params.addBodyParameter("main_manhour", "0");
            params.addBodyParameter("main_overtime", "0");
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MPOORINFO, params,
                    new RequestCallBackExpand<String>() {
                        @SuppressWarnings("deprecation")
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                closeDialog();
                                CommonListJson<BaseNetBean> bean = CommonListJson.fromJson(responseInfo.result, BaseNetBean.class);
                                if (bean.getState() == 0) {
                                    DataUtil.showErrOrMsg(EditorAccountAbstractActivity.this, bean.getErrno(),
                                                bean.getErrmsg());
                                } else {
                                    CommonMethod.makeNoticeShort(EditorAccountAbstractActivity.this, "修改成功", CommonMethod.SUCCESS);
                                    setResult(Constance.DISPOSEATTEND_RESULTCODE, getIntent());
                                    finish();
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(EditorAccountAbstractActivity.this, EditorAccountAbstractActivity.this.getString(R.string.service_err), CommonMethod.ERROR);

                            } finally {
                                if (null != diaglog) {
                                    diaglog.dismiss();
                                }
                            }
                        }

                        @Override
                        public void onFailure(HttpException error, String msg) {
                            closeDialog();
                        }
                    });
    }
}
