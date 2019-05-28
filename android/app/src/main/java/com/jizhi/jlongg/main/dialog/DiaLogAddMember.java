package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.os.Build;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.hcs.uclient.utils.StrUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.listener.AccordingTelgetRealNameListener;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.MessageUtil;

import java.util.Timer;
import java.util.TimerTask;
import java.util.regex.Pattern;

import static com.jizhi.jlongg.R.id.telph;

/**
 * 功能:添加班组成员
 * 时间:2016年9月14日 15:40:05
 * 作者:xuj
 */
public class DiaLogAddMember extends Dialog implements View.OnClickListener {
    /**
     * 添加记账对象接口回调
     */
    private AddGroupMemberListener listener;
    /**
     * 根据11位电话号码请求服务器得到名称
     */
    private AccordingTelgetRealNameListener getTelphoneListener;
    /**
     * 用户名称
     */
    private EditText nickName;
    /**
     * 电话号码
     */
    private EditText telphEdit;
    /**
     * 头像
     */
    private String memberPic;


    private BaseActivity context;


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(true);
    }


    public DiaLogAddMember(BaseActivity context, int addType) {
        super(context, R.style.Custom_Progress);
        this.context = context;
        createLayout(addType);
        commendAttribute(false);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(int addType) {
        setContentView(R.layout.add_member);
        telphEdit = (EditText) findViewById(telph);
        nickName = (EditText) findViewById(R.id.nickname);
        findViewById(R.id.btn_asscess).setOnClickListener(this);
        findViewById(R.id.closeIcon).setOnClickListener(this);

        TextView textView = findViewById(R.id.title);
        textView.setText(addType == MessageUtil.WAY_ADD_SOURCE_MEMBER ? "添加数据来源人" : "添加成员");
        telphEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() == 0) {
                    nickName.setText("");
                } else if (s.length() == 11) {
                    if (getTelphoneListener != null) {
                        getTelphoneListener.accordingTelgetRealName(telphEdit.getText().toString());
                    }
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }


    public void setTitle(String title) {
        if (!TextUtils.isEmpty(title)) {
            TextView titleText = (TextView) findViewById(R.id.title);
            titleText.setText(title);
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess://确认
                if (access()) {
                    String name = nickName.getText().toString().trim();
                    String telphone = telphEdit.getText().toString().trim();
                    listener.add(telphone, name, memberPic);
//                    nickName.setText("");
//                    telphEdit.setText("");
//                    nickName.setFocusable(true);
//                    nickName.setFocusableInTouchMode(true);
//                    nickName.requestFocus();
//                    dismiss();
                }
                break;
            case R.id.closeIcon:
                dismiss();
                break;
        }
    }

    /**
     * 验证名字和电话号码输入框格式
     */
    public boolean access() {
        boolean access = false;
        String telphValue = telphEdit.getText().toString().trim();
        if (TextUtils.isEmpty(telphValue)) {
            CommonMethod.makeNoticeShort(context, context.getString(R.string.input_mobile), CommonMethod.ERROR);
            return access;
        }
        if (!StrUtil.isMobileNum(telphValue)) {
            CommonMethod.makeNoticeShort(context, context.getString(R.string.input_sure_mobile), CommonMethod.ERROR);
            return access;
        }
        if (telphValue.equals(UclientApplication.getLoginTelephone(context))) {
            CommonMethod.makeNoticeShort(context, "不能添加自己为成员", CommonMethod.ERROR);
            return access;
        }
        String nickNamevalue = nickName.getText().toString().trim();
        if (TextUtils.isEmpty(nickNamevalue)) {
            CommonMethod.makeNoticeShort(context, context.getString(R.string.inputOtherSideName), CommonMethod.ERROR);
            return access;
        }
        String ruler = "(([\u4E00-\u9FA5]{2,7})|([a-zA-Z]{3,10}))";
        if (!Pattern.matches(ruler, nickNamevalue)) {
            if (nickNamevalue.length() < 2 || nickNamevalue.length() > 10) {
                CommonMethod.makeNoticeShort(context, "姓名只能为二至十个字!", CommonMethod.ERROR);
                return access;
            }
//            CommonMethod.makeNoticeShort(context, "姓名只能是中文!", CommonMethod.ERROR);
//            return access;
        }
        access = true;
        return access;
    }

    public void setUserName(String userName) {
        nickName.setText(userName);
    }

    /**
     * 自动打开键盘
     */
    public void openKeyBoard() {
        telphEdit.requestFocus();
        new Timer().schedule(new TimerTask() { //自动开启键盘
            public void run() {
                context.showSoftKeyboard(telphEdit);
            }
        }, 200);
    }

    /**
     * 添加人员回调
     */
    public interface AddGroupMemberListener {
        /**
         * @param realName 人物名称
         * @param telphone 电话号码
         * @param headPic  头像
         */
        public void add(String telphone, String realName, String headPic);
    }


    public AccordingTelgetRealNameListener getGetTelphoneListener() {
        return getTelphoneListener;
    }

    public void setGetTelphoneListener(AccordingTelgetRealNameListener getTelphoneListener) {
        this.getTelphoneListener = getTelphoneListener;
    }

    public AddGroupMemberListener getListener() {
        return listener;
    }

    public void setListener(AddGroupMemberListener listener) {
        this.listener = listener;
    }

    public String getMemberPic() {
        return memberPic;
    }

    public void setMemberPic(String memberPic) {
        this.memberPic = memberPic;
    }
}
