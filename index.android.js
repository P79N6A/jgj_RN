/**
 * @format
 */

import {AppRegistry} from 'react-native';
import App from './App';
import {jobname,findname,myname} from './app.json';
import GLOBAL from './src/config'

import Find from './src/pagelatestversion/find/find'
import My from './src/pagelatestversion/my/my'

console.ignoredYellowBox = ['Warning: BackAndroid is deprecated. Please use BackHandler instead.','source.uri should not be an empty string','Invalid props.style key'];
console.disableYellowBox = true // 关闭全部黄色警告

AppRegistry.registerComponent(jobname, () => App);
AppRegistry.registerComponent(findname, () => Find);
AppRegistry.registerComponent(myname, () => My);
