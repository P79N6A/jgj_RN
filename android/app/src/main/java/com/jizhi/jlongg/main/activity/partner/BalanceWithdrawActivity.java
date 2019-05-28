package com.jizhi.jlongg.main.activity.partner;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.BalanceWithdrawAccount;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;

/**
 * CName:合伙人 -->余额提现
 * User: xuj
 * Date: 2017年7月20日
 * Time: 14:19:10
 */
public class BalanceWithdrawActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 列表适配器
     */
    private BalanceWithdrawAdapter adapter;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, BalanceWithdrawActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.balance_withdraw);
        initView();
    }

    private void initView() {
        setTextTitle(R.string.balance_withdrawa);
        Button defaultBtn = getButton(R.id.defaultBtn);
        defaultBtn.setVisibility(View.VISIBLE);
        getTextView(R.id.defaultDesc).setText("还未设置提现账户");
        defaultBtn.setText("添加提现账户");
        getBindAccount();
    }

    /**
     * 获取绑定的账户
     */
    public void getBindAccount() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.PARTNER_WITHDRAWTELELIST,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<BalanceWithdrawAccount> base = CommonJson.fromJson(responseInfo.result, BalanceWithdrawAccount.class);
                            if (base.getState() != 0) {
                                setAdapter(base.getValues().getList());
                            } else {
                                CommonMethod.makeNoticeShort(getApplicationContext(), base.getErrmsg(), CommonMethod.ERROR);
                                finish();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                            finish();
                        } finally {
                            closeDialog();
                        }
                    }
                });
    }

    /**
     * 删除提现账户
     *
     * @param position 下标
     * @param id       删除的账户id
     */
    public void deleteAccount(final int position, int id) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", id + "");
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DEL_PARTNER_WITHDRAWTELELIST,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                            if (base.getState() != 0) {
                                adapter.getList().remove(position);
                                adapter.notifyDataSetChanged();
                            } else {
                                CommonMethod.makeNoticeShort(getApplicationContext(), base.getErrmsg(), CommonMethod.ERROR);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }
                });
    }


    private void setAdapter(List<BalanceWithdrawAccount> list) {
        if (adapter == null) {
            adapter = new BalanceWithdrawAdapter(BalanceWithdrawActivity.this, list);
            ListView listView = (ListView) findViewById(R.id.listView);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setAdapter(adapter);
        } else {
            adapter.updateList(list);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.defaultBtn: //添加提现账户
                AddWithdrawCashAccountActiviy.actionStart(this);
                break;
        }
    }

    /**
     * 余额提现适配器
     *
     * @author xuj
     * @version 1.0
     * @time 2017年7月20日14:24:16
     */
    @SuppressLint("DefaultLocale")
    public class BalanceWithdrawAdapter extends BaseAdapter {

        /**
         * xml解析器
         */
        private LayoutInflater inflater;
        /**
         * 列表数据
         */
        private List<BalanceWithdrawAccount> list;

        public BalanceWithdrawAdapter(Context mContext, List<BalanceWithdrawAccount> list) {
            this.list = list;
            inflater = LayoutInflater.from(mContext);
        }


        public int getCount() {
            return list == null ? 0 : list.size();
        }

        public Object getItem(int position) {
            return list.get(position);
        }

        public long getItemId(int position) {
            return position;
        }

        public View getView(final int position, View convertView, ViewGroup arg2) {
            final ViewHolder holder;
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.balance_withdraw_item, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(position, convertView, holder);
            return convertView;
        }

        private void bindData(final int position, View convertView, ViewHolder holder) {
            final BalanceWithdrawAccount bean = list.get(position);
            if (bean.getPay_type() == ProductUtil.WX_PAY) { //微信支付
                holder.payAccountState.setText("已绑定");
                holder.payIcon.setImageResource(R.drawable.wechat_big_icon);
            } else if (bean.getPay_type() == ProductUtil.ALI_PAY) { //支付宝支付
                holder.payIcon.setImageResource(R.drawable.zhifubao_big_icon);
                holder.payAccountState.setVisibility(View.GONE);
            }
            holder.payAccountInfo.setText(bean.getAccount_name()); //绑定的账户名称
            holder.firstPositionTips.setVisibility(position == 0 ? View.VISIBLE : View.GONE);
            holder.addAccountBtn.setVisibility(list.size() <= 2 && position == list.size() - 1 ? View.VISIBLE : View.GONE);
            View.OnClickListener onClickListener = new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    switch (view.getId()) {
                        case R.id.deleteAccountBtn: //删除账户
                            deleteAccount(position, bean.getId());
                            break;
                        case R.id.addAccountBtn: //添加账户
                            AddWithdrawCashAccountActiviy.actionStart(BalanceWithdrawActivity.this);
                            break;
                        case R.id.itemLayout:
                            BalanceWithdrawDetailActivity.actionStart(BalanceWithdrawActivity.this, bean);
                            break;
                    }
                }
            };
            holder.itemLayout.setOnClickListener(onClickListener);
            holder.deleteAccountBtn.setOnClickListener(onClickListener);
            holder.addAccountBtn.setOnClickListener(onClickListener);
        }

        public void updateList(List<BalanceWithdrawAccount> list) {
            this.list = list;
            notifyDataSetChanged();
        }

        class ViewHolder {

            public ViewHolder(View convertView) {
                itemLayout = convertView.findViewById(R.id.itemLayout);
                payIcon = (ImageView) convertView.findViewById(R.id.payIcon);
                firstPositionTips = (TextView) convertView.findViewById(R.id.firstPositionTips);
                payAccountInfo = (TextView) convertView.findViewById(R.id.payAccountInfo);
                payAccountState = (TextView) convertView.findViewById(R.id.payAccountState);
                deleteAccountBtn = (TextView) convertView.findViewById(R.id.deleteAccountBtn);
                addAccountBtn = (Button) convertView.findViewById(R.id.addAccountBtn);
            }

            View itemLayout;
            /**
             * 支付图标
             */
            ImageView payIcon;
            /**
             * 支付账户信息
             */
            TextView payAccountInfo;
            /**
             * 支付账户状态
             */
            TextView payAccountState;
            /**
             * 删除账户按钮
             */
            TextView deleteAccountBtn;
            /**
             * 提示
             */
            TextView firstPositionTips;
            /**
             * 添加账户
             */
            Button addAccountBtn;
        }

        public List<BalanceWithdrawAccount> getList() {
            return list;
        }

        public void setList(List<BalanceWithdrawAccount> list) {
            this.list = list;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.BIND_ACCOUNT_SUCCESS) {
            BalanceWithdrawAccount account = (BalanceWithdrawAccount) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            if (account != null) {
                BalanceWithdrawDetailActivity.actionStart(this, account);
            }
            getBindAccount();
        } else if (resultCode == Constance.BALANCE_WITHDRAW_SUCCESS) {
            setResult(Constance.BALANCE_WITHDRAW_SUCCESS);
            finish();
        }
    }
}
