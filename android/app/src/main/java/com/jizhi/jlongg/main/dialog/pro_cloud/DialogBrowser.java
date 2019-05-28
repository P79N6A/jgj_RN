package com.jizhi.jlongg.main.dialog.pro_cloud;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;

import droidninja.filepicker.FilePickerBuilder;
import droidninja.filepicker.FilePickerConst;


/**
 * 功能:项目云盘-->重命名文件夹
 * 时间:2017年7月17日14:43:52
 * 作者:xuj
 */
public class DialogBrowser extends Dialog implements View.OnClickListener {


    private BaseActivity activity;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public DialogBrowser(BaseActivity activity) {
        super(activity, R.style.network_dialog_style);
        this.activity = activity;
        createLayout(activity);
        commendAttribute(true);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity activity) {
        setContentView(R.layout.selecte_browser);
        findViewById(R.id.picLayout).setOnClickListener(this);
        findViewById(R.id.videoLayout).setOnClickListener(this);
        findViewById(R.id.txtLayout).setOnClickListener(this);

        findViewById(R.id.pdfLayout).setOnClickListener(this);
        findViewById(R.id.excelLayout).setOnClickListener(this);
        findViewById(R.id.docLayout).setOnClickListener(this);

        findViewById(R.id.pptLayout).setOnClickListener(this);
        findViewById(R.id.cadLayout).setOnClickListener(this);
        findViewById(R.id.zipLayout).setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.picLayout: //图片
                startPicBrowse();
                break;
            case R.id.videoLayout: //视频
                startVideoBrowse();
                break;
            case R.id.txtLayout: //txt
                startFileBrowse(new String[]{".txt"}, "txt", R.drawable.txt_icon);
                break;
            case R.id.pdfLayout: //pdf文件
                startFileBrowse(new String[]{".pdf"}, FilePickerConst.PDF, R.drawable.pdf_icon);
                break;
            case R.id.excelLayout: //excel文件
                startFileBrowse(new String[]{".xls", ".xlsx"}, FilePickerConst.XLS, R.drawable.excel_icon);
                break;
            case R.id.docLayout: //doc文件
                startFileBrowse(new String[]{".doc", ".docx", ".dot", ".dotx"}, FilePickerConst.DOC, R.drawable.doc_icon_cloud);
                break;
            case R.id.pptLayout: //ppt文件
                startFileBrowse(new String[]{".ppt"}, FilePickerConst.PPT, R.drawable.cloud_ppt_icon);
                break;
            case R.id.cadLayout: //cad
                startFileBrowse(new String[]{".cad", ".dwg"}, "CAD", R.drawable.doc_icon_cloud);
                break;
            case R.id.zipLayout: //压缩包
                startFileBrowse(new String[]{".zip", ".rar"}, "ZIP", R.drawable.zip_icon);
                break;
        }
        dismiss();
    }

    /**
     * 开启视频浏览
     */
    public void startVideoBrowse() {
        FilePickerBuilder.getInstance().setMaxCount(1)
                .setActivityTheme(R.style.FilePickerTheme)
                .enableVideoPicker(true)
                .enableImagePicker(false)
                .showGifs(false)
                .showFolderView(true)
                .pickPhoto(activity);
    }

    /**
     * 开启图片浏览
     */
    public void startPicBrowse() {
        FilePickerBuilder.getInstance().setMaxCount(1)
                .setActivityTheme(R.style.FilePickerTheme)
                .enableImagePicker(true)
                .showGifs(false)
                .showFolderView(true)
                .pickPhoto(activity);
    }

    /**
     * 开启文件浏览
     *
     * @param typs         文件类型
     * @param typeName     文件类型名称
     * @param fileResource 文件类型图标
     */
    public void startFileBrowse(String[] typs, String typeName, int fileResource) {
        FilePickerBuilder.getInstance().setMaxCount(1)
                .setActivityTheme(R.style.FilePickerTheme)
                .addFileSupport(typeName, typs, fileResource)
                .enableDocSupport(false)
                .pickFile(activity);
    }

}
