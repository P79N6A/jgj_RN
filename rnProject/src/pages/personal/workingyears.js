/*
 * @Author: stl
 * @Date: 2019-03-18 11:30:44 
 * @Module：工龄
 * @Last Modified time: 2019-03-18 11:30:44 
 */
import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, ImageBackground, ProgressBarAndroid, TextInput } from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";

export default class basic extends Component {
    constructor(props) {
        super(props)
        this.state = {
            inputValue: ''
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
                        <Icon style={{marginRight: 3}} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>工龄</Text>
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
                        placeholder={GLOBAL.editbasic.workingyears} style={{ height: 16, flex: 1, color: '#000', fontSize: 15, padding: 0, }}></TextInput>
                    <TouchableOpacity onPress={() => this.clearname()} style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Image style={{ width: 18, height: 18 }} source={require('../../assets/personal/error.png')}></Image>
                        <Text style={{ color: '#999', fontSize: 15, marginLeft: 5 }}>年</Text>
                    </TouchableOpacity>
                </View>
            </View>
        )
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
    componentDidMount() {
        this.props.navigation.setParams({ navigatePress: this.editname.bind(this) })
    }
    editname() {
        GLOBAL.editbasic.workingyears = this.state.inputValue
        this.props.navigation.state.params.callback()
        this.props.navigation.goBack()
    }
}
const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#ebebeb',
    },
})