-- =============================================================
--  新闻管理系统 - 数据库初始化脚本
--  数据库：java_news（MySQL 5.7+）
--  说明：表结构由项目 Java 实体类（entity）+ MyBatis Mapper 反推得出
--  生成日期：2026-10-16
-- =============================================================
--  执行方式（在 Windows 命令行里跑，二选一）：
--
--  方式一：整脚本导入
--    mysql -uroot -p --default-character-set=utf8mb4 < "本文件路径"
--
--  方式二：先进 mysql 再 source
--    mysql -uroot -p
--    mysql> source D:/xxx/java_news.sql;
-- =============================================================


-- ---------- 1. 建库 ----------
CREATE DATABASE IF NOT EXISTS `java_news`
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE `java_news`;


-- ---------- 2. 建表（12 张） ----------

-- 2.1 用户表
CREATE TABLE IF NOT EXISTS `b_user` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `username`    VARCHAR(64)           DEFAULT NULL COMMENT '用户名',
    `password`    VARCHAR(64)           DEFAULT NULL COMMENT '密码（明文存储）',
    `nickname`    VARCHAR(64)           DEFAULT NULL COMMENT '昵称',
    `mobile`      VARCHAR(32)           DEFAULT NULL COMMENT '手机号',
    `email`       VARCHAR(128)          DEFAULT NULL COMMENT '邮箱',
    `description` VARCHAR(512)          DEFAULT NULL COMMENT '个人简介',
    `role`        VARCHAR(8)            DEFAULT '1' COMMENT '角色：1普通用户 2演示用户 3管理员',
    `status`      VARCHAR(8)            DEFAULT '1' COMMENT '状态',
    `score`       VARCHAR(32)           DEFAULT '0' COMMENT '积分',
    `avatar`      VARCHAR(255)          DEFAULT NULL COMMENT '头像文件名',
    `token`       VARCHAR(64)           DEFAULT NULL COMMENT '登录令牌（登录后写入）',
    `create_time` VARCHAR(32)           DEFAULT NULL COMMENT '创建时间（毫秒时间戳字符串）',
    `push_email`  VARCHAR(128)          DEFAULT NULL COMMENT '消息推送邮箱',
    `push_switch` VARCHAR(8)            DEFAULT NULL COMMENT '消息推送开关',
    PRIMARY KEY (`id`),
    KEY `idx_username` (`username`),
    KEY `idx_token` (`token`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '用户表';


-- 2.2 新闻表
CREATE TABLE IF NOT EXISTS `b_thing` (
    `id`                BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `title`             VARCHAR(255)          DEFAULT NULL COMMENT '新闻标题',
    `cover`             VARCHAR(255)          DEFAULT NULL COMMENT '封面图片文件名',
    `description`       TEXT                  COMMENT '新闻正文（富文本 HTML）',
    `status`            VARCHAR(8)            DEFAULT '0' COMMENT '状态：0上架 1下架',
    `create_time`       VARCHAR(32)           DEFAULT NULL COMMENT '发布时间（毫秒时间戳字符串）',
    `score`             VARCHAR(32)           DEFAULT '0' COMMENT '评分累计',
    `source`            VARCHAR(128)          DEFAULT NULL COMMENT '来源',
    `pv`                VARCHAR(32)           DEFAULT '0' COMMENT '浏览量',
    `rate`              VARCHAR(32)           DEFAULT '5' COMMENT '评分',
    `recommend_count`   VARCHAR(32)           DEFAULT '0' COMMENT '推荐次数',
    `wish_count`        VARCHAR(32)           DEFAULT '0' COMMENT '点赞数',
    `collect_count`     VARCHAR(32)           DEFAULT '0' COMMENT '收藏数',
    `classification_id` BIGINT                DEFAULT NULL COMMENT '分类 id',
    `user_id`           BIGINT                DEFAULT NULL COMMENT '发布者 id',
    `location`          VARCHAR(128)          DEFAULT NULL COMMENT '遗留字段（代码中查询条件用到）',
    PRIMARY KEY (`id`),
    KEY `idx_classification` (`classification_id`),
    KEY `idx_create_time` (`create_time`),
    KEY `idx_pv` (`pv`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '新闻表';


-- 2.3 新闻分类表
CREATE TABLE IF NOT EXISTS `b_classification` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `title`       VARCHAR(128)          DEFAULT NULL COMMENT '分类名称',
    `create_time` VARCHAR(32)           DEFAULT NULL COMMENT '创建时间（毫秒时间戳字符串）',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '新闻分类表';


-- 2.4 评论表
CREATE TABLE IF NOT EXISTS `b_comment` (
    `id`           BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
    `content`      VARCHAR(1024)          DEFAULT NULL COMMENT '评论内容',
    `comment_time` VARCHAR(32)            DEFAULT NULL COMMENT '评论时间（毫秒时间戳字符串）',
    `like_count`   VARCHAR(32)            DEFAULT '0' COMMENT '点赞数',
    `user_id`      BIGINT                 DEFAULT NULL COMMENT '评论人 id',
    `thing_id`     BIGINT                 DEFAULT NULL COMMENT '新闻 id',
    PRIMARY KEY (`id`),
    KEY `idx_thing` (`thing_id`),
    KEY `idx_user` (`user_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '评论表';


-- 2.5 点赞表
CREATE TABLE IF NOT EXISTS `b_thing_wish` (
    `id`       BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `thing_id` BIGINT          DEFAULT NULL COMMENT '新闻 id',
    `user_id`  BIGINT          DEFAULT NULL COMMENT '用户 id',
    PRIMARY KEY (`id`),
    KEY `idx_user` (`user_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '新闻点赞表';


-- 2.6 收藏表
CREATE TABLE IF NOT EXISTS `b_thing_collect` (
    `id`       BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `thing_id` BIGINT          DEFAULT NULL COMMENT '新闻 id',
    `user_id`  BIGINT          DEFAULT NULL COMMENT '用户 id',
    PRIMARY KEY (`id`),
    KEY `idx_user` (`user_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '新闻收藏表';


-- 2.7 浏览记录表（协同过滤推荐用）
CREATE TABLE IF NOT EXISTS `b_record` (
    `id`       BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `thing_id` BIGINT          DEFAULT NULL COMMENT '新闻 id',
    `score`    INT             DEFAULT 0 COMMENT '浏览得分',
    `ip`       VARCHAR(64)     DEFAULT NULL COMMENT '访客 ip',
    PRIMARY KEY (`id`),
    KEY `idx_ip` (`ip`),
    KEY `idx_thing` (`thing_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '浏览记录表';


-- 2.8 消息公告表
CREATE TABLE IF NOT EXISTS `b_notice` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `title`       VARCHAR(255)          DEFAULT NULL COMMENT '标题',
    `content`     TEXT                  COMMENT '内容',
    `create_time` VARCHAR(32)           DEFAULT NULL COMMENT '创建时间（毫秒时间戳字符串）',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '消息公告表';


-- 2.9 广告表
CREATE TABLE IF NOT EXISTS `b_ad` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `image`       VARCHAR(255)          DEFAULT NULL COMMENT '广告图片文件名',
    `link`        VARCHAR(512)          DEFAULT NULL COMMENT '广告跳转链接',
    `create_time` VARCHAR(32)           DEFAULT NULL COMMENT '创建时间（毫秒时间戳字符串）',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '广告表';


-- 2.10 意见反馈表
CREATE TABLE IF NOT EXISTS `b_feedback` (
    `id`      BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `title`   VARCHAR(255)          DEFAULT NULL COMMENT '反馈标题',
    `content` TEXT                  COMMENT '反馈内容',
    `name`    VARCHAR(64)           DEFAULT NULL COMMENT '姓名',
    `email`   VARCHAR(128)          DEFAULT NULL COMMENT '邮箱',
    `mobile`  VARCHAR(32)           DEFAULT NULL COMMENT '手机号',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '意见反馈表';


-- 2.11 操作日志表（拦截器每个请求都会写入一条）
CREATE TABLE IF NOT EXISTS `b_op_log` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `re_ip`       VARCHAR(64)           DEFAULT NULL COMMENT '请求 ip',
    `re_time`     VARCHAR(64)           DEFAULT NULL COMMENT '请求时间 yyyy-MM-dd HH:mm:ss.SSS',
    `re_ua`       VARCHAR(600)          DEFAULT NULL COMMENT '请求 User-Agent',
    `re_url`      VARCHAR(512)          DEFAULT NULL COMMENT '请求 url',
    `re_method`   VARCHAR(16)           DEFAULT NULL COMMENT '请求方法',
    `re_content`  TEXT                  COMMENT '请求内容',
    `access_time` VARCHAR(32)           DEFAULT NULL COMMENT '耗时（毫秒）',
    PRIMARY KEY (`id`),
    KEY `idx_re_time` (`re_time`),
    KEY `idx_re_ip` (`re_ip`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '操作日志表';


-- 2.12 错误日志表
CREATE TABLE IF NOT EXISTS `b_error_log` (
    `id`       BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `ip`       VARCHAR(64)           DEFAULT NULL COMMENT 'ip 地址',
    `url`      VARCHAR(512)          DEFAULT NULL COMMENT '请求 url',
    `method`   VARCHAR(16)           DEFAULT NULL COMMENT '请求方法',
    `content`  TEXT                  COMMENT '错误内容',
    `log_time` VARCHAR(64)           DEFAULT NULL COMMENT '记录时间',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '错误日志表';


-- =============================================================
--  3. 初始数据
--  注意：以下语句只在空库（首次初始化）时执行，
--        如果库里已经录入了你自己的数据，请跳过本节，不要重复执行
-- =============================================================

-- 3.1 管理员账号：admin / 123456 ；普通用户：user1 / user2 / user3，密码同为 123456
--     密码是明文比对（UserServiceImpl 里直接 eq password），不要改成加密值
--     status：'0' = 正常，'1' = 封号（前端 views/admin/user.vue 里就是这么判断的）
INSERT INTO `b_user` (`username`, `password`, `nickname`, `mobile`, `email`, `role`, `status`, `score`, `avatar`, `create_time`) VALUES
('admin', '123456', '系统管理员', '13800000001', 'admin@java_news.com', '3', '0', '0', '004cc2ec-b5d1-4bdf-8f9e-efe43aa5be1c.jpeg', CAST(UNIX_TIMESTAMP() * 1000 AS UNSIGNED)),
('user1', '123456', '芙芙',     '13800000002', 'user1@java_news.com', '1', '0', '20', '1925f29b-f835-4a05-b96c-ff83b9b6c76f.png',    CAST(UNIX_TIMESTAMP() * 1000 AS UNSIGNED)),
('user2', '123456', '小海',     '13800000003', 'user2@java_news.com', '1', '0', '10', '4ef360ce-9fb9-4080-bf10-83a6f3c0a3f2.png',    CAST(UNIX_TIMESTAMP() * 1000 AS UNSIGNED)),
('user3', '123456', '阿宁',     '13800000004', 'user3@java_news.com', '1', '0', '5',  '96056987-e17e-437b-89f2-e0ffa62bb4ff.png',    CAST(UNIX_TIMESTAMP() * 1000 AS UNSIGNED));


-- 3.2 新闻分类（5 个）
INSERT INTO `b_classification` (`title`, `create_time`) VALUES
('科技', CAST(UNIX_TIMESTAMP() * 1000 AS UNSIGNED)),
('财经', CAST(UNIX_TIMESTAMP() * 1000 AS UNSIGNED)),
('体育', CAST(UNIX_TIMESTAMP() * 1000 AS UNSIGNED)),
('文化', CAST(UNIX_TIMESTAMP() * 1000 AS UNSIGNED)),
('社会', CAST(UNIX_TIMESTAMP() * 1000 AS UNSIGNED));


-- 3.3 新闻示例（8 条；封面直接引用项目 upload/image 下已有的图片文件名）
INSERT INTO `b_thing` (`title`, `cover`, `description`, `status`, `create_time`, `score`, `source`, `pv`, `rate`, `recommend_count`, `wish_count`, `collect_count`, `classification_id`, `user_id`, `location`) VALUES
('国产大模型集体开源，中小团队迎来新机会',
 '02669227-c406-45b5-8656-8d0817aaaf75.jpeg',
 '<p>本周多家国内厂商陆续开源了自家的中等规模模型权重，参数规模集中在 7B 到 32B 之间，均允许商用。</p><p>对中小团队而言，这意味着不必再从零训练底座，可以把精力放在数据清洗和业务场景适配上。多位开发者表示，推理成本相比半年前下降了约六成。</p>',
 '0', CAST((UNIX_TIMESTAMP() - 0) * 1000 AS UNSIGNED), '0', '青岛日报', '128', '5', '0', '12', '3', 1, 1, NULL),

('新能源车下乡活动启动，覆盖百余县域市场',
 '04516ae1-a48f-4d98-b8d5-53049e7fb867.jpeg',
 '<p>新一轮新能源汽车下乡活动正式启动，本次覆盖全国一百多个县域市场，参与车型以 10 万元以下的小型车为主。</p><p>业内人士指出，县域市场的充电设施建设仍是关键瓶颈，配套政策有望在下半年跟进。</p>',
 '0', CAST((UNIX_TIMESTAMP() - 86400) * 1000 AS UNSIGNED), '0', '经济观察', '96', '5', '0', '8', '2', 2, 1, NULL),

('全民健身热潮持续，城市马拉松报名人数创新高',
 '04543c8b-9ccb-444d-a897-66e15941ca97.jpeg',
 '<p>今年秋季多场城市马拉松的报名人数刷新纪录，其中半数以上为首次参赛的业余跑者。</p><p>赛事组委会普遍提高了医疗保障标准，并在赛道沿线增设了补给和降温点。</p>',
 '0', CAST((UNIX_TIMESTAMP() - 86400 * 2) * 1000 AS UNSIGNED), '0', '体育周刊', '77', '5', '0', '15', '4', 3, 1, NULL),

('博物馆夜场开放常态化，年轻人成参观主力',
 '066794d5-285c-467c-b2dc-de0b2597b758.jpeg',
 '<p>多家省级博物馆宣布将夜场开放转为常态化安排，每周至少两晚延长至 21 点。</p><p>数据显示，夜场观众中 35 岁以下人群占比超过七成，文创产品销售同步增长。</p>',
 '0', CAST((UNIX_TIMESTAMP() - 86400 * 3) * 1000 AS UNSIGNED), '0', '文化报', '64', '5', '0', '9', '2', 4, 1, NULL),

('社区食堂加速铺开，老年助餐服务更加便利',
 '07dfd814-28a7-408a-ba89-368789592361.jpeg',
 '<p>今年以来多个城市新增社区食堂数百家，为周边老年人提供平价助餐服务。</p><p>部分食堂还引入了智能结算设备，刷脸即可完成取餐和扣费，减少了排队时间。</p>',
 '0', CAST((UNIX_TIMESTAMP() - 86400 * 4) * 1000 AS UNSIGNED), '0', '民生观察', '53', '5', '0', '6', '1', 5, 1, NULL),

('算力成本下降，AI 应用进入规模化落地阶段',
 '08a43d90-a216-4b5b-8e97-cbae79a35572.jpeg',
 '<p>随着推理芯片供给改善和调度技术成熟，单位算力成本持续走低，AI 应用正从试点走向规模部署。</p><p>报告显示，客服、质检、文档处理是最先出现规模化收益的三个场景。</p>',
 '0', CAST((UNIX_TIMESTAMP() - 86400 * 5) * 1000 AS UNSIGNED), '0', '科技前线', '143', '5', '0', '21', '7', 1, 1, NULL),

('个人养老金产品扩容，长期配置理念逐步普及',
 '09c48dc0-9e4b-4304-9798-48e8b659f5ef.jpeg',
 '<p>个人养老金可投产品范围进一步扩大，新增多只目标日期基金和指数基金。</p><p>专家提醒，个人养老金账户资金封闭运行至退休，配置时应更关注长期稳健性。</p>',
 '0', CAST((UNIX_TIMESTAMP() - 86400 * 6) * 1000 AS UNSIGNED), '0', '财经时报', '41', '5', '0', '4', '1', 2, 1, NULL),

('城市书房进社区，24 小时自助借阅受欢迎',
 '0afbfea8-0924-47d3-84b4-54c377229bc2.jpeg',
 '<p>一批 24 小时自助城市书房在居民区落地，凭身份证即可进入并完成借还书。</p><p>运营方表示，晚间 19 点至 22 点是使用高峰，周末则集中在下午时段。</p>',
 '0', CAST((UNIX_TIMESTAMP() - 86400 * 7) * 1000 AS UNSIGNED), '0', '城市晚报', '35', '5', '0', '3', '1', 4, 1, NULL);


-- 3.4 评论示例
INSERT INTO `b_comment` (`content`, `comment_time`, `like_count`, `user_id`, `thing_id`) VALUES
('开源对中小企业确实是利好，希望生态能跟上。',     CAST((UNIX_TIMESTAMP() - 3600) * 1000 AS UNSIGNED),     '5', 2, 1),
('推理成本这部分有具体数据来源吗？想看看原文。',   CAST((UNIX_TIMESTAMP() - 1800) * 1000 AS UNSIGNED),     '2', 3, 1),
('县城的充电桩确实是个问题，我们这边还很稀缺。',   CAST((UNIX_TIMESTAMP() - 7200) * 1000 AS UNSIGNED),     '3', 4, 2),
('已经报名了，第一次跑全马，有点紧张。',           CAST((UNIX_TIMESTAMP() - 5400) * 1000 AS UNSIGNED),     '1', 2, 3),
('夜场开放这个安排很好，下班之后也能去看看。',     CAST((UNIX_TIMESTAMP() - 9000) * 1000 AS UNSIGNED),     '4', 3, 4);


-- 3.5 点赞 / 收藏示例
INSERT INTO `b_thing_wish` (`thing_id`, `user_id`) VALUES (1, 2), (1, 3), (2, 2), (3, 4), (6, 2);
INSERT INTO `b_thing_collect` (`thing_id`, `user_id`) VALUES (1, 2), (4, 3), (6, 2);


-- 3.6 浏览记录（给协同过滤推荐做冷启动，3 个不同 ip）
INSERT INTO `b_record` (`thing_id`, `score`, `ip`) VALUES
(1, 5, '192.168.1.101'),
(2, 3, '192.168.1.101'),
(6, 2, '192.168.1.101'),
(1, 4, '192.168.1.102'),
(3, 5, '192.168.1.102'),
(6, 3, '192.168.1.102'),
(2, 2, '192.168.1.103'),
(4, 4, '192.168.1.103'),
(6, 5, '192.168.1.103');


-- 3.7 公告
INSERT INTO `b_notice` (`title`, `content`, `create_time`) VALUES
('系统上线公告', '新闻管理系统已完成部署，欢迎各位使用。如有问题请通过意见反馈告诉我们。', CAST(UNIX_TIMESTAMP() * 1000 AS UNSIGNED)),
('内容规范提醒', '发布新闻时请注明来源，禁止发布未经核实的信息。', CAST((UNIX_TIMESTAMP() - 86400 * 2) * 1000 AS UNSIGNED));


-- 3.8 广告位
INSERT INTO `b_ad` (`image`, `link`, `create_time`) VALUES
('1085cacc-bd97-451b-b9f0-a5a3bfa0cd13.jpeg', 'https://www.qq.com', CAST(UNIX_TIMESTAMP() * 1000 AS UNSIGNED));


-- 3.9 意见反馈示例
INSERT INTO `b_feedback` (`title`, `content`, `name`, `email`, `mobile`) VALUES
('希望增加夜间模式', '晚上看新闻有点刺眼，希望前端能加一个深色主题切换。', '芙芙', 'user1@java_news.com', '13800000002');


-- ---------- 4. 校验 ----------
-- 执行完成后，可以用下面两条语句核对结果：
--   SHOW TABLES;                        -- 应返回 12 张 b_ 开头的表
--   SELECT (SELECT COUNT(*) FROM b_user)  AS 用户数,
--          (SELECT COUNT(*) FROM b_thing) AS 新闻数,
--          (SELECT COUNT(*) FROM b_classification) AS 分类数;
