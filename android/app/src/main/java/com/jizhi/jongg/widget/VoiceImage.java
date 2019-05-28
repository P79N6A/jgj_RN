package com.jizhi.jongg.widget;

import android.content.Context;
import android.os.Environment;
import android.os.Handler;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.ImageView;

import com.hcs.uclient.utils.SDCardUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.AudioManager;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.DialogManager;

/**
 * Created by Administrator on 2016/2/24.
 */
public class VoiceImage extends ImageView implements AudioManager.AudioStageListener {
    /**
     * 一般状态
     */
    private final int STATE_NORMAL = 1;
    /**
     * 按下录音状态
     */
    private final int STATE_RECORDING = 2;


    private boolean isDown = false;
    /**
     * 取消发送状态
     */
    private final int STATE_WANT_TO_CANCEL = 3;
    /**
     * 移动的距离临界值（判断是否录音还是取消发送）
     */
    private final int DISTANCE_Y_CANCEL = 50;
    /**
     * 录音弹出对话框
     */
    private DialogManager mDialogManager;
    /**
     * 语音录制管理器
     */
    private AudioManager mAudioManager;
    /**
     * 已经开始录音
     */
    private boolean isRecording = false;
    /**
     * 录音时间
     */
    private float mTime = 0;
    /**
     * 当前状态
     */
    private int mCurrentState = STATE_NORMAL;
    private Context context;
    private boolean outsixsecond = false;

    public VoiceImage(Context context) {
        super(context);
        this.context = context;
        if (isInEditMode()) {
            return;
        }
    }

    public VoiceImage(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
        if (isInEditMode()) {//处理：标红处代码会导致可视化编辑报错。
            return;
        }
        setImageResource(R.drawable.voice_sign_normal);
        mTime = 0;
        mDialogManager = new DialogManager(context);
        if (SDCardUtils.isSDCardEnable()) {
            String dir = Environment.getExternalStorageDirectory() + "/nickming_recorder_audios";
//            mAudioManager = AudioManager.getInstance(dir);
            mAudioManager = new AudioManager(dir);
            mAudioManager.setOnAudioStageListener(this);
            mTime = 0;
//            setOnLongClickListener(new OnLongClickListener() {
//                @Override
//                public boolean onLongClick(View v) {
//                    mTime = 0;
//                    return false;
//                }
//            });
        } else {
            CommonMethod.makeNoticeShort(context, "当前内存卡不可用!", CommonMethod.ERROR);
        }
    }

    /**
     * 录音完成后的回调，回调给activiy，可以获得mtime和文件的路径
     *
     * @author nickming
     */
    public interface AudioFinishRecorderListener {
        void onFinished(float seconds, String filePath);
    }

    private AudioFinishRecorderListener mListener;

    public void setAudioFinishRecorderListener(AudioFinishRecorderListener listener) {
        mListener = listener;
    }

    // 获取音量大小的runnable
    public Runnable mGetVoiceLevelRunnable = new Runnable() {
        @Override
        public void run() {
            while (isRecording) {
                try {
                    Thread.sleep(100);
                    mTime += 0.1f;
                    if (mTime >= 60) {
                        isRecording = false;
                        break;
                    }
                    mhandler.sendEmptyMessage(MSG_VOICE_CHANGE);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    };
    // 准备三个常量
    private final int MSG_AUDIO_PREPARED = 0X110;
    private final int MSG_VOICE_CHANGE = 0X111;
    private final int MSG_DIALOG_DIMISS = 0X112;
    private Handler mhandler = new Handler() {
        public void handleMessage(android.os.Message msg) {
            switch (msg.what) {
                case MSG_AUDIO_PREPARED:
                    // 显示应该是在audio end prepare之后回调
//                    isRecording = true;
                    runThread();
                    // 需要开启一个线程来变换音量
                    break;
                case MSG_VOICE_CHANGE:
                    mDialogManager.updateVoiceLevel(mAudioManager.getVoiceLevel(7));
                    break;
                case MSG_DIALOG_DIMISS:
                    mAudioManager.cancel();
                    mDialogManager.dimissDialog();
                    break;
            }
        }
    };

    private synchronized void runThread() {
        new Thread(mGetVoiceLevelRunnable).start();
    }

    @Override
    public void wellPrepared() {
        mhandler.sendEmptyMessage(MSG_AUDIO_PREPARED);
    }

    @Override
    public void callClose() {
        isDown = false;
        isRecording = false;
    }

    /**
     * 直接复写这个监听函数
     */

    private long touchTime = 0;

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        return onTouchEventCus(event);
    }

    public boolean onTouchEventCus(MotionEvent event) {
        int action = event.getAction();
        int x = (int) event.getX();
        int y = (int) event.getY();
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                try {
                    if (isDown) {
                        return true;
                    }
                    mDialogManager.showRecordingDialog();
                    changeState(STATE_RECORDING);
                    isDown = true;
                    isRecording = true;
                    mAudioManager.prepareAudio();
                    getParent().requestDisallowInterceptTouchEvent(true);
                    break;
                } catch (Exception e) {
                    CommonMethod.makeNoticeShort(context, "录音没有给权限", CommonMethod.ERROR);
                    return false;
                }
            case MotionEvent.ACTION_MOVE:
                if (isRecording) {
                    // 根据x，y来判断用户是否想要取消
                    if (wantToCancel(x, y)) {
                        changeState(STATE_WANT_TO_CANCEL);
                    } else {
                        changeState(STATE_RECORDING);
                    }
                }
                break;
            case MotionEvent.ACTION_UP:

                getParent().requestDisallowInterceptTouchEvent(false);
                if (isDown && isRecording && mTime < 0.6) { //如果按的时间过短则取消
                    isRecording = false;
                    mDialogManager.tooShort();
                    mhandler.sendEmptyMessageDelayed(MSG_DIALOG_DIMISS, 500);// 持续1.0s
                } else if (mCurrentState == STATE_RECORDING) {// 正常录制结束
                    mAudioManager.release();// release释放一个mediarecorder
                    mDialogManager.dimissDialog();
                    if (mListener != null) {// 并且callbackActivity，保存录音
                        if (mTime >= 60) {
                            mListener.onFinished(60, mAudioManager.getCurrentFilePath());
                        } else {
                            mListener.onFinished(mTime, mAudioManager.getCurrentFilePath());
                        }
                    }
                } else if (mCurrentState == STATE_WANT_TO_CANCEL) { //发送取消
                    mhandler.sendEmptyMessage(MSG_DIALOG_DIMISS);
                }
                reset();
                break;
            case MotionEvent.ACTION_CANCEL:
                mhandler.sendEmptyMessage(MSG_DIALOG_DIMISS);
                break;
        }
//        return true;
        return super.onTouchEvent(event);
    }

    private void changeState(int state) {
        if (mCurrentState != state) {
            mCurrentState = state;
            switch (mCurrentState) {
                case STATE_NORMAL:
                    setImageResource(R.drawable.voice_sign_normal);
                    break;
                case STATE_RECORDING:
                    setImageResource(R.drawable.voice_sign_press);
                    if (isRecording) {
                        mDialogManager.recording();
                    }
                    break;
                case STATE_WANT_TO_CANCEL:
                    setImageResource(R.drawable.voice_sign_press);
                    mDialogManager.wantToCancel();
                    break;
            }
        }
    }

    /**
     * 回复标志位以及状态
     */
    private void reset() {
        mTime = 0;
        changeState(STATE_NORMAL);
    }

    /**
     * 按住后移动方向，向下true，取消发送，false ：发送
     */
    private boolean wantToCancel(int x, int y) {
//        if (x < 0 || x > getWidth()) {// 判断是否在左边，右边，上边，下边
//            return true;
//        }
        if (y < -DISTANCE_Y_CANCEL || y > getHeight() + DISTANCE_Y_CANCEL) {
            return true;
        }
        return false;
    }
}
