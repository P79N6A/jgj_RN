

import React, { Component } from 'react'
import {
    StyleSheet, Text, View, TouchableOpacity, Platform,
    Image, ScrollView, ImageBackground,
    NativeModules, DeviceEventEmitter, NativeEventEmitter
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'

export default class authen extends Component {
    constructor(props) {
        super(props)
        this.state = {
            num: 0,//工友圈未读数
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
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            GLOBAL.userinfo.os = 'A'
        } else {
            GLOBAL.userinfo.os = 'I'
        }
        this.callbackComm()
        // 监听原生调取RN的刷新RN页面方法
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
    }
    //卸载监听器
    componentWillUnmount() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            this.offDidUn.remove()
            this.refreshRNUn.remove()
        }
    }
    refreshRN(param) {
        // console.log('Find版本号：----------------', GLOBAL.infoverFind, JSON.parse(param).infover)
        // if (GLOBAL.infoverFind != JSON.parse(param).infover) {//刷新版本号不等-刷新操作
            GLOBAL.infoverFind = JSON.parse(param).infover//刷新版本号更新
            // console.log('find更新=================')
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
                            // 获取工友圈原点标识
                            this.getNum()
                        })
                    }
                })
            }
            if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端

                NativeModules.JGJRecruitmentController.getAppToken(msg, (result) => {
                    // ToastAndroid.show("CallBack收到消息:" + result, ToastAndroid.SHORT);
                    // 根据原生传过来的token获取用户信息存储到config
                    // console.log('find', result)
                    GLOBAL.userinfo.token = result.replace("A ", "");
                    // console.log(result)
                    if (result) {
                        this.setState({}, () => {
                            this.getuserinfo()
                            // 个人名片信息
                            this.mycard()
                            // 获取工友圈未读数
                            this.getNum()
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
                    // this.setState({}, () => {
                    this.getuserinfo()
                    // 个人名片信息
                    this.mycard()
                    // 获取工友圈原点标识
                    this.getNum()
                    // })
                }
            })
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端

            NativeModules.JGJRecruitmentController.getAppToken(msg, (result) => {
                // ToastAndroid.show("CallBack收到消息:" + result, ToastAndroid.SHORT);
                // 根据原生传过来的token获取用户信息存储到config
                // console.log('find', result)
                GLOBAL.userinfo.token = result.replace("A ", "");
                // console.log(result)
                if (result) {
                    this.setState({}, () => {
                        this.getuserinfo()
                        // 个人名片信息
                        this.mycard()
                        // 获取工友圈未读数
                        this.getNum()
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
                GLOBAL.userinfo.uid = res.uid//登陆成功后对应的uid
                GLOBAL.userinfo.verified = res.verified//角色是否已通过实名
                GLOBAL.userinfo.verified_arr = {
                    foreman: res.verified_arr.foreman,
                    worker: res.verified_arr.worker
                }
                // this.setState({
                // })
            }
        });
    }
    mycard() {
        fetchFun.load({
            url: 'v2/workday/getResumeInfo',
            noLoading: true,//不显示自定义加载框
            data: {
                role: GLOBAL.userinfo.role
            },
            success: (res) => {
                // console.log('---我的名片信息---', res)
                GLOBAL.userinfo.worker_info = res.worker_info//工人信息
                GLOBAL.userinfo.foreman_info = res.foreman_info//班组长信息
                GLOBAL.userinfo.telph = res.telephone//电话号码
                GLOBAL.userinfo.introduce = res.introduce//自我介绍
                // this.setState({})
            }
        });
    }
    getNum() {
        fetchFun.load({
            url: 'v2/dynamic/newMsgNum',
            noLoading: true,//不显示自定义加载框
            data: {
            },
            success: (res) => {
                // console.log('---工友圈未读数---', res)
                this.setState({
                    num: Number(res.new_comment_num) + Number(res.new_fans_num) + Number(res.new_liked_num)
                })
            }
        });
    }
    render() {
        let { num } = this.state
        // console.log(num)
        return (
            <View style={{ flex: 1, backgroundColor: '#ebebeb' }}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{
                        flexDirection: 'row', alignItems: 'center',
                        marginLeft: 10, marginBottom: 1, width: '25%'
                    }}>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>发现</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7} style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>

                {/* 工友圈 */}
                <TouchableOpacity activeOpacity={.7}
                    onPress={() => this.linkPage(GLOBAL.co_workers_circle)}
                    style={{
                        marginTop: 20,
                        backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                        flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center'
                    }}>
                    <View style={{ flexDirection: "row", alignItems: 'center', marginLeft: 20 }}>
                        <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/my/find-circle.png` }}></Image>

                        <Text style={{ color: '#000', fontSize: 15, marginLeft: 12 }}>工友圈</Text>
                    </View>

                    <View style={{ flexDirection: "row", alignItems: "center" }}>
                        {
                            num > 0 ? (
                                <View style={{
                                    marginRight: 10, width: 20, height: 20, borderRadius: 20, backgroundColor: "red",
                                    flexDirection: 'row', alignItems: "center", justifyContent: 'center'
                                }}>
                                    {
                                        num < 100 ? (
                                            <Text style={{ color: "white", fontSize: 10 }}>{num}</Text>
                                        ) : (
                                                <Text style={{ color: "white", fontSize: 10 }}>99+</Text>
                                            )
                                    }
                                </View>
                            ) : false
                        }
                        <Icon name="r-arrow" size={10} color="#000" />
                    </View>
                </TouchableOpacity>

                {/* 曝光台 */}
                <TouchableOpacity activeOpacity={.7}
                    onPress={() => this.linkPage(GLOBAL.lighthouse)}
                    style={{
                        marginTop: 20,
                        backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                        flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center'
                    }}>
                    <View style={{ flexDirection: "row", alignItems: 'center', marginLeft: 20 }}>
                        <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/my/find-exposure.png` }}></Image>

                        <Text style={{ color: '#000', fontSize: 15, marginLeft: 12 }}>曝光台</Text>
                    </View>
                    <Icon name="r-arrow" size={10} color="#000" />
                </TouchableOpacity>

                {/* 积分兑好礼 */}
                <TouchableOpacity activeOpacity={.7}
                    onPress={() => this.linkPage(GLOBAL.points_for_gifts)}
                    style={{
                        marginTop: 20,
                        backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                        flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center'
                    }}>
                    <View style={{ flexDirection: "row", alignItems: 'center', marginLeft: 20 }}>
                        <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/my/find-integral.png` }}></Image>

                        <Text style={{ color: '#000', fontSize: 15, marginLeft: 12 }}>积分兑好礼</Text>
                    </View>
                    <Icon name="r-arrow" size={10} color="#000" />
                </TouchableOpacity>

                {/* 资料库 */}
                <TouchableOpacity activeOpacity={.7}
                    onPress={() => this.openRepository()}
                    style={{ marginTop: 20, paddingLeft: 20, backgroundColor: '#fff' }}>
                    <View style={{
                        backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                        flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center',
                        borderBottomWidth: 1, borderBottomColor: '#ebebeb',
                    }}>
                        <View style={{
                            flexDirection: "row", alignItems: 'center',
                        }}>
                            <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/my/find-datum.png` }}></Image>
                            <Text style={{ color: '#000', fontSize: 15, marginLeft: 12 }}>资料库</Text>
                        </View>
                        <Icon name="r-arrow" size={10} color="#000" />
                    </View>
                </TouchableOpacity>
                {/* 资讯 */}
                <TouchableOpacity activeOpacity={.7}
                    onPress={() => this.linkPage(GLOBAL.information)}
                    style={{
                        backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                        flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center'
                    }}>
                    <View style={{ flexDirection: "row", alignItems: 'center', marginLeft: 20 }}>
                        <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/my/find-coffee.png` }}></Image>

                        <Text style={{ color: '#000', fontSize: 15, marginLeft: 12 }}>资讯</Text>
                    </View>
                    <Icon name="r-arrow" size={10} color="#000" />
                </TouchableOpacity>

                {/* 建工计算器 */}
                <TouchableOpacity activeOpacity={.7}
                    onPress={() => this.openCalender()}
                    style={{
                        marginTop: 20,
                        backgroundColor: '#fff', paddingTop: 14, paddingBottom: 14, paddingRight: 15,
                        flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center'
                    }}>
                    <View style={{ flexDirection: "row", alignItems: 'center', marginLeft: 20 }}>
                        <Image style={{ width: 20, height: 20 }} source={{ uri: `${GLOBAL.server}public/imgs/jsq.png` }}></Image>

                        <Text style={{ color: '#000', fontSize: 15, marginLeft: 12 }}>建工计算器</Text>
                    </View>
                    <Icon name="r-arrow" size={10} color="#000" />
                </TouchableOpacity>


            </View>
        )
    }
    // 调用原生进行页面跳转
    linkPage(e) {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openWebView(e);//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {
            NativeModules.JGJDiscoveryController.openWebView(e);//调用原生方法
        }
    }
    // 资料库openRepository
    openRepository() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openRepository();//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {
            NativeModules.JGJDiscoveryController.openRepository();//调用原生方法
        }
    }
    // 建工计算器opencalender
    openCalender() {
        let url = 'https://a.app.qq.com/o/simple.jsp?pkgname=com.glodon.constructioncalculators'
        let params = { title: '建工计算器', url, isShowHeader: 1 }
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openCalculator();//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {
            NativeModules.JGJDiscoveryController.openCalculator(params);//调用原生方法
        }
    }

}
