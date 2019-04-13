/*
 * @Author: stl
 * @Date: 2019-03-15 09:41:44 
 * @Module:自我介绍提示弹框
 * @Last Modified time: 2019-03-15 09:41:44 
 */
import React, { Component } from 'React'
import { View, Text, Image, StyleSheet, TouchableOpacity, Modal,ScrollView } from 'react-native'
import Icon from "react-native-vector-icons/Ionicons";
export default class bottomalert extends Component {
    constructor(props) {
        super(props)
        this.state = {
            issl:true,//示例一还是示例二控制
        }
    }
    render() {
        return (
            <Modal visible={this.props.orbottomalert}
                animationType="none"//从底部划出
                transparent={true}//透明蒙层
                style={{ height: '100%', }}
            >
                <View style={{flexDirection:'row',alignItems:'center',justifyContent:'center',flex: 1, backgroundColor: 'rgba(0,0,0,.5)'}}>
                    <View style={{width:300,height:280,backgroundColor:'#fff',borderRadius:4.5}}>
                        {/* header */}
                        <View style={{height:33,paddingRight:6,flexDirection:'row',justifyContent:'flex-end',alignItems:'center'}}>
                            <TouchableOpacity onPress={()=>this.props.close()}>
                            <Image style={{width:22,height:22}} source={require('../assets/personal/error.png')}></Image>
                            </TouchableOpacity>
                        </View>
                        {/* title */}
                        <View style={{flexDirection:'row',alignItems:'center',justifyContent:'center'}}>
                            <TouchableOpacity onPress={()=>this.setState({issl:!this.state.issl})} 
                                style={{marginRight:22,
                                borderBottomWidth:1.1,borderBottomColor:this.state.issl?'rgb(235, 78, 78)':'#fff',
                                flexDirection:'row',alignItems:'center',justifyContent:'center'}}>
                                <Text style={{color:this.state.issl?'rgb(235, 78, 78)':'#999',fontSize:19,}}>示例1</Text>
                            </TouchableOpacity>
                            
                            <TouchableOpacity onPress={()=>this.setState({issl:!this.state.issl})}
                                 style={{marginRight:22,
                                borderBottomWidth:1.1,borderBottomColor:!this.state.issl?'rgb(235, 78, 78)':'#fff',
                                flexDirection:'row',alignItems:'center',justifyContent:'center'}}>
                                <Text style={{color:!this.state.issl?'rgb(235, 78, 78)':'#999',fontSize:19,}}>示例2</Text>
                            </TouchableOpacity>
                        </View>
                        {/* 介绍示例文本 */}
                        <View style={{padding:15,}}>
                              <ScrollView style={{height:170}}>
                                  {
                                      this.state.issl?(
                                          <Text style={{color:'#3d4145',fontSize:18,lineHeight:28}}>我叫张三，来自陕西西安，从事电工工作已经15年了，有国家颁发的特种行业操作资格证书，主要从事建筑工地的用电安装和管理，能快速安全的处理施工过程中突发的各种电路事故，能独立操作各种配电的安装和管理。</Text>
                                      ):(
                                        <Text style={{color:'#3d4145',fontSize:18,lineHeight:28}}>我叫李四，来自河南郑州，从事焊工工作已经10年了，有国家颁发的特种行业操作资格证二级证书，主要从事幕墙龙骨的焊接和管道的焊接工作，经我电焊的龙骨，经探伤检测全部合格。焊缝无气孔，夹渣，弧坑，裂纹，电弧檫伤等。而且在很多创杯工程中，获得专家的一致好评。焊龙骨一般一天焊一包3.2的焊条。</Text>
                                      )
                                  }
                                </ScrollView>      
                        </View>
                    </View>
                </View>
            </Modal>
        )
    }
}