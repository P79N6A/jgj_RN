package com.jizhi.jlongg.main.activity;

import android.os.Bundle;
import android.text.Html;
import android.widget.TextView;
import com.jizhi.jlongg.R;

/**
 * 主页点击网络连接失败跳转
 */
public class NetFailActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.net_fail);
        setText();
    }


    public void setText() {
        setTextTitle(R.string.net_fail_server);
        TextView textDesc1 = getTextView(R.id.textDesc1);
        TextView textDesc2 = getTextView(R.id.textDesc2);
        StringBuilder builder = new StringBuilder(100);
        builder.append(lightText("在设备的") + darkText("&nbsp;“设置”&nbsp;—&nbsp;“Wi-Fi网络”&nbsp;") + lightText("设置面板中选择一个可用的Wi-Fi热点接入。"));
        textDesc1.setText(Html.fromHtml(builder.toString()));
        builder.delete(0, builder.toString().length());
        builder.append(lightText("在设备的") + darkText("&nbsp;“设置”&nbsp;—&nbsp;“通用”&nbsp;—&nbsp;“网络”&nbsp;") +
                lightText("设置面板中启用蜂窝数据(启用后运营商可能会收取数据通信费用)"));
        textDesc2.setText(Html.fromHtml(builder.toString()));

    }

    /**
     * 深色文本
     */
    public String darkText(String text) {
        return "<strong><font color='#333333'>" + text + "</font></strong>";
    }

    /**
     * 浅色文本
     */
    public String lightText(String text) {
        return "<font color='#666666'>" + text + "</font>";
    }

}
