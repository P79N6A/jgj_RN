/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-21 15:49:51 
 * @Module:发布招工
 * @Last Modified time: 2019-03-21 15:49:51 
 */
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    ActivityIndicator,
    ListView,
    Image,
    ScrollView,
    Dimensions,
    TouchableOpacity,
    StatusBar,
    Platform,
    FlatList,
    RefreshControl
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";

export default class myjob extends Component {
    constructor(props) {
        super(props)
        this.state = {
            zgr: true,//招工人
            zbz: false,//招班组
            ztjd: false,//招突击队
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    render() {
        return (
            <View style={{ backgroundColor: '#ebebeb', flex: 1 }}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{marginRight: 3}} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>发布招工</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <View style={{ paddingTop: 11, paddingBottom: 11, marginBottom: 15, backgroundColor: '#fff' }}>
                    <Text style={{ marginTop: 15.5, marginBottom: 15.5, color: '#999', fontSize: 15.4, textAlign: 'center' }}>选择你想招的人</Text>
                    {/* 三个选项 */}
                    <View style={{ paddingLeft: 22, paddingRight: 22, flexDirection: 'row', justifyContent: 'center' }}>
                        <TouchableOpacity
                            onPress={() => this.zgrFun()}
                            style={{ width: '33.33%', flexDirection: 'row', justifyContent: 'center' }}>
                            <View>
                                <View style={{ width: 75, height: 75, borderRadius: 75, position: 'relative' }}>
                                    {
                                        this.state.zgr ? (
                                            <Icon name="liushui" size={75} color="#1496DB" />
                                        ) : (
                                            <Icon name="liushui" size={75} color="#ebebeb" />
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
                                <Text style={{ textAlign: 'center', color: '#000', fontSize: 13.2 }}>招工人</Text>
                            </View>
                        </TouchableOpacity>

                        <TouchableOpacity
                            onPress={() => this.zbzFun()}
                            style={{ width: '33.33%', flexDirection: 'row', justifyContent: 'center' }}>
                            <View>
                                <View style={{ width: 75, height: 75, borderRadius: 75 }}>
                                    {
                                        this.state.zbz ? (
                                            <Icon name="dingdan" size={75} color="#1496DB" />
                                        ) : (
                                            <Icon name="dingdan" size={75} color="#ebebeb" />
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
                                <Text style={{ textAlign: 'center', color: '#000', fontSize: 13.2 }}>招班组</Text>
                            </View>
                        </TouchableOpacity>

                        <TouchableOpacity
                            onPress={() => this.ztjdFun()}
                            style={{ width: '33.33%', flexDirection: 'row', justifyContent: 'center' }}>
                            <View>
                                <View style={{ width: 75, height: 75, borderRadius: 75 }}>
                                    {
                                        this.state.ztjd ? (
                                            <Icon name="profession" size={75} color="#1296DB" />
                                        ) : (   
                                                <Icon name="profession" size={75} color="#BFBFBF" />
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
                <TouchableOpacity
                    onPress={() => this.props.navigation.navigate('Releasetype', {
                        callback: (() => {
                            this.setState({})
                        })
                    })}
                    style={{
                        paddingLeft: 22, paddingRight: 22, paddingTop: 11, paddingBottom: 11, marginBottom: 11, backgroundColor: '#fff',
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between'
                    }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Icon style={{marginRight:5.5}} name="profession" size={26} color="#1296DB" />
                        <Text style={{ color: '#000', fontWeight: '700', fontSize: 16.5 }}>所需工种</Text>
                    </View>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        {
                            GLOBAL.fbtype.length > 0 ? (
                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 5 }}>{GLOBAL.fbtype}</Text>
                            ) : (
                                    <Text style={{ color: '#999', fontSize: 15.4, marginRight: 5 }}>请选择工种</Text>
                                )
                        }
                        <Icon name="r-arrow" size={12} color="#000" />
                    </View>
                </TouchableOpacity>

                {/* 工程类别 */}
                <TouchableOpacity
                    onPress={() => this.props.navigation.navigate('Releaseworktype', {
                        callback: (() => {
                            this.setState({})
                        })
                    })}
                    style={{
                        paddingLeft: 22, paddingRight: 22, paddingTop: 11, paddingBottom: 11, marginBottom: 11, backgroundColor: '#fff',
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between'
                    }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Icon style={{marginRight:5.5}} name="project" size={26} color="#DB7F00" />
                        <Text style={{ color: '#000', fontWeight: '700', fontSize: 16.5 }}>工程类别</Text>
                    </View>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        {
                            GLOBAL.fbworklb.length > 0 ? (
                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 5 }}>{GLOBAL.fbworklb}</Text>
                            ) : (
                                    <Text style={{ color: '#999', fontSize: 15.4, marginRight: 5 }}>请选择工程类别</Text>
                                )
                        }
                        <Icon style={{marginLeft: 10}} name="r-arrow" size={12} color="#000" />
                    </View>
                </TouchableOpacity>

                {/* 项目所在地 */}
                <TouchableOpacity
                    onPress={() => this.props.navigation.navigate('Releaseaddres', {
                        callback: (() => {
                            this.setState({})
                        })
                    })}
                    style={{
                        paddingLeft: 22, paddingRight: 22, paddingTop: 11, paddingBottom: 11, marginBottom: 11, backgroundColor: '#fff',
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between'
                    }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                    <Icon style={{marginRight:5.5}} name="area" size={26} color="#6BBE00" />
                        <Text style={{ color: '#000', fontWeight: '700', fontSize: 16.5 }}>项目所在地</Text>
                    </View>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        {
                            GLOBAL.fbaddress.fbtwoName ? (
                                <Text style={{ color: '#000', fontSize: 15.4, marginRight: 5 }}>{GLOBAL.fbaddress.fboneName} {GLOBAL.fbaddress.fbtwoName}</Text>
                            ) : (
                                    <Text style={{ color: '#999', fontSize: 15.4, marginRight: 5 }}>请选择项目所在地</Text>
                                )
                        }
                        <Icon style={{marginLeft: 10}} name="r-arrow" size={12} color="#000" />
                    </View>
                </TouchableOpacity>

                {/* 下一步按钮 */}
                <TouchableOpacity onPress={() => this.props.navigation.navigate('Releasedetail')} style={{
                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                    backgroundColor: '#eb4e4e', marginTop: 33, marginLeft: 11, marginRight: 11, height: 49, borderRadius: 5.5
                }}>
                    <Text style={{ color: '#fff', fontSize: 16.5 }}>下一步</Text>
                </TouchableOpacity>
            </View>
        )
    }
    zgrFun() {
        this.setState({
            zgr: true,
            zbz: false,
            ztjd: false,
        })
    }
    zbzFun() {
        this.setState({
            zgr: false,
            zbz: true,
            ztjd: false,
        })
    }
    ztjdFun() {
        this.setState({
            zgr: false,
            zbz: false,
            ztjd: true,
        })
    }
}