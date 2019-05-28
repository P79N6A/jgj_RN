package com.jizhi.jlongg.recoed.manager.AudioRecordMessageButton;

import android.content.Context;
import android.graphics.Color;
import android.os.Handler;
import android.os.Message;
import android.os.Vibrator;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;


//录音按钮核心类，包括点击、响应、与弹出对话框交互等操作。
public class AudioRecordMessageButton extends Button implements AudioManager.AudioStageListener {

    //三个对话框的状态常量
    private static final int STATE_NORMAL = 1;
    private static final int STATE_RECORDING = 2;
    private static final int STATE_WANT_TO_CANCEL = 3;

    //垂直方向滑动取消的临界距离
    private static final int DISTANCE_Y_CANCEL = 50;
    //取消录音的状态值
    private static final int MSG_VOICE_STOP = 4;
    //当前状态
    private int mCurrentState = STATE_NORMAL;
    // 正在录音标记
    private boolean isRecording = false;
    //录音对话框
    private DialogManager mDialogManager;
    //核心录音类
    private AudioManager mAudioManager;
    //当前录音时长
    private float mTime = 0;
    // 是否触发了onlongclick，准备好了
    private boolean mReady;
    //标记是否强制终止
    private boolean isOverTime = false;
    //最大录音时长（单位:s）
    private int mMaxRecordTime = 60;

    //上下文
    Context mContext;
    //震动类
    private Vibrator vibrator;
    //提醒倒计时
    private int mRemainedTime = 10;
    //设置是否允许录音
    private boolean canRecord = true;

    public boolean isCanRecord() {
        return canRecord;
    }

    public void setCanRecord(boolean canRecord) {
        this.canRecord = canRecord;
    }

    @Override
    public boolean isInEditMode() {
        return true;
    }

    public AudioRecordMessageButton(Context context) {
        this(context, null);
    }

    public AudioRecordMessageButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        mContext = context;
        //初始化语音对话框
        mDialogManager = new DialogManager(getContext());
        //获取录音保存位置
        String dir = FileUtils.getAppRecordDir(mContext).toString();
        //实例化录音核心类
        mAudioManager = AudioManager.getInstance(dir);
        mAudioManager.setOnAudioStageListener(this);
        setOnLongClickListener(new OnLongClickListener() {

            @Override
            public boolean onLongClick(View v) {
                if (isCanRecord()) {
                    mReady = true;
                    mAudioManager.prepareAudio();
                    return false;
                } else {
                    return true;
                }
            }
        });
        Utils.setBackGround(this, getResources().getDrawable(R.drawable.chat_room_normal_speak_btn));
    }

    public interface AudioFinishRecorderListener {
        void onFinished(float seconds, String filePath);
    }

    private AudioFinishRecorderListener mListener;

    public void setAudioFinishRecorderListener(AudioFinishRecorderListener listener) {
        mListener = listener;
    }

    // 获取音量大小的runnable
    private Runnable mGetVoiceLevelRunnable = new Runnable() {

        @Override
        public void run() {
            while (isRecording) {
                try {

                    //最长mMaxRecordTimes
                    if (mTime > mMaxRecordTime) {
                        mStateHandler.sendEmptyMessage(MSG_VOICE_STOP);
                        return;
                    }

                    Thread.sleep(100);
                    mTime += 0.1f;
                    mStateHandler.sendEmptyMessage(MSG_VOICE_CHANGE);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    };

    // 三个状态
    private static final int MSG_AUDIO_PREPARED = 0X110;
    private static final int MSG_VOICE_CHANGE = 0X111;
    private static final int MSG_DIALOG_DIMISS = 0X112;

    private Handler mStateHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case MSG_AUDIO_PREPARED:
                    // 显示应该是在audio end prepare之后回调
                    mDialogManager.showRecordingDialog();
                    isRecording = true;
                    new Thread(mGetVoiceLevelRunnable).start();

                    // 需要开启一个线程来变换音量
                    break;
                case MSG_VOICE_CHANGE:
                    //剩余10s
                    showRemainedTime();
                    mDialogManager.updateVoiceLevel(mAudioManager.getVoiceLevel(7));
                    break;
                case MSG_DIALOG_DIMISS:

                    break;
                case MSG_VOICE_STOP:
                    isOverTime = true;//超时
                    mDialogManager.dimissDialog();
                    mAudioManager.release();// release释放一个mediarecorder
                    mListener.onFinished(mTime, mAudioManager.getCurrentFilePath());
                    reset();// 恢复标志位
                    break;

            }
        }

        ;
    };
    boolean isShcok;

    private void showRemainedTime() {
        //倒计时
        int remainTime = (int) (mMaxRecordTime - mTime);
        if (remainTime < mRemainedTime) {
            if (!isShcok) {
                isShcok = true;
                doShock();
            }
            mDialogManager.getTipsTxt().setText("还可以说" + remainTime + "秒  ");
        }

    }

    /*
     * 想设置震动大小可以通过改变pattern来设定，如果开启时间太短，震动效果可能感觉不到
     * */
    private void doShock() {
        vibrator = (Vibrator) mContext.getSystemService(Context.VIBRATOR_SERVICE);
        long[] pattern = {100, 400, 100, 400};   // 停止 开启 停止 开启
        vibrator.vibrate(pattern, -1);           //重复两次上面的pattern 如果只想震动一次，index设为-1
    }

    // 在这里面发送一个handler的消息
    @Override
    public void wellPrepared() {
        mStateHandler.sendEmptyMessage(MSG_AUDIO_PREPARED);
    }

    //手指滑动监听
    @Override
    public boolean onTouchEvent(MotionEvent event) {
        int action = event.getAction();
        int x = (int) event.getX();
        int y = (int) event.getY();
        switch (action) {

            case MotionEvent.ACTION_DOWN:
                changeState(STATE_RECORDING);
                break;
            case MotionEvent.ACTION_MOVE:

                if (isRecording) {

                    // 根据x，y来判断用户是否想要取消
                    if (wantToCancel(x, y)) {
                        changeState(STATE_WANT_TO_CANCEL);
                    } else {
                        if (!isOverTime)
                            changeState(STATE_RECORDING);
                    }

                }

                break;
            case MotionEvent.ACTION_UP:
                // 首先判断是否有触发onlongclick事件，没有的话直接返回reset
                if (!mReady) {
                    reset();
                    return super.onTouchEvent(event);
                }
                // 如果按的时间太短，还没准备好或者时间录制太短，就离开了，则显示这个dialog
                if (!isRecording || mTime < 0.8f) {
                    mStateHandler.sendEmptyMessageDelayed(MSG_DIALOG_DIMISS, 1300);// 持续1.3s
                    mDialogManager.tooShort();
                    mAudioManager.cancel();
                    mStateHandler.sendEmptyMessage(MSG_VOICE_STOP);
                } else if (mCurrentState == STATE_RECORDING) {//正常录制结束
                    if (isOverTime) return super.onTouchEvent(event);//超时
                    mDialogManager.dimissDialog();
                    mAudioManager.release();// release释放一个mediarecorder
                    if (mListener != null) {// 并且callbackActivity，保存录音
                        mListener.onFinished(mTime, mAudioManager.getCurrentFilePath());
                    }
                } else if (mCurrentState == STATE_WANT_TO_CANCEL) {
                    // cancel
                    mAudioManager.cancel();
                    mDialogManager.dimissDialog();
                }
                reset();// 恢复标志位
                break;
            case MotionEvent.ACTION_CANCEL:
                mStateHandler.sendEmptyMessage(MSG_VOICE_STOP);
                break;

        }

        return super.onTouchEvent(event);
    }
    /**
     * 回复标志位以及状态
     */
    private void reset() {
        isRecording = false;
        changeState(STATE_NORMAL);
        mReady = false;
        mTime = 0;

        isOverTime = false;
        isShcok = false;
    }

    private boolean wantToCancel(int x, int y) {
        if (x < 0 || x > getWidth()) {// 判断是否在左边，右边，上边，下边
            return true;
        }
        if (y < -DISTANCE_Y_CANCEL || y > getHeight() + DISTANCE_Y_CANCEL) {
            return true;
        }

        return false;
    }

    private void changeState(int state) {
        if (mCurrentState != state) {
            mCurrentState = state;
            switch (mCurrentState) {
                case STATE_NORMAL:
//                    setText(mContext.getString(R.string.long_click_record));//长按录音
                    Utils.setBackGround(this, getResources().getDrawable(R.drawable.chat_room_normal_speak_btn));
                    setTextColor(getResources().getColor(R.color.color_333333));
                    break;
                case STATE_RECORDING:
//                    setBackgroundColor(Color.rgb(0xcd, 0xcd, 0xcd));
//                    setText(R.string.hang_up_finsh);//松开结束
                    Utils.setBackGround(this, getResources().getDrawable(R.drawable.chat_room_press_speak_btn));
                    setTextColor(getResources().getColor(R.color.white));
                    setTextColor(Color.WHITE);
                    if (isRecording) {
                        // 复写dialog.recording();
                        mDialogManager.recording();
                    }
                    break;

                case STATE_WANT_TO_CANCEL:
//                    setText(R.string.release_cancel);//松开取消
                    setTextColor(getResources().getColor(R.color.color_333333));
                    Utils.setBackGround(this, getResources().getDrawable(R.drawable.chat_room_normal_speak_btn));
                    // dialog want to cancel
                    mDialogManager.wantToCancel();
                    break;

            }
        }

    }

    @Override
    public boolean onPreDraw() {
        return false;
    }

}
