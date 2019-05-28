package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.hcs.uclient.utils.StrUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.util.CommonMethod;

import java.util.Timer;
import java.util.TimerTask;
import java.util.regex.Pattern;

import static com.jizhi.jlongg.R.id.telph;

/**
 * 功能:点击通讯录中包含表情的联系人，弹出完善姓名弹框，输入完整的姓名后，点击确定，界面跳转到记工界面；
 * 时间:2019年2月20日17:37:19
 * 作者:xuj
 */
public class DialogRemoveContactsEmoji extends Dialog implements View.OnClickListener {
    /**
     * 左边、右边按钮点击事件回调
     */
    private DiaLogAddMember.AddGroupMemberListener listener;
    /**
     * 用户名称
     */
    private EditText nickName;
    /**
     * 电话号码
     */
    private TextView telphText;


    public DialogRemoveContactsEmoji(BaseActivity activity, String telephone) {
        super(activity, R.style.Custom_Progress);
        createLayout(telephone, activity);
        commendAttribute(true);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(String telephone, final BaseActivity activity) {
        setContentView(R.layout.dialog_remove_contain_emoji);

        telphText = (TextView) findViewById(telph);
        nickName = (EditText) findViewById(R.id.nickname);

        telphText.setText(telephone);
        findViewById(R.id.leftBtn).setOnClickListener(this);
        findViewById(R.id.rightBtn).setOnClickListener(this);
        nickName.requestFocus();
        new Timer().schedule(new TimerTask() { //自动开启键盘
            public void run() {
                activity.showSoftKeyboard(nickName);
            }
        }, 300);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.leftBtn: //确认
                dismiss();
                break;
            case R.id.rightBtn:
                if (listener != null) {
                    if (access()) {
                        String name = nickName.getText().toString().trim();
                        String telphone = telphText.getText().toString().trim();
                        listener.add(telphone, name, null);
                    }
                }
                break;
        }
    }

    /**
     * 验证名字和电话号码输入框格式
     */
    public boolean access() {
        boolean access = false;
        String telphValue = telphText.getText().toString().trim();
        if (TextUtils.isEmpty(telphValue)) {
            CommonMethod.makeNoticeShort(getContext().getApplicationContext(), getContext().getString(R.string.input_mobile), CommonMethod.ERROR);
            return access;
        }
        if (!StrUtil.isMobileNum(telphValue)) {
            CommonMethod.makeNoticeShort(getContext().getApplicationContext(), getContext().getString(R.string.input_sure_mobile), CommonMethod.ERROR);
            return access;
        }
//        if (telphValue.equals(UclientApplication.getLoginTelephone(getContext()))) {
//            CommonMethod.makeNoticeShort(getContext().getApplicationContext(), "不能添加自己为成员", CommonMethod.ERROR);
//            return access;
//        }
        String nickNamevalue = nickName.getText().toString().trim();
        if (TextUtils.isEmpty(nickNamevalue)) {
            CommonMethod.makeNoticeShort(getContext().getApplicationContext(), nickName.getHint().toString(), CommonMethod.ERROR);
            return access;
        }
        String ruler = "(([\u4E00-\u9FA5]{2,7})|([a-zA-Z]{3,10}))";
        if (!Pattern.matches(ruler, nickNamevalue)) {
            if (nickNamevalue.length() < 2 || nickNamevalue.length() > 10) {
                CommonMethod.makeNoticeShort(getContext().getApplicationContext(), "姓名只能为二至十个字!", CommonMethod.ERROR);
                return access;
            }
//            CommonMethod.makeNoticeShort(context, "姓名只能是中文!", CommonMethod.ERROR);
//            return access;
        }
        access = true;
        return access;
    }


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public DiaLogAddMember.AddGroupMemberListener getListener() {
        return listener;
    }

    public void setListener(DiaLogAddMember.AddGroupMemberListener listener) {
        this.listener = listener;
    }
}
