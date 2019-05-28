package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.text.Html;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.SourceEditorProAdapter;
import com.jizhi.jlongg.main.bean.SourceMemberProList;
import com.jizhi.jlongg.main.bean.SourceMemberProManager;
import com.jizhi.jlongg.main.listener.SourceMemberListener;

/**
 * 功能:数据来源人同步项目编辑
 * 时间:2016年10月8日 18:45:02
 * 作者:xuj
 */
public class DialogEditorSourcePro extends Dialog implements View.OnClickListener {

    private Activity context;
    /**
     * 数据来源 回调
     */
    private SourceMemberListener listener;
    /**
     * 适配器
     */
    private SourceEditorProAdapter adapter;


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


    public DialogEditorSourcePro(Activity context, String realName, String telphone, SourceMemberProManager manager) {
        super(context, R.style.network_dialog_style);
        this.context = context;
        initView(realName, telphone);
        initListViewData(manager);
        commendAttribute(true);
    }

    /**
     * 显示底部Layout
     */
    private void showBottomLayout(int selectSize, String desc) {
        TextView synchCount = (TextView) findViewById(R.id.synchCount);
        synchCount.setText(Html.fromHtml("<font color='#666666'>他" + desc + "同步给你&nbsp;</font><font color='#d7252c'>" + selectSize +
                "</font><font color='#666666'>&nbsp;个项目</font>"));
    }


    private void initView(String userName, String telphone) {
        setContentView(R.layout.dialog_manager_source_editor_pro);
        TextView callPhoneText = (TextView) findViewById(R.id.callPhoneText);
        TextView realNameText = (TextView) findViewById(R.id.realName);

        callPhoneText.setText(telphone);
        realNameText.setText(userName);

        findViewById(R.id.closeBtn).setOnClickListener(this);
        findViewById(R.id.correlation).setOnClickListener(this);
        findViewById(R.id.requestSynchPro).setOnClickListener(this);
        callPhoneText.setOnClickListener(this);
        realNameText.setOnClickListener(this);
    }


    /**
     * 初始化同步数据源数据
     *
     * @param manager
     */
    private void initListViewData(SourceMemberProManager manager) {
        LinearLayout synchLayout = (LinearLayout) findViewById(R.id.synchLayout); //底部同步相关信息
        TextView requestSynchPro = (TextView) findViewById(R.id.requestSynchPro); //要求同步项目文字
        TextView tips = (TextView) findViewById(R.id.tips); //文本提示
        View cognateLayout = findViewById(R.id.cognateLayout); //需要关联的Layout
        ListView listView = (ListView) findViewById(R.id.listView);

        if (manager != null && manager.getList() != null && manager.getList().size() > 0) {
            SourceMemberProList unSyncsource = manager.getList().get(0).getSync_unsource(); //未作为源的项目
            SourceMemberProList syncSource = manager.getList().get(0).getSync_source(); //已经作为源的项目
            if (unSyncsource != null && unSyncsource.getList() != null && unSyncsource.getList().size() > 0) {
                requestSynchPro.setVisibility(View.GONE);
                synchLayout.setVisibility(View.VISIBLE);
                cognateLayout.setVisibility(View.VISIBLE);
                if (syncSource != null && syncSource.getList() != null && syncSource.getList().size() > 0) {
                    adapter = new SourceEditorProAdapter(context, syncSource.getList());
                    listView.setAdapter(adapter);
                    listView.setVisibility(View.VISIBLE);
                    tips.setVisibility(View.GONE);
                    showBottomLayout(unSyncsource.getList().size(), "还");
                } else {
                    listView.setVisibility(View.GONE);
                    tips.setText("暂时还没有关联的项目");
                    tips.setVisibility(View.VISIBLE);
                    showBottomLayout(unSyncsource.getList().size(), "已");
                }
            } else if (syncSource != null && syncSource.getList() != null && syncSource.getList().size() > 0) {
                tips.setVisibility(View.GONE);
                listView.setVisibility(View.VISIBLE);
                synchLayout.setVisibility(View.VISIBLE);
                adapter = new SourceEditorProAdapter(context, syncSource.getList());
                listView.setAdapter(adapter);
                if (unSyncsource != null && unSyncsource.getList() != null && unSyncsource.getList().size() > 0) {
                    showBottomLayout(unSyncsource.getList().size(), "还");
                    requestSynchPro.setVisibility(View.GONE);
                    cognateLayout.setVisibility(View.VISIBLE);
                } else {
                    requestSynchPro.setVisibility(View.VISIBLE);
                    cognateLayout.setVisibility(View.GONE);
                    showBottomLayout(unSyncsource.getList().size(), "已");
                }
            } else {
                listView.setVisibility(View.GONE);
                synchLayout.setVisibility(View.GONE);
                tips.setVisibility(View.VISIBLE);
                tips.setText("该用户还未同意向你同步项目");
            }
        } else {
            listView.setVisibility(View.GONE);
            synchLayout.setVisibility(View.GONE);
            tips.setVisibility(View.VISIBLE);
            tips.setText("该用户还未同意向你同步项目");
        }
    }


    @Override
    public void onClick(View v) {
        if (listener == null) {
            return;
        }
        switch (v.getId()) {
            case R.id.closeBtn: //关闭按钮
                dismiss();
                break;
            case R.id.correlation: //关联到本组
                listener.correlation();
                dismiss();
                break;
            case R.id.callPhoneText: //拨打电话
                listener.callPhone();
                break;
            case R.id.requestSynchPro: //要求同步项目
                listener.requestPro();
                dismiss();
                break;
            case R.id.realName: //查看资料
                listener.clickName();
                break;
        }
    }

    public SourceMemberListener getListener() {
        return listener;
    }

    public void setListener(SourceMemberListener listener) {
        this.listener = listener;
        if (adapter != null) {
            adapter.setListener(listener);
        }
    }
}
