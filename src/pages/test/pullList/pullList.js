
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    ActivityIndicator,
    ListView,
    Image
} from 'react-native';

import { PullList } from 'react-native-pull';
import PullRefreshScrollView from 'react-native-pullrefresh-scrollview';

export default class Refresh extends Component {

	constructor(props) {
        super(props);
        this.dataSource = [{
            id: 0,
        }];
        this.state = {
            list: (new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2})).cloneWithRows(this.dataSource),
        };
        this.renderRow = this.renderRow.bind(this);
        this.topIndicatorRender = this.topIndicatorRender.bind(this);
    }

	topIndicatorRender(pulling, pullok, pullrelease) {
        const hide = {position: 'absolute', left: -10000};
        const show = {position: 'relative', left: 0};
        setTimeout(() => {
            if (pulling) {
                this.txtPulling && this.txtPulling.setNativeProps({style: show});
                this.txtPullok && this.txtPullok.setNativeProps({style: hide});
                this.txtPullrelease && this.txtPullrelease.setNativeProps({style: hide});
            } else if (pullok) {
                this.txtPulling && this.txtPulling.setNativeProps({style: hide});
                this.txtPullok && this.txtPullok.setNativeProps({style: show});
                this.txtPullrelease && this.txtPullrelease.setNativeProps({style: hide});
            } else if (pullrelease) {
                this.txtPulling && this.txtPulling.setNativeProps({style: hide});
                this.txtPullok && this.txtPullok.setNativeProps({style: hide});
                this.txtPullrelease && this.txtPullrelease.setNativeProps({style: show});
            }
        }, 1);
		return (
            <View style={{flexDirection: 'row', justifyContent: 'center', alignItems: 'center', height: 60}}>
                <ActivityIndicator size="small" color="gray" />
                <Text ref={(c) => {this.txtPulling = c;}} style={{marginLeft:10}}>
                <Image style={styles.loading} source={require('../../../assets/test/img.jpg')}></Image>
                正在下拉的状态...</Text>
                <Text ref={(c) => {this.txtPullok = c;}} style={{marginLeft:10}}>
                <Image style={styles.loading} source={require('../../../assets/test/img.jpg')}></Image>可以放手的状态...</Text>
                <Text ref={(c) => {this.txtPullrelease = c;}} style={{marginLeft:10}}>
                <Image style={styles.loading} source={require('../../../assets/test/img.jpg')}></Image>放手加载的状态...</Text>
    		</View>
        );
	}

    render() {
        return (
          <View style={styles.container}>
              <PullList
                  topIndicatorRender={this.topIndicatorRender}
                  dataSource={this.state.list}
                  renderRow={this.renderRow}
                  >
                  </PullList>
          </View>
        );
    }

    renderRow(item, sectionID, rowID, highlightRow) {
      return (
          <View style={{height: 50, backgroundColor: '#fafafa', alignItems: 'center', justifyContent: 'center'}}>
              <Text>正文内容</Text>
          </View>
      );
    }

}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'column',
    backgroundColor: '#F5FCFF',
  },
  loading:{
      width:20,
      height:20,
  }
});