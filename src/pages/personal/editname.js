/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-20 14:57:44 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-03-27 15:43:16
 */
import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, ImageBackground, ProgressBarAndroid, TextInput } from 'react-native';
import Icon from "react-native-vector-icons/iconfont";

export default class basic extends Component {
    constructor(props) {
        super(props)
        this.state = {
            inputValue: ''
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
                    <TouchableOpacity style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{marginRight: 3}} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>姓名</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <View style={{
                    marginTop: 16,
                    backgroundColor: "#fff",
                    paddingLeft: 10,
                    paddingRight: 10,
                    paddingTop: 15,
                    paddingBottom: 15,
                    flexDirection: 'row',
                    alignItems: 'center',
                    justifyContent: 'space-between'
                }}>
                    <TextInput
                        onChangeText={this.namefun.bind(this)}
                        value={this.state.inputValue}
                        placeholder={GLOBAL.editbasic.name} style={{ height: 16, flex: 1, color: '#000', fontSize: 15, padding: 0, }}></TextInput>
                    <TouchableOpacity onPress={() => this.clearname()}>
                        <Image style={{ width: 18, height: 18 }} source={require('../../assets/personal/error.png')}></Image>
                    </TouchableOpacity>
                </View>
            </View>
        )
    }
    componentDidMount() {
        this.props.navigation.setParams({ navigatePress: this.editname.bind(this) })
    }
    editname() {
        GLOBAL.editbasic.name = this.state.inputValue
        this.props.navigation.state.params.callback()
        this.props.navigation.goBack()
    }
    // 姓名输入框事件
    namefun(name) {
        this.setState({
            inputValue: name
        })
    };
    // 清空姓名事件
    clearname() {
        this.setState({
            inputValue: ''
        })
    }
}
const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#ebebeb',
    },
})