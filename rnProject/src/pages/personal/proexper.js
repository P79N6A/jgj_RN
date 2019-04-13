/*
 * @Author: stl
 * @Date: 2019-03-19 14:41:11 
 * @Module:项目经验
 * @Last Modified time: 2019-03-19 14:41:11 
 */

import React, { Component } from 'react';
import {
    ActivityIndicator,
    FlatList,
    Image,
    RefreshControl,
    StyleSheet,
    Text,
    TouchableOpacity,
    View,
    Platform
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
import ListItem from '../../component/listitem'
import Header from '../../component/listheader'


export default class readme extends Component {
    constructor(props) {
        super(props);
        //当前页
        this.page = 1
        //状态
        this.state = {
            // 列表数据结构
            dataSource: [
                { key: 0 },
                { key: 1 },
                { key: 2 },
            ],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,
        }
    }

    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });

    render() {
        return (
            <View style={styles.container}>
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>项目经验</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header />}//头布局
                    renderItem={({item}) => <List data={item}/>}//item显示的布局
                    ListFooterComponent={() => <Footer />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => this._onLoadMore()}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                />
            </View>
        );
    }

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
    // 加载更多
    _onLoadMore() {
        // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
        if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
            this.page = this.page + 1
            this._getHotList()
        }
    }
}
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
                    <Icon name="note" size={45} color="#999999" />
                </View>
                <Text style={{
                    color: '#999',
                    fontSize: 15,
                    textAlign: 'center',
                }}>数据为空</Text>
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
            <View>
                <View style={{ paddingLeft: 26, paddingRight: 26 }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Image style={{ width: 14, height: 14, marginRight: 14 }} source={require('../../assets/personal/sj.png')}></Image>
                        <Text style={{ color: '#333', fontSize: 17.6, height: 26, marginTop: 5.5, marginBottom: 5.5, marginLeft: 5 }}>项目名称</Text>
                    </View>
                    <View style={{
                        borderLeftWidth: 2,
                        borderLeftColor: '#d7262b',
                        marginBottom: 7,
                        paddingLeft: 17, marginLeft: 7,
                    }}>
                        <View style={{ flexDirection: 'row', alignItems: "center", justifyContent: 'space-between', paddingLeft: 10 }}>
                            <View style={{ flexDirection: 'row', alignItems: "center" }}>
                                <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>2019-03</Text>
                                <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>四川省  成都市</Text>
                            </View>
                            <TouchableOpacity onPress={() => this.props.navigation.navigate('Updateproject')} style={styles.btns}>
                                <Text style={styles.btnfont}>编辑</Text>
                            </TouchableOpacity>
                        </View>
                        <View style={{ flexWrap: 'wrap', marginLeft: 5.2, marginTop: 5.2, flexDirection: 'row', marginBottom: 20 }}>
                            <Image style={{ width: 114, height: 114 }} source={require('../../assets/personal/img.jpg')}></Image>
                        </View>
                        <View style={{
                            paddingLeft: 11, paddingRight: 11, paddingTop: 15, paddingBottom: 15,
                            backgroundColor: '#ebebeb', borderRadius: 4.4, marginLeft: 10
                        }}>
                            <Text style={{ color: '#999', fontSize: 15.4 }}>项目描述</Text>
                        </View>
                    </View>
                </View>
            </View>
        )
    }
}
// 尾布局
class Footer extends React.Component{
    constructor(props) {
        super(props)
        this.state = {}
    }
    render(){
        return(
            <View>
                <View style={{ flexDirection: 'row', alignItems: 'center' ,paddingLeft: 26,}}>
                    <View style={{ width: 14, height: 14, marginRight: 14, backgroundColor: '#d7262b', borderRadius: 14 }}></View>
                    <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>没有更多了</Text>
                </View>
            </View>
        )
    }
}
const styles = StyleSheet.create({
    btns: {
        width: 50,
        height: 25,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        borderWidth: 1,
        borderColor: '#eb4e4e',
        borderRadius: 4.4,
    },
    btnfont: {
        color: '#eb4e4e',
        fontSize: 13.2,
    },
    container: {
        flex: 1,
        backgroundColor: '#fff',
    },
    bg: {
        height: 479,
        backgroundColor: 'rgb(85,65,190)'
    },
    lanmu: {
        marginTop: 4.5,
        marginBottom: 4.5,
        flexDirection: 'row',
        alignItems: 'flex-start',

    },
    fontl: {
        color: "#999",
        fontSize: 15.4
    },
    fontr: {
        color: "#000",
        fontSize: 15.4
    },
    fontrs: {
        color: "#000",
        fontSize: 15.4,
        flexWrap: 'wrap',
        width: 280,
    },
    tit: {
        marginLeft: 22,
        marginRight: 22,
        marginTop: 11,
        marginBottom: 4.5,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center'
    },
    titfont: {
        color: '#000',
        fontSize: 18.7,
        fontWeight: '700',
        marginLeft: 11,
        marginRight: 11,
    },
    a: {
        width: 3,
        height: 13,
        borderRadius: 2,
        marginRight: 2,
        backgroundColor: '#fa6ba2',
        transform: [{ rotate: '15deg' }]
    },
    b: {
        width: 3,
        height: 13,
        borderRadius: 2,
        marginRight: 2,
        backgroundColor: '#efbb59',
        transform: [{ rotate: '15deg' }]
    },
    viewfont: {
        paddingLeft: 22,
        paddingRight: 22,
        paddingTop: 11,
        paddingBottom: 11,
        flexDirection: 'row',
        justifyContent: "center",
        flexWrap: 'wrap',
    },
    font: {
        color: '#000',
        fontSize: 15.4,
    },
});