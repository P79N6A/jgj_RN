package com.jizhi.jlongg.main.bean;


import com.jizhi.jlongg.main.msg.NewMessageBaseActivity;

/**
 * @author: SCY
 * @date: 2019/4/17   11:10
 * @desc: 添加好友来源
 * @version: 4.0.2
 * 来源路径：
 * <p>
 * 1）通过群聊添加
 * <p>
 * 2）来自手机通讯录
 * <p>
 * 3）通过班组添加
 * <p>
 * 4）通过项目组添加
 * <p>
 * 5）通过工友圈添加
 * <p>
 * 6）通过找活招工添加
 * <p>
 * 7）通过扫码添加
 * <p>
 * 8）搜索手机号码
 * <p>
 * 9）通过人脉资源添加
 * <p>
 * 10）通过聊天添加
 * <p>
 * 3、对方加我：来源显示他发起好友申请的路径
 * <p>
 * 4、我加对方：来源显示我发起好友申请的路径
 * <p>
 * 5、双方同时添加好友的，哪方先“通过验证”，就取哪方的添加路径
 */
public class AddFriendsSources {
    private String source = "";
    /************是否可以重置来源，默认允许******************/
    private boolean isReset=true;
    private static AddFriendsSources addFriendsSources = null;
    public static final String SOURCE_GROUP_CHAT = "1";
    public static final String SOURCE_MOBILE_ADDRESS = "2";
    public static final String SOURCE_TEAM = "3";
    public static final String SOURCE_PROJECT_TEAM = "4";
    public static final String SOURCE_WORKMATES_CICLE = "5";
    public static final String SOURCE_JOB = "6";
    public static final String SOURCE_SCANNER_CODE = "7";
    public static final String SOURCE_SEARCH_PHONE = "8";
    public static final String SOURCE_PEOPLE_CONNECTION = "9";
    public static final String SOURCE_SINGLE_CHAT = "10";

    private AddFriendsSources() {
    }

    public static AddFriendsSources create() {
        if (addFriendsSources == null) {
            synchronized (AddFriendsSources.class) {
                addFriendsSources = new AddFriendsSources();
            }
        }
        return addFriendsSources;
    }


    public String getSource() {
        return source;
    }

    public AddFriendsSources setSource(String source) {
        if (isReset) {
            this.source = source;
        }
        return addFriendsSources;
    }

    /**
     * 添加好友来源时，工友圈和分享的招工找活，会先进入单聊,通过{@link NewMessageBaseActivity#getIntentData()}
     * 方法重新设置来源，这个方法是为了这两种特殊情况下，不重置来源为单聊
     * @param reset 是否可以重置来源， 默认可以
     * @return
     */
    public AddFriendsSources setReset(boolean reset) {
        isReset = reset;
        return addFriendsSources;
    }

    public boolean isReset() {
        return isReset;
    }
}
