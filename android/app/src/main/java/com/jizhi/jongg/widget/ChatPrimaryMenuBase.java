package com.jizhi.jongg.widget;

import android.app.Activity;
import android.content.Context;
import android.util.AttributeSet;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.RelativeLayout;

public abstract class ChatPrimaryMenuBase extends RelativeLayout {
    /**
     * 聊天主按钮回调
     */
    protected EaseChatPrimaryMenuListener listener;
    /**
     * Activity
     */
    protected Activity activity;
    /**
     * 键盘管理
     */
    protected InputMethodManager inputManager;
    protected boolean isExample;
    protected String groupId;
    /**
     * 1.创建者 2。成员
     */
    private int isMyseleGroup;
    private boolean isSingleChat;
    protected String classType;
    private int is_not_source;
    private int can_at_all;

    public int getCan_at_all() {
        return can_at_all;
    }

    public void setCan_at_all(int can_at_all) {
        this.can_at_all = can_at_all;
    }

    public int getIs_not_source() {
        return is_not_source;
    }

    public void setIs_not_source(int is_not_source) {
        this.is_not_source = is_not_source;
    }

    public void setClassType(String classType) {
        this.classType = classType;
    }

    public boolean isSingleChat() {
        return isSingleChat;
    }

    public void setSingleChat(boolean singleChat) {
        isSingleChat = singleChat;
    }

    public void setIsMyseleGroup(int isMyseleGroup) {
        this.isMyseleGroup = isMyseleGroup;
    }

    public int getIsMyseleGroup() {
        return isMyseleGroup;
    }

    public ChatPrimaryMenuBase(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(context);
    }

    public ChatPrimaryMenuBase(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public ChatPrimaryMenuBase(Context context) {
        super(context);
        init(context);
    }

    private void init(Context context) {
        this.activity = (Activity) context;
        inputManager = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
    }

    /**
     * set primary menu listener
     *
     * @param listener
     */
    public void setChatPrimaryMenuListener(EaseChatPrimaryMenuListener listener) {
        this.listener = listener;
    }


    /**
     * hide keyboard
     */
    public void hideKeyboard() {
        if (activity.getWindow().getAttributes().softInputMode != WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN) {
            if (activity.getCurrentFocus() != null)
                inputManager.hideSoftInputFromWindow(activity.getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
        }
    }

    public void setExample(boolean isExample) {
        this.isExample = isExample;
    }

    public abstract void setExampleVocie();

    /**
     * 显示底部
     */
    public abstract void onBottomVisble();

    /**
     * 隐藏底部
     */
    public abstract void onBottomGone();


    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

    public String getGroupId() {
        return groupId;
    }


    public interface EaseChatPrimaryMenuListener {
        /**
         * 点击发送按钮
         *
         * @param content
         */
        void onSendTextmsg(String content);
        /**
         * 录音完成
         */
        void onVoicefinish(float seconds, String filePath);

        /**
         * 拍照
         */
        void onCamera();

    }

}
