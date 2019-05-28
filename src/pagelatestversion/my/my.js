

import React, { Component } from 'react'
import {
    StyleSheet, Text, View, TouchableOpacity, Platform,
    Image, ScrollView, ImageBackground,
    NativeModules, DeviceEventEmitter, NativeEventEmitter, StatusBar
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'
import ImageCom from '../../component/imagecom';
import { openWebView } from '../../utils'

export default class authen extends Component {
    constructor(props) {
        super(props)
        this.state = {
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    componentDidMount() {
        this.offDidUn = DeviceEventEmitter.addListener("offDid", (param) => {
            GLOBAL.jogShowDid = false
            this.setState({})
        });
        GLOBAL.jogShowDid = true//招工找活页面加载痕迹
        // alert(JSON.stringify(GLOBAL.userinfo.work_staus));
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            GLOBAL.userinfo.os = 'A'
        } else {
            GLOBAL.userinfo.os = 'I'
        }
        this.callbackComm()
        this.setState({}, () => {
            // 获取android_token
            if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
                NativeModules.MyNativeModule.closeDialog('close');
                // 完善资料后android调用RN方法，刷新NR页面
                this.refreshRNUn = DeviceEventEmitter.addListener("refreshRN", (param) => {
                    // 刷新界面等
                    if (GLOBAL.jogShowDid) {//加载过招工找活页面才执行下面代码
                        this.refreshRN(param)
                    }
                });
            }
            if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
                const bridge = new NativeEventEmitter(NativeModules.JGJNativeEventEmitter);
                bridge.addListener('refreshRN', (param) => {
                    this.refreshRN(param);
                });

            }
        })
    }
    //卸载监听器
    componentWillUnmount() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            this.offDidUn.remove()
            this.refreshRNUn.remove()
        }
    }
    refreshRN(param) {
        // console.log(GLOBAL.infoverMy + ',' + JSON.parse(param).infover)
        // alert(GLOBAL.infoverMy+','+JSON.parse(param).infover)
        // if (GLOBAL.infoverMy != JSON.parse(param).infover) {//刷新版本号不等-刷新操作
            GLOBAL.infoverMy = JSON.parse(param).infover//刷新版本号更新
            // console.log('my更新=================')
            let msg = ''
            if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端

                NativeModules.MyNativeModule.getAppToken(msg, (result) => {
                    // ToastAndroid.show("CallBack收到消息:" + result, ToastAndroid.SHORT);
                    // 根据原生传过来的token获取用户信息存储到config
                    GLOBAL.userinfo.token = result.replace("A ", "");
                    // console.log(result)
                    if (result) {
                        this.setState({}, () => {
                            this.getuserinfo()
                            // 个人名片信息
                            this.mycard()
                        })
                    }
                })
            }
            if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端

                NativeModules.JGJRecruitmentController.getAppToken(msg, (result) => {
                    // ToastAndroid.show("CallBack收到消息:" + result, ToastAndroid.SHORT);
                    // 根据原生传过来的token获取用户信息存储到config
                    // console.log('my', result)
                    GLOBAL.userinfo.token = result.replace("A ", "");
                    // console.log(result)
                    if (result) {
                        this.setState({}, () => {
                            this.getuserinfo()
                            // 个人名片信息
                            this.mycard()
                        })
                    }
                })
            }
        // }
    }
    // RN调用Native且通过Callback回调 通信方式_获取token
    callbackComm() {
        let msg = ''
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端

            NativeModules.MyNativeModule.getAppToken(msg, (result) => {
                // ToastAndroid.show("CallBack收到消息:" + result, ToastAndroid.SHORT);
                // 根据原生传过来的token获取用户信息存储到config
                GLOBAL.userinfo.token = result.replace("A ", "");
                // console.log(result)
                if (result) {
                    this.setState({}, () => {
                        this.getuserinfo()
                        // 个人名片信息
                        this.mycard()
                    })
                }
            })
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端

            NativeModules.JGJRecruitmentController.getAppToken(msg, (result) => {
                // ToastAndroid.show("CallBack收到消息:" + result, ToastAndroid.SHORT);
                // 根据原生传过来的token获取用户信息存储到config
                // console.log('my', result)
                GLOBAL.userinfo.token = result.replace("A ", "");
                // console.log(result)
                if (result) {
                    this.setState({}, () => {
                        this.getuserinfo()
                        // 个人名片信息
                        this.mycard()
                    })
                }
            })
        }
    }
    // 获取用户信息存储到config
    getuserinfo() {
        let token = GLOBAL.userinfo.token
        fetchFun.load({
            url: 'v2/signup/userstatus',
            noLoading: true,//不显示自定义加载框
            data: {
            },
            success: (res) => {
                // console.log('---用户信息---', res)
                GLOBAL.userinfo.gender = res.gender
                GLOBAL.userinfo.group_user_name = res.group_user_name
                GLOBAL.userinfo.group_verified = res.group_verified//班组认证
                GLOBAL.userinfo.head_pic = res.head_pic//头像
                GLOBAL.userinfo.is_commando = res.is_commando
                GLOBAL.userinfo.is_info = res.is_info//是否具有基本信息
                GLOBAL.userinfo.os = res.os//平台
                GLOBAL.userinfo.partner_level = res.partner_level
                GLOBAL.userinfo.partner_status = res.partner_status
                GLOBAL.userinfo.real_name = res.real_name//登陆成功后对应的用户姓名
                GLOBAL.userinfo.resume_perfectness = res.resume_perfectness
                GLOBAL.userinfo.role = res.role//当前角色
                GLOBAL.userinfo.serverTime = res.serverTime
                GLOBAL.userinfo.signature = ''
                GLOBAL.userinfo.token = token
                GLOBAL.userinfo.work_status = res.work_status
                GLOBAL.userinfo.uid = res.uid//登陆成功后对应的uid
                GLOBAL.userinfo.verified = res.verified//角色是否已通过实名
                GLOBAL.userinfo.verified_arr = {
                    foreman: res.verified_arr.foreman,
                    worker: res.verified_arr.worker
                }
                this.setState({

                })
            }
        });
    }
    mycard() {
        fetchFun.load({
            url: 'v2/workday/getResumeInfo',
            noLoading: true,//不显示自定义加载框
            data: {
                role: GLOBAL.userinfo.role,
            },
            success: (res) => {
                // console.log('---我的名片信息---', res)
                GLOBAL.userinfo.worker_info = res.worker_info//工人信息
                GLOBAL.userinfo.foreman_info = res.foreman_info//班组长信息
                GLOBAL.userinfo.telph = res.telephone//电话号码
                GLOBAL.userinfo.introduce = res.introduce//自我介绍
                GLOBAL.userinfo.signature = res.signature//个性签名
                this.setState({})
            }
        });
    }
    componentWillUnmount() {
    }

    render() {
        // console.log(GLOBAL.userinfo.role)
        return (
            <View style={{ flex: 1, backgroundColor: '#ebebeb' }}>
                <StatusBar
                    backgroundColor='black' //状态栏的背景色
                />

                {/* header */}
                <ImageBackground style={styles.header} source={require('../../assets/personal/db.png')}>
                    <View style={{ width: '100%', height: '100%', backgroundColor: 'rgba(0,0,0,.3)' }}>

                    </View>
                    <TouchableOpacity activeOpacity={.7}
                        activeOpacity={1}
                        onPress={() => this.linkPage(GLOBAL.personal_information)}
                        style={styles.padd}>
                        {/* 用户头像 */}
                        {/* <Image style={styles.userimg} source={require('../../assets/personal/img.jpg')}></Image> */}
                        {
                            GLOBAL.userinfo.head_pic && GLOBAL.userinfo.head_pic.indexOf('iconimgs') != -1 ? (
                                <ImageCom
                                    style={styles.userimg}
                                    fontSize='17.6'
                                    userPic={GLOBAL.userinfo.head_pic}
                                    userName={GLOBAL.userinfo.real_name}
                                />
                            ) : (
                                    <Image style={styles.userimg} source={{ uri: `${GLOBAL.server}public/imgs/my/header.png` }}></Image>
                                )
                        }
                        {/* 用户信息 */}
                        <View style={styles.you}>
                            <View style={styles.mainh}>
                                <View style={styles.top}>
                                    {
                                        GLOBAL.userinfo.real_name ? (
                                            <Text style={styles.name}>{GLOBAL.userinfo.real_name}</Text>
                                        ) : (
                                                <Text></Text>
                                            )
                                    }
                                    {
                                        GLOBAL.userinfo.telph ? (
                                            <Text style={styles.phone}>{GLOBAL.userinfo.telph.slice(0, 3)}****{GLOBAL.userinfo.telph.slice(8, 11)}</Text>
                                        ) : false
                                    }
                                </View>
                                {
                                    GLOBAL.userinfo.telph ? (
                                        <View style={styles.right}>
                                            <Icon style={{ marginRight: 10 }} name="erweima" size={20} color="#fff" />
                                            <Image style={styles.more} source={require('../../assets/personal/more.png')}></Image>
                                        </View>
                                    ) : false
                                }
                            </View>
                            <View sytle={styles.bot}>
                                {
                                    GLOBAL.userinfo.signature ? (
                                        <Text style={{ color: '#ffffff', fontSize: 12, marginTop: 4,lineHeight:18 }}>{GLOBAL.userinfo.signature}</Text>
                                    ) : (
                                            <Text style={{ color: '#ffffff', fontSize: 12, marginTop: 4,lineHeight:18 }}>独一无二的个性介绍，会让你的朋友满天下！</Text>
                                        )
                                }
                            </View>
                        </View>
                    </TouchableOpacity>
                </ImageBackground>

                <ScrollView>
                    {/* 实名认证 */}
                    {
                        GLOBAL.userinfo.verified == 3 ? false : (
                            <TouchableOpacity activeOpacity={.7}
                                onPress={() => this.linkPage(GLOBAL.real_name_authentication)}
                                style={styles.authen}>
                                <Text style={styles.authent}>你还没有进行实名认证</Text>
                                <Text style={styles.authent}>立即认证 ></Text>
                            </TouchableOpacity>
                        )
                    }

                    {/* 切换身份 */}
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.chooseRole()}
                        style={{ paddingLeft: 20, backgroundColor: '#fff' }}>
                        <View style={{
                            backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                            flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
                            borderBottomColor: '#ebebeb', borderBottomWidth: 1,
                        }}>
                            <View style={{
                                flexDirection: "row", alignItems: 'center',
                            }}>
                                <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/my/my-identity.png` }}></Image>
                                <Text style={{ color: '#000', fontSize: 15, marginLeft: 12 }}>切换身份</Text>
                            </View>
                            <View style={{ flexDirection: 'row', alignItems: "center" }}>
                                {
                                    GLOBAL.userinfo.role ? (
                                        <Text style={{ color: '#000', fontSize: 12, }}>{GLOBAL.userinfo.role == '1' ? '工人' : '班组长/工头'}</Text>
                                    ) : false
                                }
                                <Icon style={{ marginLeft: 10 }} name="r-arrow" size={10} color="#000" />
                            </View>
                        </View>
                    </TouchableOpacity>
                    {/* 我的找活名片 */}
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.linkPage(GLOBAL.mycard)}
                        style={{
                            backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                            flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
                        }}>
                        <View style={{ flexDirection: "row", alignItems: 'center', marginLeft: 20 }}>
                            <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/my/my-resume.png` }}></Image>
                            <Text style={{ color: '#000', fontSize: 15, marginLeft: 12 }}>我的找活名片</Text>
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: "center" }}>
                            {
                                GLOBAL.userinfo.work_status ? (
                                    GLOBAL.userinfo.work_status == '0' ? (
                                        <Text style={{ color: 'rgb(65, 147, 223)', fontSize: 12, }}>未开工正在找工作</Text>
                                    ) : (
                                            GLOBAL.userinfo.work_status == '1' ? (
                                                <Text style={{ color: 'rgb(65, 147, 223)', fontSize: 12, }}>暂时不需要找工作</Text>
                                            ) : (
                                                    <Text style={{ color: 'rgb(65, 147, 223)', fontSize: 12, }}>已开工也在找工作</Text>
                                                )
                                        )
                                ) : false
                            }
                            <Icon style={{ marginLeft: 10 }} name="r-arrow" size={10} color="#000" />
                        </View>
                    </TouchableOpacity>

                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.linkPage('partner/recommend')}
                        style={{ paddingLeft: 20, backgroundColor: '#fff', marginTop: 20 }}>
                        <View style={{
                            backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                            flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
                            borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                        }}>
                            <View style={{
                                flexDirection: "row", alignItems: 'center',
                            }}>
                                <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/my/icon-invitation.png` }}></Image>
                                <Text style={{ color: '#000', fontSize: 15, marginLeft: 12 }}>推荐给他人</Text>
                            </View>
                            <View style={{ flexDirection: 'row', alignItems: "center" }}>
                                <Icon style={{ marginLeft: 10 }} name="r-arrow" size={10} color="#000" />
                            </View>
                        </View>
                    </TouchableOpacity>

                    {/* 每日一签 */}
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.linkPage(GLOBAL.the_day_to_sign)}
                        style={{ paddingLeft: 20, backgroundColor: '#fff', marginTop: 20 }}>
                        <View style={{
                            backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                            flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
                            borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                        }}>
                            <View style={{
                                flexDirection: "row", alignItems: 'center',
                            }}>
                                <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/my/icon-signin.png` }}></Image>
                                <Image style={{ width: 65, height: 16, marginLeft: 10 }} source={{ uri: `${GLOBAL.server}public/imgs/my/signtitle.png` }}></Image>
                            </View>
                            <View style={{ flexDirection: 'row', alignItems: "center" }}>
                                <Text style={{ color: '#999', fontSize: 12 }}>天天领积分</Text>
                                <Icon style={{ marginLeft: 10 }} name="r-arrow" size={10} color="#000" />
                            </View>
                        </View>
                    </TouchableOpacity>
                    {/* 我的收藏 */}
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.linkPage(GLOBAL.my_collection)}
                        style={{ paddingLeft: 20, backgroundColor: '#fff' }}>
                        <View style={{
                            backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                            flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
                            borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                        }}>
                            <View style={{
                                flexDirection: "row", alignItems: 'center',
                            }}>
                                <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/my/icon-collection.png` }}></Image>
                                <Text style={{ color: '#000', fontSize: 15, marginLeft: 12 }}>我的收藏</Text>
                            </View>
                            <View style={{ flexDirection: 'row', alignItems: "center" }}>
                                <Icon style={{ marginLeft: 10 }} name="r-arrow" size={10} color="#000" />
                            </View>
                        </View>
                    </TouchableOpacity>
                    {/* 我的帖子 */}
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.linkPage(GLOBAL.my_post)}
                        style={{
                            backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                            flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
                            marginBottom: 20
                        }}>
                        <View style={{ flexDirection: "row", alignItems: 'center', marginLeft: 20 }}>
                            <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/my/icon-dynamic.png` }}></Image>
                            <Text style={{ color: '#000', fontSize: 15, marginLeft: 12 }}>我的帖子</Text>
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: "center" }}>
                            <Icon style={{ marginLeft: 10 }} name="r-arrow" size={10} color="#000" />
                        </View>
                    </TouchableOpacity>

                    {/* 意见反馈 */}
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.linkPage(GLOBAL.feedback)}
                        style={{ paddingLeft: 20, backgroundColor: '#fff' }}>
                        <View style={{
                            backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                            flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
                            borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                        }}>
                            <View style={{
                                flexDirection: "row", alignItems: 'center',
                            }}>
                                <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/my/icon-advice.png` }}></Image>

                                <Text style={{ color: '#000', fontSize: 15, marginLeft: 12 }}>意见反馈</Text>
                            </View>
                            <View style={{ flexDirection: 'row', alignItems: "center" }}>
                                <Icon style={{ marginLeft: 10 }} name="r-arrow" size={10} color="#000" />
                            </View>
                        </View>
                    </TouchableOpacity>
                    {/* 设置 */}
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.openSet()}
                        style={{
                            backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                            flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
                            marginBottom: 20
                        }}>
                        <View style={{ flexDirection: "row", alignItems: 'center', marginLeft: 20 }}>
                            <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/my/icon-setting.png` }}></Image>
                            <Text style={{ color: '#000', fontSize: 15, marginLeft: 12 }}>设置</Text>
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: "center" }}>
                            <Icon style={{ marginLeft: 10 }} name="r-arrow" size={10} color="#000" />
                        </View>
                    </TouchableOpacity>
                </ScrollView>
            </View>
        )
    }
    // 调用原生进行页面跳转
    linkPage(e) {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openWebView(e);//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJMineViewController.openWebView(e);//调用原生方法
        }
    }
    // 切换身份
    chooseRole() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.chooseRole();//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJMineViewController.chooseRole();//调用原生方法
        }
    }
    // 设置
    openSet() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openSet();//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJMineViewController.openSet();//调用原生方法
        }
    }
}

const styles = StyleSheet.create({
    oneljt: {
        color: '#000000',
        fontSize: 14,
    },
    onertext: {
        color: '#999999',
        fontSize: 14,
        marginRight: 10,
    },
    oner: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    oneltext: {
        color: '#000000',
        fontSize: 16,
    },
    onelimg: {
        width: 20,
        height: 20,
        marginRight: 13,
    },
    onel: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    single: {
        height: 50,
        borderBottomColor: '#DBDBDB',
        borderBottomWidth: 0.5,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingRight: 15,

    },
    one: {
        width: '100%',
        height: 100,
        backgroundColor: '#ffffff',
        paddingLeft: 20,
    },
    redeven: {
        width: '100%',
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        paddingTop: 10,
        paddingBottom: 10
    },
    authent: {
        color: '#FF6600',
        fontSize: 15,
    },
    authen: {
        width: '100%',
        height: 50,
        backgroundColor: '#FDF1E0',
        borderBottomColor: '#DBDBDB',
        borderBottomWidth: 0.5,
        paddingLeft: 20,
        paddingRight: 15,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        color: '#f60',
        fontSize: 15,
        fontWeight: '400',
        lineHeight: 22
    },
    container: {
        flex: 1,
        alignItems: 'center',
        backgroundColor: '#EEEEEE',
    },
    header: {
        height: 131,
        width: '100%',
        position: 'relative'
    },
    padd: {
        paddingLeft: 19,
        paddingTop: 25,
        paddingRight: 16,
        flexDirection: 'row',
        position: 'absolute'
    },
    userimg: {
        width: 60,
        height: 60,
        marginRight: 15,
        borderRadius: 4,
        marginTop: 7
    },
    you: {
        flex: 1,
        paddingTop:4
    },
    mainh: {
        width: '100%',
        flexDirection: 'row',
        borderBottomWidth: 0.5,
        borderBottomColor: 'rgba(255,255,255,0.4)',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingBottom: 5,
    },
    top: {
        flex: 1,
    },
    name: {
        color: '#FFFFFF',
        fontSize: 19,
        lineHeight: 27,
        fontWeight: '400'
    },
    phone: {
        color: '#FFFFFF',
        fontSize: 12,
        lineHeight: 18
    },
    right: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    erweima: {
        width: 20,
        height: 20,
        marginRight: 8,
    },
    more: {
        width: 15,
        height: 15,
        transform: [{ rotate: '270deg' }],
    },
    bot: {
        flex: 1,
        flexWrap: 'wrap',
    },
})