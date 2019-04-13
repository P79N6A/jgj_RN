/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:35:23 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-03-29 16:38:03
 * Module:购买找活招工电话
 */

import React, { Component } from 'react'
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
    ScrollView,
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";

export default class pay extends Component {
    constructor(props) {
        super(props)
        this.state = {
            pay: 'wx',
            num: '10'
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
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>购买找活招工电话</Text>
                    </View>
                    <TouchableOpacity
                        onPress={() => this.props.navigation.navigate('Servicewater')}
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                        <Text style={{ color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>服务流水</Text>
                    </TouchableOpacity>
                </View>

                <ScrollView>
                    <View style={{ backgroundColor: '#fff', padding: 15 }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                            <Text style={{ flexDirection: 'row', alignItems: 'center', lineHeight: 30 }}>当前剩余找活招工电话数</Text>
                            <Text style={{ marginLeft: 7, marginRight: 7, color: '#000', fontSize: 30, }}>2</Text>
                        </View>
                        {/* 框 */}
                        <View style={{ borderWidth: 1, borderColor: '#dbdbdb', borderRadius: 4, marginTop: 16, backgroundColor: '#fafafa', padding: 10 }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center', height: 19 }}>
                                <Text style={{ fontSize: 30, color: '#eb4e4e', marginRight: 5 }}>·</Text>
                                <Text style={{ color: '#eb4e4e', fontSize: 12, }}>已拨打过的电话可免费重复呼叫</Text>
                            </View>
                            <View style={{ flexDirection: 'row', alignItems: 'center', height: 19 }}>
                                <Text style={{ fontSize: 30, color: '#eb4e4e', marginRight: 5 }}>·</Text>
                                <Text style={{ color: '#eb4e4e', fontSize: 12, }}>每月免费赠送2个找活招工电话，仅限当月使用</Text>
                            </View>
                            <View style={{ flexDirection: 'row', alignItems: 'center', height: 19 }}>
                                <Text style={{ fontSize: 30, color: '#eb4e4e', marginRight: 5 }}>·</Text>
                                <Text style={{ color: '#eb4e4e', fontSize: 12, }}>套餐购买的找活招工电话无使用期限限制</Text>
                            </View>
                        </View>
                    </View>
                    {/* 请选择套餐 */}
                    <View style={{ height: 43, flexDirection: 'row', alignItems: 'center', paddingLeft: 15 }}>
                        <Text style={{ color: '#3d4145', fontSize: 14, fontWeight: '400' }}>请选择套餐</Text>
                    </View>
                    <View style={{ backgroundColor: "#fff", padding: 15 }}>
                        <View style={{ borderRadius: 4, paddingLeft: 10, paddingRight: 10 }}>
                            {/* 10个 */}
                            <TouchableOpacity
                                onPress={() => this.setState({
                                    num: '10'
                                })}
                                style={{
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 80, padding: 15,
                                    borderWidth: 1, borderColor: this.state.num == '10' ? '#eb4e4e' : '#ebebeb', borderRadius: 4.4, marginBottom: 15,
                                    position: 'relative'
                                }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#3d4145', fontSize: 15.4 }}>找活招工</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}> 10 </Text>
                                    <Text style={{ color: '#3d4145', fontSize: 15.4 }}>个</Text>
                                </View>
                                <View style={{
                                    flexDirection: 'row', alignItems: 'center', paddingRight: 20,
                                    borderLeftWidth: 1, borderLeftColor: '#ebebeb', paddingLeft: 15
                                }}>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>￥</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 24.9, }}>29.00</Text>
                                    <Text style={{ color: '#999', fontSize: 13.2, marginLeft: 5 }}>￥50.00</Text>
                                </View>
                                {
                                    this.state.num == '10' ? (<Image style={{ width: 22, height: 22, position: 'absolute', right: 1, bottom: 1 }}
                                        source={require('../../assets/recruit/icon-sharp-tick.png')}></Image>) : (
                                            <Image 
                                            style={{ width: 0, height: 0, position: 'absolute', right: 1, bottom: 1 }}
                                                source={require('../../assets/recruit/icon-sharp-tick.png')}></Image>
                                        )
                                }
                            </TouchableOpacity>
                            {/* 30个 */}
                            <TouchableOpacity
                                onPress={() => this.setState({
                                    num: '30'
                                })}
                                style={{
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 80, padding: 15,
                                    borderWidth: 1, borderColor: this.state.num == '30' ? '#eb4e4e' : '#ebebeb', borderRadius: 4.4
                                }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#3d4145', fontSize: 15.4 }}>找活招工</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}> 30 </Text>
                                    <Text style={{ color: '#3d4145', fontSize: 15.4 }}>个</Text>
                                </View>
                                <View style={{
                                    flexDirection: 'row', alignItems: 'center', paddingRight: 20,
                                    borderLeftWidth: 1, borderLeftColor: '#ebebeb', paddingLeft: 15
                                }}>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>￥</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 24.9, }}>59.00</Text>
                                    <Text style={{ color: '#999', fontSize: 13.2, marginLeft: 5 }}>￥100.00</Text>
                                </View>
                                {
                                    this.state.num == '30' ? (<Image style={{ width: 22, height: 22, position: 'absolute', right: 1, bottom: 1 }}
                                        source={require('../../assets/recruit/icon-sharp-tick.png')}></Image>) : (
                                            <Image
                                            style={{ width: 0, height: 0, position: 'absolute', right: 1, bottom: 1 }}
                                                source={require('../../assets/recruit/icon-sharp-tick.png')}></Image>
                                        )
                                }
                            </TouchableOpacity>
                        </View>
                    </View>


                    {/* 支付方式 */}
                    <View style={{ height: 43, flexDirection: 'row', alignItems: 'center', paddingLeft: 15 }}>
                        <Text style={{ color: '#3d4145', fontSize: 14, fontWeight: '400' }}>支付方式</Text>
                    </View>
                    {/* 选择支付方式 */}
                    <View style={{ backgroundColor: "#fff", padding: 15, marginBottom: 200 }}>
                        <View style={{ backgroundColor: '#f1f1f1', borderRadius: 4, paddingLeft: 10, paddingRight: 10 }}>
                            {/* 微信 */}
                            <TouchableOpacity onPress={() => this.wxfun()} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 57 }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <Icon style={{ marginRight: 21 }} name="wechat" size={32} color="#4EB52E" />
                                    <Text style={{ color: '#3d4145', fontSize: 14, fontWeight: '400' }}>微信支付</Text>
                                </View>
                                {
                                    this.state.pay == 'wx' ? (
                                        <Icon name="success" size={19} color="#eb4e4e" />
                                    ) : (
                                            <Image 
                                            style={{ width: 19, height: 19 }} 
                                            source={require('../../assets/recruit/yuan.png')}></Image>
                                        )
                                }
                            </TouchableOpacity>
                            {/* 虚线 */}
                            <View style={{ height: 1, borderRadius: 0.5, borderColor: 'rgb(219, 219, 219)', borderTopWidth: 1, borderStyle: 'dashed' }}></View>
                            {/* 支付宝 */}
                            <TouchableOpacity onPress={() => this.zfbfun()} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', height: 57, borderBottomStyle: 'dashed', }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <Icon style={{ marginRight: 21 }} name="alipay" size={32} color="#00A9F1" />
                                    <Text style={{ color: '#3d4145', fontSize: 14, fontWeight: '400' }}>支付宝支付</Text>
                                </View>
                                {
                                    this.state.pay == 'zfb' ? (
                                        <Icon name="success" size={21} color="#eb4e4e" />
                                    ) : (
                                            <Image style={{ width: 19, height: 19 }} source={require('../../assets/recruit/yuan.png')}></Image>
                                        )
                                }
                            </TouchableOpacity>
                        </View>
                    </View>
                </ScrollView>
                {/* 支付按钮栏 */}
                <View style={{
                    backgroundColor: '#fff', height: 64, padding: 10, position: "absolute", bottom: 0, width: '100%', flexDirection: 'row', justifyContent: 'space-between',
                    alignItems: 'center'
                }}>
                    <View>
                        <View style={{ flexDirection: 'row', alignItems: "center", height: 19 }}>
                            <Text style={{ color: '#999', fontSize: 13.2 }}>以优惠金额：</Text>
                            <Text style={{ color: '#999', fontSize: 13.2 }}>￥21.00</Text>
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: "center", height: 26 }}>
                            <Text style={{ color: '#3d4145', fontSize: 15 }}>订单金额：</Text>
                            <Text style={{ color: '#eb4e4e', fontSize: 16 }}>￥29.00</Text>
                        </View>
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