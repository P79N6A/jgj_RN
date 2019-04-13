/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-25 11:05:54 
 * @Module：招聘记录-已收藏劳务
 * @Last Modified time: 2019-03-25 11:05:54 
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
import Icon from "react-native-vector-icons/Ionicons";
import ListItem from '../../component/listitem'
import Header from '../../component/listheader'
import Footer from '../../component/listfooter'
import fetchFun from '../../fetch/fetch'
import ImageCom from '../../component/imagecom';
import Images from '../../component/images';
import Loading from '../../component/loading'

export default class hiriingrecord extends Component {
    constructor(props) {
        super(props)
        //当前页
        this.page = 1
        this.pagesize = 10
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

            openAlert:false,//加载弹框
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    componentWillMount() {
        this.getData()
    }
    // 获取我联系的数据
    getData() {
        fetchFun.load({
            url: 'v2/project/connectedOrCollectionServiceList',
            data: {
                pg: this.page,
                pagesize: this.pagesize,
                type: 1,//1，收藏列表，2，联系过的列表
            },
            success: (res) => {
                console.log('---收藏列表---', res)
                if (res.state == 1) {
                    this.setState({
                        dataSource: res.values
                    })
                }
            }
        });
    }
    render() {
        return (
            <View style={{ backgroundColor: '#fff', flex: 1, }}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>我收藏的</Text>
                    </View>
                    <TouchableOpacity
                        onPress={() => this.ifModalFun()}
                        style={{
                            width: '25%', height: '100%', marginRight: 10,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end'
                        }}>
                    </TouchableOpacity>
                </View>

                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header navigation={this.props.navigation} />}//头布局
                    renderItem={({ item }) => <List data={item} navigation={this.props.navigation} cancelFun={this.cancelFun.bind(this)} />}//item显示的布局
                    ListFooterComponent={() => <Footer navigation={this.props.navigation} />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => this._onLoadMore()}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                />

                {/* 加载弹框组件 */}
                <Loading 
                openAlertFun={this.openAlertFun.bind(this)} 
                openAlert={this.state.openAlert}
                icon = 'loading'
                font = '数据加载中' />
            </View>
        )
    }
    // 加载弹框控制
    openAlertFun(){
        this.setState({
            openAlert:!this.state.openAlert
        })
    }
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            // this._getHotList()
        }
    };
    // 加载更多
    _onLoadMore() {
        // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
        if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
            // this.page = this.page + 1
            // this._getHotList()
        }
    }
    // 取消收藏
    cancelFun(item){
        this.setState({
            openAlert:!this.state.openAlert
        },()=>{
            fetchFun.load({
                url: 'v2/project/serviceOperating',
                data: {
                    type: 2,//1，收藏，2，取消收藏
                    uid:item.uid,//被收藏或取消的uid
                    role_type:item.role_type,//1，工人，2工头
                },
                success: (res) => {
                    console.log('---取消收藏---', res)
                    if (res.state == 1) {
                        this.getData()
                        this.openAlertFun()
                    }
                }
            });
        })
    }
}
// item布局
class List extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        const item = this.props.data
        return (
            <TouchableOpacity activeOpacity={0.5} 
            onPress={() => this.props.navigation.navigate('Personal_preview', { uid: item.uid, fromTo: 'yzlw', role_type: '2' })}>
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
                                // backgroundColor: 'rgb(114, 102, 202)', 
                                flexDirection: 'row', alignItems: 'center',
                                justifyContent: 'center',
                                borderRadius: 4.4, width: 49, height: 49, marginRight: 20, overFlow: 'hidden'
                            }}>
                                <ImageCom
                                    style={{ borderRadius: 4.4, width: 49, height: 49, }}
                                    fontSize='17.6'
                                    userPic={item.head_pic}
                                    userName={item.real_name}
                                />
                            </View>
                            <View style={{ flex: 1 }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 17.6 }}>{item.real_name}</Text>
                                        {/* 实名 */}
                                        {
                                            item.verified !== '0' ? (
                                                <TouchableOpacity
                                                    onPress={() => this.props.alertFun('sm')}>
                                                    <Image style={{ width: 52, height: 18.5, marginLeft: 8 }} source={require('../../assets/recruit/verified.png')}></Image>
                                                </TouchableOpacity>
                                            ) : (false)
                                        }

                                        {/* 认证 */}
                                        {
                                            item.group_verified == '1' ? (
                                                <TouchableOpacity
                                                    onPress={() => this.props.alertFun('rz')}>
                                                    <Image style={{ width: 52, height: 18.5, marginLeft: 8 }} source={require('../../assets/recruit/group-verified.png')}></Image>
                                                </TouchableOpacity>
                                            ) : (false)
                                        }
                                    </View>

                                    {/* 地点 */}
                                    {
                                        item.current_addr ? (
                                            <View style={{ flexDirection: 'row', alignItems: 'center', marginRight: 15 }}>
                                                <Icon name="place" size={15} color="#BFBFBF" />
                                                <Text style={{ color: '#666', fontSize: 13.2, marginLeft: 5 }}>{item.current_addr}</Text>
                                            </View>
                                        ) : (false)
                                    }

                                </View>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row' }}>
                                        {
                                            item.nationality ? (
                                                <Text style={{ color: '#666', fontSize: 13.2, marginRight: 10 }}>{item.nationality}族</Text>
                                            ) : (false)
                                        }
                                        {
                                            item.work_year ? (
                                                <View
                                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start', marginRight: 10 }}>
                                                    <Text style={{ color: '#666', fontSize: 13.2 }}>工龄</Text>
                                                    <Text style={{ color: '#eb4e4e', fontSize: 13.2 }}> {item.work_year} </Text>
                                                    <Text style={{ color: '#666', fontSize: 13.2 }}>年</Text>
                                                </View>
                                            ) : (false)
                                        }
                                        {
                                            item.work_year ? (
                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start' }}>
                                                    <Text style={{ color: '#666', fontSize: 13.2 }}>队伍</Text>
                                                    <Text style={{ color: '#eb4e4e', fontSize: 13.2 }}> {item.scale} </Text>
                                                    <Text style={{ color: '#666', fontSize: 13.2 }}>人</Text>
                                                </View>
                                            ) : (false)
                                        }
                                    </View>
                                    <Icon style={{ marginRight: 5 }} name="r-arrow" size={12} color="#000" />
                                </View>
                            </View>
                        </View>

                        <View style={{ flexDirection: 'row', flexWrap: 'wrap', marginTop: 3 }}>
                            <View style={{ flexDirection: 'row' }}>
                                {
                                    item.pro_type && item.pro_type.length > 0 ? (
                                        item.pro_type.map((item, index) => {
                                            return (
                                                <View key={index} style={{
                                                    marginTop: 4.4, marginRight: 6.6, backgroundColor: '#eee',
                                                    paddingLeft: 4.4, paddingRight: 4.4,
                                                    paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row',
                                                    alignItems: 'center', justifyContent: 'center', borderRadius: 2.2,
                                                }}>
                                                    <Text style={{ color: '#666', fontSize: 13.2 }}>{item}</Text>
                                                </View>
                                            )
                                        })
                                    ) : (false)
                                }
                            </View>

                            <View style={{ flexDirection: 'row' }}>
                                {
                                    item.work_type && item.work_type.length > 0 ? (
                                        item.work_type.map((items, index) => {
                                            if (index !== item.work_type.length - 1) {
                                                return (
                                                    <View key={index} style={{
                                                        marginTop: 4.4, marginRight: 1, paddingLeft: 4.4, paddingRight: 4.4,
                                                        paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                                                    }}>
                                                        <Text style={{ color: '#000', fontSize: 13.2 }}>{items} |</Text>
                                                    </View>
                                                )
                                            } else {
                                                return (
                                                    <View key={index} style={{
                                                        marginTop: 4.4, marginRight: 6.6, paddingLeft: 4.4, paddingRight: 4.4,
                                                        paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                                                    }}>
                                                        <Text style={{ color: '#000', fontSize: 13.2 }}>{items}</Text>
                                                    </View>
                                                )
                                            }
                                        })
                                    ) : (false)
                                }
                            </View>
                        </View>

                        {
                            item.introduce ? (
                                <View style={{ flexDirection: 'row', flexWarp: 'warp', marginTop: 6.6 }}>
                                    <Text style={{ color: '#999', fontSize: 13.2 }}>
                                        {item.introduce.length > 25 ? item.introduce.substr(0, 25) + "..." : item.introduce}
                                    </Text>
                                </View>
                            ) : (false)
                        }
                    </View>
                </View>
                {/* 取消收藏 */}
                <TouchableOpacity
                onPress={()=>this.props.cancelFun(item)}
                style={{padding:15,flexDirection:'row',backgroundColor:"rgb(250,250,250)",justifyContent:'center',alignItems:'center'}}>
                    <Icon name="heart" size={15} color="#ccc" />
                    <Text style={{color:'#999',fontSize:15,lineHeight:22,marginLeft:5}}>取消收藏</Text>
                </TouchableOpacity>
            </TouchableOpacity>
        )
    }
}
// 空布局
class Empty extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            <View style={{ flex: 1 }}>
                <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                    <Icon name="note" size={45} color="#999999" />
                </View>
                <Text style={styles.font}>你收藏的工人/班组长将会出现在这里</Text>
            </View>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#fff',
    },
    font: {
        color: '#999',
        fontSize: 15,
        textAlign: 'center',
    },
});