package com.jizhi.jlongg.main.activity.procloud;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.ProCloudService;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.FirstLevelMenuFileAdatper;
import com.jizhi.jlongg.main.bean.Cloud;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.cloud.CloudUtil;
import com.jizhi.jlongg.main.util.cloud.OssClientUtil;

import java.io.File;
import java.util.List;

/**
 * CName:删除文件
 * User: xuj
 * Date: 2017-8-4
 * Time: 10:23:42
 */
public class DeleteFileActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 记录员适配器
     */
    private FirstLevelMenuFileAdatper adapter;
    /**
     * 已选中人员
     */
    private TextView personCount;
    /**
     * 记录员人员数量
     */
    private int count;
    /**
     * 底部布局
     */
    private View bottomLayout;
    /**
     * 项目组id
     */
    private String groupId;
    /**
     * 全选、取消全选
     */
    private TextView selecteAllOrCancelAllText;


    /**
     * @param context
     */
    public static void actionStart(Activity context, String groupId, int fileStateType) {
        Intent intent = new Intent(context, DeleteFileActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra("fileStateType", fileStateType);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pro_cloud_delete_file);
        initView();
    }

    private void initView() {
        Intent intent = getIntent();
        findViewById(R.id.sidrbar).setVisibility(View.GONE);
        groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        personCount = (TextView) findViewById(R.id.personCount);
        bottomLayout = findViewById(R.id.bottom_layout);
        selecteAllOrCancelAllText = getTextView(R.id.selecteAllOrCancelAllText);
        getTextView(R.id.confirmAdd).setText(R.string.delete);
        getTextView(R.id.defaultDesc).setText("暂无记录");
        findViewById(R.id.lin_back).setVisibility(View.GONE); //隐藏返回按钮
        findViewById(R.id.right_title).setVisibility(View.GONE);//隐藏导航栏右图标
        findViewById(R.id.cancelText).setVisibility(View.VISIBLE); //显示导航栏 取消文字
        int fileStateType = intent.getIntExtra("fileStateType", CloudUtil.FILE_TYPE_DOWNLOAD_TAG);
        if (fileStateType == CloudUtil.FILE_TYPE_DOWNLOAD_TAG) { //文件下载
            setTextTitleAndRight(R.string.i_downloaded, R.string.cancel);
            setAdatper(ProCloudService.getInstance(getApplicationContext()).getUploadOrDownLoadFileList(getApplicationContext(), CloudUtil.FILE_TYPE_DOWNLOAD_TAG, groupId));
        } else if (fileStateType == CloudUtil.FILE_TYPE_UPLOAD_TAG) { //文件上传
            setTextTitleAndRight(R.string.i_uploaded, R.string.cancel);
            setAdatper(ProCloudService.getInstance(getApplicationContext()).getUploadOrDownLoadFileList(getApplicationContext(), CloudUtil.FILE_TYPE_UPLOAD_TAG, groupId));
        }
        selecteAllOrCancelAllText.setVisibility(View.VISIBLE);
        bottomLayout.setVisibility(View.GONE);
    }

    /**
     * 删除文件
     */
    private void deleteFiles() {
        if (count == 0) {
            return;
        }
        if (adapter != null && adapter.getCount() > 0) {
            createCustomDialog();
            int fileStateType = getIntent().getIntExtra("fileStateType", CloudUtil.FILE_TYPE_DOWNLOAD_TAG);
            for (Cloud cloud : adapter.getList()) {
                if (cloud.isSelected()) { //移除选中了的文件
                    if (fileStateType == CloudUtil.FILE_TYPE_DOWNLOAD_TAG) { //文件下载
                        int fileState = ProCloudService.getInstance(getApplicationContext()).getFileDownLoadState(getApplicationContext(), cloud.getId(), groupId);
                        if (fileState == CloudUtil.FILE_LOADING_STATE) { //如果文件正在下载则还需要暂停文件的下载
                            OssClientUtil.getInstance().setPauseTag(cloud, getApplicationContext(), groupId);
                        }
                        ProCloudService.getInstance(getApplicationContext()).deleteFileInfo(getApplicationContext(), cloud.getId(), groupId, CloudUtil.FILE_TYPE_DOWNLOAD_TAG + ""); //移除数据库数据
                        File file = new File(cloud.getFileLocalPath()); //获取本地文件
                        if (file.exists()) { //如果文件存在 则需要删除
                            file.delete();
                        }
                    } else if (fileStateType == CloudUtil.FILE_TYPE_UPLOAD_TAG) { //文件上传
                        int fileState = ProCloudService.getInstance(getApplicationContext()).getFileUpLoadState(getApplicationContext(), cloud.getId(), groupId);
                        if (fileState == CloudUtil.FILE_LOADING_STATE) { //如果文件正在上传则还需要暂停上传的文件
                            OssClientUtil.getInstance().setPauseTag(cloud, getApplicationContext(), groupId);
                        }
                        ProCloudService.getInstance(getApplicationContext()).deleteFileInfo(getApplicationContext(), cloud.getId(), groupId, CloudUtil.FILE_TYPE_UPLOAD_TAG + ""); //移除数据库数据
                    }
                }
            }
            closeDialog();
            setResult(Constance.DELETE_SUCCESS);
            finish();
        }
    }

    /**
     * 全选
     */
    private void selecteAll() {
        if (adapter != null && adapter.getCount() > 0) {
            for (Cloud cloud : adapter.getList()) {
                cloud.setSelected(true);
            }
            count = adapter.getList().size();
            adapter.notifyDataSetChanged();
            setCount();
        }
    }

    /**
     * 取消全选
     */
    private void cancelSelecteAll() {
        if (adapter != null && adapter.getCount() > 0) {
            for (Cloud cloud : adapter.getList()) {
                cloud.setSelected(false);
            }
            count = 0;
            adapter.notifyDataSetChanged();
            setCount();
        }
    }

    private void setCount() {
        bottomLayout.setVisibility(count == 0 ? View.GONE : View.VISIBLE); //如果数量大于1 显示底部布局
        personCount.setText(Html.fromHtml("<font color='#666666'>本次已选中</font><font color='#d7252c'> " + count + "</font><font color='#666666'> 个文件</font>"));
        selecteAllOrCancelAllText.setText(count == adapter.getCount() ? R.string.cancel_check_all : R.string.check_all);
    }


    private void setAdatper(final List<Cloud> list) {
        if (adapter == null) {
            ListView listView = (ListView) findViewById(R.id.listView);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            adapter = new FirstLevelMenuFileAdatper(DeleteFileActivity.this, list);
            adapter.setEditor(true);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    Cloud cloud = adapter.getList().get(position);
                    cloud.setSelected(!cloud.isSelected());
                    count = cloud.isSelected() ? count + 1 : count - 1;
                    adapter.notifyDataSetChanged();
                    setCount();
                }
            });
        } else {
            adapter.updateList(list);
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.cancelText: //取消
                finish();
                break;
            case R.id.selecteAllOrCancelAllText: //取消全选、全选按钮
                if (adapter == null || adapter.getCount() == 0) {
                    return;
                }
                if (count == adapter.getList().size()) { //现在是全选状态
                    cancelSelecteAll();
                } else {
                    selecteAll();
                }
                break;
            case R.id.confirmAdd://确认删除
                deleteFiles();
                break;
        }
    }
}
