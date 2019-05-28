package com.jizhi.jlongg.main.activity.procloud;

import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.text.Editable;
import android.text.Html;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.animation.Animation;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.ExpandableListView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.ProCloudService;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.SecondLevelMenuFileAdatper;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Cloud;
import com.jizhi.jlongg.main.bean.CloudConfiguration;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.dialog.pro_cloud.DialogBrowser;
import com.jizhi.jlongg.main.dialog.pro_cloud.DialogCreateFolder;
import com.jizhi.jlongg.main.dialog.pro_cloud.DialogRenameFile;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.popwindow.ProCloudyPopWindow;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.ResizeAnimation;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.cloud.CloudUtil;
import com.jizhi.jlongg.main.util.cloud.OssClientUtil;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import droidninja.filepicker.FilePickerConst;

/**
 * 项目云盘
 *
 * @author Xuj
 * @time 2017年7月17日10:04:07
 * @Version 1.0
 */
public class ProCloudActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 组id
     */
    private String groupId;
    /**
     * 列表数据
     */
    private List<Cloud> list;
    /**
     * 二级菜单
     */
    private ExpandableListView listView;
    /**
     * 云盘适配器
     */
    private SecondLevelMenuFileAdatper adatper;
    /**
     * 顶部更多按钮
     */
    private TextView rightTitle;
    /**
     * 取消文字,选中文本、已选文件的提示
     */
    private TextView cancelText, selectedText, checkTextTips;
    /**
     * 返回布局、搜索文件输入框布局
     */
    private View returnView, inputLayout;
    /**
     * 是否选中了全部文件
     */
    private boolean isSelecteAllFiles;
    /**
     * 传输文件、新建文件、上传文件、移动文件、删除文件 布局
     */
    private LinearLayout transmissionLayout, createFileLayout, uploadFileLayout, moveFileLayout, deleteFileLayout;
    /**
     * 文件父id
     */
    private String parentId;
    /**
     * 模糊搜索框
     */
    private ClearEditText mClearEditText;
    /**
     * 云盘已用空间、云盘总空间大小
     */
    private double cloudUseSpace, cloudTotalSpace;
    /**
     * 项目名称
     */
    private String groupName;
    /**
     * true 表示已关闭
     */
    private boolean isCLose;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId         项目组id
     * @param cloudTotalSpace 云盘总空间大小 单位是GB
     * @param cloudUseSpace   云盘已用空间 单位是GB
     * @param groupName       项目名称
     * @param fileParentId    文件父id
     * @param fileName        文件名称 主要是做标题展示
     * @param isClosed        项目是否已关闭
     */
    public static void actionStart(Activity context, String groupId, double cloudTotalSpace, double cloudUseSpace, String groupName, String fileParentId, String fileName, boolean isClosed) {
        Intent intent = new Intent(context, ProCloudActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.GROUP_NAME, groupName);
        intent.putExtra(Constance.CLOUD_TOTAL_SPACE, cloudTotalSpace);
        intent.putExtra(Constance.CLOUD_USE_SPACE, cloudUseSpace);
        intent.putExtra(Constance.FILE_PARENT_ID, fileParentId);
        intent.putExtra(Constance.FILE_PARENT_NAME, fileName);
        intent.putExtra(Constance.IS_CLOSED, isClosed);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId         项目组id
     * @param cloudTotalSpace 云盘总空间大小 单位是GB
     * @param cloudUseSpace   云盘已用空间 单位是G
     * @param groupName       项目名称
     * @param fileParentId    文件父id
     * @param isClosed        项目是否已关闭
     */
    public static void actionStart(Activity context, String groupId, double cloudTotalSpace, double cloudUseSpace, String groupName, String fileParentId, boolean isClosed) {
        Intent intent = new Intent(context, ProCloudActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.GROUP_NAME, groupName);
        intent.putExtra(Constance.CLOUD_TOTAL_SPACE, cloudTotalSpace);
        intent.putExtra(Constance.CLOUD_USE_SPACE, cloudUseSpace);
        intent.putExtra(Constance.FILE_PARENT_ID, fileParentId);
        intent.putExtra(Constance.IS_CLOSED, isClosed);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pro_cloud);
        initView();
        loadCloudFiles();
    }

    private void initView() {
        Intent intent = getIntent();
        isCLose = intent.getBooleanExtra(Constance.IS_CLOSED, false);
        parentId = intent.getStringExtra(Constance.FILE_PARENT_ID);
        groupId = intent.getStringExtra(Constance.GROUP_ID);
        cloudUseSpace = intent.getDoubleExtra(Constance.CLOUD_USE_SPACE, 0);
        cloudTotalSpace = intent.getDoubleExtra(Constance.CLOUD_TOTAL_SPACE, 0);
        groupName = intent.getStringExtra(Constance.GROUP_NAME);

        getTextView(R.id.defaultDesc).setText("云盘暂时没有任何资料");
        TextView title = getTextView(R.id.title);

        if (!TextUtils.isEmpty(parentId) && parentId.equals(CloudUtil.ROOT_DIR)) {
            Drawable dawable = getResources().getDrawable(R.drawable.helper);
            dawable.setBounds(0, 0, dawable.getIntrinsicWidth(), dawable.getIntrinsicHeight());
            title.setCompoundDrawablePadding(DensityUtils.dp2px(getApplicationContext(), 2)); //设置文字与清除图片的距离
            title.setCompoundDrawables(null, null, dawable, null);
            title.setOnClickListener(this);
        }
        title.setText(!TextUtils.isEmpty(parentId) && parentId.equals(CloudUtil.ROOT_DIR) ? getString(R.string.pro_cloud) : intent.getStringExtra(Constance.FILE_PARENT_NAME));


        rightTitle = (TextView) findViewById(R.id.right_title);
        cancelText = getTextView(R.id.cancelText);
        inputLayout = findViewById(R.id.input_layout);
        returnView = findViewById(R.id.lin_back);
        selectedText = getTextView(R.id.selecteAllOrCancelAllText);
        checkTextTips = getTextView(R.id.checkTextTips);
        transmissionLayout = (LinearLayout) findViewById(R.id.transmissionLayout);
        createFileLayout = (LinearLayout) findViewById(R.id.createFileLayout);
        uploadFileLayout = (LinearLayout) findViewById(R.id.uploadFileLayout);
        moveFileLayout = (LinearLayout) findViewById(R.id.moveFileLayout);
        deleteFileLayout = (LinearLayout) findViewById(R.id.deleteFileLayout);
        listView = (ExpandableListView) findViewById(R.id.listView);
        listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() { //长按事件
            @Override
            public boolean onItemLongClick(AdapterView<?> adapterView, View view, int position, long l) {
                if (adatper != null && adatper.getGroupCount() > 0) {
                    if (adatper.isEditor()) {
                        return false;
                    }
                    clearAllFileSelectState();
                    adatper.getList().get(position).setSelected(true);
                    showEditorState();
                }
                return false;
            }
        });
        listView.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
            @Override
            public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
                Cloud cloud = adatper.getList().get(groupPosition);
                if (adatper.isEditor()) { //正在编辑状态下
                    boolean isSelected = !cloud.isSelected();
                    cloud.setSelected(isSelected);
                    if (isSelected && isSelecteAll()) {
                        isSelecteAllFiles = true;
                        selectedText.setText(R.string.cancel_check_all);
                    } else {
                        isSelecteAllFiles = false;
                        selectedText.setText(R.string.check_all);
                    }
                    setSelectedFilesCountTips();
                    adatper.notifyDataSetChanged();
                } else { //非编辑状态
                    if (cloud.getType().equals(CloudUtil.FOLDER_TAG)) { //文件夹 递归打开
                        ProCloudActivity.actionStart(ProCloudActivity.this, groupId, cloudTotalSpace, cloudUseSpace, groupName,
                                cloud.getId(), cloud.getFile_name(), isCLose);
                        if (!TextUtils.isEmpty(mClearEditText.getText().toString())) {
                            mClearEditText.setText("");
                        }
                    } else { //文件  这里处理文件解析事件
                        if (!ProductUtil.IscloudSpaceEnough(ProCloudActivity.this, cloudUseSpace, cloudTotalSpace, groupId)) { //云盘空间大小已不够使用
                            return true;
                        }
                        CloudUtil.openFileOrShareFile(ProCloudActivity.this, cloud, CloudUtil.OPEN_FILE, groupId, adatper.getList());
                    }
                }
                return true;
            }
        });
        mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("输入文件名查找");
        mClearEditText.setImeOptions(EditorInfo.IME_ACTION_SEARCH);
        // 根据输入框输入值的改变来过滤搜索
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (TextUtils.isEmpty(s.toString())) {
                    if (adatper != null) {
                        adatper.setFilterValue(null);
                        adatper.updateList(list);
                    }
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        mClearEditText.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_SEARCH) {//按下手机键盘的搜索按钮的时候去 执行搜索的操作
                    searchCloudFiles(mClearEditText.getText().toString());
                }
                return false;
            }
        });
        rightTitle.setText(R.string.more);
        findViewById(R.id.bottom_layout).setVisibility(isCLose ? View.GONE : View.VISIBLE);
        rightTitle.setVisibility(isCLose ? View.GONE : View.VISIBLE);
    }

    /**
     * 加载云盘数据
     */
    private void loadCloudFiles() {
        CloudUtil.getCloudDir(this, groupId, WebSocketConstance.TEAM, parentId, false, new CloudUtil.GetFileListListener() {
            @Override
            public void onSuccess(List<Cloud> list) {
                setAdatper(list);
            }

            @Override
            public void onFailure() {

            }
        });
    }


    private void setAdatper(List<Cloud> list) {
        this.list = list;
        if (adatper == null) {
            adatper = new SecondLevelMenuFileAdatper(ProCloudActivity.this, list, new CloudUtil.FileEditorListener() {
                @Override
                public void renameFile(final Cloud cloud) { //文件重命名
                    DialogRenameFile renameDialog = new DialogRenameFile(ProCloudActivity.this);
                    renameDialog.setFileType(cloud, new DialogRenameFile.RenameFileListener() {
                        @Override
                        public void getUpdateName(String fileName) {
                            ProCloudActivity.this.renameFile(cloud, fileName);
                        }
                    });
                    renameDialog.openKeyBoard();
                    renameDialog.show();
                }

                @Override
                public void shareFile(final Cloud cloud) { //文件分享
                    CloudUtil.openFileOrShareFile(ProCloudActivity.this, cloud, CloudUtil.SHARE_FILE, groupId, adatper.getList());
                }

                @Override
                public void downLoadFile(final Cloud cloud) { //文件下载
                    int fileState = ProCloudService.getInstance(getApplicationContext()).getFileDownLoadState(getApplicationContext(), cloud.getId(), groupId); //获取文件状态
                    if (fileState == CloudUtil.FILE_COMPLETED_STATE) { //文件已下载完毕
                        CommonMethod.makeNoticeLong(getApplicationContext(), "该文件已下载,不需要再次下载，可在 传输列表 中找到此文件", CommonMethod.SUCCESS);
                        return;
                    }
                    if (fileState == CloudUtil.FILE_LOADING_STATE) {  //文件正在下载中
                        CommonMethod.makeNoticeLong(getApplicationContext(), "该文件正在下载,可在 传输列表 中找到此文件", CommonMethod.SUCCESS);
                        return;
                    }
                    CloudUtil.getOssClientDownLoadInfo(ProCloudActivity.this, cloud.getId(), new CloudUtil.GetOssConfigurationListener() {
                        @Override
                        public void onSuccess(CloudConfiguration configuration) {
                            CommonMethod.makeNoticeLong(ProCloudActivity.this, "文件开始下载,可在 传输列表 中找到此文件", CommonMethod.SUCCESS);
                            OssClientUtil ossClientUtil = OssClientUtil.getInstance(getApplicationContext(), configuration.getEndPoint(),
                                    configuration.getAccessKeyId(), configuration.getAccessKeySecret(), configuration.getSecurityToken());
                            final Cloud cloudDaoInfo = ProCloudService.getInstance(getApplicationContext()).getFileDownLoadInfo(getApplicationContext(), cloud.getId(), groupId);
                            if (cloudDaoInfo != null) { //获取文件本地已保存的信息  有存在的信息
                                ossClientUtil.downLoadFile(getApplicationContext(), cloudDaoInfo.getBucket_name(), cloudDaoInfo.getOss_file_name(), cloudDaoInfo, groupId);
                            } else {
                                String saveName = cloud.getId() + "_" + UclientApplication.getUid(getApplicationContext()) + "_" + cloud.getFile_name();
                                cloud.setFileTotalSize(configuration.getFile_size());//设置文件的总大小
                                cloud.setFileLocalPath(OssClientUtil.DOWNLOADING_PATH + saveName); //设置下载中的路径
                                cloud.setFileTypeState(CloudUtil.FILE_TYPE_DOWNLOAD_TAG); //设置文件下载标识
                                ProCloudService.getInstance(getApplicationContext()).saveFileDownLoadInfo(getApplicationContext(), cloud); //保存下载的信息
                                ossClientUtil.downLoadFile(getApplicationContext(), cloud.getBucket_name(), cloud.getOss_file_name(), cloud, groupId);
                            }
                        }
                    });
                }

                @Override
                public void startFile(Cloud cloud) {

                }

                @Override
                public void pauseFile(Cloud cloud) {

                }

                @Override
                public void showFileDetail(Cloud cloud, int groupPosition) { //显示文件的详情
                    if (!ProductUtil.IscloudSpaceEnough(ProCloudActivity.this, cloudUseSpace, cloudTotalSpace, groupId)) { //云盘空间大小已不够使用
                        return;
                    }
                    int size = adatper.getGroupCount();
                    for (int i = 0; i < size; i++) {
                        if (groupPosition != i) {
                            if (listView.isGroupExpanded(i)) {
                                listView.collapseGroup(i); // 关闭所有的展开项
                            }
                        }
                    }
                    listView.smoothScrollToPosition(groupPosition);
                    if (listView.isGroupExpanded(groupPosition)) {
                        listView.collapseGroup(groupPosition);
                        cloud.setShowFileDetail(false);
                    } else {
                        listView.expandGroup(groupPosition);
                        cloud.setShowFileDetail(true);
                    }
                    adatper.notifyDataSetChanged();
                }
            });
            adatper.setShowFileDetail(!isCLose);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setAdapter(adatper);
        } else {
            adatper.updateList(list);
        }
    }


    /**
     * 搜索云盘数据
     */
    private void searchCloudFiles(final String fileName) {
        if (adatper == null || adatper.getGroupCount() == 0) {
            return;
        }
        CloudUtil.searchFile(this, fileName, parentId, groupId, false, new CloudUtil.GetFileListListener() {
            @Override
            public void onSuccess(List<Cloud> list) {
                adatper.setFilterValue(mClearEditText.getText().toString());
                adatper.updateList(list);
            }

            @Override
            public void onFailure() {

            }
        });
    }


    /**
     * 删除云盘数据
     */
    private void deleteCloudFiles(String sourceIds) {
        CloudUtil.deleteFiles(this, groupId, WebSocketConstance.TEAM, sourceIds, CloudUtil.DELELTE_FILE, parentId, new CloudUtil.GetFileListListener() {
            @Override
            public void onSuccess(List<Cloud> list) {
                cancelEditorState();
                setAdatper(list);
            }

            @Override
            public void onFailure() {

            }
        });
    }


    /**
     * 重命名文件
     *
     * @param cloud      文件信息
     * @param renameFile 重命名的文件名称
     */
    private void renameFile(final Cloud cloud, final String renameFile) {
        final String fileType = cloud.getType().equals(CloudUtil.FOLDER_TAG) ? "dir" : "file";
        CloudUtil.renameFile(this, renameFile, fileType, cloud.getId(), new CloudUtil.GetFileListListener() {
            @Override
            public void onSuccess(List<Cloud> list) {
//                cloud.setFile_name(fileType.equals(CloudUtil.FILE_TAG) ? updateName + "." + cloud.getFile_type() : updateName);
//                cloud.setFile_name(renameFile);
//                adatper.notifyDataSetChanged();
                loadCloudFiles();
            }

            @Override
            public void onFailure() {

            }
        });
    }

    /**
     * 上传文件
     *
     * @param fileName 文件名称
     * @param filePath 文件路径
     * @param fileSize 文件大小
     */
    private void uploadFiles(final String fileName, final String filePath, final long fileSize, final OssClientUtil.UpLoadSuccessListener listener) {
        if (filePath.lastIndexOf(".") == -1) { //文件没有后缀名 不能提交上去
            CommonMethod.makeNoticeShort(getApplicationContext(), "此文件没有后缀名不能上传", CommonMethod.ERROR);
            return;
        }
        final int upLoadState = ProCloudService.getInstance(getApplicationContext()).getFileUpLoadState(getApplicationContext(), filePath, groupId); //获取上传文件状态
        if (upLoadState != CloudUtil.FILE_NO_EXIST) {//数据库中已存在上传的数据
            CommonMethod.makeNoticeShort(getApplicationContext(), "上传的文件已存在", CommonMethod.ERROR);
            return;
        }
        final String fileType = filePath.substring(filePath.lastIndexOf(".") + 1); //文件类型
        CloudUtil.getUploadFileOssClientInfo(this, groupId, WebSocketConstance.TEAM, parentId, fileName, fileType, fileSize + "", null, new CloudUtil.UploadFileListener() {
            @Override
            public void onSuccess(CloudConfiguration configuration) {
                CommonMethod.makeNoticeLong(getApplicationContext(), "该文件已在上传,可在 传输列表 中找到此文件", CommonMethod.SUCCESS);
                OssClientUtil instance = OssClientUtil.getInstance(getApplicationContext(), configuration.getEndPoint(), configuration.getAccessKeyId(), configuration.getAccessKeySecret(), configuration.getSecurityToken());
                String bucketKey = configuration.getObject_name() + File.separator + configuration.getBucketname() + File.separator + fileName;
                if (upLoadState != CloudUtil.FILE_NO_EXIST) { //数据库中已存在上传的数据
                    Cloud daoCloud = ProCloudService.getInstance(getApplicationContext()).getFileUpLoadInfo(getApplicationContext(), filePath, groupId); //获取数据库中已存的下载信息
                    instance.asyncUpload(getApplicationContext(), daoCloud, configuration.getBucketname(), filePath, bucketKey, groupId, configuration, listener);
                } else { //创建一个数据库上传的对象  记录上传的进度状态等
                    String fileTime = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date(configuration.getUpload_time() * 1000)); //文件上传的时间
                    Cloud cloud = new Cloud(configuration.getId(), fileName, "file:///" + filePath, configuration.getBucketname(), bucketKey,
                            fileTime, configuration.getFile_broad_type(), fileType, filePath, fileSize, CloudUtil.FILE_LOADING_STATE, CloudUtil.FILE_TYPE_UPLOAD_TAG,
                            parentId, groupId, CloudUtil.FILE_TAG, null);
                    ProCloudService.getInstance(getApplicationContext()).saveFileUpLoadInfo(getApplicationContext(), cloud, groupId); //首次保存上传的信息
                    instance.asyncUpload(getApplicationContext(), cloud, configuration.getBucketname(), filePath, bucketKey, groupId, configuration, listener);
                }
            }
        });
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.translateText: //传输列表
                if (!ProductUtil.IscloudSpaceEnough(ProCloudActivity.this, cloudUseSpace, cloudTotalSpace, groupId)) { //云盘空间大小已不够使用
                    return;
                }
                TranmissionActivity.actionStart(this, groupId);
                break;
            case R.id.createFileText: //创建文件
                if (!ProductUtil.IscloudSpaceEnough(ProCloudActivity.this, cloudUseSpace, cloudTotalSpace, groupId)) { //云盘空间大小已不够使用
                    return;
                }
                final DialogCreateFolder createFolderDialog = new DialogCreateFolder(this);
                createFolderDialog.setListener(new DialogCreateFolder.CreateFolderGetNameListener() {
                    @Override
                    public void getName(String folderName) {
                        CloudUtil.createCloudDir(ProCloudActivity.this, groupId,
                                WebSocketConstance.TEAM, parentId, folderName, CloudUtil.UN_MOVE_FILE_TAG, null, new CloudUtil.GetFileListListener() {
                                    @Override
                                    public void onSuccess(List<Cloud> list) {
                                        createFolderDialog.dismiss();
                                        setAdatper(list);
                                    }

                                    @Override
                                    public void onFailure() {
                                    }
                                });
                    }
                });
                createFolderDialog.openKeyBoard();
                createFolderDialog.show();
                break;
            case R.id.uploadFileText: //上传文件
                if (!ProductUtil.IscloudSpaceEnough(ProCloudActivity.this, cloudUseSpace, cloudTotalSpace, groupId)) { //云盘空间大小已不够使用
                    return;
                }
                DialogBrowser dialogBrowser = new DialogBrowser(this);
                dialogBrowser.show();
                break;
            case R.id.right_title: //操作更多
                ProCloudyPopWindow moreDialog = new ProCloudyPopWindow(this, new ProCloudyPopWindow.MoreActionsListener() {
                    @Override
                    public void clickMoreActions() { //操作更多
                        if (adatper != null && adatper.getGroupCount() > 0) {
                            clearAllFileSelectState();
                            showEditorState();
                        }
                    }

                    @Override
                    public void clickRecycleBin() { //回收站
                        RecycleBinActivity.actionStart(ProCloudActivity.this, groupId, parentId);
                    }
                });
                //显示窗口
                moreDialog.showAsDropDown(rightTitle, 0, DensityUtils.dp2px(this, 10));
                break;
            case R.id.deleteFileText: //删除文件
                if (adatper == null || adatper.getGroupCount() == 0) {
                    return;
                }
                DialogOnlyTitle deleteDialog = new DialogOnlyTitle(this, new DiaLogTitleListener() {
                    @Override
                    public void clickAccess(int position) {
                        List<Cloud> delteFiles = new ArrayList<>();
                        for (Cloud cloud : adatper.getList()) {
                            if (cloud.isSelected()) {
                                delteFiles.add(cloud);
                            }
                        }
                        if (delteFiles.size() == 0) {
                            return;
                        }
                        deleteCloudFiles(new Gson().toJson(delteFiles));
                    }
                }, -1, getString(R.string.delete_pro_cloudfile_tips));
                deleteDialog.show();
                break;
            case R.id.moveFileText: //移动文件
                if (!ProductUtil.IscloudSpaceEnough(ProCloudActivity.this, cloudUseSpace, cloudTotalSpace, groupId)) { //云盘空间大小已不够使用
                    return;
                }
                StringBuilder eliminateIdsBuilder = new StringBuilder(); //移动文件时需要排除的文件id
                List<Cloud> selecteFilesList = new ArrayList<>();
                for (Cloud cloud : adatper.getList()) {
                    if (cloud.isSelected()) {
                        eliminateIdsBuilder.append(TextUtils.isEmpty(eliminateIdsBuilder.toString()) ? cloud.getId() : "," + cloud.getId());
                        selecteFilesList.add(cloud);
                    }
                }
                if (selecteFilesList.size() == 0) {
                    return;
                }
                MoveFileActivity.actionStart(this, groupId, "0", new Gson().toJson(selecteFilesList), eliminateIdsBuilder.toString());
                cancelEditorState();
                break;
            case R.id.cancelText: //取消编辑
                cancelEditorState();
                break;
            case R.id.selecteAllOrCancelAllText: //取消全选、选中全部
                if (isSelecteAllFiles) {
                    clearAllFileSelectState();
                } else {
                    selecteAllFilesState();
                }
                setSelectedFilesCountTips();
                adatper.notifyDataSetChanged();
                break;
            case R.id.title:
                HelpCenterUtil.actionStartHelpActivity(this, 191);
                break;
        }
    }

    /**
     * 是否选中了全部
     *
     * @return
     */
    public boolean isSelecteAll() {
        if (adatper != null && adatper.getGroupCount() > 0) {
            int count = 0;
            for (Cloud cloud : adatper.getList()) {
                if (cloud.isSelected()) {
                    count += 1;
                }
            }
            return count == adatper.getGroupCount() ? true : false;
        }
        return false;
    }

    /**
     * 清空文件选中状态
     *
     * @return
     */
    public void clearAllFileSelectState() {
        if (adatper != null && adatper.getGroupCount() > 0) {
            for (Cloud cloud : adatper.getList()) {
                if (cloud.isSelected()) {
                    cloud.setSelected(false);
                }
            }
            isSelecteAllFiles = false;
            selectedText.setText(R.string.check_all);
        }
    }


    /**
     * 设置文件全选
     *
     * @return
     */
    public void selecteAllFilesState() {
        if (adatper != null && adatper.getGroupCount() > 0) {
            for (Cloud cloud : adatper.getList()) {
                cloud.setSelected(true);
            }
            isSelecteAllFiles = true;
            selectedText.setText(R.string.cancel_check_all);
        }
    }

    /**
     * 取消文件编辑状态
     */
    private void cancelEditorState() {
        closeSelectedTextAnim();
        inputLayout.setVisibility(View.VISIBLE);
        cancelText.setVisibility(View.GONE);
        rightTitle.setVisibility(View.VISIBLE);
        returnView.setVisibility(View.VISIBLE);
        selectedText.setVisibility(View.GONE);

        transmissionLayout.setVisibility(View.VISIBLE); //隐藏传输文件按钮
        uploadFileLayout.setVisibility(View.VISIBLE); //隐藏上传文件按钮
        createFileLayout.setVisibility(View.VISIBLE);//隐藏新建文件按钮
        deleteFileLayout.setVisibility(View.GONE); //显示删除文件按钮
        moveFileLayout.setVisibility(View.GONE); //显示移动文件按钮

        adatper.setEditor(false);
        adatper.notifyDataSetChanged();
    }

    /**
     * 显示文件编辑状态
     */
    private void showEditorState() {
        setSelectedFilesCountTips();
        openSelectedTextAnim();
        inputLayout.setVisibility(View.GONE);
        cancelText.setVisibility(View.VISIBLE);
        rightTitle.setVisibility(View.GONE);
        returnView.setVisibility(View.GONE);
        selectedText.setVisibility(View.VISIBLE);
        transmissionLayout.setVisibility(View.GONE); //隐藏传输文件按钮
        uploadFileLayout.setVisibility(View.GONE); //隐藏上传文件按钮
        createFileLayout.setVisibility(View.GONE);//隐藏新建文件按钮
        deleteFileLayout.setVisibility(View.VISIBLE); //显示删除文件按钮
        moveFileLayout.setVisibility(View.VISIBLE); //显示移动文件按钮
        adatper.setEditor(true);
        adatper.notifyDataSetChanged();
    }


    /**
     * 设置选中文件个数的提示
     */
    private void setSelectedFilesCountTips() {
        int count = 0;
        if (adatper != null && adatper.getGroupCount() > 0) {
            for (Cloud cloud : adatper.getList()) {
                if (cloud.isSelected()) {
                    count += 1;
                }
            }
        }
        checkTextTips.setText(Html.fromHtml("<font color='#999999'>已选中</font><font color='#eb4e4e'> " + count + " </font><font color='#999999'>个文件</font>"));
    }


    /**
     * 开启选中状态动画
     */
    private void openSelectedTextAnim() {
        checkTextTips.setVisibility(View.VISIBLE);
        ResizeAnimation animation = new ResizeAnimation(checkTextTips);
        animation.setDuration(300);
        animation.setParams(0, DensityUtils.dp2px(getApplicationContext(), 35));
        checkTextTips.startAnimation(animation);
    }

    /**
     * 关闭选中状态动画
     */
    private void closeSelectedTextAnim() {
        ResizeAnimation animation = new ResizeAnimation(checkTextTips);
        animation.setDuration(300);
        animation.setParams(DensityUtils.dp2px(getApplicationContext(), 35), 0);
        checkTextTips.startAnimation(animation);
        animation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                checkTextTips.setVisibility(View.GONE);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.DEGRADE) {
            setResult(Constance.DEGRADE);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //查看订单
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //返回首页
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        } else if (requestCode == Constance.REQUEST) {
            loadCloudFiles();
        } else if (requestCode == FilePickerConst.REQUEST_CODE_PHOTO || requestCode == FilePickerConst.REQUEST_CODE_DOC) { //上传文件回调
            if (resultCode == Activity.RESULT_OK && data != null) {
                List<String> selectePath = new ArrayList<>();
                selectePath.addAll(data.getStringArrayListExtra(requestCode == FilePickerConst.REQUEST_CODE_PHOTO ? FilePickerConst.KEY_SELECTED_MEDIA : FilePickerConst.KEY_SELECTED_DOCS));
                for (String path : selectePath) {
                    File file = new File(path);
                    uploadFiles(file.getName(), file.getAbsolutePath(), file.length(), new OssClientUtil.UpLoadSuccessListener() {
                        @Override
                        public void onUpdateSuccess() {
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    loadCloudFiles();
                                }
                            });
                        }
                    });
                }
            }
        }
    }

    @Override
    public void onBackPressed() {
        if (adatper != null && adatper.isEditor()) {
            cancelEditorState();
            return;
        }
        super.onBackPressed();
    }

}