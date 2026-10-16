# 新闻管理系统

## 项目简介

本项目是一个基于 **Java + Spring Boot + Vue** 开发的前后端分离新闻管理系统，用于课程设计。

系统分为「前台门户」和「后台管理」两部分：

- **前台门户**：面向普通用户，提供新闻浏览、模糊搜索、查看详情、评论、收藏点赞、意见反馈、个人中心（资料修改、密码、我的收藏、我的评论）等功能。
- **后台管理**：面向管理员，提供新闻管理、类型管理、评论管理、用户管理、消息管理、广告管理、意见反馈处理、操作日志、错误日志、统计分析、系统信息查看等功能。

项目采用前后端分离架构：后端提供 REST 风格接口，前端通过 axios 调用接口完成页面渲染与交互，两端可独立开发、独立部署。

## 主要功能

- 新闻管理：管理系统可以录入、修改和查询新闻的基本信息，如名称、内容、来源等。
- 类型管理：系统可以管理新闻的类型信息，包括类型的名称等。
- 评论管理：管理和浏览整个网站的评论信息。
- 用户管理：管理和浏览网站的用户信息，可以新增、编辑和删除用户。
- 统计分析：系统可以根据新闻的活动数据和用户参与度进行统计和分析，帮助管理员了解整个系统的状况。
- 消息管理：新闻管理员可以在系统上发布消息，整个网站的用户都能收到。
- 广告管理：新闻管理员可以在系统上发布广告消息，然后在详情页面右侧展示。
- 意见反馈：新闻管理员可以在后台查看浏览用户提交的意见反馈信息。
- 系统信息：管理员可以查看系统的基本信息，包括系统名称、服务器信息、内存信息、CPU 信息、软件信息等。
- 注册登录：用户通过注册和登录后，才能使用网站。
- 门户浏览：用户进入首页后，可以浏览新闻列表信息，包括最新、最热。
- 热门推荐：基于协同过滤推荐算法的热门推荐。
- 用户中心：包括用户基本资料修改、用户基本信息、密码、收藏点赞等。
- 意见反馈：包括用户提交意见反馈的入口页面。
- 模糊搜索：顶部搜索功能，支持模糊搜索新闻信息。
- 新闻评论：详情页下侧用户可以评论新闻。

## 项目结构

```
java_news
├── server/     后端代码（Spring Boot + MyBatis-Plus）
│   ├── pom.xml             Maven 依赖配置
│   ├── upload/             图片等上传文件的存放目录
│   └── src/main/
│       ├── java/com/gk/study/
│       │   ├── controller/   接口层
│       │   ├── service/      业务逻辑层
│       │   ├── mapper/       数据访问层（MyBatis Mapper 接口）
│       │   ├── entity/       实体类
│       │   ├── config/       配置类
│       │   ├── interceptor/  权限拦截器
│       │   └── MyApp.java    程序入口（启动类）
│       └── resources/
│           ├── application.yml          项目配置（数据库、端口、上传路径等）
│           └── mapper/*.xml             MyBatis 映射文件
├── web/        前端代码（Vue 3 + Vite + Ant Design Vue）
│   └── src/
│       ├── view/index/     前台门户页面
│       ├── view/admin/     后台管理页面
│       ├── api/            接口请求封装
│       ├── router/         路由配置
│       └── store/          状态管理与全局常量
└── doc/        开发文档与数据库脚本
```

## 开发环境

| 项目 | 说明 |
| --- | --- |
| 后端 | Java 8 + Spring Boot 2.5.5 |
| 前端 | JavaScript + Vue 3 + Vite |
| 数据库 | MySQL 5.7 及以上 |
| 开发工具 | IDEA + VS Code |
| 运行环境 | Windows 10 / 11 |

## 关键技术

**前端技术栈**：ES6、Vue 3、Vue Router、Pinia、Axios、Ant Design Vue、Less、Vite

**后端技术栈**：Java 8、Spring Boot、MyBatis-Plus、Druid 数据库连接池、MySQL

## 运行步骤

### 软件准备

1. JDK 8 [下载地址](https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html)
2. IDEA [下载地址](https://www.jetbrains.com/idea/download/)
3. MySQL 5.7 及以上 [下载地址](https://dev.mysql.com/get/Downloads/MySQLInstaller/mysql-installer-community-5.7.44.0.msi)
4. Node.js 16 及以上（推荐 18 或更高）[下载地址](https://nodejs.org/dist/v18.20.2/node-v18.20.2-x64.msi)

> 注意：后端必须使用 **JDK 8** 编译和运行，使用更高版本（如 JDK 17）可能因依赖兼容性启动失败。

### 后端运行步骤

**(1) 打开项目**

使用 IDEA 打开 `server` 目录，在 `File → Project Structure → Project SDK` 中把 JDK 设置为 1.8，然后等待 Maven 自动同步依赖。

**(2) 创建数据库**

在 MySQL 中执行：

```sql
CREATE DATABASE IF NOT EXISTS java_news DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_general_ci;
```

**(3) 导入表结构与初始数据**

数据库脚本位于 `doc/java_news.sql`，在 MySQL 客户端中依次执行：

```sql
mysql> use java_news;
mysql> source D:/你的路径/java_news/doc/java_news.sql;
```

**(4) 配置数据库连接**

打开 `server/src/main/resources/application.yml`，把数据库账号、密码改成你自己本机的：

```yaml
DB_NAME: java_news
spring:
  datasource:
    username: root
    password: [你的数据库密码]
    url: jdbc:mysql://localhost:3306/${DB_NAME}?useUnicode=true&characterEncoding=utf-8&useSSL=true&serverTimezone=UTC
    driver-class-name: com.mysql.cj.jdbc.Driver
    type: com.alibaba.druid.pool.DruidDataSource
```

**(5) 启动服务**

运行 `server/src/main/java/com/gk/study/MyApp.java` 的 `main` 方法。启动成功后，后端地址为 `http://127.0.0.1:9100`，接口统一前缀为 `/api`。

### 前端运行步骤

**(1) 安装依赖**

```bash
cd web
npm install
```

**(2) 启动前端**

```bash
npm run dev
```

启动后浏览器访问 `http://localhost:8080` 即可打开前台门户，访问 `http://localhost:8080/admin` 进入后台管理。

> 说明：前端通过 `web/src/store/constants.js` 中的 `BASE_URL` 指定后端地址（默认 `http://127.0.0.1:9100`）。如果后端端口有改动，需要同步修改这里。
>
> 前端开发服务器与后端端口不同，跨域由后端统一处理，无需额外配置代理。

### 前台 / 后台默认账号

| 角色 | 账号 | 密码 |
| --- | --- | --- |
| 管理员 | admin | 123456 |
| 普通用户 | user1 / user2 / user3 | 123456 |

## 开发文档

| 文档 | 说明 |
| --- | --- |
| [开发文档](doc/doc.md) | 功能介绍、所用框架说明与运行步骤 |
| [项目启动与验证指南](doc/项目启动与验证指南.md) | 环境准备、启动步骤与功能验证清单 |
| [项目缺口清单](doc/项目缺口清单.md) | 已补齐的接口与前端文件、仍待处理的事项 |
| [数据库表结构](doc/表结构.docx) | 各数据表的字段说明 |
| [数据库脚本](doc/java_news.sql) | 建库建表语句与初始数据 |

## 常见问题

**1. 数据库版本有什么要求？**

答：MySQL 5.7 及以上版本即可。

**2. 项目的代码结构？**

答：`server` 目录是后端代码（Spring Boot），`web` 目录是前端代码（Vue），`doc` 目录是开发文档与数据库脚本。

**3. 需要学习哪些技术知识？**

答：需要学习 [Java 编程知识](https://www.w3cschool.cn/java/)、[Spring Boot 框架知识](https://springdoc.cn/spring-boot/)、[Vue 编程知识](https://cn.vuejs.org/guide/introduction.html)。

**4. 后台管理的默认账号密码是？**

答：管理员账号密码是：admin / 123456。

**5. 后台管理提示账号权限不足怎么办？**

答：需要把该用户的角色改为管理员，即在数据表 `b_user` 中把该用户的 `role` 字段改为 `3`。

**6. 后端启动报数据库连接失败？**

答：检查三步：MySQL 服务是否已启动；`application.yml` 中的账号密码是否正确；`java_news` 数据库是否已经导入 `doc/java_news.sql`。

**7. 图片无法显示？**

答：确认 `application.yml` 中的 `BASE_LOCATION` 配置为本项目在本机的实际路径（Windows 路径请使用反斜杠），该配置决定上传图片的读取目录。
