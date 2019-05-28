/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:22:44 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-03-29 16:40:43
 * Module:招聘套餐
 */

import React, { Component } from 'react';
import {
    Text,
    View,
    Image,
    TouchableOpacity,
    DeviceEventEmitter,
    NativeModules,
    ScrollView,
    Platform,
    BackHandler, NativeEventEmitter
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'
import AlertUser from '../../component/alertuser'
import { openWebView } from '../../utils'
import { NavigationEvents } from 'react-navigation'

export default class recruitplan extends Component {
    constructor(props) {
        super(props)
        this.state = {
            have_job: 0,
            free_job: 0,
            foreman: {
                auth_expire_time: "",
                is_pay: 0,
                status: "",
                time_left_day: ''
            },
            commando: {
                auth_expire_time: "",
                is_pay: 0,
                status: "",
                time_left_day: ''
            },
            worker: {
                auth_expire_time: "",
                is_pay: 0,
                status: "",
                time_left_day: ''
            },

            // ----------实名or认证、突击弹框----------
            ifOpenAlert: false,//是否打开弹框
            param: '',//实名or认证、突击
            // ---------------------------------------
        }
        this.getAllBuyService = this.getAllBuyService.bind(this)
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    componentDidMount() {
        // 底部导航控制
        this.bottomTab()
        // this.getAllBuyService()
        this.txt = {
            '-1': '[审核未通过]',
            '0': '[待提交资料]',
            '1': '[待审核资料]'
        }

        // android返回start==================================
        BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid);
        // DeviceEventEmitter.addListener('updateTelNum', this.getAllBuyService)
        // 获取我的
        this.myzone()

        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            DeviceEventEmitter.addListener("refreshRN", (param) => {
                // 刷新界面等
				this.refreshRN(param)
			});
            // 拨打电话后重新获取剩余电话数
            // DeviceEventEmitter.addListener("phoneNum", (param) => {
            //     this.getAllBuyService()
            // });
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            const bridge = new NativeEventEmitter(NativeModules.JGJNativeEventEmitter);
            bridge.addListener('refreshRN',(param)=>{
                this.refreshRN(param)
            });
        }
    }
    refreshRN(param) {
        if (param !== {} && !param == '') {
            console.log(JSON.parse(param))
			// alert(GLOBAL.infoverHome + ',' + JSON.parse(param).infover)
			// 先不判断版本号
            if (true || GLOBAL.infoverHome != JSON.parse(param).infover) {//刷新版本号不等-刷新操作
                GLOBAL.infoverHome = JSON.parse(param).infover//刷新版本号更新
                console.log('homepage更新')
                this.setState({}, () => {
                    // 我的页面接口
                    this.myzone()
                })
            }
        }
    }
    componentWillUnmount() {
        BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid);
        // this.subscription.remove()
    }
    onBackButtonPressAndroid = () => {
        if (this.props.navigation.isFocused()) {
            if (this.lastBackPressed && this.lastBackPressed + 2000 >= Date.now()) {
                //最近2秒内按过back键，可以退出应用。
                return false;
            }
            this.lastBackPressed = Date.now();
            this.props.navigation.goBack(), DeviceEventEmitter.emit("EventType", param)
            return true;
        }
    }
    // android返回end====================================================
    myzone() {
        fetchFun.load({
            url: 'jlwork/myzone',
            data: {
                kind: 'recruit'
            },
            success: (res) => {
                console.log('---我的页面接口---', res)
                GLOBAL.userinfo.is_info = res.is_info
                GLOBAL.userinfo.verified = res.verified//3已认证
                this.setState({})
            }
        });
    }

    bottomTab() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.footerController('{state:"hide"}');//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.footerController({ state: "hide" });//调用原生方法
        }
    }
    getAllBuyService() {
        fetchFun.load({
            url: 'v2/project/getAllBuyService',
            data: {},
            noLoading: true,//不显示自定义加载框
            success: (res) => {
                console.log('res', res)
                this.setState({
                    ...res
                })
            }
        })
    }
    commando = () => {
        if (GLOBAL.userinfo.is_info == 0) {//未完善资料
            this.setState({
                ifOpenAlert: !this.state.ifOpenAlert,
                param: 'wszlandsmrz'
            })
        } else {
            if (GLOBAL.userinfo.verified == 3) {//已实名
                if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
                    NativeModules.MyNativeModule.openWebView('my/attest/commando')
                }
                if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
                    NativeModules.JGJRecruitmentController.openWebView('my/attest/commando')
                }
            } else {
                this.setState({
                    ifOpenAlert: !this.state.ifOpenAlert,
                    param: 'smrz'
                })
            }
        }
    }
    alertFunr() {
        this.setState({
            ifOpenAlert: false
        })
    }
    // 去完善资料
    gows() {
        this.setState({
            ifOpenAlert: !this.state.ifOpenAlert,
        })
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openWebView('my/info?perfect=1&verified=1');//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            NativeModules.JGJRecruitmentController.openWebView('my/info?perfect=1&verified=1');//调用原生方法
        }
    }
    render() {
        let { have_job, free_job, foreman, worker, commando } = this.state

        return (
            <View style={{ backgroundColor: '#ebebeb', flex: 1 }}>
                <NavigationEvents onDidFocus={payload => this.getAllBuyService()} />
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => { this.props.navigation.goBack(), DeviceEventEmitter.emit("EventType", param) }}
                    >
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>招聘服务</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7} style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <ScrollView>

                    <View style={{ backgroundColor: '#fff', paddingTop: 16.5, paddingBottom: 16.5, flexDirection: 'row' }}>
                        <TouchableOpacity activeOpacity={.7}
                            onPress={() => this.props.navigation.navigate('Recruit_joborder', {
                                callback: (() => {
                                    this.bottomTab()
                                })
                            })}
                            style={{ width: '50%' }}>
                            <View style={{ flexDirection: 'row', justifyContent: 'center' }}>
                                <Icon name="dingdan" size={45} color="#6F7BD4" />
                            </View>
                            <Text style={{ color: '#333', fontSize: 12, textAlign: 'center', marginTop: 6.6 }}>招聘订单</Text>
                        </TouchableOpacity>
                        <TouchableOpacity activeOpacity={.7}
                            onPress={() => this.props.navigation.navigate('Recruit_servicewater', {
                                callback: (() => {
                                    this.bottomTab()
                                })
                            })}
                            style={{ width: '50%' }}>
                            <View style={{ flexDirection: 'row', justifyContent: 'center' }}>
                                <Icon name="liushui" size={45} color="#33B995" />
                            </View>
                            <Text style={{ color: '#333', fontSize: 12, textAlign: 'center', marginTop: 6.6 }}>服务流水</Text>
                        </TouchableOpacity>
                    </View>

                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.props.navigation.navigate('Recruit_buyalivecall', {
                            callback: (() => {
                                this.bottomTab()
                            })
                        })}
                        style={{ backgroundColor: '#fff', marginTop: 11, padding: 11, }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{ flexDirection: 'row', alignItems: 'flex-start' }}>
                                <Image style={{ width: 66, height: 66 }}
                                    source={require('../../assets/recruit/jobwork.png')}></Image>
                                <View style={{ marginLeft: 11,flex:1 }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center',marginBottom:5 }}>
                                        <Text style={{ color: '#000', fontWeight: '400', fontSize: 15 }}>购买</Text>
                                        <Text style={{ color: 'rgb(47, 161, 160)', fontWeight: '400', fontSize: 15 }}>找活招工</Text>
                                        <Text style={{ color: '#000', fontWeight: '400', fontSize: 15 }}>电话数</Text>
                                    </View>
                                    <Text style={{ color: '#666', fontSize: 12 }}>·可直接拨打电话联系项目和工作</Text>
                                    <Text style={{ color: '#666', fontSize: 12 }}>·可直接拨打电话联系工人</Text>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 4.4,justifyContent:"space-between" }}>
                                        <View style={{flexDirection:"row",alignItems:'center'}}>
                                            <Text style={{ color: '#eb4e4e', fontWeight: '400', fontSize: 15 }}>1.97元/个</Text>
                                            <Text style={{ color: '#666', fontWeight: '400', fontSize: 12, marginLeft: 3 }}>起</Text>
                                        </View>
                                        <View style={{
                                            borderWidth: 1, borderColor: '#666', borderRadius: 4.4, width: 77, height: 29,
                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                        }}>
                                            <Text style={{ color: '#000', fontSize: 14 }}>购买</Text>
                                        </View>
                                    </View>
                                </View>
                            </View>
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 5.5 }}>
                            <Text style={{ color: '#666', fontSize: 14 }}>当前剩余数量：</Text>
                            <Text style={{ color: '#000', fontWeight: '400', fontSize: 14 }}>{have_job}</Text>
                            <Text style={{ color: '#666', fontSize: 14 }}>个(每月赠送{free_job}个)</Text>
                        </View>
                    </TouchableOpacity>

                    <TouchableOpacity activeOpacity={.7}
                        // onPress={() => this.props.navigation.navigate('Recruit_authen', { type: 2,callback: (() => {
                        //     this.bottomTab()
                        // }) })}
                        onPress={() => openWebView('my/attest?role=2')}
                        style={{ backgroundColor: '#fff', marginTop: 11, padding: 11 }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{ flexDirection: 'row', alignItems: 'flex-start' }}>
                                <Image style={{ width: 66, height: 66 }}
                                    source={require('../../assets/recruit/foreman.png')}></Image>
                                <View style={{ marginLeft: 11,flex:1 }}>
                                    {!foreman.is_pay || (foreman.status == 2 && foreman.time_left_day < 1) ?
                                        <View style={{ flexDirection: 'row', alignItems: 'center',marginBottom:5 }}>
                                            <Text style={{ color: '#000', fontWeight: '400', fontSize: 15 }}>购买</Text>
                                            <Text style={{ color: 'rgb(242, 85, 108)', fontWeight: '400', fontSize: 15 }}>班组长认证</Text>
                                            <Text style={{ color: '#000', fontWeight: '400', fontSize: 15 }}>好处</Text>
                                        </View> :
                                        <Text style={{ color: '#3fa976', fontSize: 15 }}>你已购买班组长认证</Text>
                                    }
                                    <Text style={{ color: '#666', fontSize: 12 }}>·可大大提高你的可信度</Text>
                                    <Text style={{ color: '#666', fontSize: 12 }}>·可优先匹配项目</Text>
                                    <Text style={{ color: '#666', fontSize: 12 }}>·可获得广告宣传等高级服务</Text>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 4.4,justifyContent:'space-between' }}>
                                        {!foreman.is_pay || (foreman.status == 2 && foreman.time_left_day < 1) ?
                                            <Text style={{ color: '#eb4e4e', fontWeight: '400', fontSize: 15 }}>99元/年</Text> :
                                            foreman.status != 2 ?
                                                <Text>{this.txt[foreman.status]}</Text> :
                                                <View>
                                                    <Text>有效期至{foreman.auth_expire_time}</Text>
                                                    <Text>[还剩<Text style={{ color: foreman.time_left_day < 90 ? '#eb4e4e' : '#000' }}>{foreman.time_left_day}</Text>天到期]</Text>
                                                </View>
                                        }
                                        <View style={{
                                            borderWidth: 1, borderColor: '#666', borderRadius: 4.4, width: 77, height: 29,
                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                        }}>
                                            <Text
                                                style={{ color: '#000', fontSize: 14 }}
                                            >
                                                查看
                                            {!foreman.is_pay || (foreman.status == 2 && foreman.time_left_day < 1) ?
                                                    <Text>/购买</Text> :
                                                    foreman.status == 2 && foreman.time_left_day <= 30 ?
                                                        <Text>/续期</Text> :
                                                        null
                                                }
                                            </Text>
                                        </View>
                                    </View>
                                </View>
                            </View>
                        </View>
                    </TouchableOpacity>

                    <TouchableOpacity activeOpacity={.7}
                        // onPress={() => this.props.navigation.navigate('Recruit_authen', { type: 1,callback: (() => {
                        //     this.bottomTab()
                        // }) })}
                        onPress={() => openWebView('my/attest?role=1')}
                        style={{ backgroundColor: '#fff', marginTop: 11, padding: 11 }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{ flexDirection: 'row', alignItems: 'flex-start' }}>
                                <Image style={{ width: 66, height: 66 }}
                                    source={require('../../assets/recruit/worker.png')}></Image>
                                <View style={{ marginLeft: 11,flex:1 }}>
                                    {!worker.is_pay || (worker.status == 2 && worker.time_left_day < 1) ?
                                        <View style={{ flexDirection: 'row', alignItems: 'center',marginBottom:5 }}>
                                            <Text style={{ color: '#000', fontWeight: '400', fontSize: 15 }}>购买</Text>
                                            <Text style={{ color: 'rgb(89, 121, 213)', fontWeight: '400', fontSize: 15 }}>工人认证</Text>
                                            <Text style={{ color: '#000', fontWeight: '400', fontSize: 15 }}>好处</Text>
                                        </View> :
                                        <Text style={{ color: '#3fa976', fontSize: 15 }}>你已购买工人认证</Text>
                                    }
                                    <Text style={{ color: '#666', fontSize: 12 }}>·可大大提高你的可信度</Text>
                                    <Text style={{ color: '#666', fontSize: 12 }}>·可优先匹配工作</Text>
                                    <Text style={{ color: '#666', fontSize: 12 }}>·可获得广告宣传等高级服务</Text>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 4.4,justifyContent:'space-between' }}>
                                        {!worker.is_pay || (worker.status == 2 && worker.time_left_day < 1) ?
                                            <Text style={{ color: '#eb4e4e', fontWeight: '400', fontSize: 15 }}>99元/年</Text> :
                                            worker.status != 2 ?
                                                <Text>{this.txt[worker.status]}</Text> :
                                                <View>
                                                    <Text>有效期至{worker.auth_expire_time}</Text>
                                                    <Text>[还剩<Text style={{ color: worker.time_left_day < 90 ? '#eb4e4e' : '' }}>{worker.time_left_day}</Text>天到期]</Text>
                                                </View>
                                        }
                                        <View style={{
                                            borderWidth: 1, borderColor: '#666', borderRadius: 4.4, width: 77, height: 29,
                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                        }}>
                                            <Text
                                                style={{ color: '#000', fontSize: 14 }}
                                            >
                                                查看
                                            {!worker.is_pay || (worker.status == 2 && worker.time_left_day < 1) ?
                                                    <Text>/购买</Text> :
                                                    worker.status == 2 && worker.time_left_day <= 30 ?
                                                        <Text>/续期</Text> :
                                                        null
                                                }
                                            </Text>
                                        </View>
                                    </View>
                                </View>
                            </View>
                        </View>
                    </TouchableOpacity>

                    <TouchableOpacity activeOpacity={.7}
                        onPress={this.commando}
                        style={{ backgroundColor: '#fff', marginTop: 11, padding: 11 }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{ flexDirection: 'row', alignItems: 'flex-start' }}>
                                <Image
                                    style={{ width: 66, height: 66 }}
                                    source={{ uri: `${GLOBAL.server}public/imgs/my/shop/commando.png` }}
                                ></Image>
                                <View style={{ marginLeft: 11,flex:1 }}>
                                    {!commando.is_pay || (commando.status == 2 && commando.time_left_day < 1) ?
                                        <View style={{ flexDirection: 'row', alignItems: 'center',marginBottom:5 }}>
                                            <Text style={{ color: '#000', fontWeight: '400', fontSize: 15 }}>购买</Text>
                                            <Text style={{ color: '#8647B6', fontWeight: '400', fontSize: 15 }}>突击队认证</Text>
                                            <Text style={{ color: '#000', fontWeight: '400', fontSize: 15 }}>好处</Text>
                                        </View> :
                                        <Text style={{ color: '#8647b6', fontSize: 15 }}>你已购买突击队认证</Text>
                                    }
                                    <Text style={{ color: '#666', fontSize: 12 }}>·可优先联系突击队工作</Text>
                                    <Text style={{ color: '#666', fontSize: 12 }}>·招工方可通过"优质突击队"直接找到你</Text>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 4.4,justifyContent:'space-between' }}>
                                        {!commando.is_pay || (commando.status == 2 && commando.time_left_day < 1) ?
                                            <Text style={{ color: '#eb4e4e', fontWeight: '400', fontSize: 15 }}>199元/年</Text> :
                                            commando.status != 2 ?
                                                <Text>{this.txt[commando.status]}</Text> :
                                                <View>
                                                    <Text>有效期至{commando.auth_expire_time}</Text>
                                                    <Text>[还剩<Text style={{ color: commando.time_left_day < 90 ? '#eb4e4e' : '' }}>{commando.time_left_day}</Text>天到期]</Text>
                                                </View>
                                        }
                                        <View style={{
                                            borderWidth: 1, borderColor: '#666', borderRadius: 4.4, width: 77, height: 29,
                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                        }}>
                                            <Text
                                                style={{ color: '#000', fontSize: 14 }}
                                            >
                                                查看
                                            {!commando.is_pay || (commando.status == 2 && commando.time_left_day < 1) ?
                                                    <Text>/购买</Text> :
                                                    commando.status == 2 && commando.time_left_day <= 30 ?
                                                        <Text>/续期</Text> :
                                                        null
                                                }
                                            </Text>
                                        </View>
                                    </View>
                                </View>
                            </View>
                        </View>
                    </TouchableOpacity>
                </ScrollView>
                {/* 弹框 */}
                <AlertUser
                    ifOpenAlert={this.state.ifOpenAlert}
                    alertFunr={this.alertFunr.bind(this)}
                    gows={this.gows.bind(this)}//去完善资料
                    param={this.state.param}
                />
            </View>
        )
    }
}