/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 18:13:05 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-17 14:34:00
 * Module:我的招聘
 */

import React, { Component } from 'react';
import {
    Text,
    View,
    TouchableOpacity,
    TextInput,
    Image,
    DeviceEventEmitter,
    NativeModules,
    Platform,
    BackHandler
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'
import Loading from '../../component/loading'

export default class myjob extends Component {
    constructor(props) {
        super(props)
        this.state = {
            zgr: true,//招工人
            zbz: false,//招班组
            ztjd: false,//招突击队

            openAlert: false,//加载弹框
            warning: '请选择所需工种',

            fbzgTypeNameOther: '',// 其他工种
            fbzgProjectNameOther: '',//其他工程

            pos: '',//当前位置经纬度

            update:false,
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    componentDidMount() {
        // 底部导航控制
        this.bottomTab()

        // 获取原生经纬度
        this.getLocation()

        // android返回start==================================
        BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid);
    }
    componentWillUnmount() {
        BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid);
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

    bottomTab() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.footerController('{state:"hide"}');//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.footerController({ state: "hide" });//调用原生方法
        }
    }
    // 获取原生经纬度
    getLocation() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.getLocation('', (result) => {
                this.setState({
                    pos: result ? result.split(',') : [0, 0]
                }, () => {
                    this.cityName()
                })
            })
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            NativeModules.JGJRecruitmentController.getLocation('', (result) => {
                // this.setState({
                //     pos: result ? result.split(',') : [0, 0]
                // }, () => {
                //     this.cityName()
                // })
                let arr = [JSON.parse(result).lat, JSON.parse(result).lng];
                if (result) {
                    this.setState({
                        pos: arr
                    }, () => {
                        this.cityName()
                    })
                }
            })
        }
    }
    // 根据经纬度获取城市名称
    cityName() {
        var longitude = this.state.pos[0];
        var latitude = this.state.pos[1];
        fetchFun.load({
            url: `https://api.map.baidu.com/geocoder/v2/?output=json&ak=${GLOBAL.baiduKey}&location=${longitude},${latitude}`,
            completeUrl: true,//是否是完整URL
            type: 'GET',
            data: {
            },
            success: (res) => {
                console.log('---定位地址---', res.result.addressComponent.province, res.result.addressComponent.city)
                GLOBAL.fbzgAddress.fbzgAddressOneName = res.result.addressComponent.province
                GLOBAL.fbzgAddress.fbzgAddressTwoName = res.result.addressComponent.city

                this.setState({}, () => {
                    // 获取省
                    this.getProvince()
                })
            }
        });
    }
    // 获取省
    getProvince() {
        if (GLOBAL.AddressOne && GLOBAL.AddressOne.length > 0) {//已缓存
            this.getCity()//获取市
        } else {
            fetchFun.load({
                url: 'jlcfg/cities',
                data: {
                    level: '1',//城市级别 1：省 2 市 3县
                    citycode: '0',//城市编码
                    kind: 'recruit'
                },
                success: (res) => {
                    console.log('---获取城市列表-省---', res)
                    GLOBAL.AddressOne = res
                    this.setState({}, () => {
                        this.getCity()//获取市
                    })
                }
            });
        }
    }
    // 获取市
    getCity() {
        let code = ''
        GLOBAL.AddressOne.map((v, i) => {
            if (v.city_name == GLOBAL.fbzgAddress.fbzgAddressOneName) {
                code = v.city_code
            }
        })
        fetchFun.load({
            url: 'jlcfg/cities',
            data: {
                level: '2',//城市级别 1：省 2 市 3县
                citycode: code,//城市编码
            },
            success: (res) => {
                console.log('---获取城市列表-市---', res)
                res.map((v, i) => {
                    if (v.city_name == GLOBAL.fbzgAddress.fbzgAddressTwoName) {
                        GLOBAL.fbzgAddress.fbzgAddressTwoNum = v.city_code
                    }
                })
                GLOBAL.AddressTwo = res
                this.setState({})
            }
        });
    }
    render() {
        if (this.props.navigation.getParam('name') == 'lookingworker' && GLOBAL.fbzgType.fbzgTypeName == '选择工种') {
            GLOBAL.fbzgType.fbzgTypeName = GLOBAL.zgrType.zgrTypeName// 工种
        }
        return (
            <View style={{ backgroundColor: '#ebebeb', flex: 1 }}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.gobackFun()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>发布招工</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7}
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <View style={{ paddingTop: 11, paddingBottom: 11, marginBottom: 15, backgroundColor: '#fff' }}>
                    <Text style={{ marginTop: 15.5, marginBottom: 15.5, color: '#999', fontSize: 15.4, textAlign: 'center' }}>选择你想招的人</Text>
                    {/* 三个选项 */}
                    <View style={{ paddingLeft: 22, paddingRight: 22, flexDirection: 'row', justifyContent: 'center' }}>
                        <TouchableOpacity activeOpacity={.7}
                            onPress={() => this.zgrFun()}
                            style={{ width: '33.33%', flexDirection: 'row', justifyContent: 'center' }}>
                            <View>
                                <View style={{ width: 75, height: 75, borderRadius: 75, position: 'relative' }}>
                                    {
                                        this.props.navigation.getParam('name') == 'lookingworker' && !this.state.update ? (
                                            <View>
                                                {
                                                    GLOBAL.lookworker ? (
                                                        <Image style={{ width: 75, height: 75 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/worker-active.png` }}></Image>
                                                    ) : (
                                                            <Image style={{ width: 75, height: 75 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/worker.png` }}></Image>
                                                        )
                                                }
                                                {
                                                    GLOBAL.lookworker ? (
                                                        <View style={{
                                                            width: 22, height: 22, borderRadius: 22,
                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                            backgroundColor: '#fff', position: 'absolute', right: 0, top: 0
                                                        }}>
                                                            <Icon name="success" size={21} color="#eb4e4e" />
                                                        </View>
                                                    ) : (
                                                            <View></View>
                                                        )
                                                }
                                            </View>
                                        ) : (
                                                <View>
                                                    {
                                                        this.state.zgr ? (
                                                            <Image style={{ width: 75, height: 75 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/worker-active.png` }}></Image>
                                                        ) : (
                                                                <Image style={{ width: 75, height: 75 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/worker.png` }}></Image>
                                                            )
                                                    }
                                                    {
                                                        this.state.zgr ? (
                                                            <View style={{
                                                                width: 22, height: 22, borderRadius: 22,
                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                backgroundColor: '#fff', position: 'absolute', right: 0, top: 0
                                                            }}>
                                                                <Icon name="success" size={21} color="#eb4e4e" />
                                                            </View>
                                                        ) : (
                                                                <View></View>
                                                            )
                                                    }
                                                </View>
                                            )
                                    }
                                </View>
                                <Text style={{ textAlign: 'center', color: '#000', fontSize: 13.2 }}>招工人</Text>
                            </View>
                        </TouchableOpacity>

                        <TouchableOpacity activeOpacity={.7}
                            onPress={() => this.zbzFun()}
                            style={{ width: '33.33%', flexDirection: 'row', justifyContent: 'center' }}>
                            <View>
                                <View style={{ width: 75, height: 75, borderRadius: 75 }}>
                                    {
                                        this.props.navigation.getParam('name') == 'lookingworker' && !this.state.update ? (
                                            <View>
                                                {
                                                    !GLOBAL.lookworker ? (
                                                        <Image style={{ width: 75, height: 75 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/foreman-active.png` }}></Image>
                                                    ) : (
                                                            <Image style={{ width: 75, height: 75 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/foreman.png` }}></Image>
                                                        )
                                                }
                                                {
                                                    !GLOBAL.lookworker ? (
                                                        <View style={{
                                                            width: 22, height: 22, borderRadius: 22,
                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                            backgroundColor: '#fff', position: 'absolute', right: 0, top: 0
                                                        }}>
                                                            <Icon name="success" size={21} color="#eb4e4e" />
                                                        </View>
                                                    ) : (
                                                            <View></View>
                                                        )
                                                }
                                            </View>
                                        ) : (
                                                <View>
                                                    {
                                                        this.state.zbz ? (
                                                            <Image style={{ width: 75, height: 75 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/foreman-active.png` }}></Image>
                                                        ) : (
                                                                <Image style={{ width: 75, height: 75 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/foreman.png` }}></Image>
                                                            )
                                                    }
                                                    {
                                                        this.state.zbz ? (
                                                            <View style={{
                                                                width: 22, height: 22, borderRadius: 22,
                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                backgroundColor: '#fff', position: 'absolute', right: 0, top: 0
                                                            }}>
                                                                <Icon name="success" size={21} color="#eb4e4e" />
                                                            </View>
                                                        ) : (
                                                                <View></View>
                                                            )
                                                    }
                                                </View>
                                            )
                                    }
                                </View>
                                <Text style={{ textAlign: 'center', color: '#000', fontSize: 13.2 }}>招班组</Text>
                            </View>
                        </TouchableOpacity>

                        <TouchableOpacity activeOpacity={.7}
                            onPress={() => this.ztjdFun()}
                            style={{ width: '33.33%', flexDirection: 'row', justifyContent: 'center' }}>
                            <View>
                                <View style={{ width: 75, height: 75, borderRadius: 75 }}>
                                    {
                                        this.state.ztjd ? (
                                            <Image style={{ width: 75, height: 75 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/commando-active.png` }}></Image>
                                        ) : (
                                                <Image style={{ width: 75, height: 75 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/commando.png` }}></Image>
                                            )
                                    }
                                    {
                                        this.state.ztjd ? (
                                            <View style={{
                                                width: 22, height: 22, borderRadius: 22,
                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                backgroundColor: '#fff', position: 'absolute', right: 0, top: 0
                                            }}>
                                                <Icon name="success" size={21} color="#eb4e4e" />
                                            </View>
                                        ) : (
                                                <View></View>
                                            )
                                    }
                                </View>
                                <Text style={{ textAlign: 'center', color: '#000', fontSize: 13.2 }}>招突击队</Text>
                            </View>
                        </TouchableOpacity>
                    </View>
                </View>

                {/* 所需工种 */}
                <TouchableOpacity activeOpacity={.7}
                    onPress={() => this.gzFun()}
                    style={{
                        paddingLeft: 22, paddingRight: 22, paddingTop: 11, paddingBottom: 11, marginBottom: 11, backgroundColor: '#fff',

                    }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                            <Icon style={{ marginRight: 5.5 }} name="profession" size={26} color="#1296DB" />
                            <Text style={{ color: '#000', fontWeight: '400', fontSize: 16.5 }}>所需工种</Text>
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                            {
                                GLOBAL.fbzgType.fbzgTypeName !== '选择工种' ? (
                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 5 }}>{GLOBAL.fbzgType.fbzgTypeName}</Text>
                                ) : (
                                        <Text style={{ color: '#999', fontSize: 15.4, marginRight: 5 }}>请选择工种</Text>
                                    )
                            }
                            <Icon name="r-arrow" size={12} color="#000" />
                        </View>
                    </View>

                    {/* 其他工种 */}
                    {
                        GLOBAL.fbzgType.fbzgTypeName == '其它工种' ? (
                            <View style={{ height: 38 }}>
                                <TextInput style={{
                                    paddingLeft: 10, flex: 1, marginTop: 5, color: '#000', textAlign: 'left',
                                    borderWidth: 1, borderColor: 'rgb(219, 219, 219)', borderRadius: 3, paddingTop: 0, paddingBottom: 0
                                }}
                                    placeholder='请输入你想要的的工种名称(最多8个字)'
                                    maxLength={8}
                                    onChangeText={this.fbzgTypeNameOtherFun.bind(this)}
                                >
                                </TextInput>
                            </View>
                        ) : false
                    }
                </TouchableOpacity>

                {/* 工程类别 */}
                <TouchableOpacity activeOpacity={.7}
                    onPress={() => this.projectFun()}
                    style={{
                        paddingLeft: 22, paddingRight: 22, paddingTop: 11, paddingBottom: 11,
                        marginBottom: 11, backgroundColor: '#fff',

                    }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                            <Icon style={{ marginRight: 5.5 }} name="project" size={26} color="#DB7F00" />
                            <Text style={{ color: '#000', fontWeight: '400', fontSize: 16.5 }}>工程类别</Text>
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                            {
                                GLOBAL.fbzgProject.fbzgProjectName !== '选择工程类别' ? (
                                    <Text style={{ color: '#000', fontSize: 15.4, }}>{GLOBAL.fbzgProject.fbzgProjectName}</Text>
                                ) : (
                                        <Text style={{ color: '#999', fontSize: 15.4, }}>请选择工程类别</Text>
                                    )
                            }
                            <Icon style={{ marginLeft: 5 }} name="r-arrow" size={12} color="#000" />
                        </View>
                    </View>

                    {/* 其他工程类别 */}
                    {
                        GLOBAL.fbzgProject.fbzgProjectName == '其它' ? (
                            <View style={{ height: 38 }}>
                                <TextInput style={{
                                    paddingLeft: 10, flex: 1, marginTop: 5, color: '#000', textAlign: 'left',
                                    borderWidth: 1, borderColor: 'rgb(219, 219, 219)', borderRadius: 3, paddingTop: 0, paddingBottom: 0
                                }}
                                    placeholder='请输入你想要的的工程名称(最多8个字)'
                                    maxLength={8}
                                    onChangeText={this.fbzgProjectNameOtherFun.bind(this)}
                                >
                                </TextInput>
                            </View>
                        ) : false
                    }
                </TouchableOpacity>

                {/* 项目所在地 */}
                <TouchableOpacity activeOpacity={.7}
                    onPress={() => this.addressFun()}
                    style={{
                        paddingLeft: 22, paddingRight: 22, paddingTop: 11, paddingBottom: 11, marginBottom: 11, backgroundColor: '#fff',
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between'
                    }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Icon style={{ marginRight: 5.5 }} name="area" size={26} color="#6BBE00" />
                        <Text style={{ color: '#000', fontWeight: '400', fontSize: 16.5 }}>项目所在地</Text>
                    </View>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        {
                            GLOBAL.fbzgAddress.fbzgAddressOneName !== '选择城市' ? (
                                <Text style={{ color: '#000', fontSize: 15.4, }}>{GLOBAL.fbzgAddress.fbzgAddressOneName} {GLOBAL.fbzgAddress.fbzgAddressTwoName}</Text>
                            ) : (
                                    <Text style={{ color: '#999', fontSize: 15.4, }}>请选择项目所在地</Text>
                                )
                        }
                        <Icon style={{ marginLeft: 5 }} name="r-arrow" size={12} color="#000" />
                    </View>
                </TouchableOpacity>

                {/* 下一步按钮 */}
                <TouchableOpacity activeOpacity={.7} onPress={() => this.btn()} style={{
                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                    backgroundColor: '#eb4e4e', marginTop: 33, marginLeft: 11, marginRight: 11, height: 49, borderRadius: 5.5
                }}>
                    <Text style={{ color: '#fff', fontSize: 16.5 }}>下一步</Text>
                </TouchableOpacity>

                {/* 加载弹框组件 */}
                <Loading
                    openAlertFun={this.openAlertFun.bind(this)}
                    openAlert={this.state.openAlert}
                    icon='warning'
                    font={this.state.warning} />
            </View>
        )
    }
    // 加载弹框控制
    openAlertFun() {
        this.setState({
            openAlert: !this.state.openAlert
        })
    }
    // 选择工种
    gzFun() {
        if (GLOBAL.typeArr && GLOBAL.typeArr.length > 0) {//工种已缓存
            this.props.navigation.navigate('Typeworker', {
                name: '发布招工工种',
                typeBz: this.state.zbz ? true : false,
                callback: (() => {
                    this.setState({})
                })
            })
        } else {
            fetchFun.load({
                url: 'jlcfg/classlist',
                data: {
                    class_id: 1,//1:工种 2：项目类型3：熟练度 31：福利 40：举报信息类型
                    kind: 'recruit'
                },
                success: (res) => {
                    console.log('---获取工种列表---', res)
                    GLOBAL.typeArr = res
                    this.setState({}, () => {
                        this.props.navigation.navigate('Typeworker', {
                            name: '发布招工工种',
                            typeBz: this.state.zbz ? true : false,
                            callback: (() => {
                                this.setState({})
                            })
                        })
                    })
                }
            });
        }
    }
    // 选择工程类别
    projectFun() {
        if (GLOBAL.projectArr && GLOBAL.projectArr.length > 0) {
            this.props.navigation.navigate('Typeproject', {
                name: '发布招工工程类别',
                callback: (() => {
                    this.setState({})
                })
            })
        } else {
            fetchFun.load({
                url: 'jlcfg/classlist',
                data: {
                    class_id: 2,//1:工种 2：项目类型3：熟练度 31：福利 40：举报信息类型
                    kind: 'recruit'
                },
                success: (res) => {
                    console.log('---获取工程类别---', res)
                    GLOBAL.projectArr = res
                    this.setState({}, () => {
                        this.props.navigation.navigate('Typeproject', {
                            name: '发布招工工程类别',
                            callback: (() => {
                                this.setState({})
                            })
                        })
                    })
                }
            });
        }
    }
    // 选择项目所在地
    addressFun() {
        if (GLOBAL.AddressOne && GLOBAL.AddressOne.length > 0) {
            this.props.navigation.navigate('Address', {
                name: '发布招工项目所在地',
                callback: (() => {
                    this.setState({})
                })
            })
        } else {
            fetchFun.load({
                url: 'jlcfg/cities',
                data: {
                    level: '1',//城市级别 1：省 2 市 3县
                    citycode: '0',//城市编码
                    kind: 'recruit'
                },
                success: (res) => {
                    console.log('---获取城市列表-省---', res)
                    GLOBAL.AddressOne = res
                    this.setState({}, () => {
                        this.props.navigation.navigate('Address', {
                            name: '发布招工项目所在地',
                            callback: (() => {
                                this.setState({})
                            })
                        })
                    })
                }
            });
        }
    }
    zgrFun() {
        if (GLOBAL.fbzgType.fbzgTypeName == '总包') {
            GLOBAL.fbzgType.fbzgTypeName = '选择工种'
        }
        this.setState({
            zgr: true,
            zbz: false,
            ztjd: false,
            update:true,
        })
    }
    zbzFun() {
        this.setState({
            zgr: false,
            zbz: true,
            ztjd: false,
            update:true,
        })
    }
    ztjdFun() {
        if (GLOBAL.fbzgType.fbzgTypeName == '总包') {
            GLOBAL.fbzgType.fbzgTypeName = '选择工种'
        }
        this.setState({
            zgr: false,
            zbz: false,
            ztjd: true,
            update:true,
        })
    }
    // 其他工种输入
    fbzgTypeNameOtherFun(e) {
        this.setState({
            fbzgTypeNameOther: e
        })
    }
    // 其他工程输入
    fbzgProjectNameOtherFun(e) {
        this.setState({
            fbzgProjectNameOther: e
        })
    }
    // 下一步按钮
    btn() {
        let reg = /^[\u0391-\uFFE5]+$/;
        if (GLOBAL.fbzgType.fbzgTypeName == '选择工种') {
            this.setState({
                openAlert: !this.state.openAlert
            }, () => {
                setTimeout(() => {
                    this.setState({
                        openAlert: false
                    })
                }, 2000)
            })
        } else if (GLOBAL.fbzgProject.fbzgProjectName == '选择工程类别') {
            this.setState({
                warning: '请选择工程类别',
                openAlert: !this.state.openAlert,
            }, () => {
                setTimeout(() => {
                    this.setState({
                        openAlert: false
                    })
                }, 2000)
            })
        } else if (GLOBAL.fbzgAddress.fbzgAddressOneName == '选择城市') {
            this.setState({
                warning: '请选择项目所在地',
                openAlert: !this.state.openAlert,
            }, () => {
                setTimeout(() => {
                    this.setState({
                        openAlert: false
                    })
                }, 2000)
            })
        } else if (GLOBAL.fbzgType.fbzgTypeName == '其它工种' && !reg.test(this.state.fbzgTypeNameOther)) {
            if (this.state.fbzgTypeNameOther == '') {
                this.setState({
                    warning: '请输入其他工种的名称',
                    openAlert: !this.state.openAlert,
                }, () => {
                    setTimeout(() => {
                        this.setState({
                            openAlert: false
                        })
                    }, 2000)
                })
            } else {
                this.setState({
                    warning: '工种名称只能是中文文字',
                    openAlert: !this.state.openAlert,
                }, () => {
                    setTimeout(() => {
                        this.setState({
                            openAlert: false
                        })
                    }, 2000)
                })
            }
        } else if (GLOBAL.fbzgProject.fbzgProjectName == '其它' && !reg.test(this.state.fbzgProjectNameOther)) {
            if (this.state.fbzgProjectNameOther == '') {
                this.setState({
                    warning: '请输入其他工程类别的名称',
                    openAlert: !this.state.openAlert,
                }, () => {
                    setTimeout(() => {
                        this.setState({
                            openAlert: false
                        })
                    }, 2000)
                })
            } else {
                this.setState({
                    warning: '工程类别名称只能是中文文字',
                    openAlert: !this.state.openAlert,
                }, () => {
                    setTimeout(() => {
                        this.setState({
                            openAlert: false
                        })
                    }, 2000)
                })
            }
        } else {
            let type
            if (this.state.zgr) {
                type = '招工人'
            } else if (this.state.zbz) {
                type = '招班组'
            } else if (this.state.ztjd) {
                type = '招突击队'
            }
            GLOBAL.fbzgAddress.detailAddress = '请选择所在地'
            this.setState({})
            if (this.props.navigation.getParam('name') == 'lookingworker') {
                GLOBAL.fbzgType.fbzgTypeName = GLOBAL.zgrType.zgrTypeName
                GLOBAL.fbzgType.fbzgTypeNum = GLOBAL.zgrType.zgrTypeNum
                this.setState({
                }, () => {
                    this.props.navigation.navigate('Myrecruit_detail', {
                        type: type,
                        fbzgTypeName: GLOBAL.fbzgType.fbzgTypeName,
                        fbzgProjectName: GLOBAL.fbzgProject.fbzgProjectName,
                        fbzgAddressOneName: GLOBAL.fbzgAddress.fbzgAddressOneName,
                        fbzgAddressTwoName: GLOBAL.fbzgAddress.fbzgAddressTwoName,
                        fbzgTypeNameOther: this.state.fbzgTypeNameOther,
                        fbzgProjectNameOther: this.state.fbzgProjectNameOther,
                        name: 'lookingworker'
                    })
                })
            } else {
                this.props.navigation.navigate('Myrecruit_detail', {
                    type: type,
                    fbzgTypeName: GLOBAL.fbzgType.fbzgTypeName,
                    fbzgProjectName: GLOBAL.fbzgProject.fbzgProjectName,
                    fbzgAddressOneName: GLOBAL.fbzgAddress.fbzgAddressOneName,
                    fbzgAddressTwoName: GLOBAL.fbzgAddress.fbzgAddressTwoName,
                    fbzgTypeNameOther: this.state.fbzgTypeNameOther,
                    fbzgProjectNameOther: this.state.fbzgProjectNameOther
                })
            }
        }
    }
    // 返回
    gobackFun() {
        GLOBAL.fbzgType.fbzgTypeName = '选择工种'
        GLOBAL.fbzgProject.fbzgProjectName = '选择工程类别'
        this.setState({})
        if (this.props.navigation.getParam('name')) {//从找工人列表进入，只是返回
            this.props.navigation.goBack()
        } else {
            this.props.navigation.goBack(),//从首页进入，返回并且显示底部导航
                DeviceEventEmitter.emit("EventType", param)
        }
    }
}