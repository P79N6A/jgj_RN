/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-04-04 16:26:13 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-04 17:50:58
 * Module:已实名、已认证、突击队弹框
 */

import React, { Component } from 'React'
import { View, Text, Image, StyleSheet, TouchableOpacity, Modal } from 'react-native'
import Icon from "react-native-vector-icons/Ionicons";
export default class bottomalert extends Component {
    constructor(props) {
        super(props)
        this.state = {
        }
    }
    render() {
        param = this.props.param
        return (
            <Modal visible={this.props.ifOpenAlert}
                animationType="none"//从底部划出
                transparent={true}//透明蒙层
                onRequestClose={() => this.props.alertFunr()}//点击返回的回调函数
                style={{ height: '100%' }}
            >
                <TouchableOpacity 
                onPress={()=>this.props.alertFunr()}
                style={{ flex: 1, backgroundColor: 'rgba(0,0,0,.5)',flexDirection:'row',justifyContent:'center',alignItems:'center'}}>
                    {/* 弹窗内容 */}
                    {
                        this.props.param == 'sm'?(
                            <View style={{backgroundColor:'#fff',borderRadius:7.7,overflow:'hidden',width:300}}>
                                <View style={{padding:16.5}}>
                                    <Text style={{color:'#68d672',fontSize:18.7,lineHeight:28.1,textAlign:'center'}}>该用户已通过实名认证</Text>
                                    <Text style={{marginTop:8.8,color:'#666',fontSize:15.4,lineHeight:23.1}}>平台已验证其身份证真实性</Text>
        
                                    <View style={{marginTop:22}}>
                                        <View 
                                        style={{marginBottom:11,flexDirection:'row',
                                        alignItems:'center',justifyContent:'space-around'}}>
                                            <View style={{width:50,height:2,backgroundColor:'#ebebeb'}}></View>
                                            <Text style={{fontSize:14.3,color:'#000',lineHeight:21.5,fontWeight:'700'}}>通过实名认证的好处</Text>
                                            <View style={{width:50,height:2,backgroundColor:'#ebebeb'}}></View>
                                        </View>
        
                                        <View style={{flexDirection:'row',alignItems:'center',height:33}}>
                                            <View style={{width:6,height:6,borderRadius:3,backgroundColor:'#000',marginLeft:8,marginRight:8}}></View>
                                            <Text style={{color:'#000',fontSize:16.5}}>可联系招工找活</Text>
                                        </View>
        
                                        <View style={{flexDirection:'row',alignItems:'center',height:33}}>
                                            <View style={{width:6,height:6,borderRadius:3,backgroundColor:'#000',marginLeft:8,marginRight:8}}></View>
                                            <Text style={{color:'#000',fontSize:16.5}}>有利于找回账号</Text>
                                        </View>
        
                                        <View style={{flexDirection:'row',alignItems:'center',height:33}}>
                                            <View style={{width:6,height:6,borderRadius:3,backgroundColor:'#000',marginLeft:8,marginRight:8}}></View>
                                            <Text style={{color:'#000',fontSize:16.5}}>提高账户安全性</Text>
                                        </View>
                                    </View>
                                </View>
        
                                {/* 按钮 */}
                                <View style={{flexDirection:'row',alignItems:'center',
                                borderTopWidth:1.5,borderTopColor:'#ebebeb',height:48,backgroundColor:'#fafafa',}}>
                                    <TouchableOpacity 
                                    onPress={()=>this.props.alertFunr()}
                                    style={{flexDirection:'row',alignItems:'center',justifyContent:'center',
                                    borderRightWidth:1,borderRightColor:'#ebebeb',width:'50%',height:'100%'}}>
                                        <Text style={{color:'#000',fontSize:16.5}}>我知道了</Text>
                                    </TouchableOpacity>
                                    <TouchableOpacity 
                                    style={{flexDirection:'row',alignItems:'center',justifyContent:'center',flex:1,height:'100%'}}>
                                        <Text style={{color:'#eb4e4e',fontSize:16.5}}>我也去认证</Text>
                                    </TouchableOpacity>
                                </View>
                            </View>
                        
                        ):(
                            this.props.param == 'rz'?(
                                <View style={{backgroundColor:'#fff',borderRadius:7.7,overflow:'hidden',width:300}}>
                                <View style={{padding:16.5}}>
                                    <Text style={{color:'#68d672',fontSize:18.7,lineHeight:28.1,textAlign:'center'}}>该用户已通过工人和班组长认证</Text>
                                    <Text style={{marginTop:8.8,color:'#666',fontSize:15.4,lineHeight:23.1}}>平台已验证其身份证真实性</Text>
                                    <Text style={{marginTop:8.8,color:'#666',fontSize:15.4,lineHeight:23.1}}>平台已验证其身份证与真人对比照片</Text>
                                    <Text style={{marginTop:8.8,color:'#666',fontSize:15.4,lineHeight:23.1}}>平台已验证其在本平台未被曝光</Text>
        
                                    <View style={{marginTop:22}}>
                                        <View 
                                        style={{marginBottom:11,flexDirection:'row',
                                        alignItems:'center',justifyContent:'space-around'}}>
                                            <View style={{width:40,height:2,backgroundColor:'#ebebeb'}}></View>
                                            <Text style={{fontSize:14.3,color:'#000',lineHeight:21.5,fontWeight:'700'}}>通过工人/班组长认证的好处</Text>
                                            <View style={{width:40,height:2,backgroundColor:'#ebebeb'}}></View>
                                        </View>
        
                                        <View style={{flexDirection:'row',alignItems:'center',height:33}}>
                                            <View style={{width:6,height:6,borderRadius:3,backgroundColor:'#000',marginLeft:8,marginRight:8}}></View>
                                            <Text style={{color:'#000',fontSize:16.5}}>大大提高你的可信度</Text>
                                        </View>
        
                                        <View style={{flexDirection:'row',alignItems:'center',height:33}}>
                                            <View style={{width:6,height:6,borderRadius:3,backgroundColor:'#000',marginLeft:8,marginRight:8}}></View>
                                            <Text style={{color:'#000',fontSize:16.5}}>优先匹配工作/项目</Text>
                                        </View>
        
                                        <View style={{flexDirection:'row',alignItems:'center',height:33}}>
                                            <View style={{width:6,height:6,borderRadius:3,backgroundColor:'#000',marginLeft:8,marginRight:8}}></View>
                                            <Text style={{color:'#000',fontSize:16.5}}>获得广告宣传等高级服务</Text>
                                        </View>
                                    </View>
                                </View>
        
                                {/* 按钮 */}
                                <View style={{flexDirection:'row',alignItems:'center',
                                borderTopWidth:1.5,borderTopColor:'#ebebeb',height:48,backgroundColor:'#fafafa',}}>
                                    <TouchableOpacity 
                                    onPress={()=>this.props.alertFunr()}
                                    style={{flexDirection:'row',alignItems:'center',justifyContent:'center',
                                    borderRightWidth:1,borderRightColor:'#ebebeb',width:'50%',height:'100%'}}>
                                        <Text style={{color:'#000',fontSize:16.5}}>我知道了</Text>
                                    </TouchableOpacity>
                                    <TouchableOpacity 
                                    style={{flexDirection:'row',alignItems:'center',justifyContent:'center',flex:1,height:'100%'}}>
                                        <Text style={{color:'#eb4e4e',fontSize:16.5}}>我也去认证</Text>
                                    </TouchableOpacity>
                                </View>
                            </View>
                        
                            ):(
                                <View style={{backgroundColor:'#fff',borderRadius:7.7,overflow:'hidden',width:300}}>
                                <View style={{padding:16.5}}>
                                    <Text style={{color:'#68d672',fontSize:18.7,lineHeight:28.1,textAlign:'center'}}>该用户已通过突击队认证</Text>
                                    <Text style={{marginTop:8.8,color:'#666',fontSize:15.4,lineHeight:23.1}}>平台已验证其身份证真实性</Text>
                                    <Text style={{marginTop:8.8,color:'#666',fontSize:15.4,lineHeight:23.1}}>平台已验证其身份证与真人对比照片</Text>
        
                                    <View style={{marginTop:22}}>
                                        <View 
                                        style={{marginBottom:11,flexDirection:'row',
                                        alignItems:'center',justifyContent:'space-around'}}>
                                            <View style={{width:50,height:2,backgroundColor:'#ebebeb'}}></View>
                                            <Text style={{fontSize:14.3,color:'#000',lineHeight:21.5,fontWeight:'700'}}>通过此认证的好处</Text>
                                            <View style={{width:50,height:2,backgroundColor:'#ebebeb'}}></View>
                                        </View>
        
                                        <View style={{flexDirection:'row',alignItems:'center',height:33}}>
                                            <View style={{width:6,height:6,borderRadius:3,backgroundColor:'#000',marginLeft:8,marginRight:8}}></View>
                                            <Text style={{color:'#000',fontSize:16.5}}>可优先联系突击队工作</Text>
                                        </View>
        
                                        <View style={{flexDirection:'row',alignItems:'center',height:33}}>
                                            <View style={{width:6,height:6,borderRadius:3,backgroundColor:'#000',marginLeft:8,marginRight:8}}></View>
                                            <Text style={{color:'#000',fontSize:16.5}}>招工方可通过"找突击队"直接找到</Text>
                                        </View>
                                        <Text style={{color:'#000',fontSize:16.5}}>你</Text>

                                        <Text style={{marginTop:11,color:'#ff8a00',fontSize:14.3,lineHeight:21.5}}>
                                            为了简历完善可靠的招工找活系统，并增强你的账户安全性，申请突击队认证前需先通过实名认证
                                        </Text>
                                    </View>
                                </View>
        
                                {/* 按钮 */}
                                <View style={{flexDirection:'row',alignItems:'center',
                                borderTopWidth:1.5,borderTopColor:'#ebebeb',height:48,backgroundColor:'#fafafa',}}>
                                    <TouchableOpacity 
                                    onPress={()=>this.props.alertFunr()}
                                    style={{flexDirection:'row',alignItems:'center',justifyContent:'center',
                                    borderRightWidth:1,borderRightColor:'#ebebeb',width:'50%',height:'100%'}}>
                                        <Text style={{color:'#000',fontSize:16.5}}>我知道了</Text>
                                    </TouchableOpacity>
                                    <TouchableOpacity 
                                    style={{flexDirection:'row',alignItems:'center',justifyContent:'center',flex:1,height:'100%'}}>
                                        <Text style={{color:'#eb4e4e',fontSize:16.5}}>去实名认证</Text>
                                    </TouchableOpacity>
                                </View>
                            </View>
                        
                            )
                        )
                    }
                </TouchableOpacity>
            </Modal>
        )
    }
}