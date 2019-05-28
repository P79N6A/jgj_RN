/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 17:58:27 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-10 17:40:11
 * Module:选择城市
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    DeviceEventEmitter,
    NativeModules,
    Platform
} from 'react-native';
import Selectaddress from '../../component/selectaddress'
import Icon from "react-native-vector-icons/iconfont";

export default class lookworker extends Component {
    constructor(props) {
        super(props)
        this.state = {
        }
    }
    componentDidMount(){
        // 底部导航控制
        this.bottomTab()
    }
    bottomTab(){
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.footerController('{state:"hide"}');//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.footerController({state:"hide"});//调用原生方法
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
    });
    render() {
        return (
            <View style={styles.main}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>选择城市</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7}
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <Selectaddress 
                    addressType={this.props.navigation.getParam('name')}
                    offAddress={this.clickaddress.bind(this)}
                />
            </View>
        )
    }
    // 选择城市
    clickaddress() {
        // this.props.navigation.state.params.callback()
        // this.props.navigation.goBack()
        if(this.props.navigation.getParam('name') == '找工人项目所在地'){
            let cityno
            GLOBAL.AddressTwo.map((v, index) => {
                if (v.city_name == GLOBAL.zgrAddress.zgrAddressTwoName) {
                    cityno = v.city_code
                }
            })
            GLOBAL.cityno = cityno
            this.setState({})
            this.props.navigation.goBack()
            this.props.navigation.state.params.callback()
        }else{
            this.props.navigation.state.params.callback()
            this.props.navigation.goBack()
        }
    }
}
const styles = StyleSheet.create({
    main: {
        backgroundColor: '#ebebeb',
        flex: 1,
    },
})