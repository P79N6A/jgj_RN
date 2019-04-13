/*
 * @Author: stl
 * @Date: 2019-03-14 10:26:52 
 * @Last 工人认证服务支付选择
 * @Last Modified time: 2019-03-14 10:26:52 
 */
import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, ImageBackground } from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";

export default class pay extends Component {
    constructor(props) {
        super(props)
        this.state = {
            pay: 'wx'
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    // 选择微信
    wxfun() {
        this.setState({
            pay: 'wx'
        })
    }
    // 选择支付宝
    zfbfun() {
        this.setState({
            pay: 'zfb'
        })
    }
    render() {
        return (
            <View style={styles.main}>
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>工人认证服务</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <View style={{ height: 43, flexDirection: 'row', alignItems: 'center', paddingLeft: 15 }}>
                    <Text style={{ color: '#3d4145', fontSize: 14, fontWeight: '400' }}>认证审核费用说明</Text>
                </View>
                <View style={{ padding: 15, backgroundColor: '#fff', }}>
                    <View style={{ color: '#999', fontSize: 12, }}>
                        <Text style={{ flexDirection: 'row', alignItems: 'center', lineHeight: 30 }}>认证审核费用
                        <Text style={{ marginLeft: 7, marginRight: 7, color: '#000', fontSize: 30, }}> 99 </Text>
                            元一次，可享受一年的认证特权，平台会在5个工作日内进行审核
                        </Text>
                    </View>
                    {/* 框 */}
                    <View style={{ borderWidth: 1, borderColor: '#dbdbdb', borderRadius: 4, marginTop: 16, backgroundColor: '#fafafa', padding: 10 }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', height: 19 }}>
                            <Text style={{ fontSize: 30, color: '#eb4e4e', marginRight: 5 }}>·</Text><Text style={{ color: '#eb4e4e', fontSize: 12, }}>认证服务购买后不可退回</Text>
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: 'center', height: 19 }}>
                            <Text style={{ fontSize: 30, color: '#eb4e4e', marginRight: 5 }}>·</Text><Text style={{ color: '#eb4e4e', fontSize: 12, }}>认证服务到期后特权失效</Text>
                        </View>
                    </View>
                </View>
                {/* 支付方式 */}
                <View style={{ height: 43, flexDirection: 'row', alignItems: 'center', paddingLeft: 15 }}>
                    <Text style={{ color: '#3d4145', fontSize: 14, fontWeight: '400' }}>支付方式</Text>
                </View>
                {/* 选择支付方式 */}
                <View style={{ backgroundColor: "#fff", padding: 15 }}>
                    <View style={{ backgroundColor: '#f1f1f1', borderRadius: 4, paddingLeft: 10, paddingRight: 10 }}>
                        {/* 微信 */}
                        <TouchableOpacity onPress={() => this.wxfun()} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 57 }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                <Icon style={{marginRight: 21}} name="wechat" size={32} color="#4EB52E" />
                                <Text style={{ color: '#3d4145', fontSize: 14, fontWeight: '400' }}>微信支付</Text>
                            </View>
                            {
                                this.state.pay == 'wx' ? (
                                    <Icon name="success" size={19} color="#eb4e4e" />
                                ) : (
                                        <Image style={{ width: 19, height: 19 }} source={require('../../../assets/recruit/yuan.png')}></Image>
                                    )
                            }
                        </TouchableOpacity>
                        {/* 虚线 */}
                        <View style={{ height: 1, borderRadius: 0.5, borderColor: 'rgb(219, 219, 219)', borderTopWidth: 1, borderStyle: 'dashed' }}></View>
                        {/* 支付宝 */}
                        <TouchableOpacity onPress={() => this.zfbfun()} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 57, borderBottomStyle: 'dashed', }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                <Icon style={{marginRight: 21}} name="alipay" size={32} color="#00A9F1" />
                                <Text style={{ color: '#3d4145', fontSize: 14, fontWeight: '400' }}>支付宝支付</Text>
                            </View>
                            {
                                this.state.pay == 'zfb' ? (
                                    <Icon name="success" size={19} color="#eb4e4e" />
                                ) : (
                                        <Image style={{ width: 19, height: 19 }} source={require('../../../assets/recruit/yuan.png')}></Image>
                                    )
                            }
                        </TouchableOpacity>
                    </View>
                </View>
                {/* 支付按钮栏 */}
                <View style={{
                    backgroundColor: '#fff', height: 64, padding: 10, position: "absolute", bottom: 0, width: '100%', flexDirection: 'row', justifyContent: 'space-between',
                    alignItems: 'center'
                }}>
                    <View style={{ flexDirection: 'row', alignItems: "center" }}>
                        <Text style={{ color: '#3d4145', fontSize: 15 }}>订单金额：</Text>
                        <Text style={{ color: '#eb4e4e', fontSize: 16 }}>￥99</Text>
                    </View>
                    <View style={{ width: 160, height: 42, backgroundColor: '#eb4e4e', flexDirection: "row", justifyContent: 'center', alignItems: 'center', borderRadius: 4 }}>
                        <Text style={{ color: '#fff', fontSize: 18 }}>立即支付</Text>
                    </View>
                </View>
            </View>
        )
    }
}
const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#ebebeb'
    }
})