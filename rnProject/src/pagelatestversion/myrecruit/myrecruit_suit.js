/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-22 14:06:54 
 * @Module:发布招工-可能合适你的人
 * @Last Modified time: 2019-03-22 14:06:54 
 */
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    TouchableOpacity,
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
import ListItem from '../../component/listitem'
import Footer from '../../component/listfooter'
import fetchFun from '../../fetch/fetch'
import ImageCom from '../../component/imagecom';

export default class musuit extends Component {
    constructor(props) {
        super(props)
        //当前页
        this.page = 1
        this.pagesize = 10
        //状态
        this.state = {
            list: {},
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
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    componentWillMount() {
        this.getfbzgList()
        this.getList()
    }
    // 发布数据
    getfbzgList() {
        fetchFun.load({
            url: 'jlwork/prodetailactive',
            data: {
                pid: GLOBAL.pid,
                work_type: GLOBAL.fbzgType.fbzgTypeNum,//工种编号
            },
            success: (res) => {
                console.log('---发布数据---', res)
                if (res.state == 1) {
                    this.setState({
                        list: res.values
                    })
                }
            }
        });
    }
    // 合适数据
    getList() {
        fetchFun.load({
            url: 'jlforemanwork/findhelper',
            data: {
                pg: this.page,
                pagesize: this.pagesize,
                cityno: GLOBAL.fbzgAddress.fbzgAddressTwoNum,//如果不传，默认是成都
                role_type: GLOBAL.userinfo.role,//查找的角色，1工人，2工头
                work_type: GLOBAL.fbzgType.fbzgTypeNum,//工种编号,
                pro_type: GLOBAL.fbzgProject.fbzgProjectNum,//工程类别
            },
            success: (res) => {
                console.log('---合适的数据---', res)
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
            <View style={{ backgroundColor: '#ebebeb', flex: 1 }}>
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>可能合适你的人</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header navigation={this.props.navigation} list={this.state.list} />}//头布局
                    renderItem={({ item }) => <List data={item} navigation={this.props.navigation} />}//item显示的布局
                    ListFooterComponent={() => <Footer />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => this._onLoadMore()}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                />
            </View>
        )
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
            this.page = this.page + 1
            // this._getHotList()
        }
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
            <View style={{ height: '100%', }}>
                <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                    <Icon name="note" size={45} color="#999999" />
                </View>
                <Text style={{ textAlign: 'center' }}>没有其他匹配的数据</Text>
            </View>
        )
    }
}
// 头布局
class Header extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        let item = this.props.list
        return (
            <View>
                <View style={{
                    backgroundColor: '#fdf1e0', height: 50,
                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginBottom: 10
                }}>
                    <Text style={{ color: '#f18215', fontSize: 13.2 }}>
                        如何防范骗子？
                    </Text>
                </View>
                {
                    item.pro_title ? (
                        <TouchableOpacity 
                        onPress={() => this.to(item)} 
                        style={styles.information}>
                            <View style={styles.head}>
                                <View style={styles.headl}>
                                    <View style={{
                                        flexDirection: 'row', alignItems: 'center',
                                        justifyContent: 'center', marginRight: 7, backgroundColor: '#eb7a4e',
                                        paddingLeft: 2, paddingRight: 2, paddingTop: 1, paddingBottom: 1,
                                        borderRadius: 3
                                    }}>
                                        {
                                            item.classes ? (
                                                <Text style={{ color: '#fff', fontSize: 12 }}>
                                                    {item.classes[0].cooperate_type.type_name}
                                                </Text>
                                            ) : false
                                        }
                                    </View>
                                    <Text style={{ fontSize: 16, color: '#000' }}>{item.pro_title}</Text>
                                </View>
                                <View style={styles.headr}>
                                    {
                                        item.classes ? (
                                            <Text>
                                                {item.classes[0].pro_type.type_name}
                                            </Text>
                                        ) : false
                                    }
                                </View>
                            </View>
                            <View style={styles.main}>
                                <View style={{ height: 41, flexDirection: 'row', alignItems: 'center' }}>
                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 14 }}>人数：</Text>
                                        {
                                            item.classes ? (
                                                <Text style={{ color: '#EB4E4C', fontSize: 14 }}>
                                                    {item.classes[0].pro_type.type_id}
                                                </Text>
                                            ) : false
                                        }
                                        <Text style={{ color: '#999', fontSize: 12, marginLeft: 5.5 }}>人</Text>
                                    </View>
                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 14 }}>工资：</Text>
                                        {
                                            item.classes ? (
                                                <Text style={{ color: '#EB4E4C', fontSize: 14 }}>
                                                    {item.classes[0].money}{item.classes[0].max_money ? '~' : false}{item.classes[0].max_money}
                                                </Text>
                                            ) : false
                                        }
                                        <Text style={{ color: '#999', fontSize: 12, marginLeft: 5.5 }}>元/天</Text>
                                    </View>
                                </View>
                                {
                                    item.welfare && item.welfare.length>0 ? (
                                        <View style={{ marginBottom: 6.5, marginTop: 6.5, flexDirection: 'row' }}>
                                            <Text style={{ fontSize: 14, color: '#000', marginTop: 3.2 }}>待遇：</Text>
                                            <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                                                {
                                                    item.welfare && item.welfare.map((v, index) => {
                                                        return (
                                                            <View
                                                                key={index}
                                                                style={{
                                                                    marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5,
                                                                    borderRadius: 2, flexDirection: 'row', alignItems: 'center',
                                                                    justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5,
                                                                    paddingTop: 2.2, paddingBottom: 2.2
                                                                }}>
                                                                <Text style={{ fontSize: 12, color: '#333' }}>{v}</Text>
                                                            </View>
                                                        )
                                                    })
                                                }
                                            </View>
                                        </View>
                                    ) : false
                                }

                            </View>
                        </TouchableOpacity>
                    ) : false
                }

                <Text style={{ color: '#999', fontSize: 13.2, textAlign: 'center', marginBottom: 11 }}>以下是根据你所天条件匹配的帮手</Text>
            </View>
        )
    }
    to(item){
        this.props.navigation.navigate('Myrecruit_detailshow')
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
            onPress={() => this.tomy(item)}>
                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginBottom: 11,
                    backgroundColor: '#fff',
                    paddingLeft: 13,
                    paddingTop: 13,
                    paddingBottom: 13,
                    paddingRight: 5.5
                }}>
                    <View style={{ width: '100%' }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{ marginRight: 17 }}>
                                {
                                    item.real_name ? (
                                        <ImageCom
                                            style={{ borderRadius: 4.4, width: 49, height: 49, }}
                                            fontSize='17.6'
                                            userPic={item.head_pic}
                                            userName={item.real_name}
                                        />
                                    ) : false
                                }
                            </View>
                            <View style={{ flex: 1 }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 17.6 }}>{item.real_name}</Text>
                                        {
                                            item.verified == 3 ? (
                                                <Image style={{ width: 51, height: 18, marginLeft: 8 }} source={require('../../assets/recruit/verified.png')}></Image>
                                            ) : false
                                        }
                                    </View>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', marginRight: 15 }}>
                                        <Icon name="place" size={15} color="#BFBFBF" />
                                        <Text style={{ color: '#666', fontSize: 13.2, marginLeft: 5 }}>
                                            {item.current_addr}
                                        </Text>
                                    </View>
                                </View>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row' }}>
                                        <Text style={{ color: '#666', fontSize: 13.2, marginRight: 11 }}>
                                            {item.nationality}族
                                        </Text>
                                        <Text style={{ color: '#666', fontSize: 13.2, marginRight: 3 }}>
                                            工龄
                                        </Text>
                                        <Text style={{ color: '#eb4e4e', fontSize: 13.2, }}>
                                            {item.work_year}
                                        </Text>
                                        <Text style={{ color: '#666', fontSize: 13.2, marginRight: 11, marginLeft: 3 }}>
                                            年
                                        </Text>
                                        {
                                            this.props.navigation.getParam('role_type') == '2' ? (
                                                <View style={{ flexDirection: 'row' }}>
                                                    <Text style={{ color: '#666', fontSize: 13.2, marginRight: 3 }}>
                                                        队伍
                                                    </Text>
                                                    <Text style={{ color: '#eb4e4e', fontSize: 13.2, }}>
                                                        {item.person_count}
                                                    </Text>
                                                    <Text style={{ color: '#666', fontSize: 13.2, marginRight: 11, marginLeft: 3 }}>
                                                        人
                                                    </Text>
                                                </View>
                                            ) : (
                                                    item.work_level && item.work_level.map((v, index) => {
                                                        return (
                                                            <View key={index} style={{ flexDirection: 'row' }}>
                                                                <Text style={{ color: '#666', fontSize: 13.2, marginRight: 3 }}>
                                                                    {v}
                                                                </Text>
                                                            </View>
                                                        )
                                                    })
                                                )
                                        }
                                    </View>
                                    <Icon style={{ marginRight: 5 }} name="r-arrow" size={12} color="#000" />
                                </View>
                            </View>
                        </View>

                        <View style={{ flexDirection: 'row', flexWrap: 'wrap', marginTop: 3 }}>
                            {
                                item.pro_type && item.pro_type.map((v, index) => {
                                    return (
                                        <View
                                            key={index}
                                            style={{
                                                marginTop: 4.4, marginRight: 6.6, backgroundColor: '#eee',
                                                paddingLeft: 4.4, paddingRight: 4.4,
                                                paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row',
                                                alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                                            }}>
                                            <Text style={{ color: '#666', fontSize: 13.2 }}>{v}</Text>
                                        </View>
                                    )
                                })
                            }

                        </View>

                        {
                            item.introduce !== '' ? (
                                <View style={{ marginTop: 6.6 }}>
                                    <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}>
                                        {item.introduce ? (item.introduce.length > 28 ? item.introduce.substr(0, 28) + "..." : item.introduce) : ""}
                                    </Text>
                                </View>
                            ) : false
                        }

                        <View style={{
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                            marginTop: 6.6, paddingTop: 11, borderTopWidth: 1, borderTopColor: '#ebebeb'
                        }}>
                            {
                                item.work_year > 0 ? (
                                    <View style={{ flexDirection: 'row' }}>
                                        <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}>他有 </Text>
                                        <Text style={{ color: '#eb4e4e', fontSize: 13.2, lineHeight: 19.8 }}>{item.work_year}</Text>
                                        <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}> 条项目经验</Text>
                                    </View>
                                ) : false
                            }
                        </View>
                    </View>
                </View>
            </TouchableOpacity>
        )
    }
    tomy(item){
        this.props.navigation.navigate('Personal_preview', 
        { uid: item.uid, fromTo: 'yzlw', role_type: GLOBAL.userinfo.role })
    }
}
const styles = StyleSheet.create({
    information: {
        paddingLeft: 15,
        paddingRight: 15,
        marginBottom: 15,
        backgroundColor: 'white',
    },
    head: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: "space-between",
        height: 38,
    },
    headl: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    headr: {
        fontSize: 14,
        backgroundColor: '#eee',
        borderRadius: 2,
        color: '#666',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: "center",
        paddingLeft: 6,
        paddingRight: 6,
        paddingTop: 2.5,
        paddingBottom: 2.5,
    },
    main: {
        borderTopWidth: .5,
        borderTopColor: '#999',
    },
    foot: {
        height: 32,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'flex-end'
    },
})