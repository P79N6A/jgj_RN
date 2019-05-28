/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 10:38:20 
 * @Module:空布局
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
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";

export default class Empty extends React.Component{
    constructor(props) {
        super(props)
        this.state = {}
    }
    render(){
        return(
            <View style={{flex:1}}>
                {
                    !this.props.ifLoadingMore?(
                        <View>
                            <View style={{ marginBottom: 21, marginTop: 120, flexDirection: 'row', justifyContent: 'center' }}>
                                <Image style={{width:80,height:46}} source={{uri:`${GLOBAL.server}public/imgs/icon/book.png`}}></Image>
                            </View>
                            <Text style={{
                                color: '#999',
                                fontSize: 15,
                                textAlign: 'center',
                            }}>数据为空</Text>
                        </View>
                    ):false
                }
            </View>
        )
    }
}