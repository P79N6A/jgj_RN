package com.jizhi.jlongg.main.fragment;

import android.support.v4.app.Fragment;
import android.text.TextUtils;
import android.view.Gravity;

import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.AccountItemAdapter;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.RecordItem;
import com.jizhi.jlongg.main.dialog.SystemDateDialog;
import com.jizhi.jlongg.main.dialog.WheelViewAboutMyProject;
import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.lidroid.xutils.http.RequestParams;

import java.util.List;

/**
 * 功能:Fragment 记账抽象类
 * 时间:2016-7-19 14:47
 * 作者:Xuj
 */
public abstract class AccountBaseInfo extends Fragment {
    /**
     * 点工记账列表适配器
     */
    public AccountItemAdapter adapter;
    /**
     * 当数据选择不完整时的提示
     */
    public String missingDataTips;
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
     * 所属项目弹出框
     */
    public WheelViewAboutMyProject selectedProjectPopWindow;
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
    public abstract void searchLastInfo();

    /**
     * 设置项目名称
     * @param proName
     * @param pid
     */
    public abstract void setProName(String proName, int pid);
    /**
     * 设置记账对象名称
     * @param recordName
     */
    public abstract void setRecordName(String recordName);
    /**
     * 设置备注信息
     * @param remarkDesc
     */
    public abstract void setRemarkInfo(String remarkDesc);

    /**
     * 根据类型 设置列不可点击
     * @param itemType
     */
    public void setItemUnClickAndValue(String itemType, String value) {
        if (adapter == null) {
            return;
        }
        for (RecordItem item : adapter.getList()) {
            if (item.getItemType().equals(itemType)) {
                item.setClick(false);
                item.setValue(value);
                adapter.notifyDataSetChanged();
                return;
            }
        }
    }

    /**
     * 根据类型 设置列表值
     * @param itemType
     * @param value
     */
    public void setItemValue(String itemType, String value) {
        if (adapter == null) {
            return;
        }
        for (RecordItem item : adapter.getList()) {
            if (item.getItemType().equals(itemType)) {
                item.setValue(value);
                adapter.notifyDataSetChanged();
                return;
            }
        }
    }

    /**
     * 根据类型获取值
     * @param itemType
     * @return
     */
    public String getItemValue(String itemType) {
        if (adapter == null) {
            return null;
        }
        for (RecordItem item : adapter.getList()) {
            if (item.getItemType().equals(itemType)) {
                return item.getValue();
            }
        }
        return null;
    }

    /**
     * 设置当前日期（由前一个界面传过来的）
     * @param dataintent
     */
    public void setData(String dataintent) {//dataintent:20150106
        year = Integer.valueOf(dataintent.substring(0, 4));
        month = Integer.valueOf(dataintent.substring(4, 6));
        day = Integer.valueOf(dataintent.substring(6, 8));
        currentTimeDesc = TimesUtils.getWeek(year, month, day);
    }

    /**
     * 所在项目弹出框
     */
    public void showProjectPopWindow() {
        if (selectedProjectPopWindow == null) {
            selectedProjectPopWindow = new WheelViewAboutMyProject(getActivity(), projectList, true);
            selectedProjectPopWindow.setListener(new CallBackSingleWheelListener() {
                @Override
                public void onSelected(String scrollContent, int postion) {
                    String proname = projectList.get(postion).getPro_name();
                    if (!TextUtils.isEmpty(proname)) {
                        pid = projectList.get(postion).getPid();
                        setItemValue(RecordItem.SELECTED_PROJECT, proname);
                    }
                }
            });
        } else {
            selectedProjectPopWindow.update();
        }
        //显示窗口
        selectedProjectPopWindow.showAtLocation(getActivity().findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(getActivity(), 0.5F);
    }
}
