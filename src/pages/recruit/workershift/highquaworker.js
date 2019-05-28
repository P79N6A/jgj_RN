/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-25 11:11:23 
 * @Module:工人/班组-优质工人
 * @Last Modified time: 2019-03-25 11:11:23 
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
    RefreshControl
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../../component/listitem'
import Footer from '../../../component/listfooter'
import Header from '../../../component/listheader'
import * as _ from "lodash";

export default class hiriingrecord extends Component {
    constructor(props) {
        super(props)
        //当前页
        this.page = 1
        this.isFresh=false
        //状态
        this.state = {
            // 列表数据结构
            dataSource: [
                { key: 0, name: '龚虎' },
                { key: 1, name: '罗平' },
                { key: 2, name: '峰哥' },
            ],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,
        }
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, {trailing: false});
    }
    componentWillMount() {
        this.setState({
            navigate: this.props.navigation//页面跳转需要
        })
    }
    render() {
        return (
            <View style={{ flex: 1 }}>
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header navigate={this.state.navigate} />}//头布局
                    renderItem={({item}) => <List data={item} navigate={this.state.navigate}/>}//item显示的布局
                    ListFooterComponent={() => <Footer navigate={this.state.navigate} />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => setTimeout(()=>{this._onLoadMore()},500)}//加载更多//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                    onContentSizeChange={()=>this.onContentSizeChange}
                />
            </View>
        )
    }
    // 获取数据事件
    _getHotList() {
        this.state.isLoadMore = true
        fetch("http://m.app.haosou.com/index/getData?type=1&page=" + this.page)
            .then((response) => response.json())
            .then((responseJson) => {
                console.log(responseJson)
                if (this.page === 1) {
                    console.log("重新加载")
                    this.setState({
                        isLoadMore: false,
                        dataSource: responseJson.list
                    })
                } else {
                    console.log("加载更多")
                    this.setState({
                        isLoadMore: false,
                        // 数据源刷新 add
                        dataSource: this.state.dataSource.concat(responseJson.list)
                    })
                    if (this.page <= 3) {
                        this.setState({
                            showFoot: 1
                        })
                    } else if (this.page > 3) {
                        this.setState({
                            showFoot: 2
                        })
                    }
                }


            })
            .catch((error) => {
                console.error(error);
            });
    }
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            // this._getHotList()
        }
    };
    onContentSizeChange=()=>{
        this.isFresh=true;
    }
    componentWillUnmount() {
        this.loadMoreDataThrottled.cancel();
    }
    // 加载更多
    _onLoadMore() {
        // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
        if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
            this.page = this.page + 1
            // this._getHotList()
        }
    }
}
//空布局
class Empty extends React.Component{
    constructor(props) {
        super(props)
        this.state = {}
    }
    render(){
        return(
            <View style={{ flex: 1, }}>
                <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                    <Image style={{width:80,height:46}} source={{uri:`${GLOBAL.server}public/imgs/icon/book.png`}}></Image>

                </View>
                <Text style={styles.font}>优质工人数据为空</Text>
            </View>
        )
    }
}
// item布局
class List extends React.Component{
    constructor(props) {
        super(props)
        this.state = {}
    }
    render(){
        const item = this.props.data
        return(
            <TouchableOpacity activeOpacity={0.5} onPress={() => this.props.navigate.navigate('Preview')}>
                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginTop: 11,
                    backgroundColor: '#fff',
                    paddingLeft: 13,
                    paddingTop: 13,
                    paddingBottom: 13,
                    paddingRight: 5.5,
                }}>
                    <View style={{ width: '100%' }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{
                                backgroundColor: 'rgb(114, 102, 202)', flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                borderRadius: 4.4, width: 49, height: 49, marginRight: 20
                            }}>
                                <Text style={{ color: '#fff', fontSize: 17.6 }}>{item.name}</Text>
                            </View>
                            <View style={{ flex: 1 }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 17.6 }}>{item.name}</Text>
                                        <Image style={{width:51,height:18,marginLeft:8}} source={require('../../../assets/recruit/verified.png')}></Image>
                                        <Image style={{width:51,height:18,marginLeft:8}} source={require('../../../assets/recruit/group-verified.png')}></Image>
                                        <Image style={{width:51,height:18,marginLeft:8}} source={require('../../../assets/recruit/commando-verified.png')}></Image>
                                    </View>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', marginRight: 15 }}>
                                    <Icon name="place" size={15} color="#BFBFBF" />
                                        <Text style={{ color: '#666', fontSize: 13.2, marginLeft: 5 }}>广元</Text>
                                    </View>
                                </View>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <Text style={{ color: '#666', fontSize: 13.2 }}>汉族  中级工（中工）</Text>
                                    <Icon style={{ marginRight: 5}} name="r-arrow" size={12} color="#000" />
                                </View>
                            </View>
                        </View>

                        <View style={{ flexDirection: 'row', flexWrap: 'wrap', marginTop: 3 }}>
                            <View style={{
                                marginTop: 4.4, marginRight: 6.6, backgroundColor: '#eee', paddingLeft: 4.4, paddingRight: 4.4,
                                paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                            }}>
                                <Text style={{ color: '#666', fontSize: 13.2 }}>机械操作</Text>
                            </View>
                            <View style={{
                                marginTop: 4.4, marginRight: 6.6, backgroundColor: '#eee', paddingLeft: 4.4, paddingRight: 4.4,
                                paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                            }}>
                                <Text style={{ color: '#666', fontSize: 13.2 }}>消防</Text>
                            </View>

                            <View style={{
                                marginTop: 4.4, marginRight: 6.6, paddingLeft: 4.4, paddingRight: 4.4,
                                paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                            }}>
                                <Text style={{ color: '#000', fontSize: 13.2 }}>水电工 | 司机</Text>
                            </View>
                        </View>

                        <View style={{ flexDirection: 'row', flexWrap: 'wrap', marginTop: 6.6 }}>
                            <Text style={{ color: '#999', fontSize: 13.2 }}>我是来自湖南的小将，从事专业铝膜从原厂瓶装到工地施工多年，又丰富的工作经验</Text>
                        </View>

                        <View style={{
                            marginTop: 6.6, borderWidth: 1, borderColor: '#dbdbdb', borderRadius: 4.4,
                            paddingLeft: 11, paddingRight: 11, paddingTop: 5.5, paddingBottom: 5.5
                        }}>
                            <Text style={{ color: '#000', height: 15.4, height: 23 }}>兔兔</Text>
                            <Text style={{ color: '#666', height: 15.4, height: 23, marginTop: 2.2 }}>突突</Text>
                            <View style={{ flexDirection: 'row', overFlow: 'hidden' }}>
                                <Image style={{ width: 90, height: 90, marginRight: 5.5, marginBottom: 5.5 }} source={require('../../../assets/recruit/img.jpg')}></Image>
                                <Image style={{ width: 90, height: 90, marginRight: 5.5, marginBottom: 5.5 }} source={require('../../../assets/recruit/img.jpg')}></Image>
                                <Image style={{ width: 90, height: 90, marginRight: 5.5, marginBottom: 5.5 }} source={require('../../../assets/recruit/img.jpg')}></Image>
                                <Image style={{ width: 90, height: 90, marginRight: 5.5, marginBottom: 5.5 }} source={require('../../../assets/recruit/img.jpg')}></Image>
                                <Image style={{ width: 90, height: 90, marginRight: 5.5, marginBottom: 5.5 }} source={require('../../../assets/recruit/img.jpg')}></Image>
                            </View>
                        </View>
                    </View>
                </View>
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