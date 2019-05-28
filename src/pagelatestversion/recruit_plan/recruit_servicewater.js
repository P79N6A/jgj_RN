/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:48:27
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-18 16:17:34
 * Module:服务流水
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    TouchableOpacity,
    AsyncStorage
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../component/listitem'
import Footer from '../../component/listfooter'
import Header from '../../component/listheader'
import fetchFun from '../../fetch/fetch'
import ImageCom from '../../component/imagecom';
import Images from '../../component/images';
import AlertUser from '../../component/alertuser'
import Thelabel from '../../component/thelabel'
import * as _ from "lodash";

export default class hiriingrecord extends Component {
    constructor(props) {
        super(props)
        //当前页
        this.page = 1
        this.pagesize = 10
        this.isFresh=false
        //状态
        this.state = {
            // 列表数据结构
            dataSource: [],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,

            // ----------实名or认证、突击弹框----------
            ifOpenAlert: false,//是否打开弹框
            param: '',//实名or认证、突击
            // ---------------------------------------

            ifFetchMore: false,
            ifLoadingMore: true,//是否显示加载更多加载框
            overList: false,//没有可以加载的数据

            dataStroage:[],//上一次请求的数据暂存处
        }
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, {trailing: false});
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
    });
    componentWillMount() {
        this._getHotList()// 优质工人列表数据获取
    }
    _getHotList(e) {
        let { dataSource } = this.state
        fetchFun.load({
            url: 'v2/Project/serviceFlow',
            noLoading: true,//不显示自定义加载框
            type: 'GET',
            data: {
                pg: this.page,
                pagesize: this.pagesize,
                kind:'recruit'
            },
            success: (res) => {
                console.log('---服务流水---', res)
                this.setState({
                    dataStroage:res,
                    // dataSource: dataSource.concat(res),
                    dataSource: e == 'refresh' ? res : dataSource.concat(res),
                    // dataSource: e == 'refresh' ? res : (this.state.dataStroage == res?this.state.dataSource:dataSource.concat(res)),
                    ifFetchMore: true,
                    ifLoadingMore: res.length < 10 ? false : true,//隐藏正在加载效果
                    overList: res.length < 10 && !(this.state.dataSource.length == 0 && res.length == 0) ? true : false
                })
            }
        });
    }
    render() {
        return (
            <View style={{ backgroundColor: '#fff', flex: 1 }}>
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                                      onPress={() => {this.props.navigation.goBack(),this.props.navigation.state.params.callback()}}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>服务流水</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7} style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header />}//头布局
                    renderItem={({ item }) => <List data={item} navigate={this.props.navigate} />}//item显示的布局
                    ListFooterComponent={() => <Footer ifLoadingMore={this.state.ifLoadingMore} overList={this.state.overList} />}//尾布局
                    ListEmptyComponent={() => <Empty ifLoadingMore={this.state.ifLoadingMore} />}// 空布局
                    onEndReached={() => setTimeout(()=>{this._onLoadMore()},500)}//加载更多//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                    onContentSizeChange={()=>this.onContentSizeChange}
                />
            </View>
        )
    }

    onContentSizeChange=()=>{
        this.isFresh=true;
    }
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            this._getHotList(refresh = 'refresh')
        }
    };

    // 加载更多
    _onLoadMore() {
        if (this.isFresh && this.state.ifLoadingMore) {
            this.setState({
                ifFetchMore: false,
            }, () => {
                // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
                if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
                    console.log('-----------------加载更多1----------------')
                    this.page = this.page + 1
                    this._getHotList()
                }
            })
        }
    }
    componentWillUnmount() {
        this.loadMoreDataThrottled.cancel();
    }
}
//空布局
class Empty extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            !this.props.ifLoadingMore ? (
                <View style={{ height: '100%', }}>
                    <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                        <Image style={{width:80,height:46}} source={{uri:`${GLOBAL.server}public/imgs/icon/book.png`}}></Image>

                    </View>
                    <Text style={styles.font}>暂无记录哦~</Text>
                </View>
            ) : false
        )
    }
}
// item布局
class List extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        // console.log(this.props.data)
        const item = this.props.data
        return (
            <TouchableOpacity activeOpacity={.7} >
                <View style={{backgroundColor:'#fff'}}>
                    <View
                        style={{
                            flexDirection: 'row',
                            alignItems: 'center',
                            justifyContent:'space-between',
                            marginLeft:10,
                            marginRight:10,
                            paddingTop:10,
                            paddingBottom:10,
                            borderBottomWidth:1,
                            borderBottomColor:'#dbdbdb'
                        }}
                    >
                        <View style={{marginRight:10}}>
                            <Text style={{fontSize:14}} className="omit-1">{item.text}</Text>
                            <Text style={{fontSize:12,color:'#999'}}>{item.date}</Text>
                        </View>
                        {Number(item.num !== 0)?
                            <View >
                                <Text
                                    style={{
                                        fontSize:24,
                                        fontWeight: '400',
                                        color:item.num > 0 ? '#eb4e4e' : '#94c17e'
                                    }}
                                >
                                    {item.num > 0 ? '+' : ''}{item.num}
                                    <Text style={{fontSize:12,color:'#999'}}>{item.unit}</Text>
                                </Text>
                            </View>:
                            <Text style={{fontSize:12,color:'#628ae0'}}>赠送</Text>
                        }
                    </View>
                </View>
                {/*

                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    // justifyContent: 'center',
                    marginTop: 5,
                    backgroundColor: '#fff',
                    padding: 10
                }}>
                    <Image source={{ uri: item.logo_url }} style={styles.itemImages} />
                    <Text style={{ marginLeft: 6 }}>
                        {item.baike_name}
                    </Text>
                </View> */}
            </TouchableOpacity>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#ebebeb',
    },
    font: {
        color: '#999',
        fontSize: 15,
        textAlign: 'center',
    },
});