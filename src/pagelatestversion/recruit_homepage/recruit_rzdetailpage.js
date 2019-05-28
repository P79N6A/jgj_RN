

import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, ImageBackground, TouchableNativeFeedback } from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'

import Attest from './recruit_authen/index'

export default class authen extends Component {
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
            <View style={styles.containermain}>
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
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>认证详情</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7} style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                
                <ScrollView style={{paddingLeft:11,paddingRight:11,paddingTop:21,paddingBottom:21,width:'100%'}}>
                    {/* 企业认证说明 */}
                    <View 
                    style={{paddingBottom:21,marginBottom:21,flexDirection:'row',width:'100%',borderBottomColor:'#ebebeb',borderBottomWidth:1}}>
                        <View style={{width:32,paddingLeft:5}}>
                            <Icon name="renzhengshuoming" size={22} color="#eb4e4e" />
                        </View>
                        <View style={{flex:1}}>
                            <Text style={{fontSize:14,color:'#000',lineHeight:21,marginBottom:11}}>企业认证说明</Text>
                            <Text 
                            style={{color:'#999',fontSize:14,lineHeight:21}}>
                            企业认证是集致生活科技对招聘企业所提交的企业信息、资质文件的真实性与合法性进行书面甄别与核实的过程。企业认证有效期为一年。
                            </Text>
                            <Text 
                            style={{color:'#999',fontSize:14,lineHeight:21}}>
                            吉工家是为用户提供建筑行业找工作、找项目的平台，招聘企业的所有行为并不因企业认证成功而具备真实性与合法性，敬请留意甄别。
                            </Text>
                        </View>
                    </View>

                    {/* 企业全称 */}
                    <View 
                    style={{paddingBottom:21,flexDirection:'row',width:'100%',borderBottomColor:'#ebebeb',borderBottomWidth:1}}>
                        <View style={{width:32,paddingLeft:5}}>
                            <Icon name="qiye" size={22} color="#eb4e4e" />
                        </View>
                        <View style={{flex:1}}>
                            <Text 
                            style={{fontSize:14,color:'#000',lineHeight:21,marginBottom:11}}>
                            企业全称
                            </Text>
                            <Text 
                            style={{color:'#999',fontSize:14,lineHeight:21}}>
                            他他他
                            </Text>

                            <Text 
                            style={{fontSize:14,color:'#000',lineHeight:21,marginBottom:11,marginTop:21}}>
                            统一社会信用代码
                            </Text>
                            <Text 
                            style={{color:'#999',fontSize:14,lineHeight:21}}>
                            665821566
                            </Text>

                            <Text 
                            style={{fontSize:14,color:'#000',lineHeight:21,marginBottom:11,marginTop:21}}>
                            经营范围
                            </Text>
                            
                        </View>
                    </View>

                    {/* 认证时间 */}
                    <View 
                    style={{paddingTop:21,flexDirection:'row',width:'100%'}}>
                        <View style={{width:32,paddingLeft:5}}>
                            <Icon name="thin-time" size={22} color="#eb4e4e" />
                        </View>
                        <View style={{flex:1}}>
                            <Text 
                            style={{fontSize:14,color:'#000',lineHeight:21,marginBottom:11}}>
                            认证时间
                            </Text>
                            <Text 
                            style={{color:'#999',fontSize:14,lineHeight:21}}>
                            2018年09月07日
                            </Text>
                        </View>
                    </View>

                </ScrollView>
            </View>
        )
    }

}

const styles = StyleSheet.create({
    containermain: {
        flex: 1,
        backgroundColor: 'white',
        alignItems: 'center',
    },
})