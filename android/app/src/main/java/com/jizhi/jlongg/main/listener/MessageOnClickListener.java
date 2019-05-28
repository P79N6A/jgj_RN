package com.jizhi.jlongg.main.listener;

import android.content.Context;
import android.view.View;

import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.message.ActivityNoticeDetailActivity;

/**
 * 聊天界面item点击时间
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2016-11-25 下午2:41:57
 */

public class MessageOnClickListener implements View.OnClickListener {
    private MessageEntity msgEntity;
    private Context context;
    private boolean isClose;

    public MessageOnClickListener(MessageEntity msgEntity, Context context, String classType, boolean isClose) {
        this.msgEntity = msgEntity;
        this.context = context;
        this.isClose = isClose;
        this.msgEntity.setClass_type(classType);
    }

    public MessageOnClickListener(MessageEntity msgEntity, Context context, String classType) {
        this.msgEntity = msgEntity;
        this.context = context;
        this.msgEntity.setClass_type(classType);
    }

    @Override
    public void onClick(View v) {
//        Intent intent = new Intent(context, ActivityNoticeDetailActivity.class);
//        Bundle bundle = new Bundle();
//        if (msgEntity.getClass_type().equals("group") && !TextUtils.isEmpty(msgEntity.getGroupName())) {
//            msgEntity.setFrom_group_name(msgEntity.getGroupName());
//        }
//        bundle.putSerializable("msgEntity", msgEntity);
//        if (!TextUtils.isEmpty(isClose) && isClose.equals("1")) {
//            intent.putExtra(Constance.BEAN_BOOLEAN, true);
//        }
//        intent.putExtras(bundle);
//        ((BaseActivity) context).startActivityForResult(intent, Constance.REQUEST);
        GroupDiscussionInfo gnInfo = new GroupDiscussionInfo();
        gnInfo.setClass_type(msgEntity.getClass_type());
        gnInfo.setGroup_id(msgEntity.getGroup_id());
        ActivityNoticeDetailActivity.actionStart(((BaseActivity) context), gnInfo, msgEntity.getMsg_id());
    }
}
