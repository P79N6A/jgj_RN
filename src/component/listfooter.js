/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 10:38:20 
 * @Module:尾布局
 * @Last Modified time: 2019-03-29 10:38:20 
 */
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    ScrollView,
    TouchableOpacity,
    Platform,
    FlatList,
    RefreshControl,
    Animated,
    ActivityIndicator
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";

export default class Footer extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            <View>
            {
                this.props.ifLoadingMore?(
                    <View style={{flexDirection:"row",alignItems:"center",justifyContent:"center",marginTop:20,marginBottom:20}}>
                        {/* 小号的加载指示器 */}
                        <ActivityIndicator
                            animating={this.state.animating}
                            size="small"
                            color='#666'
                            />
                        <Text style={{color:"#000",fontSize:14,marginLeft:10}}>正在加载</Text>
                    </View>
                ):false
            }
            {
                this.props.overList?(
                    <View style={{flexDirection:"row",alignItems:"center",justifyContent:"center",marginTop:20,marginBottom:20}}>
                        <View style={{width:100,height:.5,backgroundColor:'#666'}}></View>
                        <Text style={{fontSize:14,color:"#666",marginLeft:10,marginRight:10}}>没有更多了</Text>
                        <View style={{width:100,height:.5,backgroundColor:'#666'}}></View>
                    </View>
                ):false
            }
                
            </View>
        )
    }
}