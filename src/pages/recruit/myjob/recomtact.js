/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-22 17:12:31 
 * @Module:系统推荐 or 联系过我
 * @Last Modified time: 2019-03-22 17:12:31 
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    ScrollView,
    TouchableOpacity,
    FlatList,
    RefreshControl
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../../component/listitem'
import Header from '../../../component/listheader'
import Footer from '../../../component/listfooter'

export default class lookworker extends Component {
    constructor(props) {
        super(props)
        this.page = 1//当前页
        this.state = {
            ///////////////系统推荐///////////////
            // 列表数据结构
            dataSource: [
                { key: 0, name: '余明' },
                { key: 1, name: '王银' },
                { key: 2, name: '陈夫' },
            ],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,
            ///////////////联系过我///////////////
            // 列表数据结构
            dataSourceb: [],
            // 下拉刷新
            isRefreshb: false,
            // 加载更多
            isLoadMoreb: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFootb: 1,

            selectone: true,//系统推荐 or 联系过我
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
                <View style={{ height: 40, backgroundColor: '#fff', position: 'relative', flexDirection: 'row', alignItems: 'center', justifyContent: "space-between" }}>
                    <TouchableOpacity style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{marginRight: 3}} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{
                        backgroundColor: '#eb4e4e', width: 160, height: 29, borderRadius: 3.3,
                        borderWidth: 1, borderColor: '#eb4e4e', flexDirection: 'row'
                    }}>
                        <TouchableOpacity onPress={() => this.setState({ selectone: true })} style={{
                            width: '50%', height: '100%',
                            backgroundColor: this.state.selectone?'#eb4e4e':'#fff',
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 3.3
                        }}>
                            <Text style={{ fontWeight: '400', fontSize: 15.4, color: this.state.selectone?'#fff':'#eb4e4e' }}>系统推荐</Text>
                        </TouchableOpacity>
                        <TouchableOpacity onPress={() => this.setState({ selectone: false })} style={{
                            width: '50%', height: '100%', backgroundColor: this.state.selectone?'#fff':'#eb4e4e',
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 3.3
                        }}>
                            <Text style={{ fontWeight: '400', fontSize: 15.4, color: this.state.selectone?'#eb4e4e':'#fff' }}>联系过我</Text>
                        </TouchableOpacity>
                    </View>
                    <View style={{ width: '25%', height: '100%', marginRight: 10 }}></View>
                </View>
                {
                    this.state.selectone ? (
                        <ListItem
                            data={this.state.dataSource}
                            ListHeaderComponent={() => <Header />}//头布局
                            renderItem={({item}) => <List data={item} navigation={this.props.navigation}/>}//item显示的布局
                            ListFooterComponent={() => <Footer />}//尾布局
                            ListEmptyComponent={() => <Empty />}// 空布局
                            onEndReached={() => setTimeout(()=>{this._onLoadMore()},500)}//加载更多
                            onRefresh={() => this._onRefresh()}//下拉刷新相关
                            onContentSizeChange={()=>this.onContentSizeChange}
                        />
                    ) : (
                        <ListItem
                        data={this.state.dataSourceb}
                        ListHeaderComponent={() => <Header />}//头布局
                        renderItem={({item}) => <Listb data={item} navigation={this.props.navigation}/>}//item显示的布局
                        ListFooterComponent={() => <Footer />}//尾布局
                        ListEmptyComponent={() => <Emptyb />}// 空布局
                        onEndReached={() => setTimeout(()=>{this._onLoadMore()},500)}//加载更多
                        onRefresh={() => this._onRefreshb()}//下拉刷新相关
                        onContentSizeChange={()=>this.onContentSizeChange}
                        />
                        )
                }

            </View>
        )
    }
    /////////////////////////系统推荐/////////////////////////////
    // 获取数据列表
    _getHotList() {
        this.state.isLoadMore = true
        // fetch("http://m.app.haosou.com/index/getData?type=1&page=" + this.page)
        //     .then((response) => response.json())
        //     .then((responseJson) => {
        //         console.log(responseJson)
        //         if (this.page === 1) {
        //             console.log("重新加载")
        //             this.setState({
        //                 isLoadMore: false,
        //                 dataSource: responseJson.list
        //             })
        //         } else {
        //             console.log("加载更多")
        //             this.setState({
        //                 isLoadMore: false,
        //                 // 数据源刷新 add
        //                 dataSource: this.state.dataSource.concat(responseJson.list)
        //             })
        //             if (this.page <= 3) {
        //                 this.setState({
        //                     showFoot: 1
        //                 })
        //             } else if (this.page > 3) {
        //                 this.setState({
        //                     showFoot: 2
        //                 })
        //             }
        //         }


        //     })
        //     .catch((error) => {
        //         console.error(error);
        //     });
    }
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            this._getHotList()
        }
    };
    onContentSizeChange=()=>{
        this.isFresh=true;
    }
    // 加载更多
    _onLoadMore() {
        if (this.isFresh) {
            this.setState({
                ifFetchMore: false,
            }, () => {
                // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
                if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
                    console.log('-----------------加载更多----------------')
                    this.page = this.page + 1
                    this.isFresh=false;
                    this._getHotList()
                }
            })
        }
    }
    componentWillUnmount() {
        this.loadMoreDataThrottled.cancel();
    }


    /////////////////////////联系过我/////////////////////////////
    // 获取数据列表
    _getHotListb() {
        this.state.isLoadMore = true
        // fetch("http://m.app.haosou.com/index/getData?type=1&page=" + this.page)
        //     .then((response) => response.json())
        //     .then((responseJson) => {
        //         console.log(responseJson)
        //         if (this.page === 1) {
        //             console.log("重新加载")
        //             this.setState({
        //                 isLoadMore: false,
        //                 dataSource: responseJson.list
        //             })
        //         } else {
        //             console.log("加载更多")
        //             this.setState({
        //                 isLoadMore: false,
        //                 // 数据源刷新 add
        //                 dataSource: this.state.dataSource.concat(responseJson.list)
        //             })
        //             if (this.page <= 3) {
        //                 this.setState({
        //                     showFoot: 1
        //                 })
        //             } else if (this.page > 3) {
        //                 this.setState({
        //                     showFoot: 2
        //                 })
        //             }
        //         }


        //     })
        //     .catch((error) => {
        //         console.error(error);
        //     });
    }
    // 下拉刷新
    _onRefreshb = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            this._getHotListb()
        }
    };
    onContentSizeChange=()=>{
        this.isFresh=true;
    }
    // 加载更多
    _onLoadMoreb() {
        if (this.isFresh) {
            this.setState({
                ifFetchMore: false,
            }, () => {
                // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
                if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
                    console.log('-----------------加载更多----------------')
                    this.page = this.page + 1
                    this.isFresh=false;
                    this._getHotListb()
                }
            })
        }
    }
}
/////////////////////////系统推荐/////////////////////////////
// 空布局
class Empty extends React.Component{
    constructor(props) {
        super(props)
        this.state = {}
    }
    render(){
        return(
            <View>
                <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                    <Image style={{width:80,height:46}} source={{uri:`${GLOBAL.server}public/imgs/icon/book.png`}}></Image>

                </View>
                <Text style={styles.font}>暂时还没有工人联系你</Text>
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
            <TouchableOpacity activeOpacity={0.5} onPress={() => this.props.navigation.navigate('Preview')}>
                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginTop: 11,
                    backgroundColor: '#fff',
                    paddingLeft: 13,
                    paddingTop: 13,
                    paddingBottom: 13,
                    paddingRight: 5.5
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
                                    <Icon style={{marginRight: 5}} name="r-arrow" size={12} color="#000" />
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
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: 'center', borderTopWidth: 1, borderTopColor: '#ebebeb', paddingTop: 6, marginTop: 5 }}>
                            <Text style={{ color: '#999', fontSize: 13.2 }}>你有</Text>
                            <Text style={{ color: '#eb4e4e', fontSize: 13.2 }}> 2 </Text>
                            <Text style={{ color: '#999', fontSize: 13.2 }}>个朋友认识他</Text>
                        </View>
                    </View>
                </View>
            </TouchableOpacity>
        )
    }
}
/////////////////////////联系过我/////////////////////////////
// 空布局
class Emptyb extends React.Component{
    constructor(props) {
        super(props)
        this.state = {}
    }
    render(){
        return(
            <View>
                <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                    <Image style={{width:80,height:46}} source={{uri:`${GLOBAL.server}public/imgs/icon/book.png`}}></Image>

                </View>
                <Text style={styles.font}>暂时还没有工人联系你</Text>
            </View>
        )
    }
}
// item布局
class Listb extends React.Component{
    constructor(props) {
        super(props)
        this.state = {}
    }
    render(){
        const item = this.props.data
        return(
            <TouchableOpacity activeOpacity={0.5} onPress={() => this.props.navigation.navigate('Preview')}>
                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginTop: 11,
                    backgroundColor: '#fff',
                    paddingLeft: 13,
                    paddingTop: 13,
                    paddingBottom: 13,
                    paddingRight: 5.5
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
                                        <Image style={{ height: 20, width: 25, marginLeft: 10 }} source={require('../../../assets/recruit/sm.png')}></Image>
                                    </View>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', marginRight: 15 }}>
                                    <Icon name="place" size={15} color="#BFBFBF" />
                                        <Text style={{ color: '#666', fontSize: 13.2, marginLeft: 5 }}>广元</Text>
                                    </View>
                                </View>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <Text style={{ color: '#666', fontSize: 13.2 }}>汉族  中级工（中工）</Text>
                                    <Icon style={{marginRight: 5}} name="r-arrow" size={12} color="#000" />
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
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: 'center', borderTopWidth: 1, borderTopColor: '#ebebeb', paddingTop: 6, marginTop: 5 }}>
                            <Text style={{ color: '#999', fontSize: 13.2 }}>你有</Text>
                            <Text style={{ color: '#eb4e4e', fontSize: 13.2 }}> 2 </Text>
                            <Text style={{ color: '#999', fontSize: 13.2 }}>个朋友认识他</Text>
                        </View>
                    </View>
                </View>
            </TouchableOpacity>
        )
    }
}
const styles = StyleSheet.create({
    main: {
        backgroundColor: '#ebebeb',
        flex: 1
    },
    font: {
        color: '#999',
        fontSize: 15,
        textAlign: 'center',
    },
})