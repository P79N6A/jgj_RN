package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.SelectProjectAdapter;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import static com.jizhi.jlongg.main.util.Constance.BEAN_CONSTANCE;


/**
 * 功能:记账 选择项目
 * 时间:2018年6月7日17:07:51
 * 作者:xuj
 */

public class SelecteProjectActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 列表适配器
     */
    private SelectProjectAdapter adapter;
    /**
     * 列表数据
     */
    private List<Project> list;
    /**
     * 筛选文字
     */
    private String matchString;
    /**
     * 编辑文本
     */
    private TextView editorText;
    /**
     * 新增项目布局 ,保存项目布局
     */
    private View newProjectayout, saveProjectLayout;
    /**
     * 项目输入框
     */
    private EditText newProjectEdit;
    /**
     * 新建项目布局
     */
    private View bottomLayout;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param proId   已选的项目id 如果没有就不传
     */
    public static void actionStart(Activity context, String proId) {
        Intent intent = new Intent(context, SelecteProjectActivity.class);
        intent.putExtra(Constance.PRO_ID, proId);
        context.startActivityForResult(intent, Constance.REQUESTCODE_EDITPROJECT);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.selecte_project);
        initView();
        getProjectList();
    }

    private void initView() {
        setTextTitleAndRight(R.string.select_project, R.string.update_and_delete);
        editorText = getTextView(R.id.right_title);
        newProjectayout = findViewById(R.id.bottom_layout);
        newProjectEdit = getEditText(R.id.newProjectEdit);
        saveProjectLayout = findViewById(R.id.saveProjectLayout);
        bottomLayout = findViewById(R.id.bottom_layout);
        final Button saveProBtn = findViewById(R.id.saveProBtn);
        getTextView(R.id.red_btn).setText(R.string.add_pro);
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("快速搜索关键字");
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence inputText, int start, int before, int count) {
                filterData(inputText.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        newProjectEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence inputText, int start, int before, int count) {
                String s = inputText.toString();
                Utils.setBackGround(saveProBtn, getResources().getDrawable(TextUtils.isEmpty(s) ? R.drawable.sk_dbdbdb_bg_white_5radius : R.drawable.draw_eb4e4e_5radius));
                saveProBtn.setTextColor(ContextCompat.getColor(getApplicationContext(), TextUtils.isEmpty(s) ? R.color.color_333333 : R.color.white));
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
    }

    /**
     * 搜索框 筛选数据
     *
     * @param mMatchString
     */
    private synchronized void filterData(final String mMatchString) {
        if (adapter == null || list == null || list.size() == 0) {
            return;
        }
        matchString = mMatchString;
        new Thread(new Runnable() {
            @Override
            public void run() {
                final List<Project> filterDataList = SearchMatchingUtil.match(Project.class, list, matchString);
                if (mMatchString.equals(matchString)) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            adapter.setFilterValue(mMatchString);
                            adapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }

    /**
     * 获取项目列表信息
     */
    private void getProjectList() {
        String httpUrl = NetWorkRequest.CREATE_GROUP_GET_PRO_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        //默认为0，表示创建班组的时候，返回的列表；1:表示记账返回的列表
        params.addBodyParameter("is_record", "1");
        CommonHttpRequest.commonRequest(this, httpUrl, Project.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                List<Project> list = (List<Project>) object;
                Intent intent = getIntent();
                String selecteProId = intent.getStringExtra(Constance.PRO_ID); //已选择的项目组id
                if (!TextUtils.isEmpty(selecteProId)) {
                    for (Project project : list) {
                        if ((project.getPro_id() + "").equals(selecteProId)) {
                            project.setIsSelected(true);
                            break;
                        }
                    }
                }
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
        //当没有项目信息的时候是否跳转到新增新增项目
//        boolean ifNoProjectIsIntentAddProjectActivity = true;
//        AccountHttpUtils.IRelatedProjects(this, new AccountHttpUtils.AccountIRelatedListener() {
//            @Override
//            public void IRelatedProjectsSuccess(final List<Project> list) {
//                if (list == null || list.size() == 0) {
//                    return;
//                }
//                Intent intent = getIntent();
//                String selecteProId = intent.getStringExtra(Constance.PRO_ID); //已选择的项目组id
//                if (!TextUtils.isEmpty(selecteProId)) {
//                    for (Project project : list) {
//                        if ((project.getPid() + "").equals(selecteProId)) {
//                            project.setIsSelected(true);
//                            break;
//                        }
//                    }
//                }
//                setAdapter(list);
//            }
//        }, ifNoProjectIsIntentAddProjectActivity);
    }

    /**
     * 删除项目信息
     *
     * @param project
     * @param position
     */
    private void deleteProject(final Project project, final int position) {
        DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(this, null, "确认删除" + project.getPro_name() + "项目吗",
                new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        String httpUrl = NetWorkRequest.WORKDAY_DEL_PRO;
                        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                        params.addBodyParameter("pid_str", project.getPro_id() + ""); //项目id
                        CommonHttpRequest.commonRequest(SelecteProjectActivity.this,
                                httpUrl, BaseNetNewBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
                                    @Override
                                    public void onSuccess(Object object) {
                                        CommonMethod.makeNoticeShort(SelecteProjectActivity.this, "项目删除成功!", CommonMethod.SUCCESS);
                                        String lastPid = getIntent().getStringExtra(Constance.PRO_ID);
                                        //从记单笔页面传过来的pid
                                        //这里可能会出现在记单笔页面已 选择了当前pid的项目 如果我在列表上将他给删除了那么需要记录当前项目已删除的标识
                                        if (!TextUtils.isEmpty(lastPid)) {
                                            if ((project.getPro_id() + "").equals(lastPid)) {
                                                setResult(Constance.SELECTE_PROJECT);
                                            }
                                        }
                                        adapter.getProjectList().remove(position);
                                        adapter.notifyDataSetChanged();
                                    }

                                    @Override
                                    public void onFailure(HttpException exception, String errormsg) {
                                    }
                                });
                    }
                });
        dialogLeftRightBtnConfirm.show();


//        DiaLogDeleteAccountProject deleteDialog = new DiaLogDeleteAccountProject(SelecteProjectActivity.this, new DiaLogDeleteAccountProject.RemoveAccountProject() {
//            @Override
//            public void remove() {
//                RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
//                params.addBodyParameter("pid_str", project.getPid() + "");
//                String httpUrl = NetWorkRequest.DELPRO;
//                CommonHttpRequest.commonRequest(SelecteProjectActivity.this, httpUrl, BaseNetBean.class, CommonHttpRequest.LIST, params,
//                        true, new CommonHttpRequest.CommonRequestCallBack() {
//                            @Override
//                            public void onSuccess(Object object) {
//                                String lastPid = getIntent().getStringExtra(Constance.PRO_ID);
////                                LUtils.e("lastPid" + lastPid + "        currentPid:" + project.getPid());
//                                //从记单笔页面传过来的pid
//                                //这里可能会出现在记单笔页面已 选择了当前pid的项目 如果我在列表上将他给删除了那么需要记录当前项目已删除的标识
//                                if (!TextUtils.isEmpty(lastPid)) {
//                                    if ((project.getPid() + "").equals(lastPid)) {
//                                        setResult(Constance.SELECTE_PROJECT);
//                                    }
//                                }
//                                adapter.getProjectList().remove(position);
//                                adapter.notifyDataSetChanged();
//                                CommonMethod.makeNoticeShort(SelecteProjectActivity.this, "项目删除成功!", CommonMethod.SUCCESS);
//                            }
//
//                            @Override
//                            public void onFailure(HttpException exception, String errormsg) {
//
//                            }
//                        });
//            }
//        }, project.getPro_name());
//        deleteDialog.show();
    }

    /**
     * 修改项目名称
     *
     * @param editorName 修改项目的名称
     * @param project
     */
    private void updateProjectName(final Project project, final String editorName) {
        if (!AppUtils.filterAppImportantWord(getApplicationContext(), editorName, "项目", false)) {
            return;
        }
        String httpUrl = NetWorkRequest.WORKDAY_MODIFY_PRO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("pid_str", project.getPro_id()); //项目id
        params.addBodyParameter("pro_name", editorName); //项目名称
        CommonHttpRequest.commonRequest(this, httpUrl, GroupDiscussionInfo.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(SelecteProjectActivity.this, "项目修改成功!", CommonMethod.SUCCESS);
                if (project.getIs_create_group() == 1) { //项目已创建了班组的标识 需要将本地的名称修改
                    GroupDiscussionInfo groupInfo = (GroupDiscussionInfo) object;
                    //修改本地已创建的班组名称
                    MessageUtil.modityLocalTeamGroupInfo(SelecteProjectActivity.this, null,
                            groupInfo.getGroup_name(), null,
                            groupInfo.getGroup_id(), groupInfo.getClass_type(),
                            null, null,
                            null, null, 0, null,
                            null, null, null);
                }
                if (project.getPro_id().equals(getIntent().getStringExtra(Constance.PRO_ID))) {
                    Intent intent = getIntent();
                    intent.putExtra(Constance.BEAN_CONSTANCE, project);
                    setResult(Constance.SELECTE_PROJECT, intent);
                }
                project.setPro_name(editorName);
                operationEditor();
//                Intent intent = getIntent();
//                intent.putExtra(Constance.BEAN_CONSTANCE, project);
//                setResult(Constance.SELECTE_PROJECT, intent);
//                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }

    private void setAdapter(List<Project> list) {
        if (adapter == null) {
            ListView listView = (ListView) findViewById(R.id.listView);
            adapter = new SelectProjectAdapter(SelecteProjectActivity.this, list, new SelectProjectAdapter.ProjectBtnListener() {
                @Override
                public void save(Project project, String editorName, int position) { //保存按钮
                    if (TextUtils.isEmpty(editorName)) {
                        CommonMethod.makeNoticeLong(getApplicationContext(), "请输入项目名称", CommonMethod.ERROR);
                        return;
                    }
                    if (project.getPro_name().equals(editorName)) {
                        CommonMethod.makeNoticeShort(SelecteProjectActivity.this, "项目修改成功!", CommonMethod.SUCCESS);
                        operationEditor();
                        return;
                    }
                    updateProjectName(project, editorName);
                }

                @Override
                public void delete(final Project project, final int position) { //删除按钮
                    deleteProject(project, position);
                }

                @Override
                public void clickItem(Project project) {
                    Intent intent = getIntent();
                    intent.putExtra(Constance.BEAN_CONSTANCE, project);
                    setResult(Constance.SELECTE_PROJECT, intent);
                    LUtils.e("-----------" + new Gson().toJson(project));
                    finish();
                }
            }, false);
            listView.setAdapter(adapter);
        } else {
            adapter.updateListView(list);
        }
        SelecteProjectActivity.this.list = list;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.saveProBtn: //保存新增项目
                submitProject();
//                AddProjectActivity.actionStart(this);
                break;
            case R.id.red_btn_layout: //新增项目按钮
                newProjectayout.setVisibility(View.GONE);
                saveProjectLayout.setVisibility(View.VISIBLE);
                newProjectEdit.requestFocus();
                new Timer().schedule(new TimerTask() {
                    public void run() {
                        showSoftKeyboard(newProjectEdit);
                    }
                }, 200);
                break;
            case R.id.right_title: //编辑按钮
                operationEditor();
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.RESULTWORKERS) {//新增项目成功后的回调
            Project project = (Project) data.getSerializableExtra(BEAN_CONSTANCE);
            handlerAddProject(project);
        }
    }


    private void handlerAddProject(Project project) {
        if (adapter == null) {
            List<Project> list = new ArrayList<>();
            list.add(project);
            setAdapter(list);
        } else {
            list.add(project);
            adapter.notifyDataSetChanged();
        }
    }

    @Override
    public void onFinish(View view) {
        super.onFinish(view);
    }


    public void submitProject() { //保存按钮
        String proName = newProjectEdit.getText().toString().trim();
        if (!AppUtils.filterAppImportantWord(getApplicationContext(), proName, "项目", false)) {
            return;
        }
        String httpUrl = NetWorkRequest.ADDPRO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("pro_name", proName);
        CommonHttpRequest.commonRequest(this, httpUrl, Project.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                Project project = (Project) object;
                project.setPro_id(project.getPid() + "");
                Intent intent = getIntent();
                intent.putExtra(Constance.BEAN_CONSTANCE, project);
                setResult(Constance.SELECTE_PROJECT, intent);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }

    private void operationEditor() {
        if (adapter == null || adapter.getCount() == 0) {
            return;
        }
        adapter.setEditor(!adapter.isEditor());
        if (adapter.isEditor()) { //编辑状态下隐藏底部按钮
            bottomLayout.setVisibility(View.GONE);
            saveProjectLayout.setVisibility(View.GONE);
            hideSoftKeyboard();
        } else {
            bottomLayout.setVisibility(View.VISIBLE);
            saveProjectLayout.setVisibility(View.GONE);
        }
        adapter.notifyDataSetChanged();
        editorText.setText(adapter.isEditor() ? R.string.cancel : R.string.update_and_delete);
    }
}
