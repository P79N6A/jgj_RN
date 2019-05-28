package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.network.NetWorkRequest;


/**
 * 功能:未注册弹框
 * 时间:2019年3月29日11:32:31
 * 作者:xuj
 */
public class DialogUnRegister extends Dialog implements View.OnClickListener {
    /**
     * 项目组类型,项目id,用户id
     */
    private String classType, groupId, uid;
    /**
     * true表示已注册
     */
    private boolean isRegister;
    /**
     * activity
     */
    private Activity activity;

    public void initView(String realName, String telphone) {
        setContentView(R.layout.dialog_project_manager_jgj);
        findViewById(R.id.left_btn).setOnClickListener(this);
        findViewById(R.id.right_btn).setOnClickListener(this);
        findViewById(R.id.userName).setOnClickListener(this);
        TextView content = (TextView) findViewById(R.id.tv_hint);
        ((TextView) findViewById(R.id.userName)).setText(realName);
        ((TextView) findViewById(R.id.tel)).setText(telphone);
        if (!isRegister) {
            findViewById(R.id.tv_hint).setVisibility(View.VISIBLE);
            content.setText(activity.getString(R.string.text_unregister_team_manager));
        } else {
            content.setVisibility(View.GONE);
        }
        setCanceledOnTouchOutside(true);
        setCancelable(true);
    }


    @Override
    public void onClick(View v) {
        dismiss();
        switch (v.getId()) {
            case R.id.right_btn: //邀请朋友  调用是 导航栏我的 分享
                final Share shareBean = new Share();
                // 图标 描述 标题 url
                shareBean.setImgUrl(NetWorkRequest.CDNURL + "/media/default_imgs/logo.jpg");
                shareBean.setDescribe("1000万建筑工友都在用！下载注册就送100积分抽百元话费！");
                shareBean.setTitle("我正在用招工找活、记工记账神器：吉工家APP");
                shareBean.setUrl(NetWorkRequest.WEBURLS + "/page/open-invite.html?uid=" + UclientApplication.getUid(getContext()) + "&plat=person");
                new CustomShareDialog(activity, true, shareBean).showAtLocation(activity.getWindow().getDecorView(),
                        Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(activity, 0.5F);
                break;
            case R.id.userName: //点击头像
                if (!isRegister) {
                    CommonMethod.makeNoticeShort(getContext(), "TA还没加入吉工家，没有更多资料了", CommonMethod.ERROR);
                    return;
                }
                Intent intent1 = new Intent(activity, ChatUserInfoActivity.class);
                intent1.putExtra(Constance.UID, uid);
                intent1.putExtra(Constance.CLASSTYPE, classType);
                intent1.putExtra(Constance.GROUP_ID, groupId);
                activity.startActivityForResult(intent1, Constance.REQUEST);
                break;
        }
    }

    public DialogUnRegister(Activity activity, String classType, String groupId, GroupMemberInfo info) {
        super(activity, R.style.network_dialog_style);
        this.activity = activity;
        this.classType = classType;
        this.groupId = groupId;
        this.uid = info.getUid();
        this.isRegister = info.getIs_active() == 1;
        initView(info.getReal_name(), info.getTelephone());
    }

    public String getClassType() {
        return classType;
    }

    public void setClassType(String classType) {
        this.classType = classType;
    }

    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }
}
