/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 14:58:26 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-05-17 19:00
 * Module:找活招工首页new
 */
import React, { Component } from 'react'
import * as _ from 'lodash';

import {
    StyleSheet, Text, View, TouchableOpacity, Image, Animated,
    LayoutAnimation, AsyncStorage, NativeModules,
    DeviceEventEmitter, Platform, NativeEventEmitter,
    ActivityIndicator
} from 'react-native';
import Address from '../../component/selectaddress'
import Typeselects from '../../component/typeselects'
import Emloyselects from '../../component/emloyselects'
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../component/listitem'
import Empty from '../../component/listempty'
import Header from '../../component/listheader'
import Footer from '../../component/listfooter'
import fetchFun from '../../fetch/fetch'
import Geolocation from 'Geolocation';
import AlertUser from '../../component/alertuser'
import { getFlatternDistance } from '../../utils/distance'
import LinearGradient from 'react-native-linear-gradient';
import Rolealert from '../../component/rolealert'
import Thelabel from '../../component/thelabel'
import Information from '../../component/information'
import { openWebView } from '../../utils'

export default class counter extends Component {
    constructor(props) {
        super(props)
        this.state = {
            selectsAddress: false,//address,type,works
            selectsType: false,
            selectsEmloy: false,//用工类型
            selectsVerified: false,//是否筛选实名信息


            moveValue: new Animated.Value(1),
            moveValueMenu: new Animated.Value(1),
            marginBottom: 0,

            // ----------实名or认证、突击弹框----------
            ifOpenAlert: false,//是否打开弹框
            param: '',//实名or认证、突击
            // ---------------------------------------

            isGetUserinfo: false,//是否已经获取到个人信息
            orbottomalert: false,//角色认证选择弹框

            pgnum: 1,//页数-控制是否显示回到顶部按钮

            resume_perfectness: 0,//资料完善度

            showFbzgBtn:false,//是否显示发布招工按钮
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    render() {
        console.log(this.state.resume_perfectness)
        let { moveValue, moveValueMenu } = this.state
        return (
            <View style={styles.containermain}>
                {/* <Text>{GLOBAL.userinfo.resume_perfectness}</Text> */}
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    zIndex: 1000,
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }
                }>
                    <View style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, width: '25%' }} >
                    </View>
                    < View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', marginRight: 3 }}>找活招工</Text>
                        <TouchableOpacity activeOpacity={.7} onPress={() => this.props.navigation.navigate('Recruit_doubt')}>
                            <Icon name="question-circle" size={19} color="#999999" />
                        </TouchableOpacity>
                    </View>
                    <TouchableOpacity activeOpacity={.7} style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}
                        onPress={() => this.props.navigation.navigate('Recruit_cheat')}>
                        <Text style={{ color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>防骗指南</Text>
                    </TouchableOpacity>
                </View>

                {/* 菜单 */}
                <Animated.View                 // 使用专门的可动画化的View组件
                    style={
                        {
                            bottom: moveValueMenu.interpolate({
                                inputRange: [0, 1],
                                outputRange: [150, 0]
                            }),
                            height: moveValueMenu.interpolate({
                                inputRange: [0, 1],
                                outputRange: [0, 115]
                            }),
                            position: 'relative',
                        }
                    }
                >
                    <View style={
                        {
                            backgroundColor: 'white',
                            paddingBottom: 15,
                            // marginBottom: 10,
                            // height: 104,
                        }
                    } >
                        <View style={styles.bot}>
                            <TouchableOpacity activeOpacity={.7}
                                style={styles.munuss}
                                onPress={() => {
                                    this.props.navigation.navigate('Lookingworker'), this.setState({
                                        selectsAddress: false,
                                        selectsType: false,
                                        selectsEmloy: false,
                                    })
                                }}>
                                <View style={{ flexDirection: "row", justifyContent: 'center' }}>
                                    <Image style={styles.menuimg} source={{ uri: `${GLOBAL.server}public/imgs/4.0.2/zgr@2x.png` }}></Image>
                                </View>
                                <View style={{ flexDirection: "row", justifyContent: 'center' }}>
                                    < Text style={styles.menufont} >找工人</Text>
                                </View>
                            </TouchableOpacity>
                            <TouchableOpacity activeOpacity={.7}
                                onPress={() => {
                                    this.props.navigation.navigate('Workteam'), this.setState({
                                        selectsAddress: false,
                                        selectsType: false,
                                        selectsEmloy: false,
                                    })
                                }}
                                style={styles.munuss} >
                                <View style={{ flexDirection: "row", justifyContent: 'center' }}>
                                    <Image style={styles.menuimg} source={{ uri: `${GLOBAL.server}public/imgs/4.0.2/yz@2x.png` }}></Image>

                                </View>
                                <View style={{ flexDirection: "row", justifyContent: 'center' }}>
                                    < Text style={styles.menufont} >工人/班组</Text>
                                </View>
                            </TouchableOpacity>
                            <TouchableOpacity activeOpacity={.7}
                                onPress={() => {
                                    this.props.navigation.navigate('Recruit_play'), this.setState({
                                        selectsAddress: false,
                                        selectsType: false,
                                        selectsEmloy: false,
                                    })
                                }}
                                style={styles.munuss} >
                                <View style={{ flexDirection: "row", justifyContent: 'center' }}>
                                    <Image style={styles.menuimg} source={{ uri: `${GLOBAL.server}public/imgs/4.0.2/job@2x.png` }}></Image>

                                </View>
                                <View style={{ flexDirection: "row", justifyContent: 'center' }}>
                                    < Text style={styles.menufont} >招聘服务</Text>
                                </View>
                            </TouchableOpacity>
                            <TouchableOpacity activeOpacity={.7}
                                style={styles.munuss}
                                onPress={() => {
                                    this.props.navigation.navigate('Myhistory'), this.setState({
                                        selectsAddress: false,
                                        selectsType: false,
                                        selectsEmloy: false,
                                    })
                                }}>
                                <View style={{ flexDirection: "row", justifyContent: 'center' }}>
                                    <Image style={styles.menuimg} source={{ uri: `${GLOBAL.server}public/imgs/4.0.2/myjob@2x.png` }}></Image>
                                </View>
                                <View style={{ flexDirection: "row", justifyContent: 'center' }}>
                                    < Text style={styles.menufont} >我的招聘</Text>
                                </View>
                            </TouchableOpacity>
                        </View>
                    </View>
                </Animated.View>
                {/* 轻松找活、立即认证 */}
                {
                    this.state.resume_perfectness <= 70 ? (
                        <TouchableOpacity activeOpacity={.7}
                            onPress={() => this.tomycard(GLOBAL.mycard)}
                            style={{
                                backgroundColor: '#FDF1E0', height: 40, width: '100%', paddingLeft: 20, paddingRight: 20,
                                flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                            }}>
                            <Text style={{ fontSize: 13, color: '#FF6600', lineHeight: 21, fontWeight: '400' }}>完善个人名片，先人一步找到工作。</Text>
                            <View style={{ flexDirection: "row", alignItems: "center" }}>
                                <Text style={{ fontSize: 13, color: '#FF6600', lineHeight: 21, fontWeight: '400' }}>立即完善</Text>
                                <Icon name="r-arrow" size={13} color="#FF6600" />
                            </View>
                        </TouchableOpacity>
                    ) : (
                            // 只填了工人信息
                            (GLOBAL.userinfo.worker_info.worktype && GLOBAL.userinfo.worker_info.worktype.length > 0) && (GLOBAL.userinfo.foreman_info.worktype && GLOBAL.userinfo.foreman_info.worktype.length == 0) ? (
                                // 工人未认证
                                GLOBAL.userinfo.verified_arr.worker == 0 ? (
                                    <TouchableOpacity activeOpacity={.7}
                                        onPress={() => {
                                            openWebView('my/attest?role=1')
                                            // this.props.navigation.navigate('Recruit_authen', {
                                            //     type: '1', callback: (() => {
                                            //         this.bottomTab()
                                            //     })
                                            // })
                                            this.setState({
                                                selectsAddress: false,
                                                selectsType: false,
                                                selectsEmloy: false,
                                            })
                                        }}
                                        style={{
                                            backgroundColor: '#FDF1E0', height: 40, width: '100%', paddingLeft: 20, paddingRight: 20,
                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                        }}>
                                        <Text style={{ fontSize: 13, color: '#FF6600', lineHeight: 21, fontWeight: '400' }}>完成认证，找活招人快人一步。</Text>
                                        <View style={{ flexDirection: "row", alignItems: "center" }}>
                                            <Text style={{ fontSize: 13, color: '#FF6600', lineHeight: 21, fontWeight: '400' }}>立即认证</Text>
                                            <Icon name="r-arrow" size={13} color="#FF6600" />
                                        </View>
                                    </TouchableOpacity>
                                ) : false
                            ) : (
                                    // 只填了班组信息
                                    (GLOBAL.userinfo.worker_info.worktype && GLOBAL.userinfo.worker_info.worktype.length == 0) && (GLOBAL.userinfo.foreman_info.worktype && GLOBAL.userinfo.foreman_info.worktype.length > 0) ? (
                                        // 班组未认证
                                        GLOBAL.userinfo.verified_arr.foreman == 0 ? (
                                            <TouchableOpacity activeOpacity={.7}
                                                onPress={() => {
                                                    openWebView('my/attest?role=2')
                                                    // this.props.navigation.navigate('Recruit_authen', {
                                                    //     type: '2', callback: (() => {
                                                    //         this.bottomTab()
                                                    //     })
                                                    // })
                                                    this.setState({
                                                        selectsAddress: false,
                                                        selectsType: false,
                                                        selectsEmloy: false,
                                                    })
                                                }}
                                                style={{
                                                    backgroundColor: '#FDF1E0', height: 40, width: '100%', paddingLeft: 20, paddingRight: 20,
                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                }}>
                                                <Text style={{ fontSize: 13, color: '#FF6600', lineHeight: 21, fontWeight: '400' }}>完成认证，找活招人快人一步。</Text>
                                                <View style={{ flexDirection: "row", alignItems: "center" }}>
                                                    <Text style={{ fontSize: 13, color: '#FF6600', lineHeight: 21, fontWeight: '400' }}>立即认证</Text>
                                                    <Icon name="r-arrow" size={13} color="#FF6600" />
                                                </View>
                                            </TouchableOpacity>
                                        ) : false
                                    ) : (
                                            //工人信息和班组信息都已填写
                                            (GLOBAL.userinfo.worker_info.worktype && GLOBAL.userinfo.worker_info.worktype.length > 0) && (GLOBAL.userinfo.foreman_info.worktype && GLOBAL.userinfo.foreman_info.worktype.length > 0) ? (
                                                // 工人未认证
                                                GLOBAL.userinfo.verified_arr.foreman == 1 && GLOBAL.userinfo.verified_arr.worker == 0 ? (
                                                    <TouchableOpacity activeOpacity={.7}
                                                        onPress={() => {
                                                            openWebView('my/attest?role=1')
                                                            // this.props.navigation.navigate('Recruit_authen', {
                                                            //     type: '1', callback: (() => {
                                                            //         this.bottomTab()
                                                            //     })
                                                            // })
                                                            this.setState({
                                                                selectsAddress: false,
                                                                selectsType: false,
                                                                selectsEmloy: false,
                                                            })
                                                        }}
                                                        style={{
                                                            backgroundColor: '#FDF1E0', height: 40, width: '100%', paddingLeft: 20, paddingRight: 20,
                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                        }}>
                                                        <Text style={{ fontSize: 13, color: '#FF6600', lineHeight: 21, fontWeight: '400' }}>完成认证，找活招人快人一步。</Text>
                                                        <View style={{ flexDirection: "row", alignItems: "center" }}>
                                                            <Text style={{ fontSize: 13, color: '#FF6600', lineHeight: 21, fontWeight: '400' }}>立即认证</Text>
                                                            <Icon name="r-arrow" size={13} color="#FF6600" />
                                                        </View>
                                                    </TouchableOpacity>
                                                ) : (
                                                        // 班组未认证
                                                        GLOBAL.userinfo.verified_arr.foreman == 0 && GLOBAL.userinfo.verified_arr.worker == 1 ? (
                                                            <TouchableOpacity activeOpacity={.7}
                                                                onPress={() => {
                                                                    openWebView('my/attest?role=2')
                                                                    // this.props.navigation.navigate('Recruit_authen', {
                                                                    //     type: '2', callback: (() => {
                                                                    //         this.bottomTab()
                                                                    //     })
                                                                    // })
                                                                    this.setState({
                                                                        selectsAddress: false,
                                                                        selectsType: false,
                                                                        selectsEmloy: false,
                                                                    })
                                                                }}
                                                                style={{
                                                                    backgroundColor: '#FDF1E0', height: 40, width: '100%', paddingLeft: 20, paddingRight: 20,
                                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                                }}>
                                                                <Text style={{ fontSize: 13, color: '#FF6600', lineHeight: 21, fontWeight: '400' }}>完成认证，找活招人快人一步。</Text>
                                                                <View style={{ flexDirection: "row", alignItems: "center" }}>
                                                                    <Text style={{ fontSize: 13, color: '#FF6600', lineHeight: 21, fontWeight: '400' }}>立即认证</Text>
                                                                    <Icon name="r-arrow" size={13} color="#FF6600" />
                                                                </View>
                                                            </TouchableOpacity>
                                                        ) : (
                                                                // 都未认证，手动选择认证选项
                                                                GLOBAL.userinfo.verified_arr.foreman == 0 && GLOBAL.userinfo.verified_arr.worker == 0 ? (
                                                                    <TouchableOpacity activeOpacity={.7}
                                                                        onPress={() => this.toauthenSelect()}
                                                                        style={{
                                                                            backgroundColor: '#FDF1E0', height: 40, width: '100%', paddingLeft: 20, paddingRight: 20,
                                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                                                        }}>
                                                                        <Text style={{ fontSize: 13, color: '#FF6600', lineHeight: 21, fontWeight: '400' }}>完成认证，找活招人快人一步。</Text>
                                                                        <View style={{ flexDirection: "row", alignItems: "center" }}>
                                                                            <Text style={{ fontSize: 13, color: '#FF6600', lineHeight: 21, fontWeight: '400' }}>立即认证</Text>
                                                                            <Icon name="r-arrow" size={13} color="#FF6600" />
                                                                        </View>
                                                                    </TouchableOpacity>
                                                                ) : false
                                                            )
                                                    )
                                            ) : false
                                        )
                                )
                        )
                }

                {/* 选择栏 */}
                <View style={{ marginBottom: -.5, backgroundColor: '#fafafa', borderTopColor: '#dbdbdb', borderTopWidth: 1, height: 44, width: '100%', flexDirection: 'row', zIndex: 1000 }}>
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => { this.addressfun() }}
                        style={{ width: '25%', borderRightColor: '#dbdbdb', borderRightWidth: 1, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', backgroundColor: this.state.selects == 'address' ? 'white' : '#fafafa', borderBottomColor: '#dbdbdb', borderBottomWidth: this.state.selects == 'address' ? 0 : 1, }}>
                        <Text style={{ color: '#000000', fontSize: 13, marginRight: 3 }}>{GLOBAL.zgzAddress.zgzAddressTwoName.length > 4 ? GLOBAL.zgzAddress.zgzAddressTwoName.substr(0, 4) + '...' : GLOBAL.zgzAddress.zgzAddressTwoName}</Text>
                        {
                            !this.state.selectsAddress ? (
                                <Icon style={{ transform: [{ rotate: '180deg' }] }
                                } name="rd-arrow" size={13} color="#333333" />
                            ) : (
                                    <Icon name="rd-arrow" size={13} color="#333333" />
                                )
                        }
                    </TouchableOpacity>
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.typefun()}
                        style={{ width: '25%', borderRightColor: '#dbdbdb', borderRightWidth: 1, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', backgroundColor: this.state.selects == 'type' ? 'white' : '#fafafa', borderBottomColor: '#dbdbdb', borderBottomWidth: this.state.selects == 'type' ? 0 : 1 }}>
                        <Text style={{ color: '#000000', fontSize: 13, marginRight: 3 }}>{GLOBAL.zgzType.zgzTypeName.length > 4 ? GLOBAL.zgzType.zgzTypeName.substr(0, 4) + '...' : GLOBAL.zgzType.zgzTypeName}</Text>
                        {
                            !this.state.selectsType ? (
                                <Icon style={{ transform: [{ rotate: '180deg' }] }
                                } name="rd-arrow" size={13} color="#333333" />
                            ) : (
                                    <Icon name="rd-arrow" size={13} color="#333333" />
                                )
                        }
                    </TouchableOpacity>
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.employfun()}
                        style={{ width: '25%', borderRightColor: '#dbdbdb', borderRightWidth: 1, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', backgroundColor: this.state.selects == 'type' ? 'white' : '#fafafa', borderBottomColor: '#dbdbdb', borderBottomWidth: this.state.selects == 'type' ? 0 : 1 }}>
                        <Text style={{ color: '#000000', fontSize: 13, marginRight: 3 }}>{GLOBAL.zgzEmploy.zgzEmployName.length > 4 ? GLOBAL.zgzEmploy.zgzEmployName.substr(0, 4) + '...' : GLOBAL.zgzEmploy.zgzEmployName}</Text>
                        {
                            !this.state.selectsEmloy ? (
                                <Icon style={{ transform: [{ rotate: '180deg' }] }
                                } name="rd-arrow" size={13} color="#333333" />
                            ) : (
                                    <Icon name="rd-arrow" size={13} color="#333333" />
                                )
                        }
                    </TouchableOpacity>
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => { this.verifiedFun() }}
                        style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, backgroundColor: '#fafafa', borderBottomColor: '#dbdbdb', borderBottomWidth: 1 }}>
                        {
                            this.state.selectsVerified ? (
                                <Icon style={{ marginRight: 3 }} name="success" size={14} color="#eb4e4e" />
                            ) : (
                                    <Image style={{ width: 13, height: 13, marginRight: 3 }} source={require('../../assets/recruit/yuan.png')} ></Image>
                                )
                        }
                        <Text style={{ color: '#000000', fontSize: 13, marginRight: 3 }}>只看实名</Text>
                    </TouchableOpacity>
                </View>
                {
                    this.state.selectsAddress ? (
                        <Address
                            national='全国'
                            offAddress={this.offAddress.bind(this)}
                            addressType='找工作' />
                    ) : (
                            this.state.selectsType ? (
                                <Typeselects
                                    offType={this.offType.bind(this)}
                                    addressType='找工作'
                                />
                            ) : (
                                    this.state.selectsEmloy ? (
                                        <Emloyselects
                                            offEmploy={this.offEmploy.bind(this)}
                                        />
                                    ) : (
                                            GLOBAL.userinfo.token ? (
                                                <List
                                                    fixedsupdateT={this.fixedsupdateT.bind(this)}
                                                    toStart={this.toStart.bind(this)}
                                                    pgnumFun={() => this.pgnumFun()}
                                                    pgnumFunOff={() => this.pgnumFunOff()}
                                                    _getRef={this._getRef}
                                                    ref='ListComponent'
                                                    navigation={this.props.navigation}
                                                    selectsVerified={this.state.selectsVerified}
                                                    fixedsupdateF={this.fixedsupdateF.bind(this)}
                                                    fixedsupdateT={this.fixedsupdateT.bind(this)}
                                                    alertFun={this.alertFun.bind(this)}
                                                    isGetUserinfo={this.state.isGetUserinfo}
                                                    _onScroll={this._onScroll.bind(this)}
                                                    fixedsupdateTMenu={this.fixedsupdateTMenu.bind(this)}
                                                    showFbzgBtnFun={this.showFbzgBtnFun.bind(this)}//显示发布招工按钮
                                                />
                                            ) : false
                                        )
                                )
                        )
                }


                {/* 发布招工按钮 */}
                <Animated.View                 // 使用专门的可动画化的View组件
                    style={
                        {
                            bottom: moveValue.interpolate({
                                inputRange: [0, 1],
                                outputRange: [0, 70]
                            }),
                        }
                    }
                >
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.tofbzgjob()}
                        style={{
                            position: 'absolute', marginLeft: -65,
                        }}
                    >
                    {
                        this.state.showFbzgBtn?(
                            <View
                                style={
                                    {
                                        backgroundColor: '#ec5e5e', flexDirection: 'row', alignItems: 'center',
                                        justifyContent: "center", borderRadius: 176.6, width: 130, height: 45,
                                        // 设置阴影
                                        elevation: 3,
                                        shadowOffset: { height: 3 },
                                        shadowColor: 'black',
                                        shadowOpacity: 0.2,
                                        shadowRadius: 2
                                    }
                                }>
                                <Icon style={{ marginLeft: 5 }} name="plus" size={15} color="#fff" />
                                <Text style={{ fontSize: 15, color: '#fff', marginLeft: 10 }}>发布招工</Text>
                            </View>
                        ):false
                    }
                    </TouchableOpacity>
                </Animated.View>
                <Animated.View                 // 使用专门的可动画化的View组件
                    style={
                        {
                            bottom: moveValue.interpolate({
                                inputRange: [0, 1],
                                outputRange: [70, 0]
                            }),
                        }
                    }
                >
                    {
                        this.state.pgnum != 1 ? (
                            <TouchableOpacity activeOpacity={.7} style={{
                                position: 'absolute',
                                right: -170,
                            }}
                                activeOpacity={1}
                                onPress={() => this.toStart()}>
                                <View
                                    style={{
                                        width: 45, height: 45, borderRadius: 45, backgroundColor: '#fff',
                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                        // 设置阴影
                                        // elevation: 3,
                                        // shadowOffset: { width: 3, height: 3 },
                                        // shadowColor: 'black',
                                        // shadowOpacity: 1,
                                        // shadowRadius: 2,
                                        borderWidth: 1,
                                        borderColor: '#dbdbdb',
                                    }}
                                >
                                    <Icon name="totop" size={30} color="#666" />
                                </View>
                            </TouchableOpacity>
                        ) : false
                    }
                </Animated.View>

                {/* 认证角色选择 */}
                <Rolealert orbottomalert={this.state.orbottomalert} selectwork={this.selectwork.bind(this)} closeModal={this.closeModal.bind(this)} />

                {/* 弹框 */}
                <AlertUser
                    gows={this.gows.bind(this)}
                    ifOpenAlert={this.state.ifOpenAlert}
                    alertFunr={this.alertFunr.bind(this)}
                    param={this.state.param}
                />
            </View>
        );
    }
    // 获取到list数据，显示发布招工按钮
    showFbzgBtnFun(){
        this.setState({
            showFbzgBtn:true
        })
    }
    _onScroll(e) {
        // console.log(e.nativeEvent.contentOffset.y)
        if (e.nativeEvent.contentOffset.y == 0) {//到顶
            GLOBAL.scrollheightDefault = e.nativeEvent.contentOffset.y
            this.fixedsupdateTMenu()
        }
    }
    // 列表回到第一行的ref设置
    _getRef = (flatList) => {
        this._flatList = flatList; const reObj = this._flatList; return reObj;
    }
    // 回到第一行事件
    toStart() {
        this._flatList.scrollToIndex({ viewPosition: 0, index: 0 });
        this.fixedsupdateT()//发布招工按钮显示
        this.setState({
            pgnum: 1,//回到顶部按钮消失
        })
    }

    pgnumFun() {
        this.setState({
            pgnum: 2//已经翻页操作
        })
    }
    pgnumFunOff() {
        this.setState({
            pgnum: 1
        })
    }

    componentDidMount() {
        // 底部导航控制
        this.bottomTab()
        this.offDid = DeviceEventEmitter.addListener("offDid", (param) => {
            GLOBAL.jogShowDid = false
            // this.setState({})
        });
        GLOBAL.jogShowDid = true//招工找活页面加载痕迹
        this.callbackComm()

        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            GLOBAL.userinfo.os = 'A'
            // 切换导航后关闭筛选框
            this.offSelectUn = DeviceEventEmitter.addListener("offSelect", (param) => {
                this.offSelect()
            });
            NativeModules.MyNativeModule.closeDialog('close');
            // 完善资料后android调用RN方法，刷新NR页面
            this.refreshRNUn = DeviceEventEmitter.addListener("refreshRN", (param) => {
                if (GLOBAL.jogShowDid) {//加载过招工找活页面才执行下面代码
                    // 刷新界面等
                    this.refreshRN(param)
                }
            });
        } else {
            GLOBAL.userinfo.os = 'I'
            const bridge = new NativeEventEmitter(NativeModules.JGJNativeEventEmitter);
            bridge.addListener('offSelect', () => {
                this.offSelect()
            });
            // 完善资料后ios调用RN方法，刷新NR页面
            bridge.addListener('refreshRN', (param) => {
                if (GLOBAL.jogShowDid) {//加载过招工找活页面才执行下面代码
                    // 刷新界面等
                    this.refreshRN(param)
                }
            });
        }
        this.EventTypeUn = DeviceEventEmitter.addListener("EventType", (param) => {
            // 底部导航控制
            this.bottomTab()
        })
        this.EventTypeAlertUn = DeviceEventEmitter.addListener("EventTypeAlert", (param) => {
            // 底部导航控制
            this.bottomTab()            // 认证弹窗控制
            this.openAlert()
        })
        // 工人认证、班组长认证、突击队认证情况
        // this.authFun()
    }
    //卸载监听器
    componentWillUnmount() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            this.offDidUn.remove()
            this.offSelectUn.remove()
            this.EventTypeAlertUn.remove()
            this.refreshRNUn.remove()
        }
    }
    // 用户认证情况v2/project/getAllBuyService
    authFun() {
        fetchFun.load({
            url: 'v2/project/getAllBuyService',
            noLoading: true,//不显示自定义加载框
            data: {
            },
            success: (res) => {
                // console.log('---用户认证情况---', res)
            }
        });
    }

    refreshRN(param) {
        if (param !== {} && !param == '') {
            console.log('Home版本号：----------------', GLOBAL.infoverHome, JSON.parse(param).infover)
            // if (GLOBAL.infoverHome != JSON.parse(param).infover) {//刷新版本号不等-刷新操作
            GLOBAL.infoverHome = JSON.parse(param).infover//刷新版本号更新
            // console.log('homepage更新=================')
            let msg = ''
            if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端

                NativeModules.MyNativeModule.getAppToken(msg, (result) => {
                    // ToastAndroid.show("CallBack收到消息:" + result, ToastAndroid.SHORT);
                    // 根据原生传过来的token获取用户信息存储到config
                    GLOBAL.userinfo.token = result.replace("A ", "");
                    if (result) {
                        this.getuserinfo()
                        // 我的页面接口
                        this.myzone()
                        // 个人名片信息
                        this.mycard()
                        // this.setState({}, () => {
                        // })
                    }
                    // console.log(result)
                })
            }
            if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
                NativeModules.JGJRecruitmentController.getAppToken(msg, (result) => {
                    // console.log('recruit', result)
                    // ToastAndroid.show("CallBack收到消息:" + result, ToastAndroid.SHORT);
                    // 根据原生传过来的token获取用户信息存储到config
                    GLOBAL.userinfo.token = result.replace("A ", "");
                    // console.log(result)
                    if (result) {
                        this.setState({}, () => {
                            this.getuserinfo()
                            // 我的页面接口
                            this.myzone()
                            // 个人名片信息
                            this.mycard()
                        })
                    }
                })
            }
            // }
        }
    }
    openAlert() {
        this.setState({
            ifOpenAlert: true,
            param: 'fbzg'
        })
    }

    // RN调用Native且通过Callback回调 通信方式_获取token
    callbackComm() {
        let msg = ''
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端

            NativeModules.MyNativeModule.getAppToken(msg, (result) => {
                // ToastAndroid.show("CallBack收到消息:" + result, ToastAndroid.SHORT);
                // 根据原生传过来的token获取用户信息存储到config
                GLOBAL.userinfo.token = result.replace("A ", "");
                if (result) {
                    this.getuserinfo()
                    // 我的页面接口
                    this.myzone()
                    // 个人名片信息
                    this.mycard()
                }
                // console.log(result)
            })
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.getAppToken(msg, (result) => {
                // console.log('recruit', result)
                // ToastAndroid.show("CallBack收到消息:" + result, ToastAndroid.SHORT);
                // 根据原生传过来的token获取用户信息存储到config
                GLOBAL.userinfo.token = result.replace("A ", "");
                // console.log(result)
                if (result) {
                    this.setState({}, () => {
                        this.getuserinfo()
                        // 我的页面接口
                        this.myzone()
                        // 个人名片信息
                        this.mycard()
                    })
                }
            })
        }
    }
    // 获取用户信息存储到config
    getuserinfo() {
        // alert('重新获取用户数据')
        let token = GLOBAL.userinfo.token
        fetchFun.load({
            url: 'v2/signup/userstatus',
            noLoading: true,//不显示自定义加载框
            data: {
            },
            success: (res) => {
                // console.log('---用户信息---', res)
                GLOBAL.timeDifference = res.serverTime * 1000 - Date.parse(new Date())//获取服务器时间差
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
                    foreman: res.verified_arr.foreman,//工头认证情况
                    worker: res.verified_arr.worker//工人认证情况
                }
                this.setState({
                    isGetUserinfo: true,
                    resume_perfectness: res.resume_perfectness
                })
            }
        });
    }
    myzone() {
        fetchFun.load({
            url: 'jlwork/myzone',
            noLoading: true,//不显示自定义加载框
            data: {
                kind: 'recruit'
            },
            success: (res) => {
                // console.log('---我的页面接口---', res)
                GLOBAL.userinfo.age = res.age
                GLOBAL.userinfo.birth = res.birth
                GLOBAL.userinfo.gender = res.gender
                GLOBAL.userinfo.headpic = res.headpic//用户头像图片路径
                GLOBAL.userinfo.hometown = res.hometown
                GLOBAL.userinfo.icno = res.icno//身份证号
                GLOBAL.userinfo.is_info = res.is_info
                GLOBAL.userinfo.nationality = res.nationality
                GLOBAL.userinfo.nickname = res.nickname
                GLOBAL.userinfo.partner_status = res.partner_status
                GLOBAL.userinfo.realname = res.realname//真实姓名
                GLOBAL.userinfo.reply_cnt = res.reply_cnt//收到的未读回复数
                // GLOBAL.userinfo.resume_perfectness = res.resume_perfectness//名片完善度
                GLOBAL.userinfo.signature = res.signature
                GLOBAL.userinfo.sys_message_cnt = res.sys_message_cnt//系统消息数量
                GLOBAL.userinfo.telph = res.telph//注册的电话号码
                GLOBAL.userinfo.user_name = res.user_name
                GLOBAL.userinfo.userlevel = res.userlevel//用户等级
                GLOBAL.userinfo.verified = res.verified//3已认证
                GLOBAL.userinfo.wkmatecount = res.wkmatecount
                GLOBAL.userinfo.work_staus = res.work_staus//工作状态0：没工作1：工作中2：已经开工也在找工作
                // this.setState({
                // resume_perfectness:res.resume_perfectness
                // })
            }
        });
    }
    mycard() {
        fetchFun.load({
            url: 'v2/workday/getResumeInfo',
            noLoading: true,//不显示自定义加载框
            data: {
                role: GLOBAL.userinfo.role,
                kind: 'recruit'
            },
            success: (res) => {
                // console.log('---我的名片信息---', res)
                GLOBAL.userinfo.worker_info = res.worker_info//工人信息
                GLOBAL.userinfo.foreman_info = res.foreman_info//班组长信息
                GLOBAL.userinfo.telph = res.telephone//电话号码
                this.setState({})
            }
        });
    }
    bottomTab() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.footerController('{state:"show"}');//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.footerController({ state: "show" });//调用原生方法
        }
    }


    // ---------------城市------------------
    //选择地址菜单(获取城市列表)
    addressfun() {
        if (this.state.selectsAddress) {//已打开状态
            this.fixedsupdateT()//出现
            this.setState({
                selectsAddress: false
            })
        } else {
            this.fixedsupdateF()//隐藏
            let _this = this
            if (GLOBAL.AddressOne && GLOBAL.AddressOne.length > 0) {//省已缓存
                this.setState({
                    selectsAddress: true,
                    selectsType: false,
                    selectsEmloy: false
                })
            } else {
                fetchFun.load({
                    url: 'jlcfg/cities',
                    noLoading: true,//不显示自定义加载框
                    data: {
                        level: '1',//城市级别 1：省 2 市 3县
                        citycode: '0',//城市编码
                        os: GLOBAL.os,
                        token: GLOBAL.userinfo.token,
                        ver: GLOBAL.ver,
                        kind: 'recruit'
                    },
                    success: (res) => {
                        // console.log('---获取城市列表-省---', res)
                        this.setState({
                            selectsAddress: true,
                            selectsType: false,
                            selectsEmloy: false
                        }, () => {
                            GLOBAL.AddressOne = res
                            this.setState({})
                        })
                    }
                });
            }
        }
    }
    //关闭城市组件
    offAddress() {
        this.setState({
            selectsAddress: false,
        })
    }

    // -------------用工类型---------------
    employfun() {
        if (this.state.selectsEmloy) {//已打开状态
            this.fixedsupdateT()//出现
            this.setState({
                selectsEmloy: false
            })
        } else {
            this.fixedsupdateF()//隐藏
            this.setState({
                selectsAddress: false,
                selectsType: false,
                selectsEmloy: true,
            })
        }
    }

    // ---------------工种-----------------
    // 选择工种菜单(获取工种列表)
    typefun() {
        if (this.state.selectsType) {//已打开状态
            this.fixedsupdateT()//出现
            this.setState({
                selectsType: false
            })
        } else {
            this.fixedsupdateF()//隐藏
            if (GLOBAL.typeArr && GLOBAL.typeArr.length > 0) {//工种已缓存
                this.setState({
                    selectsType: true,
                    selectsAddress: false,
                    selectsEmloy: false,
                })
            } else {
                fetchFun.load({
                    url: 'jlcfg/classlist',
                    noLoading: true,//不显示自定义加载框
                    data: {
                        class_id: 1,//1:工种 2：项目类型3：熟练度 31：福利 40：举报信息类型
                        // os: GLOBAL.os,
                        // token: GLOBAL.userinfo.token,
                        // ver: GLOBAL.ver,
                        kind: 'recruit'
                    },
                    success: (res) => {
                        // console.log('---获取工种列表---', res)
                        this.setState({
                            selectsType: true,
                            selectsAddress: false,
                            selectsEmloy: false,
                        }, () => {
                            GLOBAL.typeArr = res
                            this.setState({})
                        })
                    }
                });
            }
        }
    }
    // 关闭工种组件
    offType() {
        this.setState({
            selectsType: false,
        })
    }
    // 关闭用工类型组件
    offEmploy() {
        this.setState({
            selectsEmloy: false,
        })
    }

    // ---------------实名-----------------
    // 选择是否实名信息
    verifiedFun() {
        this.setState({
            selectsVerified: !this.state.selectsVerified,
            selectsAddress: false,
            selectsType: false,
            selectsEmloy: false,
        }, () => {
            this.refs.ListComponent.deleteList(this.state.selectsVerified)//清空子组件list数据
        })
    }

    // 选择角色认证
    toauthenSelect() {
        this.setState({
            orbottomalert: !this.state.orbottomalert,
            selectsAddress: false,
            selectsType: false,
            selectsEmloy: false,
        })
    }
    selectwork(name) {
        if (name) {
            if (name == '工人认证') {
                this.props.navigation.navigate('Recruit_authen', {
                    type: '1', callback: (() => {
                        this.bottomTab()
                    })
                })
            } else {
                this.props.navigation.navigate('Recruit_authen', {
                    type: '2', callback: (() => {
                        this.bottomTab()
                    })
                })
            }
        }
        this.setState({
            orbottomalert: !this.state.orbottomalert
        })
    }
    closeModal() {
        this.setState({
            orbottomalert: !this.state.orbottomalert
        })
    }
    // 发布招工按钮
    tofbzgjob() {
        // 关闭筛选项
        this.setState({
            selectsAddress: false,
            selectsType: false,
            selectsEmloy: false,
        })
        // 先判断是否被挤掉账号
        fetchFun.load({
            url: 'v2/signup/userstatus',
            noLoading: true,//不显示自定义加载框
            data: {
            },
            success: (res) => {
                // 账号没有被挤掉
                if (res.uid && res.uid != 0) {
                    if (GLOBAL.userinfo.is_info == 0) {
                        this.setState({
                            ifOpenAlert: !this.state.ifOpenAlert,
                            param: 'wszl'
                        })
                    }
                    else {
                        this.props.navigation.navigate('Myrecruit')
                    }
                } else {// 账号被挤掉
                    if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
                        NativeModules.MyNativeModule.login();
                    }
                    if (Platform.OS == 'ios' && GLOBAL.client_type == 'person' && GLOBAL.newUrl.data.kind == 'my') {//android个人端
                        NativeModules.JGJMineViewController.login();
                    }
                    if (Platform.OS == 'ios' && GLOBAL.client_type == 'person' && GLOBAL.newUrl.data.kind == 'recruit') {//android个人端
                        NativeModules.JGJRecruitmentController.login();
                    }
                    if (Platform.OS == 'ios' && GLOBAL.client_type == 'person' && GLOBAL.newUrl.data.kind == 'find') {//android个人端
                        NativeModules.JGJDiscoveryController.login();
                    }
                }
            }
        });


    }
    // 跳转到完善资料页面
    gows() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openWebView('my/info?perfect=1');//调用原生方法
            this.setState({
                ifOpenAlert: !this.state.ifOpenAlert,
            })
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            NativeModules.JGJRecruitmentController.openWebView('my/info?perfect=1');//调用原生方法
            this.setState({
                ifOpenAlert: !this.state.ifOpenAlert,
            })
        }
    }
    // 立即完善个人名片
    tomycard(e) {
        this.setState({
            selectsAddress: false,
            selectsType: false,
            selectsEmloy: false,
        })
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openWebView(e);//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.openWebView(e);//调用原生方法
        }
    }
    // ----------实名or认证、突击弹框----------
    alertFun(e) {
        this.setState({
            ifOpenAlert: !this.state.ifOpenAlert,
            param: e,
        })
    }
    alertFunr() {
        this.setState({
            ifOpenAlert: false
        })
    }

    // --------------------------------------

    // 动画函数-隐藏
    fixedsupdateF() {
        Animated.timing(
            this.state.moveValue,  // 初始化从0开始
            {
                toValue: 0, // 目标值
                duration: 300,         // 时间间隔
            }
        ).start()
        Animated.timing(
            this.state.moveValueMenu,  // 初始化从0开始
            {
                toValue: 0, // 目标值
                duration: 300,         // 时间间隔
            }
        ).start()
    }
    // 显示
    fixedsupdateT() {
        Animated.timing(
            this.state.moveValue,  // 初始化从0开始
            {
                toValue: 1, // 目标值
                duration: 300,         // 时间间隔
            }
        ).start()
    }

    // 显示菜单
    fixedsupdateTMenu() {
        Animated.timing(
            this.state.moveValueMenu,  // 初始化从0开始
            {
                toValue: 1, // 目标值
                duration: 300,         // 时间间隔
            }
        ).start()
    }
    // 点击原生底部导航按钮，关闭城市、工种、类型筛选框
    offSelect() {
        this.setState({
            selectsAddress: false,
            selectsType: false,
            selectsEmloy: false,
        })
    }
}

// 工作列表数据
class List extends React.Component {
    constructor(props) {
        super(props)
        this.page = 1//当前页
        this.pagesize = 10
        this.isFresh = true
        this.first = true;
        this.state = {
            // 列表数据结构
            dataSource: [],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,


            ifFetchMore: false,
            ifLoadingMore: true,//是否显示加载更多加载框
            overList: false,//没有可以加载的数据

            pos: [],

            animating: true,// 初始设为显示加载动画

        }
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, { trailing: false });
    }
    componentWillReceiveProps(nextProps) {//父组件是否实名改变，这里重新获取列表数据
        this.setState({
            selectsVerified: nextProps.selectsVerified,
            isGetUserinfo: this.props.isGetUserinfo
        }, () => {
            if (nextProps.isGetUserinfo) {
            }
        })
    }
    componentDidMount() {
        // this.timeDiffer()//获取服务器时间差
        this.setState({
            navigate: this.props.navigation,//页面跳转需要
            isGetUserinfo: this.props.isGetUserinfo,
            selectsVerified: this.props.selectsVerified
        }, () => {
            console.log(GLOBAL.zgzAddress.zgzAddressTwoNum)
            if (GLOBAL.zgzAddress.zgzAddressTwoNum == '') {//没有获取过城市id
                console.log(GLOBAL.zgzAddress.zgzAddressTwoName)
                if (GLOBAL.zgzAddress.zgzAddressTwoName != '全国') {
                    console.log('---------getPosition')
                    this.getPosition();
                } else {
                    this.getList()
                }
            } else {
                this.getList()
            }

        })
        // if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
        //     GLOBAL.userinfo.os = 'A'
        //     // 切换导航后关闭筛选框
        //     this.offSelectUn = DeviceEventEmitter.addListener("getPlace", (result) => {
        //         if(result){
        //             this.setState({
        //                 pos: result ? result.split(',') : [0, 0]
        //             }, () => {
        //                 this.cityName()
        //             })
        //         }else {
        //             this.getList()
        //         }
        //     });
        // } else {
        //     GLOBAL.userinfo.os = 'I'
        //     const bridge = new NativeEventEmitter(NativeModules.JGJNativeEventEmitter);
        //     bridge.addListener('getPlace', (result) => {
        //         let arr = [JSON.parse(result).lat, JSON.parse(result).lng];
        //         if (!result.lat) {
        //             this.setState({
        //                 pos: arr
        //             }, () => {
        //                 this.cityName();
        //                 // this.getProvince();
        //
        //             })
        //         }else {
        //             this.getList();
        //         }
        //     });
        // }
    }
    // 更改查看是否实名数据，清空list
    deleteList() {
        this.page = 1
        this.getList(refresh = 'refresh')
        if (this.state.dataSource && this.state.dataSource.length > 0) {
            this.props.toStart()
        }
    }
    //获取服务器时间差
    timeDiffer() {
        fetchFun.load({
            url: 'v2/signup/userstatus',
            noLoading: true,//不显示自定义加载框
            data: {
                // kind: 'recruit'
                // timestamp:'1554189847',
                // sign:'7778b7fa0b86ddbe60fb0ed8a6544527dc337aa8'
            },
            success: (res) => {
                GLOBAL.timeDifference = res.serverTime * 1000 - Date.parse(new Date())
                this.setState({})
                // console.log('---服务器时间---', res)
            }
        });
    }
    //获取列表数据方法
    getList(e) {
        let that = this;
        let { dataSource } = this.state
        let pagesize = 10;
        let resNum = dataSource.length;
        if (e != 'refresh') {
            this.page = Math.ceil(resNum / pagesize) + 1;
        } else {
            this.page = 1
        }

        // let reqNum = this.page * pagesize;
        //
        //
        // console.log(this.page ,resNum);
        // if(reqNum - resNum > pagesize){
        //     this.setState(({isLoadMore:true,ifFetchMore: true
        //     }));
        //     this.isFresh=true;
        //     return;
        // }


        console.log(GLOBAL.zgzAddress.zgzAddressTwoNum)
        fetchFun.load({
            url: 'jlforemanwork/findjobactive',
            noLoading: true,//不显示自定义加载框
            data: {
                kind: 'recruit',
                pg: this.page,//分页页码
                pagesize: 10,//分页每页显示条数
                city_no: GLOBAL.zgzAddress.zgzAddressTwoNum,//城市
                contacted: '0',//是否查看已联系列表
                is_all_area: GLOBAL.zgzAddress.national ? '1' : '0',//如果看全国的数据传1
                work_type: GLOBAL.zgzType.zgzTypeNum,
                role_type: GLOBAL.userinfo.role,//当前角色(默认)
                pro_type: '-1',//工程类别(默认)
                // is_verified: e ? (e ? '1' : '0') : (this.state.selectsVerified ? '1' : '0'),//是否实名:1已实名,0未实名
                is_verified: this.props.selectsVerified ? '1' : '0',//是否实名:1已实名,0未实名
                cooperate_type: GLOBAL.zgzEmploy.zgzEmployNum

            },
            success: (res) => {
                console.log('---招工列表---', res.data_list)
                this.props.showFbzgBtnFun()//显示发布招工按钮
                this.setState({
                    dataSource: e == 'refresh' ? res.data_list : dataSource.concat(res.data_list),
                    ifFetchMore: true,
                    ifLoadingMore: res.data_list.length < 10 ? false : true,//隐藏正在加载效果
                    overList: res.data_list.length < 10 && !(this.state.dataSource.length == 0 && res.data_list.length == 0) ? true : false,

                    isLoadMore: true

                })
                that.isFresh = true;
                // that.page = that.page + 1
            }
        });


    }
    /** 获取地理位置（经纬度） */
    getPosition() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.getLocation('', (result) => {
                console.log(result, result.indexOf('-'))
                if (result && result.indexOf('-') == -1) {//获取到经纬度
                    this.setState({
                        pos: result ? result.split(',') : [0, 0]
                    }, () => {
                        this.cityName()
                    })
                } else {
                    this.getList()
                }
            })
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            NativeModules.JGJRecruitmentController.getLocation('', (result) => {
                let arr = [JSON.parse(result).lat, JSON.parse(result).lng];
                if (result && JSON.parse(result) && result.indexOf('lat') != -1) {
                    this.setState({
                        pos: arr
                    }, () => {
                        this.cityName();
                        // this.getProvince();

                    })
                } else {
                    this.getList();
                }
                // this.setState({}, () => {
                //     // 获取省
                //     this.getProvince();
                // })
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
            noLoading: true,//不显示自定义加载框
            type: 'GET',
            data: {
            },
            success: (res) => {
                // console.log('---定位地址---', res, res.result.addressComponent.province, res.result.addressComponent.city)
                GLOBAL.zgrAddress.zgrAddressOneName = res.result.addressComponent.province
                GLOBAL.zgrAddress.zgrAddressTwoName = res.result.addressComponent.city
                this.setState({}, () => {
                    // 获取省
                    this.getProvince()
                })
            }
        });
    }
    // 获取省
    getProvince() {
        if (GLOBAL.AddressOne && GLOBAL.AddressOne.length > 0) {
            this.getCity()//获取市
        } else {
            fetchFun.load({
                url: 'jlcfg/cities',
                noLoading: true,//不显示自定义加载框
                data: {
                    level: '1',//城市级别 1：省 2 市 3县
                    citycode: '0',//城市编码
                    kind: 'recruit'
                },
                success: (res) => {
                    // console.log('---获取城市列表-省---', res)
                    GLOBAL.AddressOne = res
                    // this.setState({}, () => {
                    //     this.getCity()//获取市
                    // })

                    this.getCity()//获取市
                }
            });
        }
    }
    // 获取市
    getCity() {
        let code = ''
        GLOBAL.AddressOne.map((v, i) => {
            if (v.city_name == GLOBAL.zgrAddress.zgrAddressOneName) {
                code = v.city_code
            }
        })
        fetchFun.load({
            url: 'jlcfg/cities',
            noLoading: true,//不显示自定义加载框
            data: {
                level: '2',//城市级别 1：省 2 市 3县
                citycode: code,//城市编码
            },
            success: (res) => {
                // console.log('---获取城市列表-市---', res)
                GLOBAL.AddressTwo = res
                res.map((v, i) => {
                    if (v.city_name == GLOBAL.zgrAddress.zgrAddressTwoName) {
                        GLOBAL.zgzAddress.zgzAddressTwoNum = v.city_code
                        this.getList();
                    }
                })
                // console.log(GLOBAL.zgzAddress.zgzAddressTwoNum)

            },

            error: () => {
                this.getList();
            },
        });

    }
    render() {
        return (
            <View style={{ flex: 1, width: '100%' }
            }>
                < ListItem
                    _getRef={this.props._getRef}
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header navigate={this.props.navigate} />} // 头布局
                    renderItem={({ item }) => <Lists data={item} position={this.state.pos} navigation={this.props.navigation} alertFun={this.props.alertFun.bind(this)} />}//item显示的布局
                    ListFooterComponent={() => <Footer overList={this.state.overList} navigate={this.props.navigate} ifLoadingMore={this.state.ifLoadingMore} />}// 尾布局
                    ListEmptyComponent={() => <Empty ifLoadingMore={this.state.ifLoadingMore} />}// 空布局
                    onEndReached={() => setTimeout(() => { this._onLoadMore() }, 500)}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                    onScrollEndDrag={() => this.onScrollEndDrag.bind(this)}//一个子view滚动结束拖拽时触发
                    _onScroll={this.props._onScroll.bind(this)}
                    onContentSizeChange={() => this.onContentSizeChange()}
                />
            </View>
        )
    }


    // 一个子view滚动结束拖拽时触发
    onScrollEndDrag(e) {
        // console.log(e.nativeEvent.contentOffset.y, GLOBAL.scrollheightDefault)
        if (e.nativeEvent.contentOffset.y > 500) {
            this.props.pgnumFun()
        } else {
            this.props.pgnumFunOff()
        }
        if (e.nativeEvent.contentOffset.y > GLOBAL.scrollheightDefault) {//向下滚动，按钮隐藏
            GLOBAL.scrollheightDefault = e.nativeEvent.contentOffset.y,
                this.props.fixedsupdateF()
        } else {//向上滚动，按钮显示
            GLOBAL.scrollheightDefault = e.nativeEvent.contentOffset.y,
                this.props.fixedsupdateT()
        }
    }

    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            this.getList(refresh = 'refresh')
            this.props.fixedsupdateT()//刷新时显示发布招工按钮
            this.props.fixedsupdateTMenu()//显示菜单
        }
    };
    onContentSizeChange = () => {

    }
    // 加载更多

    _onLoadMore() {
        // console.log(this.isFresh)
        // if(!this.isFresh){
        //     return;
        // }
        // this.setState({
        //     ifFetchMore: false,
        // }, () => {
        //     // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
        //     if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
        //         // console.log('-----------------加载更多----------------')
        //         this.page = this.page + 1
        //         this.isFresh = false;
        //         this.getList()
        //     }
        // })

        if (!this.isFresh) {
            return;
        }
        this.isFresh = false;
        if (this.state.isLoadMore) {
            this.setState({
                isLoadMore: false
            }, () => {
                // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
                if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
                    // console.log('-----------------加载更多----------------')

                    this.isFresh = false;
                    this.getList()
                }
            })
        }
    }
    componentWillUnmount() {
        this.loadMoreDataThrottled.cancel();
    }
}

// item布局
class Lists extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        const item = this.props.data

        let distance = ''
        const [lat, lng] = this.props.position;
        if (item.pro_location && item.pro_location[0] > 0 && lat > 0) {
            distance = " / " + parseInt(getFlatternDistance(+lat, +lng, item.pro_location[1], item.pro_location[0])) + "公里";
        }

        return (
            <TouchableOpacity activeOpacity={.7}
                onPress={() => this.listItemClick(item)
                }
                style={styles.information} >

                {/* 右箭头 */}
                <View style={{
                    flexDirection: 'row', justifyContent: "center", alignItems: 'center', position: "absolute",
                    right: 10, top: '60%'
                }}>
                    <Icon name="r-arrow" size={12} color="#000" />
                </View>

                <View style={styles.head}>
                    <View style={styles.headl}>
                        {
                            item.classes ? (
                                item.classes[0].cooperate_type ? (
                                    item.classes[0].cooperate_type.type_name ? (
                                        item.classes[0].cooperate_type.type_name == '突击队' ? (
                                            <LinearGradient colors={['#C419D3', '#5612BC',]}
                                                start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                style={{
                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                    marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                    paddingBottom: 1, borderRadius: 9
                                                }}>
                                                <Text style={{ color: '#fff', fontSize: 12 }}>
                                                    {item.classes[0].cooperate_type.type_name}
                                                </Text>
                                            </LinearGradient>
                                        ) : (
                                                item.classes[0].cooperate_type.type_name == '点工' ? (
                                                    <LinearGradient colors={['#f97547', '#F53055',]}
                                                        start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                        style={{
                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                            marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                            paddingBottom: 1, borderRadius: 9
                                                        }}>
                                                        <Text style={{ color: '#fff', fontSize: 12 }}>
                                                            {item.classes[0].cooperate_type.type_name}
                                                        </Text>
                                                    </LinearGradient>
                                                ) : (
                                                        item.classes[0].cooperate_type.type_name == '包工' ? (
                                                            <LinearGradient colors={['#4DBDEC', '#1259EA',]}
                                                                start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                                style={{
                                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                    marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                                    paddingBottom: 1, borderRadius: 9
                                                                }}>
                                                                <Text style={{ color: '#fff', fontSize: 12 }}>
                                                                    {item.classes[0].cooperate_type.type_name}
                                                                </Text>
                                                            </LinearGradient>
                                                        ) : (
                                                                item.classes[0].cooperate_type.type_name == '总包' ? (
                                                                    <LinearGradient colors={['#f97547', '#F53055',]}
                                                                        start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                                        style={{
                                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                            marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                                            paddingBottom: 1, borderRadius: 9
                                                                        }}>
                                                                        <Text style={{ color: '#fff', fontSize: 12 }}>
                                                                            {item.classes[0].cooperate_type.type_name}
                                                                        </Text>
                                                                    </LinearGradient>
                                                                ) : false
                                                            )
                                                    )
                                            )
                                    ) : false
                                ) : false
                            ) : false
                        }

                        <View style={{ flexDirection: "row", alignItems: "center", }}>
                            <Text style={{ fontSize: 17, color: '#000', overflow: 'hidden', fontWeight: '400' }}>
                                {item.pro_title ? (item.pro_title.length > 11 ? item.pro_title.substr(0, 10) + "..." : item.pro_title) : ""}
                            </Text>

                            {
                                item.is_verified == 1 ? (
                                    item.is_company_auth == '2' ? (
                                        <TouchableOpacity activeOpacity={.7}
                                            onPress={() => this.props.navigation.navigate('Recruit_rzdetailpage')}>
                                            <Image style={{ width: 18, height: 17, marginLeft: 5, marginTop: 2 }}
                                                source={{ uri: `${GLOBAL.server}public/imgs/icon/company_auth.png` }}></Image>
                                        </TouchableOpacity>
                                    ) : (
                                            <TouchableOpacity activeOpacity={.7}
                                                onPress={() => this.props.alertFun('information-sm')}>
                                                <Image style={{ width: 46, height: 16, marginLeft: 5 }}
                                                    source={{ uri: `${GLOBAL.server}public/imgs/icon/jobverified.png` }} ></Image>
                                            </TouchableOpacity>
                                        )
                                ) : false
                            }
                            {/* <Thelabel name = 'information' is_verified={item.is_verified} is_company_auth={item.is_company_auth} /> */}
                        </View>
                    </View>
                    {
                        item.classes ? (
                            item.classes[0].pro_type ? (
                                item.classes[0].pro_type.type_name ? (
                                    < View style={styles.headr} ><Text style={{ fontSize: 12, color: '#666666' }}>{item.classes[0].pro_type.type_name}</Text></View >
                                ) : false
                            ) : false
                        ) : false
                    }
                </View>

                {/* 字段显示组件 */}
                <Information item={item} />

                <View style={styles.foot} >
                    <Text style={{ color: '#666666', fontSize: 12 }}>
                        {item.call_time_txt ? item.call_time_txt : (item.create_time_txt + distance)}
                    </Text>

                    <View
                        // onPress={() => this.acquaintance()}
                        style={{ flexDirection: 'row', alignItems: 'center' }}>
                        {
                            item.sharefriendnum ? (
                                <View style={{ flexDirection: "row", alignItems: "center" }}

                                >
                                    <Text style={{ color: '#666666', fontSize: 12 }}>
                                        你有&nbsp;
                                    </Text>
                                    <Text style={{ color: '#EB4E4E', fontSize: 12 }}>
                                        {item.sharefriendnum}
                                    </Text>
                                    <Text style={{ color: '#666666', fontSize: 12 }}>
                                        &nbsp;个朋友认识他
                                    </Text>
                                </View>
                            ) : false
                        }
                    </View>
                </View>
            </TouchableOpacity>
        )
    }
    // listItemClick(item) {
    //     this.props.navigation.navigate('Recruit_jobdetails', { pid: item.pid, nameTo: 'homepage' })
    // }
    listItemClick(item) {
        this.props.navigation.navigate('Recruit_jobdetails', { pid: item.pid, nameTo: 'homepage' })
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {
            NativeModules.GrowingIO.track('A_work_list_RN', {});
        } else {
            NativeModules.GrowingIO.track('I_work_list_RN', {});
        }
        NativeModules.GrowingIO.setUserId(GLOBAL.userinfo.uid.toString());
    }
    // 认识他好友列表
    // acquaintance() {
    //     if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
    //         NativeModules.MyNativeModule.openWebView('friend');//调用原生方法
    //     }
    //     if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
    //         NativeModules.JGJRecruitmentController.openWebView('friend');//调用原生方法

    //     }
    // }
}

const styles = StyleSheet.create({
    containermain: {
        height: '100%',
        backgroundColor: '#ebebeb',
        alignItems: 'center',
    },

    headl: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    headr: {
        fontSize: 14,
        backgroundColor: '#eee',
        borderRadius: 2,
        color: '#666',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: "center",
        paddingLeft: 6,
        paddingRight: 6,
        paddingTop: 2.5,
        paddingBottom: 2.5,
    },

    top: {
        flexDirection: 'row'
    },
    bot: {
        flexDirection: 'row',
        marginTop: 22
    },
    munuss: {
        width: '25%',
        height: 70,
    },
    munussb: {
        width: '25%',
        height: 70,
        paddingLeft: 20,
        paddingRight: 20,
        flexDirection: 'row',
        flexWrap: 'wrap',
        justifyContent: 'center',
        borderRightWidth: 1,
        borderRightColor: '#ebebeb'
    },
    menuimg: {
        width: 42,
        height: 42,
        marginBottom: 7.5,
    },
    menufont: {
        fontSize: 13,
        color: '#000',
    },
    information: {
        paddingLeft: 15,
        paddingRight: 15,
        paddingTop: 14.5,
        paddingBottom: 10,
        paddingBottom: 14.5,
        marginBottom: 10,
        backgroundColor: 'white',
    },
    head: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: "space-between",
        flexDirection: 'row',
        marginBottom: 5,
    },
    headl: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    headr: {
        fontSize: 12,
        backgroundColor: '#eee',
        borderRadius: 2,
        color: '#666',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: "center",
        paddingLeft: 6,
        paddingRight: 6,
        paddingTop: 2.5,
        paddingBottom: 2.5,
    },
    foot: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        marginTop: 10
    },
})