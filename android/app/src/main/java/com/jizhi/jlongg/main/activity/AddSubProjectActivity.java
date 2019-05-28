package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountAllWorkBean;
import com.jizhi.jlongg.main.bean.DeleteSubProject;
import com.jizhi.jlongg.main.bean.NoteBook;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.List;

/**
 * 功能: 选择分享模版
 * 时间:2019/2/16 15:03
 * 作者:hcs
 */
public class AddSubProjectActivity extends BaseActivity implements View.OnClickListener {

    //项目名称
    private EditText ed_sub_proname;
    private AddSubProjectActivity mActivity;
    //项目信息
    private AccountAllWorkBean accountAllWorkBean;
    private ListView listView;
    private List<AccountAllWorkBean> accountAllWorkBeanList;
    private TextView chooseM;
    private DialogLeftRightBtnConfirm dialog;
    //private int position;//删除item的位置
    private SubProjectAdapter subProjectAdapter;
    private int contextMenuClickPostion;
    /**
     * @param context 请求当前页
     */
    public static void actionStart(Activity context, AccountAllWorkBean accountAllWorkBean, int positon) {
        Intent intent = new Intent(context, AddSubProjectActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, accountAllWorkBean);
        intent.putExtra(Constance.BEAN_INT, positon);
        context.startActivityForResult(intent, Constance.REQUESTCODE_ADD_SUB_PRONAME);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_sub_project);
        initView();
        getIntentData();
        initData();
        getContractonTplList();
        hideSoftKeyboard();

    }

    /**
     * 初始化view
     */
    public void initView() {
        mActivity = AddSubProjectActivity.this;
        SetTitleName.setTitle(findViewById(R.id.title), "选择分项模板");
        ed_sub_proname = findViewById(R.id.ed_sub_proname);
        chooseM = findViewById(R.id.chooseM);
        findViewById(R.id.save).setOnClickListener(this);
        listView = findViewById(R.id.listView);
        listView.setOnCreateContextMenuListener(new View.OnCreateContextMenuListener() {
            public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
                //在上下文菜单选项中添加选项内容
                //add方法的参数：add(分组id,itemid, 排序, 菜单文字)
                menu.add(0, Menu.FIRST, 0, "删除");
            }
        });
        listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                contextMenuClickPostion = position;
                return false;
            }
        });

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                AccountAllWorkBean bean = accountAllWorkBeanList.get(position);
                bean.setSub_count(accountAllWorkBean.getSub_count());

                closeAct(accountAllWorkBeanList.get(position));
            }
        });
    }
    //给菜单项添加事件
    @Override
    public boolean onContextItemSelected(MenuItem item) {
        //参数为用户选择的菜单选项对象
        //根据菜单选项的id来执行相应的功能
        switch (item.getItemId()) {
            case Menu.FIRST: //删除好友申请
                dialog = new DialogLeftRightBtnConfirm(this, null, "确定删除该分项模板吗？",
                        new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                            @Override
                            public void clickLeftBtnCallBack() {
                                dialog.dismiss();
                            }

                            @Override
                            public void clickRightBtnCallBack() {
                                if (!accountAllWorkBeanList.isEmpty()) {
                                    //删除分项
                                    deleteSubProject();
                                }

                            }
                        });
                dialog.setLeftBtnText("取消");
                dialog.setRightBtnText("确定");
                dialog.show();
                break;
        }
        return super.onOptionsItemSelected(item);
    }
    /**
     * 获取传递过来的数据
     */
    public void getIntentData() {
        accountAllWorkBean = (AccountAllWorkBean) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
    }

    /**
     * 初始化数据
     */
    public void initData() {
        if (null != accountAllWorkBean && !TextUtils.isEmpty(accountAllWorkBean.getSub_pro_name())) {
//            ed_sub_proname.setText(accountAllWorkBean.getSub_pro_name());
//            ed_sub_proname.setSelection(accountAllWorkBean.getSub_pro_name().length());
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.save:
                if (null == accountAllWorkBean) {
                    accountAllWorkBean = new AccountAllWorkBean();
                }
                accountAllWorkBean.setSub_pro_name(ed_sub_proname.getText().toString().trim());
                closeAct(accountAllWorkBean);
                break;
        }
    }

    /**
     * 关闭当前页面
     */
    public void closeAct(AccountAllWorkBean accountAllWorkBean) {

        Intent intent = new Intent();
        intent.putExtra(Constance.BEAN_CONSTANCE, accountAllWorkBean);
        intent.putExtra(Constance.BEAN_INT, getIntent().getIntExtra(Constance.BEAN_INT, -1));
        setResult(Constance.RESULTCODE_ADD_SUB_PRONAME, intent);
        finish();
    }

    /**
     * 删除分项模板
     */
    public void deleteSubProject() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        int tpl_id = accountAllWorkBeanList.get(contextMenuClickPostion).getTpl_id();
        params.addBodyParameter("tpl_id", String.valueOf(tpl_id));
        CommonHttpRequest.commonRequest(this, NetWorkRequest.DELETE_SUB_PRO, DeleteSubProject.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                closeDialog();
//                int status= (int) object;
//                LUtils.i("刪除分項",status+"");
//                if (status==1){
                accountAllWorkBeanList.remove(contextMenuClickPostion);
                subProjectAdapter.notifyDataSetChanged();
//                }
                if (accountAllWorkBeanList.isEmpty()) {
                    chooseM.setVisibility(View.GONE);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();

            }
        });
    }

    /**
     * 获取包工模版
     */
    public void getContractonTplList() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(AddSubProjectActivity.this);
        CommonHttpRequest.commonRequest(this, NetWorkRequest.GET_CONTRACTOR_TPL_LIST, AccountAllWorkBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                //v4.0.1
                accountAllWorkBeanList = (List<AccountAllWorkBean>) object;
                if (accountAllWorkBeanList.isEmpty()) {
                    chooseM.setVisibility(View.GONE);
                }
                LUtils.i("包工模板", accountAllWorkBeanList.toString());
                closeDialog();
                if (null != accountAllWorkBeanList && accountAllWorkBeanList.size() > 0) {
                    subProjectAdapter = new SubProjectAdapter(mActivity, accountAllWorkBeanList);
                    listView.setAdapter(subProjectAdapter);
                }

            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();
            }
        });
    }

    public class SubProjectAdapter extends BaseAdapter {
        /* 列表数据 */
        private List<AccountAllWorkBean> list;
        /* xml解析器 */
        private LayoutInflater inflater;


        public SubProjectAdapter(Context context, List<AccountAllWorkBean> list) {
            super();
            this.list = list;
            inflater = LayoutInflater.from(context);
        }

        @Override
        public int getCount() {
            return list == null ? 0 : list.size();
        }

        @Override
        public Object getItem(int position) {
            return list.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            final ViewHolder holder;
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.item_sub_project, null);
                holder = new SubProjectAdapter.ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
//            holder.tv_name.setText(list.get(position).getSub_pro_name());
//            holder.tv_price.setText(list.get(position).getSet_unitprice());
//            holder.tv_unit.setText("/"+list.get(position).getUnits());
            holder.tv_name.setText(Html.fromHtml(list.get(position).getSub_pro_name() + "&nbsp;&nbsp;&nbsp;&nbsp;<font color='#eb4e4e'>" + list.get(position).getSet_unitprice() + "</font>" + "/" + list.get(position).getUnits()));
            return convertView;
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                tv_name = convertView.findViewById(R.id.tv_name);
//                tv_price = convertView.findViewById(R.id.tv_price);
//                tv_unit = convertView.findViewById(R.id.tv_unit);
            }

            //分项名称
            TextView tv_name;
            //分项单价
            TextView tv_price;
            //分项单位
            TextView tv_unit;
        }

    }


}
