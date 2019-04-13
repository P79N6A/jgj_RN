/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-21 10:42:42 
 * @Module：找工人-选工种
 * @Last Modified time: 2019-03-21 11:15:54
 */
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    ActivityIndicator,
    ListView,
    Image,
    ScrollView,
    Dimensions,
    TouchableOpacity,
    StatusBar,
    Platform,
    FlatList,
    RefreshControl
} from 'react-native';
import Typeselects from '../../component/typeselects'
import Icon from "react-native-vector-icons/Ionicons";

export default class lookworker extends Component {
    constructor(props) {
        super(props)
        this.state = {
            type: [
                { key: 0, name: '木工' },
                { key: 1, name: '水电工' },
                { key: 2, name: '钢筋工' },
                { key: 3, name: '小工 杂工' },
                { key: 4, name: '水泥工' },
                { key: 5, name: '油漆工' },
                { key: 6, name: '电焊工' },
                { key: 7, name: '砌筑工' },
                { key: 8, name: '制模工' },
                { key: 9, name: '架子工' },
                { key: 10, name: '抹灰工' },
                { key: 11, name: '安装工' },
                { key: 12, name: '混泥土工' },
                { key: 13, name: '消防共' },
                { key: 14, name: '外墙保温工' },
                { key: 15, name: '门窗工' },
                { key: 16, name: '管道工' },
                { key: 17, name: '钢结构共' },
                { key: 18, name: '乳胶漆工' },
                { key: 19, name: '防水工' },
                { key: 20, name: '机械操作工' },
                { key: 21, name: '弱电工' },
            ],
            selected: [],//选择的民族
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    componentWillMount() {
        let arr = []
        GLOBAL.zgrtype.map((item, index) => {
            arr.push(item)
        })
        this.setState({
            selected: arr
        })
    }
    render() {
        let obj = {}
        obj.type = '找工人工种'
        return (
            <View style={styles.main}>
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>选择工种</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <Typeselects
                    obj={obj}
                    type={this.state.type}
                    selected={this.state.selected}
                    clicktype={this.clicktype.bind(this)}
                />
            </View>
        )
    }
    // 选择工种
    clicktype(e) {
        GLOBAL.zgrtype = [e]
        this.props.navigation.state.params.callback()//回调刷新函数，改变全局变量后需要手动刷新
        this.props.navigation.goBack()
    }

}
const styles = StyleSheet.create({
    main: {
        backgroundColor: '#ebebeb',
        flex: 1
    },
})