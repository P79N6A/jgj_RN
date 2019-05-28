package com.hcs.uclient.utils;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.provider.ContactsContract;
import android.text.TextUtils;

import com.jizhi.jlongg.main.bean.AddressBook;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.SynBill;

import java.util.ArrayList;
import java.util.List;

/**
 * 获取手机通讯录
 *
 * @author hcs
 * @time 2016年3月11日 10:54:20
 */
public class ReadAddressBook {


    public static List<AddressBook> getAddrBook(Context context) {
        ContentResolver cr = context.getContentResolver();
        String str[] = {ContactsContract.CommonDataKinds.Phone.NUMBER, ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME};
        Cursor cur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, str, null, null, null);
        List<AddressBook> list = null;
        if (cur != null) {
            while (cur.moveToNext()) {
                if (list == null) {
                    list = new ArrayList<>();
                }
                String telphone = cur.getString(cur.getColumnIndex(str[0]));
                String realName = cur.getString(cur.getColumnIndex(str[1]));
                telphone = telphone.replaceAll("\\+86", "");
                telphone = telphone.replaceAll(" ", "");
                realName = realName.replaceAll(" ", "");
                if (!TextUtils.isEmpty(realName) && realName.length() > 8) {
                    realName = realName.substring(0, 8);
                }
                AddressBook addressBook = new AddressBook();
                addressBook.setName(realName);
                addressBook.setTelph(telphone);
                list.add(addressBook);
            }
            cur.close();
        }
        return list;
    }


    // ----------------得到本地联系人信息-------------------------------------
    public static List getLocalContactsInfos(Context context, boolean isPerson) {
        ContentResolver cr = context.getContentResolver();
        String str[] = {ContactsContract.CommonDataKinds.Phone.NUMBER, ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME};
        Cursor cur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, str, null, null, null);
        List<Object> list = null;
        if (cur != null) {
            while (cur.moveToNext()) {
                if (list == null) {
                    list = new ArrayList<>();
                }
                String telphone = cur.getString(cur.getColumnIndex(str[0]));
                String realName = cur.getString(cur.getColumnIndex(str[1]));
                telphone = telphone.replaceAll("\\+86", "");
                telphone = telphone.replaceAll(" ", "");
                realName = realName.replaceAll(" ", "");
                if (!TextUtils.isEmpty(realName) && realName.length() > 8) {
                    realName = realName.substring(0, 8);
                }
                if (isPerson) {
                    PersonBean personBean = new PersonBean();
                    personBean.setName(realName);
                    personBean.setTelph(telphone);
                    list.add(personBean);
                } else {
                    SynBill syn = new SynBill();
                    syn.setReal_name(realName);
                    syn.setTelephone(telphone);
                    list.add(syn);
                }
            }
            cur.close();
        }
        return list;
    }


    public static ArrayList<GroupMemberInfo> getLocalContactsInfo(Context context) {
        ContentResolver cr = context.getContentResolver();
        String str[] = {ContactsContract.CommonDataKinds.Phone.NUMBER, ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME};
        Cursor cur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, str, null, null, null);
        ArrayList<GroupMemberInfo> list = new ArrayList<>();
        if (cur != null) {
            while (cur.moveToNext()) {
                String telphone = cur.getString(cur.getColumnIndex(str[0]));
                if (TextUtils.isEmpty(telphone)) {
                    continue;
                }
                String realName = cur.getString(cur.getColumnIndex(str[1]));
                telphone = telphone.replaceAll("\\+86", "");
                telphone = telphone.replaceAll(" ", "");
                realName = realName.replaceAll(" ", "");
                if (!TextUtils.isEmpty(realName) && realName.length() > 8) {
                    realName = realName.substring(0, 8);
                }
                list.add(new GroupMemberInfo(realName, telphone));
            }
            cur.close();
        }
        return list;
    }

}
