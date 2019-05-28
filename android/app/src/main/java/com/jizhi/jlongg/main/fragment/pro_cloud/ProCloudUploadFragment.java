package com.jizhi.jlongg.main.fragment.pro_cloud;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ExpandableListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.ProCloudService;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.SecondLevelMenuDownLoadFileAdatper;
import com.jizhi.jlongg.main.bean.Cloud;
import com.jizhi.jlongg.main.bean.CloudConfiguration;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ShareUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.cloud.CloudUtil;
import com.jizhi.jlongg.main.util.cloud.OssClientUtil;
import com.squareup.otto.Subscribe;

import java.io.File;
import java.util.List;

import noman.weekcalendar.eventbus.BusProvider;

/**
 * 功能:项目云盘-->我上传的
 * 作者：xuj
 * 时间: 2017年7月18日11:12:43
 */
public class ProCloudUploadFragment extends Fragment implements View.OnClickListener {

    /**
     * 云盘适配器
     */
    private SecondLevelMenuDownLoadFileAdatper adatper;
    /**
     * 二级菜单
     */
    private ExpandableListView listView;
    /**
     * 文件上传成功的数量
     */
    private TextView upLoadSuccessText;
    /**
     * 项目组id
     */
    private String groupId;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View main_view = inflater.inflate(R.layout.pro_cloud_upload, container, false);
        return main_view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        BusProvider.getInstance().register(this);
        initView();
    }


    private void initView() {
        groupId = getArguments().getString(Constance.GROUP_ID);
        listView = (ExpandableListView) getView().findViewById(R.id.listView);
        upLoadSuccessText = (TextView) getView().findViewById(R.id.upLoadSuccessText);
        ((TextView) (getView().findViewById(R.id.defaultDesc))).setText("暂无文件");
        getUploadData();
        listView.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
            @Override
            public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
                Cloud bean = adatper.getList().get(groupPosition);
                if (bean.getFileState() == CloudUtil.FILE_COMPLETED_STATE) { //文件已上传完毕才能打开文件
                    CloudUtil.openFile(getActivity(), bean, adatper.getList());
                }
                return true;
            }
        });
    }


    /**
     * 获取已下载完毕的数据
     */
    private void getUploadData() {
        List<Cloud> list = ProCloudService.getInstance(getActivity().getApplicationContext()).getUploadOrDownLoadFileList(getActivity().getApplicationContext(), CloudUtil.FILE_TYPE_UPLOAD_TAG, groupId);
        setAdatper(list);
        getUpLoadSuccessCount(list);
    }


    private void getUpLoadSuccessCount(List<Cloud> list) {
        int count = 0;
        if (list != null && list.size() > 0) {
            for (Cloud cloud : list) {
                if (cloud.getFileState() == CloudUtil.FILE_COMPLETED_STATE) { //文件已上传完成标志
                    count += 1;
                }
            }
        }
        upLoadSuccessText.setText("上传完成(" + count + ")");
    }

    private void setAdatper(List<Cloud> list) {
        if (adatper == null) {
            listView.setEmptyView(getView().findViewById(R.id.defaultLayout));
            adatper = new SecondLevelMenuDownLoadFileAdatper((BaseActivity) getActivity(), list, new CloudUtil.FileEditorListener() {
                @Override
                public void renameFile(Cloud cloud) {

                }

                @Override
                public void shareFile(Cloud cloud) {
                    ShareUtil.shareFile(new File(cloud.getFileLocalPath()), getActivity()); //将下载好的文件分享
                }

                @Override
                public void downLoadFile(Cloud cloud) {

                }

                @Override
                public void startFile(final Cloud cloud) {
                    CloudUtil.getUploadFileOssClientInfo((BaseActivity) getActivity(), cloud.getGroup_id(), WebSocketConstance.TEAM, cloud.getParent_id(),
                            cloud.getFile_name(), cloud.getFile_type(), cloud.getFileTotalSize() + "", cloud.getId(), new CloudUtil.UploadFileListener() {
                                @Override
                                public void onSuccess(CloudConfiguration configuration) {
                                    File file = new File(cloud.getFileLocalPath());
                                    if (!file.exists()) { //如果本地断点续传的文件已不存在 则删除数据库 并提示
                                        ProCloudService.getInstance(getActivity().getApplicationContext()).deleteFileInfo(getActivity().getApplicationContext(),
                                                cloud.getId(), groupId, CloudUtil.FILE_TYPE_UPLOAD_TAG + ""); //移除数据库数据
                                        CommonMethod.makeNoticeShort(getActivity(), "上传的文件已不存在", CommonMethod.ERROR);
                                        return;
                                    }
                                    cloud.setFileState(CloudUtil.FILE_LOADING_STATE);
                                    adatper.notifyDataSetChanged();
                                    OssClientUtil instance = OssClientUtil.getInstance(getActivity().getApplicationContext(), configuration.getEndPoint(),
                                            configuration.getAccessKeyId(), configuration.getAccessKeySecret(), configuration.getSecurityToken());
                                    instance.asyncUpload(getActivity().getApplicationContext(), cloud, configuration.getBucketname(),
                                            cloud.getFileLocalPath(), cloud.getOss_file_name(), groupId, configuration, null);
                                }
                            });
                }

                @Override
                public void pauseFile(Cloud cloud) {
                    OssClientUtil.getInstance().setPauseTag(cloud, getActivity().getApplicationContext(), groupId);
                }

                @Override
                public void showFileDetail(Cloud cloud, int groupPosition) {
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
            listView.setAdapter(adatper);
        } else {
            expandGroup();
            adatper.updateList(list);
        }
    }

    @Override
    public void onClick(View v) {

    }

    //文件上传回调
    @Subscribe
    public void upLoadingCallBack(Cloud cloud) {
        if (cloud.getFileTypeState() == CloudUtil.FILE_TYPE_DOWNLOAD_TAG) {
            return;
        }
        if (!TextUtils.isEmpty(cloud.getGroup_id()) && cloud.getGroup_id().equals(groupId) && adatper != null && adatper.getGroupCount() > 0) {
            int size = adatper.getGroupCount();
            for (int i = 0; i < size; i++) {
                Cloud bean = adatper.getList().get(i);
                if (bean.getFileLocalPath().equals(cloud.getFileLocalPath())) {
                    adatper.getList().set(i, cloud);
                    adatper.notifyDataSetChanged();
                    if (cloud.getFileState() == CloudUtil.FILE_COMPLETED_STATE) {
                        getUpLoadSuccessCount(adatper.getList());
                    }
                    return;
                }
            }
        }
    }

    /**
     * 关闭listView选项
     */
    private void expandGroup() {
        int size = adatper.getGroupCount();
        for (int i = 0; i < size; i++) {
            listView.collapseGroup(i); // 关闭
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        BusProvider.getInstance().unregister(this);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.DELETE_SUCCESS) {
            getUploadData();
        }
    }

}

