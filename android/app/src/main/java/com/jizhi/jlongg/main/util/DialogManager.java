package com.jizhi.jlongg.main.util;

import android.app.Dialog;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;

public class DialogManager {

    /**
     * 以下为dialog的初始化控件，包括其中的布局文件
     */

    private Dialog mDialog;

    private ImageView mIcon;
    private ImageView mVoice;
    private TextView mLable;
    private Context mContext;
    private boolean showmvoice = true;

    public DialogManager(Context context) {
        mContext = context;
    }

    //显示语音对话框
    public void showRecordingDialog() {
        if (MediaManager.isPlayer()) {
            MediaManager.release();
        }
        mDialog = new Dialog(mContext, R.style.Theme_audioDialog);
        // 用layoutinflater来引用布局
        LayoutInflater inflater = LayoutInflater.from(mContext);
        View view = inflater.inflate(R.layout.dialog_manager, null);
        mDialog.setContentView(view);
        mIcon = (ImageView) mDialog.findViewById(R.id.dialog_icon);
        mVoice = (ImageView) mDialog.findViewById(R.id.dialog_voice);
        mLable = (TextView) mDialog.findViewById(R.id.recorder_dialogtext);
        mDialog.show();
    }

    /**
     * 设置正在录音时的dialog界面
     */
    public void recording() {
        if (mDialog != null && mDialog.isShowing()) {
            showmvoice = true;
            mIcon.setVisibility(View.VISIBLE);
            mVoice.setVisibility(View.VISIBLE);
            mLable.setVisibility(View.VISIBLE);
            mIcon.setImageResource(R.drawable.recorder);
            mLable.setText(R.string.shouzhishanghua);
        }
    }

    /**
     * 取消发送语音界面
     */
    public void wantToCancel() {
        if (mDialog != null && mDialog.isShowing()) {
            showmvoice = false;
            mIcon.setVisibility(View.VISIBLE);
            mVoice.setVisibility(View.GONE);
            mLable.setVisibility(View.VISIBLE);
            mIcon.setImageResource(R.drawable.cancel_voice);
            mLable.setText(R.string.want_to_cancle);
        }
    }

    // 时间过短
    public void tooShort() {
        if (mDialog != null && mDialog.isShowing()) {
            showmvoice = false;
            mIcon.setVisibility(View.VISIBLE);
            mVoice.setVisibility(View.GONE);
            mLable.setVisibility(View.VISIBLE);
            mIcon.setImageResource(R.drawable.voice_to_short);
            mLable.setText(R.string.tooshort);
        } else if (mDialog == null) {
        } else if (mDialog.isShowing()) {
        }
    }

    // 关闭语音对话界面
    public void dimissDialog() {
        if (mDialog != null && mDialog.isShowing()) {
            showmvoice = true;
            mDialog.dismiss();
            mDialog = null;
        }
    }

    //由声音语调，来控制动画
    public void updateVoiceLevel(int level) {
        if (mDialog != null && mDialog.isShowing()) {
            //先不改变它的默认状态
            mIcon.setVisibility(View.VISIBLE);
            if (showmvoice) {
                mVoice.setVisibility(View.VISIBLE);
                //通过level来找到图片的id，也可以用switch来寻址，但是代码可能会比较长
                int resId = mContext.getResources().getIdentifier("v" + level, "drawable", mContext.getPackageName());

                mVoice.setImageResource(resId);
            } else {
                mVoice.setVisibility(View.GONE);
            }
            mLable.setVisibility(View.VISIBLE);
        }
    }
}
