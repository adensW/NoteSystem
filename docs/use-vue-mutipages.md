# 创建多页 Vue 项目

### 为什么要使用多页应用呢?

由于写这篇博客要实现的是博客的评论系统.通过iframe展示在页面上,页面内容简单.但是包含两个主要内容.

1. 展示和交互功能
2. 后台管理功能
3. 登陆以即授权功能

主要逻辑就三块.使用一个单页通过Vue-Router模拟跳转有点划不来.既然工作简单那就用最少的代码依赖来完成,

### 项目准备

使用 Vue-cli 初始化一个单页项目,修改代码使他变成多页项目.这在vue 官方也是有文档支持的

主要通过修改  ```vue.config.js``` 里面的pages属性来改变

```
module.exports = {
    pages: {
      index: {
        // entry for the page
        entry: 'src/index/main.js',
        // the source template
        template: 'public/index.html',
        // output as dist/index.html
        filename: 'index.html',
        // when using title option,
        // template title tag needs to be <title><%= htmlWebpackPlugin.options.title %></title>
        title: 'Index Page',
        // chunks to include on this page, by default includes
        // extracted common chunks and vendor chunks.
        chunks: ['chunk-vendors', 'chunk-common', 'index']
      },
      login: {
        entry: 'src/login/main.js',
        template: 'public/login.html',
        filename: 'login.html',
        title: 'Login Page',
        chunks: ['chunk-vendors', 'chunk-common', 'login']
      },
      backstage: {
        entry: 'src/backstage/main.js',
        template: 'public/backstage.html',
        filename: 'backstage.html',
        title: 'Backstage Page',
        chunks: ['chunk-vendors', 'chunk-common', 'backstage']
      },
    },
    devServer: {
    historyApiFallback: {
        rewrites: [
          { from: /^\/$/, to: '/index.html' },
          { from: /^\/login/, to: '/login.html' },
          { from: /^\/backstage/, to: '/backstage.html' },
          { from: /./, to: '/404.html' }
        ]
      }
    }
  }
```

### 建立页面入口

代码结构如下
- src
  - assets                 //公共资源
  - components       //公共组件
  - index                  //Index 页面
    - components   // index 组件
    - main.js            //index页面的js 入口
    - app.vue           //index 页面 app入口
  - login                   // login 页面
    - components   // login 组件
    - main.js            // login页面的js 入口
    - app.vue           //login 页面 app入口
  - backstage            // backstage 页面
    - components   // backstage 页面 组件
    - main.js            // backstage 页面的js 入口
    - app.vue           // backstage 页面 app入口
- vue.config.js

从以上结构可以看出来,多页应用其实就是多个单页应用,只不过在配置里添加多个入口而已.剩下的开发就和开发单页应用一样了.

