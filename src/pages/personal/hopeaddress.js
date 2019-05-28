/*
 * @Author: stl
 * @Date: 2019-03-18 11:40:43 
 * @Module:期望工作地
 * @Last Modified time: 2019-03-18 11:40:43 
 */

import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, ImageBackground, ProgressBarAndroid, TextInput } from 'react-native';
import Selectaddress from '../../component/selectaddress'
import Icon from "react-native-vector-icons/iconfont";

export default class basic extends Component {
    constructor(props) {
        super(props)
        this.state = {
            clickaddressoneNum: -1,
            clickaddresstwoNum: -1,
            addressone: [
                { key: 0, name: '北京市' },
                { key: 1, name: '天津市' },
                { key: 2, name: '河北省' },
                { key: 3, name: '山西省' },
                { key: 4, name: '内蒙古自治区' },
                { key: 5, name: '辽宁区' },
                { key: 6, name: '吉林省' },
                { key: 7, name: '上海市' },
                { key: 8, name: '江苏省' },
                { key: 9, name: '浙江省' },
                { key: 10, name: '安徽省' },
                { key: 11, name: '福建省' },
                { key: 12, name: '江西省' },
                { key: 13, name: '山东省' },
                { key: 14, name: '河南省' },
                { key: 15, name: '湖北省' },
                { key: 16, name: '湖南省' },
                { key: 17, name: '广东省' },
                { key: 18, name: '广西壮族自治区' },
                { key: 19, name: '海南省' },
                { key: 20, name: '重庆市' },
            ],
            addresstwo: [
                { key: 0, name: '山东省' },
                { key: 1, name: '济南市' },
                { key: 2, name: '青岛市' },
                { key: 3, name: '淄博市' },
                { key: 4, name: '枣庄市' },
                { key: 5, name: '东营市' },
                { key: 6, name: '烟台市' },
                { key: 7, name: '潍坊市' },
                { key: 8, name: '济宁市' },
                { key: 9, name: '泰安市' },
                { key: 10, name: '威海市' },
                { key: 11, name: '日照市' },
                { key: 12, name: '莱芜市' },
                { key: 13, name: '临沂市' },
                { key: 14, name: '德州市' },
                { key: 15, name: '聊城市' },
                { key: 16, name: '滨州市' },
                { key: 17, name: '菏泽市' },
            ],

        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
    });
    render() {
        let objAddress = {}
        objAddress.addressone = this.state.addressone
        objAddress.addresstwo = this.state.addresstwo
        objAddress.onenum = this.state.clickaddressoneNum
        objAddress.twonum = this.state.clickaddresstwoNum
        objAddress.jb = 'qwaddress'
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>选择城市</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <Selectaddress clickaddress={this.clickaddress.bind(this)}
                    objAddress={objAddress}
                />
            </View>
        )
    }
    // 选择城市
    clickaddress(obj) {
        this.setState({
            clickaddressoneNum: obj.a,
            clickaddresstwoNum: obj.b,
        })
        this.state.addressone.map((item, key) => {
            if (item.key == obj.a) {
                GLOBAL.editbasic.qwaddress.qwoneName = item.name
            }
        })
        this.state.addresstwo.map((item, key) => {
            if (item.key == obj.b) {
                GLOBAL.editbasic.qwaddress.qwtwoName = item.name
            }
        })
        GLOBAL.editbasic.qwaddress.qwone = obj.a
        GLOBAL.editbasic.qwaddress.qwtwo = obj.b
        this.props.navigation.state.params.callback()
        this.props.navigation.navigate('Basic')
    }
}
const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#ebebeb',
    },
})