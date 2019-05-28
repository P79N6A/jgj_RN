/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 18:02:46 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-10 10:12:05
 * Module:选择工种
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
} from 'react-native';
import Typeselects from '../../component/typeselects'
import Icon from "react-native-vector-icons/iconfont";

export default class lookworker extends Component {
    constructor(props) {
        super(props)
        this.state = {
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
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>选择工种</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7}
                        style={{
                            width: '25%', height: '100%', marginRight: 10, flexDirection: 'row',
                            alignItems: 'center', justifyContent: 'flex-end'
                        }}>
                    </TouchableOpacity>
                </View>
                <Typeselects
                    addressType={this.props.navigation.getParam('name')}
                    typeBz={this.props.navigation.getParam('typeBz')}
                    zgrBz={this.props.navigation.getParam('zgrBz')?this.props.navigation.getParam('zgrBz'):false}
                    offType={this.clicktype.bind(this)}
                />
            </View>
        )
    }
    // 选择工种
    clicktype(e) {
        this.props.navigation.state.params.callback()//回调刷新函数，改变全局变量后需要手动刷新
        this.props.navigation.goBack()
    }

}
const styles = StyleSheet.create({
    main: {
        backgroundColor: '#ebebeb',
        flex: 1
    },
})