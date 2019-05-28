package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.EditorProjectAdapter;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DiaLogDeleteAccountProject;
import com.jizhi.jlongg.main.dialog.DiaLogUpdateProjectName;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.io.Serializable;
import java.util.List;

/**
 * 功能: 编辑项目Activity
 * 作者：Xuj
 * 时间: 2016-7-18 10:04
 */
public class EditorProjectActivity extends BaseActivity implements View.OnClickListener, DiaLogUpdateProjectName.UpProjectNameListener, EditorProjectAdapter.ProjectCallBack, DiaLogDeleteAccountProject.RemoveAccountProject {

    /**
     * 编辑项目适配器
     */
    private EditorProjectAdapter adapter;
    /**
     * 是否正在编辑项目
     * true 编辑中  显示删除图片
     * false 非编辑状态 隐藏删除图片
     */
    private boolean isEditor;
    /**
     * 是否正在编辑项目文本
     * true 编辑中  显示删除图片
     * false 非编辑状态 隐藏删除图片
     */
    private TextView isEditorText;
    /**
     * 是否编辑或删除过图片
     */
    private boolean isEditorOrDeleteData;
    /**
     * 项目id
     */
    private int pid;
    /**
     * 项目名称
     */
    private String proName;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.editor_project);
        initView();
    }

    private void initView() {
        setTextTitleAndRight(R.string.edit_project, R.string.delete);
        isEditorText = getTextView(R.id.right_title);
        Intent intent = getIntent();
        List<Project> list = (List<Project>) intent.getSerializableExtra(Constance.BEAN_ARRAY);
        for (Project p : list) {
            p.setShowAnim(true);
        }
        ListView listView = (ListView) findViewById(R.id.listView);
        adapter = new EditorProjectAdapter(this, list, isEditor, this, listView);
        listView.setAdapter(adapter);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title:
                List<Project> list = adapter.getList();
                int size = list.size();
                for (int i = 0; i < size; i++) {
                    list.get(i).setShowAnim(false);
                }
                isEditor = !isEditor;
                SetTitleName.setTitle(isEditorText, getString(isEditor ? R.string.cancel : R.string.delete));
                adapter.setEditor(isEditor);
                adapter.notifyDataSetChanged();
                break;
        }
    }


    /**
     * 删除项目
     */
    @Override
    public void remove(final int position, final int pid) {
        String projectName = adapter.getList().get(adapter.getClickPosition()).getPro_name();
        DiaLogDeleteAccountProject deleteDialog = new DiaLogDeleteAccountProject(this, this, projectName);
        deleteDialog.show();
    }

    /**
     * 修改项目名称Dialog
     */
    @Override
    public void update(String proName) {
        DiaLogUpdateProjectName updateProjectDialog = new DiaLogUpdateProjectName(this, this, proName);
        updateProjectDialog.openKeyBoard();
        updateProjectDialog.show();
    }


    /**
     * 修改项目名称
     */
    @Override
    public void UpProjectName(final String pro_name) {
        submitUpdateProName(pro_name);

    }


    public void submitUpdateProName(final String proName) {
        this.proName = proName;
        pid = adapter.getList().get(adapter.getClickPosition()).getPid();
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPPRONAME, params(proName, pid, true), new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<BaseNetBean> base = CommonListJson.fromJson(responseInfo.result, BaseNetBean.class);
                    if (base.getState() != 0) {
                        List<Project> list = adapter.getList();
                        list.get(adapter.getClickPosition()).setPro_name(proName);
//                        adapter.updateSingleView();
                        isEditorOrDeleteData = true;
                        isEditor();
                        finish();
                        CommonMethod.makeNoticeShort(EditorProjectActivity.this, "项目修改成功!", CommonMethod.SUCCESS);
                    } else {
                        DataUtil.showErrOrMsg(EditorProjectActivity.this, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(EditorProjectActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }
        });
    }


    /**
     * 修改项目名称、删除项目
     */
    public RequestParams params(String projectName, int pid, boolean isEditor) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        if (isEditor) {
            params.addBodyParameter("pro_name", projectName);
            params.addBodyParameter("pid", pid + "");
        } else {
            params.addBodyParameter("pid_str", pid + "");
        }
        return params;
    }

    /**
     * 是否编辑或删除过项目
     */
    public void isEditor() {
        if (isEditorOrDeleteData) {
            Intent intent = getIntent();
            intent.putExtra(Constance.BEAN_ARRAY, (Serializable) adapter.getList());
            Project project = new Project();
            project.setPro_name(proName);
            project.setPid(pid);
            intent.putExtra(Constance.BEAN_CONSTANCE, project);
            setResult(Constance.EDITOR_PROJECT_SUCCESS, intent);
        }
    }

    @Override
    public void onFinish(View view) {
        isEditor();
        super.onFinish(view);
    }

    @Override
    public void onBackPressed() {
        isEditor();
        super.onBackPressed();
    }

    @Override
    public void remove() {
        int pid = adapter.getList().get(adapter.getClickPosition()).getPid();
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DELPRO, params(null, pid, false), new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<BaseNetBean> base = CommonListJson.fromJson(responseInfo.result, BaseNetBean.class);
                    if (base.getState() != 0) {
                        List<Project> list = adapter.getList();
                        list.remove(adapter.getClickPosition());
                        adapter.notifyDataSetChanged();
                        isEditorOrDeleteData = true;
                        CommonMethod.makeNoticeShort(EditorProjectActivity.this, "项目删除成功!", CommonMethod.SUCCESS);
                    } else {
                        DataUtil.showErrOrMsg(EditorProjectActivity.this, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplication(), getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }
        });
    }
}
