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
} from 'react-native';
import Selectaddress from '../../component/selectaddress'
import Icon from "react-native-vector-icons/Ionicons";

export default class lookworker extends Component {
    constructor(props) {
        super(props)
        this.state = {
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
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
                    <TouchableOpacity style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>选择城市</Text>
                    </View>
                    <TouchableOpacity
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
        this.props.navigation.state.params.callback()
        this.props.navigation.goBack()
    }
}
const styles = StyleSheet.create({
    main: {
        backgroundColor: '#ebebeb',
        flex: 1,
    },
})