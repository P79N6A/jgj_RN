package com.jizhi.jlongg.main.fragment;

import android.support.v4.app.Fragment;
import android.widget.TextView;

import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.dialog.SystemDateDialog;
import com.jizhi.jlongg.main.dialog.WheelViewAboutMyProject;
import com.lidroid.xutils.http.RequestParams;

import java.util.List;

/**
 * 功能:Fragment 记账抽象类
 * 时间:2016-7-19 14:47
 * 作者:Xuj
 */
public abstract class AccountAbstractFragment extends Fragment {

    /**
     * 记账对象
     */
    public TextView per_name;
    /**
     * 提交时间
     */
    public TextView submitTime;
    /**
     * 所在项目
     */
    public TextView recordProject;
    /**
     * 备注信息
     */
    public TextView remark_text;
    /**
     * 提示信息
     */
    public String notice;
    /**
     * 参数对象
     */
    public RequestParams params;
    /**
     * 年、月、日
     */
    public int year, month, day;
    /**
     * 当前时间描述
     */
    public String currentTimeDesc;
    /**
     * 选择与我相关项目的WheelView
     */
    public WheelViewAboutMyProject addProject;
    /**
     * 系统日期弹出框
     */
    public SystemDateDialog systemDateDialog;
    /**
     * 语音路径
     */
    public String voicePath;
    /**
     * 语音长度
     */
    public int voiceLength;
    /**
     * 图片数据
     */
    public List<ImageItem> imageItems;
    /**
     * 选择对象列表数据
     */
    public List<PersonBean> personList;
    /**
     * 与我相关项目数据
     */
    public List<Project> projectList;
    /**
     * 项目id
     */
    public int pid;
    /**
     * 记账对象ID
     */
    public int uid;
    /**
     * 记账人电话号码
     */
    public String telphone;
    /**
     * 使用说明
     */
    public abstract void guide();

    /**
     * 记账数据提交
     */
    public abstract void FileUpData(final int type);


    /**
     * 查询最后一次记账信息
     */
    public abstract void LastRecordInfo();


    /**
     * 设置记账对象信息
     *
     * @param personName 记账对象名称
     */
    public void setPersonInfo(String personName) {
        if (per_name != null) {
            per_name.setText(personName);
        } else {
            per_name.setText("");
        }
    }

    /**
     * 设置项目名称
     *
     * @param projectName 项目名称
     */
    public void setProjectInfo(String projectName) {
        if (recordProject != null) {
            recordProject.setText(projectName);
        }
    }

    /**
     * 设置描述信息
     *
     * @param desc 描述内容
     */
    public void setRemarkDesc(String desc) {
        if (remark_text != null) {
            remark_text.setText(desc);
        }
    }
}
