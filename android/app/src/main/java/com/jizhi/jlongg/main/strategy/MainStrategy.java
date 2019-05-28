package com.jizhi.jlongg.main.strategy;

import android.view.LayoutInflater;
import android.view.View;

/**
 * 处理策略数据
 * 主要是首页展示项目组 以及显示找工作时的处理
 *
 * @author Xuj
 * @time 2018年6月19日14:29:38
 * @Version 1.0
 */
public abstract class MainStrategy {

    public abstract View getView(LayoutInflater inflater);

    abstract void setView(View convertView);

    public abstract void bindData(Object object, View convertView, final int position);
}
