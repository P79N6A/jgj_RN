package com.jizhi.jlongg.main.activity.procloud;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.FirstLevelMenuFileAdatper;
import com.jizhi.jlongg.main.bean.Cloud;
import com.jizhi.jlongg.main.dialog.pro_cloud.DialogCreateFolder;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.cloud.CloudUtil;

import java.util.List;


/**
 * 项目云盘-->移动文件
 *
 * @author Xuj
 * @time 2017年7月17日10:04:07
 * @Version 1.0
 */
public class MoveFileActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 云盘适配器
     */
    private FirstLevelMenuFileAdatper adatper;
    /**
     * 文件父id
     */
    private String parentId;
    /**
     * 项目组id
     */
    private String groupId;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId      项目组id
     * @param fileParentId 父文件id
     * @param sourceIds    移动文件的json
     */
    public static void actionStart(Activity context, String groupId, String fileParentId, String sourceIds, String eliminateIds) {
        Intent intent = new Intent(context, MoveFileActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.FILE_PARENT_ID, fileParentId);
        intent.putExtra(Constance.MOVE_FILES_JSON_OBJECT, sourceIds);
        intent.putExtra(Constance.MOVE_FILES_IDS, eliminateIds);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.move_file);
        initView();
        loadCloudData();
    }

    private void initView() {
        setTextTitleAndRight(R.string.move_location, R.string.create_folder_tips);
        findViewById(R.id.returnText).setVisibility(View.GONE);
        groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        parentId = getIntent().getStringExtra(Constance.FILE_PARENT_ID);
    }

    /**
     * 加载云盘数据
     */
    private void loadCloudData() {
        String eliminateIds = getIntent().getStringExtra(Constance.MOVE_FILES_IDS);
        CloudUtil.getFolders(this, groupId, eliminateIds, WebSocketConstance.TEAM, parentId, CloudUtil.FOLDER_TAG, new CloudUtil.GetFileListListener() {
            @Override
            public void onSuccess(final List<Cloud> list) {
                setAdatper(list);
            }

            @Override
            public void onFailure() {

            }
        });
    }


    private void setAdatper(final List<Cloud> list) {
        if (adatper == null) {
            ListView listView = (ListView) findViewById(R.id.listView);
            adatper = new FirstLevelMenuFileAdatper(MoveFileActivity.this, list);
            listView.setAdapter(adatper);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    Cloud cloud = adatper.getList().get(position);
                    Intent intent = getIntent();
                    MoveFileActivity.actionStart(MoveFileActivity.this, groupId, cloud.getId(),
                            intent.getStringExtra(Constance.MOVE_FILES_JSON_OBJECT), intent.getStringExtra(Constance.MOVE_FILES_IDS));
                }
            });
        } else {
            adatper.updateList(list);
        }
    }

    /**
     * 移动云文件
     */
    private void moveFile() {
        String sourceIds = getIntent().getStringExtra(Constance.MOVE_FILES_JSON_OBJECT);
        CloudUtil.moveFile(this, groupId, WebSocketConstance.TEAM, parentId, sourceIds, new CloudUtil.MoveFileListener() {
            @Override
            public void onSuccess() {
                setResult(Constance.CANCEL_MOVE_FILE);
                finish();
            }
        });
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //新建文件夹
                final DialogCreateFolder createFolderDialog = new DialogCreateFolder(this);
                createFolderDialog.setListener(new DialogCreateFolder.CreateFolderGetNameListener() {
                    @Override
                    public void getName(String folderName) {
                        String eliminateIds = getIntent().getStringExtra(Constance.MOVE_FILES_IDS); //需要排除的文件id
                        CloudUtil.createCloudDir(MoveFileActivity.this, groupId,
                                WebSocketConstance.TEAM, parentId, folderName, CloudUtil.MOVE_FILE_TAG, eliminateIds, new CloudUtil.GetFileListListener() {
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
            case R.id.cancel: //取消移动
                setResult(Constance.CANCEL_MOVE_FILE);
                finish();
                break;
            case R.id.moveFile: //移动文件
                moveFile();
                break;
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CANCEL_MOVE_FILE) { //取消文件移动
            setResult(Constance.CANCEL_MOVE_FILE);
            finish();
        }
    }
}