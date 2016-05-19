
/*==============================================================*/
/* Table: EPG_AD_PUTTING                                        */
/*==============================================================*/
create table EPG_AD_PUTTING
(
   ID                   bigint(20) not null,
   CATEGORY_ID          bigint(20) not null comment '栏目标识',
   CATEGORY_CODE        varchar(128) not null comment '栏目编码',
   PUTTING              int(2) comment '是否投放：
            0：不投放
            1：投放',
   PROPERTY             varchar(128),
   primary key (ID)
);

alter table EPG_AD_PUTTING comment '广告配置表';

/*==============================================================*/
/* Index: ADCategoryCodeIndex                                   */
/*==============================================================*/
create index ADCategoryCodeIndex on EPG_AD_PUTTING
(
   CATEGORY_CODE
);

/*==============================================================*/
/* Table: EPG_BUSINESS                                          */
/*==============================================================*/
create table EPG_BUSINESS
(
   ID                   bigint(20) not null,
   NAME                 varchar(128),
   CODE                 varchar(128),
   TITLE                varchar(128),
   SUB_TITLE            varchar(128),
   TYPE                 varchar(32),
   STATUS               int(4),
   GENRE                varchar(128),
   VALID_TIME           datetime,
   EXPIRE_TIME          datetime,
   BUSINESS_ICON        varchar(256),
   DESCRIPTION          varchar(1024),
   primary key (ID)
);

/*==============================================================*/
/* Index: businessCodeIndex                                     */
/*==============================================================*/
create index businessCodeIndex on EPG_BUSINESS
(
   CODE
);

/*==============================================================*/
/* Table: EPG_CATEGORY                                          */
/*==============================================================*/
create table EPG_CATEGORY
(
   ID                   bigint(20) not null,
   NAME                 varchar(128) not null,
   TITLE                varchar(64) not null,
   CODE                 varchar(128) not null,
   ACTIVE_STATUS        int(2) not null default 0 comment '0：失效
            1：生效',
   CHILD_INDEX          int(8),
   PARENT_CODE          varchar(128),
   LOCATE_STRING        varchar(256) not null,
   CATEGORY_ICON        varchar(128),
   BACKGROUND           varchar(128),
   DESCRIPTION          varchar(1024),
   SERVICE_TYPES         varchar(64),
   primary key (ID)
);

/*==============================================================*/
/* Index: categoryCodeIndex                                     */
/*==============================================================*/
create index categoryCodeIndex on EPG_CATEGORY
(
   CODE
);

/*==============================================================*/
/* Table: EPG_CATEGORY_ITEM                                     */
/*==============================================================*/
create table EPG_CATEGORY_ITEM
(
   ID                   bigint(20) not null,
   CATEGORY_CODE        varchar(128) not null,
   ITEM_TYPE            varchar(64) not null,
   ITEM_CODE            varchar(128) not null,
   TITLE                varchar(256),
   SUB_TITLE            varchar(128),
   STATUS               int(2) not null comment '-1：已删除
            0：可见
            1：不可见',
   TYPE                 int(2) comment '0：普通
            1：置顶',
   SHOW_FLAG            int(2) comment '1： 火
            2： 热 
            3： 新 ',
   ITEM_ORDER           int(8),
   BEGIN_TIME           datetime,
   END_TIME             datetime,
   VALID_TIME           datetime,
   EXPIRE_TIME          datetime,
   ITEM_ICON            varchar(256),
   CREATE_TIME          datetime,
   primary key (ID)
);

/*==============================================================*/
/* Index: itemCategoryCodeIndex                                 */
/*==============================================================*/
create index itemCategoryCodeIndex on EPG_CATEGORY_ITEM
(
   CATEGORY_CODE
);

/*==============================================================*/
/* Index: itemCodeIndex                                         */
/*==============================================================*/
create index itemCodeIndex on EPG_CATEGORY_ITEM
(
   ITEM_CODE
);

/*==============================================================*/
/* Index: validTimeIndex                                        */
/*==============================================================*/
create index validTimeIndex on EPG_CATEGORY_ITEM
(
   VALID_TIME
);

/*==============================================================*/
/* Index: expireTimeIndex                                       */
/*==============================================================*/
create index expireTimeIndex on EPG_CATEGORY_ITEM
(
   EXPIRE_TIME
);

/*==============================================================*/
/* Table: EPG_CHANNEL_PARAM                                     */
/*==============================================================*/
create table EPG_CHANNEL_PARAM
(
   ID                   bigint(20) not null,
   CHANNEL_ID           bigint(20),
   CHANNEL_CODE         varchar(128) not null,
   CHANNEL_NUMBER       int(4),
   NETWORK_ID           varchar(32),
   CASYSTEM_ID          varchar(32),
   ECM_PID              varchar(32),
   VIDEO_PID            varchar(64),
   VIDEO_TYPE           varchar(16) comment '视频类型包括：
            mp1v
            mp2v
            mp4v
            h264
            vcl',
   AUDIO_PID            varchar(64),
   AUDIO_TYPE           varchar(16) comment '音频类型包括：
            mp1a
            mp2a
            mp4a
            ac3
            aac
            wma
            mp3',
   PCR_PID              varchar(32),
   FREQ                 bigint(12) comment '频率，单位Hz',
   SYM                  bigint(12) comment '符号率，单位：symbol/s',
   MOD_TYPE             int(8) comment 'QAM调制方式',
   SERVICE_ID           varchar(32) comment '服务标识',
   TRANSPORT_ID         varchar(32) comment '码流标识',
   primary key (ID)
);

alter table EPG_CHANNEL_PARAM comment '直播频道配置参数';

/*==============================================================*/
/* Index: channelCodeParamIndex                                 */
/*==============================================================*/
create index channelCodeParamIndex on EPG_CHANNEL_PARAM
(
   CHANNEL_CODE
);

/*==============================================================*/
/* Table: EPG_CONTENT_CHANNEL                                   */
/*==============================================================*/
create table EPG_CONTENT_CHANNEL
(
   CONTENT_ID           bigint(20) not null comment '记录标识',
   CONTENT_CODE         varchar(128) not null comment '内容编码',
   TITLE                varchar(128) not null comment '显示标题',
   TITLE_BRIEF          varchar(64) not null comment '显示标题',
   PROVIDER             varchar(64) comment '提供商',
   PROVIDER_ID          varchar(32) comment '提供商标识',
   CREATION_DATE        date comment '入库日期',
   RESERVE5             varchar(512),
   RESERVE4             varchar(256),
   RESERVE3             varchar(256),
   RESERVE2             varchar(128),
   RESERVE1             varchar(128),
   SERVICE_NAME         varchar(128),
   PLAY_URL             varchar(256),
   LIVE_CODE            varchar(32),
   CHANNEL_NUM          varchar(4),
   primary key (CONTENT_ID)
);

alter table EPG_CONTENT_CHANNEL comment '直播频道表';

/*==============================================================*/
/* Index: channelCodeIndex                                      */
/*==============================================================*/
create index channelCodeIndex on EPG_CONTENT_CHANNEL
(
   CONTENT_CODE
);

/*==============================================================*/
/* Table: EPG_CONTENT_EPISODE                                   */
/*==============================================================*/
create table EPG_CONTENT_EPISODE
(
   ID                   bigint(20) not null,
   EPISODE_INDEX        int(8) not null,
   CONTENT_ID           bigint(20) not null,
   SERIES_ID            bigint(20) not null,
   CONTENT_CODE         varchar(128) not null,
   SERIES_CODE          varchar(128) not null,
   primary key (ID)
);

alter table EPG_CONTENT_EPISODE comment '连续剧剧集表';

/*==============================================================*/
/* Index: seriesCodeEpisodeIndex                                */
/*==============================================================*/
create index seriesCodeEpisodeIndex on EPG_CONTENT_EPISODE
(
   SERIES_CODE
);

/*==============================================================*/
/* Table: EPG_CONTENT_LABEL                                     */
/*==============================================================*/
create table EPG_CONTENT_LABEL
(
   ID                   bigint(20) not null,
   CONTENT_CODE         varchar(128) not null,
   USER_ID              varchar(128) not null,
   EPISODE_INDEX        int(8) not null default 0,
   UPDATE_TIME          datetime,
   primary key (ID)
);

alter table EPG_CONTENT_LABEL comment '用于记录当前用户观看连续剧的集数';

/*==============================================================*/
/* Index: labelIndex                                            */
/*==============================================================*/
create index labelIndex on EPG_CONTENT_LABEL
(
   USER_ID
);

/*==============================================================*/
/* Table: EPG_CONTENT_MARK                                      */
/*==============================================================*/
create table EPG_CONTENT_MARK
(
   ID                   bigint(20) not null AUTO_INCREMENT,
   CONTENT_TYPE         varchar(64) not null,
   CONTENT_CODE         varchar(128) not null,
   GOOD_COUNT           bigint(11) not null default 0,
   BAD_COUNT            bigint(11) not null default 0,
   primary key (ID)
);

alter table EPG_CONTENT_MARK comment '记录用户对内容进行顶踩的统计';

/*==============================================================*/
/* Index: markContentCodeIndex                                  */
/*==============================================================*/
create index markContentCodeIndex on EPG_CONTENT_MARK
(
   CONTENT_CODE
);

/*==============================================================*/
/* Table: EPG_CONTENT_MEDIA                                     */
/*==============================================================*/
create table EPG_CONTENT_MEDIA
(
   ID                   bigint(20) not null,
   CONTENT_ID           bigint(20) not null comment '内容标识',
   CONTENT_CODE         varchar(128) comment '内容编码',
   TYPE                 varchar(16) not null comment 'movie:正片
            preview:预览片',
   AUDIO_TYPE           varchar(16) comment '音频类型',
   FILE_SIZE            bigint(20) comment '文件大小',
   CHECKSUM             varchar(64) comment '校验码',
   FILE_NAME            varchar(256) comment '文件名',
   FORMAT               varchar(64) comment '编码格式',
   BITRATE              varchar(64) comment '码流',
   HIGN_DEFITION        int(2) comment '1：高清
            0：不是高清',
   RESERVE1             varchar(128) comment '保留字段1',
   RESERVE2             varchar(128) comment '保留字段2',
   RESERVE3             varchar(256) comment '保留字段3',
   RESERVE4             varchar(256) comment '保留字段4',
   RESERVE5             varchar(512) comment '保留字段5',
   ASSET_ID             varchar(128),
   primary key (ID)
);

alter table EPG_CONTENT_MEDIA comment '内容媒体文件表';

/*==============================================================*/
/* Index: mediaContentCodeindex                                 */
/*==============================================================*/
create index mediaContentCodeindex on EPG_CONTENT_MEDIA
(
   CONTENT_CODE
);

/*==============================================================*/
/* Table: EPG_CONTENT_OFFERING                                  */
/*==============================================================*/
create table EPG_CONTENT_OFFERING
(
   ID                   bigint(20) not null comment 'ID',
   OFFERING_ID          varchar(128) comment 'offeringId',
   CONTENT_CODE         varchar(128) comment '内容编码',
   SERVICE_TYPE         varchar(64) comment '服务类型',
   SERVICE_NAME         varchar(128) comment '服务名称',
   SERVICE_CODE         varchar(128) comment '服务编码',
   SUGGESTED_PRICE      int(8) default NULL comment '建议价格',
   PRICE                int(8) default NULL comment '使用价格',
   RENTAL_DURATION      int(8) default NULL comment 'RENTAL周期',
   RESERVE1             varchar(128),
   RESERVE2             varchar(128),
   RESERVE3             varchar(256),
   RESERVE4             varchar(256),
   primary key (ID)
);

alter table EPG_CONTENT_OFFERING comment 'Offering表';

/*==============================================================*/
/* Table: EPG_CONTENT_PROGRAM                                   */
/*==============================================================*/
create table EPG_CONTENT_PROGRAM
(
   CONTENT_ID           bigint(20) not null comment '记录标识',
   CONTENT_CODE         varchar(128) comment '内容编码',
   TITLE                varchar(256) comment '显示标题',
   TITLE_BRIEF          varchar(256),
   PROVIDER             varchar(64) comment '提供商',
   RATING               varchar(10) comment '影片分级',
   RUN_TIME             varchar(8) comment '播出时长',
   DISPLAY_RUN_TIME     varchar(8) comment '显示时长',
   MAXIMUM_VIEWING_LENGTH varchar(10) comment '最大播出时长',
   PREVIEW_PERIOD       varchar(8) comment '预览片段时长',
   BILLING_ID           varchar(16) comment '计费标识',
   PRODUCT              varchar(32) comment '产品标识',
   SUGGESTED_PRICE      int(8) comment '建议价格，单位：分',
   COUNTRY_OF_ORIGIN    varchar(64) comment '发行国家',
   YEAR                 varchar(4) comment '发行年份',
   STUDIO               varchar(128) comment '发行公司',
   PRODUCERS            varchar(128) comment '制片',
   ACTORS               varchar(128) comment '演员',
   DIRECTOR             varchar(128) comment '导演',
   WRITER               varchar(128) comment '编剧',
   TAGS                 varchar(1024),
   SUMMARY_MEDIUM       varchar(1024) comment '内容简介',
   SUMMARY_SHORT        varchar(1024) comment '内容看点',
   CREATION_DATE        date comment '入库日期',
   COURTYARD            varchar(256) comment '院线信息',
   PROGRAM_LEVEL        int(2) comment '评分',
   VOD_DUB              varchar(64) comment '配音',
   VOD_CAPTION          varchar(64) comment '字幕',
   KEY_WORD             varchar(256) comment '关键字',
   REMARK               varchar(512) comment '备注',
   RESERVE1             varchar(128),
   RESERVE2             varchar(128),
   RESERVE3             varchar(256),
   RESERVE4             varchar(256),
   RESERVE5             varchar(512),
   OFFERING_ID          varchar(128),
   SERVICE_TYPE         varchar(64),
   SERVICE_NAME         varchar(128),
   POSTER               varchar(512),
   STILL                varchar(512),
   ICON                 varchar(512),
   ENABLE_STATUS        int(2) comment '可用状态，只有连续剧中所有剧集可用后，连续剧才可用
            0：不可用
            1：可用',
   SERVICE_CODE         varchar(128),
   TYPE                 varchar(128),
   SEARCH_NAME          varchar(128),
   TITLE_TYPE           varchar(128),
   PROVIDER_ID          varchar(32),
   MAIN_FOLDER varchar(64) default NULL,
   SUB_FOLDER varchar(64) default NULL,
   primary key (CONTENT_ID)
);

alter table EPG_CONTENT_PROGRAM comment '节目表';

/*==============================================================*/
/* Index: programCodeindex                                      */
/*==============================================================*/
create index programCodeindex on EPG_CONTENT_PROGRAM
(
   CONTENT_CODE
);

/*==============================================================*/
/* Index: searchNameindex                                       */
/*==============================================================*/
create index searchNameindex on EPG_CONTENT_PROGRAM
(
   SEARCH_NAME
);

/*==============================================================*/
/* Table: EPG_CONTENT_SCHEDULE                                  */
/*==============================================================*/
create table EPG_CONTENT_SCHEDULE
(
   ID                   bigint(20) not null,
   CHANNEL_CODE         varchar(128) not null,
   NAME                 varchar(256) not null,
   CODE                 varchar(128),
   BEGIN_TIME           datetime,
   END_TIME             datetime,
   CONTENT_CODE         varchar(128),
   primary key (ID)
);

alter table EPG_CONTENT_SCHEDULE comment '直播频道节目单表';

/*==============================================================*/
/* Index: channelCodeScheduleIndex                              */
/*==============================================================*/
create index channelCodeScheduleIndex on EPG_CONTENT_SCHEDULE
(
   CHANNEL_CODE
);

/*==============================================================*/
/* Table: EPG_CONTENT_SERIES                                    */
/*==============================================================*/
create table EPG_CONTENT_SERIES
(
   CONTENT_ID           bigint(20) not null comment '记录标识',
   CONTENT_CODE         varchar(128) comment '内容编码',
   TITLE                varchar(256) comment '显示标题',
   TITLE_BRIEF          varchar(256) comment '显示标题',
   ENABLE_STATUS        int(2) comment '可用状态，只有连续剧中所有剧集可用后，连续剧才可用
            0：不可用
            1：可用',
   EPISODE_NUMBER       int(8) not null default 0 comment '连续剧总集数',
   PROVIDER             varchar(64) comment '提供商',
   COUNTRY_OF_ORIGIN    varchar(64) comment '发行国家',
   YEAR                 varchar(4) comment '发行年份',
   STUDIO               varchar(128) comment '发行公司',
   PRODUCERS            varchar(128) comment '制片',
   ACTORS               varchar(128) comment '演员',
   DIRECTOR             varchar(128) comment '导演',
   WRITER               varchar(128) comment '编剧',
   SUMMARY_MEDIUM       varchar(1024) comment '内容简介',
   SUMMARY_SHORT        varchar(1024) comment '内容看点',
   CREATION_DATE        date comment '入库日期',
   PROGRAM_LEVEL        int(2) comment '评分',
   VOD_DUB              varchar(64) comment '配音',
   VOD_CAPTION          varchar(64) comment '字幕',
   KEY_WORD             varchar(256) comment '关键字',
   REMARK               varchar(512) comment '备注',
   RESERVE1             varchar(128),
   RESERVE2             varchar(128),
   RESERVE3             varchar(256),
   RESERVE4             varchar(256),
   RESERVE5             varchar(512),
   ICON                 varchar(512),
   STILL                varchar(512),
   POSTER               varchar(512),
   SEARCH_NAME          varchar(128),
   TAGS					varchar(128),
   RUN_TIME				varchar(8),
   DISPLAY_RUN_TIME		varchar(8),
   MAIN_FOLDER varchar(64) default NULL,
   SUB_FOLDER varchar(64) default NULL,
   primary key (CONTENT_ID)
);

alter table EPG_CONTENT_SERIES comment '连续剧表';

/*==============================================================*/
/* Index: seriesCodeIndex                                       */
/*==============================================================*/
create index seriesCodeIndex on EPG_CONTENT_SERIES
(
   CONTENT_CODE
);

/*==============================================================*/
/* Index: seriesSearchNameIndex                                 */
/*==============================================================*/
create index seriesSearchNameIndex on EPG_CONTENT_SERIES
(
   SEARCH_NAME
);

/*==============================================================*/
/* Table: EPG_HOST_PROFILE                                      */
/*==============================================================*/
create table EPG_HOST_PROFILE
(
   ID                   bigint(20) not null AUTO_INCREMENT,
   GROUP_ID             bigint(20),
   HOST_CODE            varchar(128),
   HOST_NAME            varchar(128),
   HOST_IP              varchar(32),
   NAME                 varchar(128),
   VALUE                varchar(128),
   STATUS               int(2),
   primary key (ID)
);

alter table EPG_HOST_PROFILE comment '主机配置';

/*==============================================================*/
/* Index: hostProfileHostNameIndex                              */
/*==============================================================*/
create index hostProfileHostNameIndex on EPG_HOST_PROFILE
(
   HOST_NAME
);

/*==============================================================*/
/* Table: EPG_POSITION                                          */
/*==============================================================*/
create table EPG_POSITION
(
   ID                   bigint(20) not null,
   CODE                 varchar(128) not null,
   TYPE                 varchar(32),
   AD_CODE              varchar(128),
   VALID_TIME           datetime,
   EXPIRE_TIME          datetime,
   WEIGHT               int(3),
   OBJ_TYPE             varchar(32) not null comment 'image：图片
            vod：点播视频
            channel：直播视频
            text：文字',
   OBJ_VALUE            varchar(128) not null,
   LINK_OBJ_TYPE        varchar(31) comment 'vod：点播视频
            channel：直播视频
            subject：专题
            category：栏目
            tvbar：看吧
            url：外部链接',
   LINK_OBJ_VALUE       varchar(128),
   DEFAULT_FLAG         int(1) not null default 0,
   primary key (ID)
);

alter table EPG_POSITION comment '推荐元素信息表';

/*==============================================================*/
/* Index: positionCodeIndex                                     */
/*==============================================================*/
create index positionCodeIndex on EPG_POSITION
(
   CODE
);

/*==============================================================*/
/* Table: EPG_SUBJECT_PAGE                                      */
/*==============================================================*/
create table EPG_SUBJECT_PAGE
(
   ID                   bigint(20) not null,
   SUBJECT_TITLE        varchar(128),
   SUBJECT_CODE         varchar(128),
   PAGE_NAME            varchar(128) not null,
   PAGE_CODE            varchar(128) not null,
   BACKGROUND           varchar(128) not null,
   DEFAULT_FLAG         int(1) not null default 0 comment '0：不是
            1：不是',
   primary key (ID)
);

alter table EPG_SUBJECT_PAGE comment '专题页面信息表';

/*==============================================================*/
/* Index: subjectCodeIndex                                      */
/*==============================================================*/
create index subjectCodeIndex on EPG_SUBJECT_PAGE
(
   SUBJECT_CODE
);

/*==============================================================*/
/* Index: pageCodeIndex                                         */
/*==============================================================*/
create index pageCodeIndex on EPG_SUBJECT_PAGE
(
   PAGE_CODE
);

/*==============================================================*/
/* Table: EPG_SUBJECT_REGION                                    */
/*==============================================================*/
create table EPG_SUBJECT_REGION
(
   ID                   bigint(20) not null,
   PAGE_CODE            varchar(64),
   LOCATION             varchar(64) not null,
   OBJ_TYPE             varchar(32) not null,
   OBJ_CODE             varchar(128) not null,
   DEFAULT_AREA         int(1),
   primary key (ID)
);

alter table EPG_SUBJECT_REGION comment '页面热区信息表';

/*==============================================================*/
/* Index: hotareaPageCodeIndex                                  */
/*==============================================================*/
create index hotareaPageCodeIndex on EPG_SUBJECT_REGION
(
   PAGE_CODE
);

/*==============================================================*/
/* Table: EPG_SUBSCRIBER                                        */
/*==============================================================*/
create table EPG_SUBSCRIBER
(
   ID                   bigint(20) not null AUTO_INCREMENT,
   USER_ACCOUNT         varchar(128) not null comment '用户帐号',
   MAC_ADDRESS          varchar(64) not null comment 'MAC地址',
   OSS_USER_ID          varchar(128) comment '外部标识',
   USER_NAME            varchar(64) comment '用户名称',
   ADDRESS              varchar(512) comment '家庭住址',
   ZIP_CODE             varchar(10) comment '邮政编码',
   PHONE_NUMBER         varchar(16) comment '联系电话',
   EMAIL                varchar(128) comment '电子邮箱',
   USER_GROUP           varchar(128) comment '用户组',
   EXPLORE_NAME         varchar(128) comment '浏览器名',
   EXPLORE_VERSION      varchar(128) comment '浏览器版本',
   NETWORK_ID           varchar(8) comment '网络号,0001/0002',
   STB_MODEL            varchar(128) comment '机顶盒型号',
   STB_TYPE             varchar(8) comment '机顶盒类型,sd/hd',
   RTSPD                varchar(8) comment 'rtsp_d 播放时使用,1 或其他',
   PROTOCOL_TYPE        varchar(128) comment '协议类型,rtsp,hfc/rtsp,ip',
   primary key (ID)
);

alter table EPG_SUBSCRIBER comment '订户信息表';

/*==============================================================*/
/* Index: subscriberUserAccountIndex                            */
/*==============================================================*/
create index subscriberUserAccountIndex on EPG_SUBSCRIBER
(
   USER_ACCOUNT
);

/*==============================================================*/
/* Index: subscriberMacAddressIndex                             */
/*==============================================================*/
create index subscriberMacAddressIndex on EPG_SUBSCRIBER
(
   MAC_ADDRESS
);

/*==============================================================*/
/* Index: subscriberOSSUserIdIndex                              */
/*==============================================================*/
create index subscriberOSSUserIdIndex on EPG_SUBSCRIBER
(
   OSS_USER_ID
);

/*==============================================================*/
/* Table: EPG_SUBSCRIBER_PPV                                    */
/*==============================================================*/
create table EPG_SUBSCRIBER_PPV
(
   ID                   bigint(20) not null AUTO_INCREMENT,
   USER_ACCOUNT         varchar(128) not null comment '用户帐号',
   USER_ID              varchar(128) not null,
   USER_MAC             varchar(64) comment 'MAC地址',
   BIZ_CODE             varchar(128) comment '看吧标识',
   CATEGORY_CODE        varchar(128) comment '栏目标识',
   CATEGORY_NAME        varchar(128) comment '栏目名称',
   PROGRAM_CODE         varchar(128) not null comment '内容标识',
   PROGRAM_TITLE        varchar(128) not null comment '内容名称',
   OFFERINGID           varchar(128) not null comment 'OfferingID',
   SERVICENAME          varchar(128) comment 'ServiceName',
   SERVICECODE          varchar(128) comment 'ServiceCode',
   SERVICETYPE          varchar(64) comment 'ServiceType',
   PROGRAM_TYPE         varchar(50) comment '影片类型',
   PROTOCOL_TYPE        varchar(128) comment '使用场景',
   PRICE                int(8) comment '单位：分',
   ORDER_TIME           date comment '订购时间',
   VALID_TIME           date comment '生效时间',
   EXPIRE_TIME          date comment '失效时间',
   FILE_NAME            varchar(256) comment '实体文件名',
   primary key (ID)
);

alter table EPG_SUBSCRIBER_PPV comment '按次点播订购列表';

/*==============================================================*/
/* Index: subscriberPPVMACFileNameIndex                         */
/*==============================================================*/
create index subscriberPPVMACFileNameIndex on EPG_SUBSCRIBER_PPV
(
   USER_MAC,
   FILE_NAME
);

/*==============================================================*/
/* Table: EPG_TEMPLATE_BIND                                     */
/*==============================================================*/
create table EPG_TEMPLATE_BIND
(
   ID                   bigint(20) not null,
   BIZ_CODE             varchar(128) not null,
   CATEGORY_CODE        varchar(128),
   LOCATE_STR           varchar(256),
   CONTENT_TYPE         varchar(32) comment '一个栏目或一个看吧下可以绑定多个详细页面模板，按内容类型进行区分',
   TEMPLATE_TYPE        varchar(32) not null,
   TEMPLATE_CODE        varchar(128) not null,
   TMP_PACK_CODE        varchar(128) not null,
   TEMPLATE_PATH        varchar(128) comment '模板文件相对于模板包所在目录的路径',
   TEMPLATE_PARAMS      varchar(2000) comment '格式：
            参数名1=参数类型1=参数值1|参数名2=参数类型2=参数值2|......',
   primary key (ID)
);

/*==============================================================*/
/* Index: tempBindBizCodeIndex                                  */
/*==============================================================*/
create index tempBindBizCodeIndex on EPG_TEMPLATE_BIND
(
   BIZ_CODE
);

/*==============================================================*/
/* Index: tempBindCatCodeIndex                                  */
/*==============================================================*/
create index tempBindCatCodeIndex on EPG_TEMPLATE_BIND
(
   CATEGORY_CODE
);

/*==============================================================*/
/* Table: EPG_USER_COLLECTION                                   */
/*==============================================================*/
create table EPG_USER_COLLECTION
(
   ID                   bigint(20) not null AUTO_INCREMENT,
   USER_ID              varchar(128) not null,
   CONTENT_NAME         varchar(128) not null,
   CONTENT_TYPE         varchar(32) not null,
   CONTENT_CODE         varchar(128) not null,
   COLLECT_TIME         date not null,
   BIZ_CODE             varchar(128),
   CATEGORY_CODE        varchar(128),
   primary key (ID)
);

alter table EPG_USER_COLLECTION comment '用户内容收藏记录';

/*==============================================================*/
/* Index: collectionUserIdIndex                                 */
/*==============================================================*/
create index collectionUserIdIndex on EPG_USER_COLLECTION
(
   USER_ID
);

/*==============================================================*/
/* Index: collectionContentCodeIndex                            */
/*==============================================================*/
create index collectionContentCodeIndex on EPG_USER_COLLECTION
(
   CONTENT_CODE
);


/*==============================================================*/
/* Table: EPG_CONTENT_VOTE                                      */
/*==============================================================*/
create table EPG_CONTENT_VOTE 
(
   ID                   bigint(20) not null AUTO_INCREMENT,
   CONTENT_TYPE         VARCHAR(64)         not null,
   CONTENT_CODE         VARCHAR(128)        not null,
   GOOD_COUNT           int(11) not null default 0,
   BAD_COUNT            int(11) not null default 0,
   SCORE                int(2) not null default 0, 
   primary key (ID)
);

alter table EPG_CONTENT_VOTE comment '记录用户对内容进行顶踩打分的统计';



/*==============================================================*/
/* Table: EPG_VOTE_RECORD                                       */
/*==============================================================*/
create table EPG_VOTE_RECORD 
(
   ID                   bigint(20) not null AUTO_INCREMENT,
   USER_MAC             VARCHAR(50)    not null,
   CONTENT_TYPE         VARCHAR(64)    not null,
   CONTENT_CODE         VARCHAR(128)   not null,
   VOTE_METHOD          VARCHAR(50)    not null,
   VOTE_VAL             int(2)      not null,
   VOTE_TIME            datetime           not null,
   primary key (ID)
);

alter table EPG_VOTE_RECORD comment '记录用户进行投票的操作记录';


/*==============================================================*/
/* Table: EPG_CONTENT_LIVE                                       */
/*==============================================================*/

create table EPG_CONTENT_LIVE 
(
   ID                   bigint(20) not null AUTO_INCREMENT,
   EVENT_ID             int(10),
   NAME                 VARCHAR(256),   
   DESCRIPTION          VARCHAR(512),
   BEGIN_TIME           datetime,
   END_TIME             datetime,
   DURATION             VARCHAR(128),
   CREATION_TIME	datetime,
   SCHEDULE_DATE	datetime,
   CHANNEL_CODE		VARCHAR(20),
   primary key (ID)
);

alter table EPG_CONTENT_LIVE comment '直播节目单';




/*==============================================================*/
/* Table: EPG_CONTENT_TIMESHIFT                                      */
/*==============================================================*/

CREATE TABLE EPG_CONTENT_TIMESHIFT 
(
	OFFERING_ID 	VARCHAR(64), 
	SERVICE_NAME 	VARCHAR(64), 
	ASSET_ID 	VARCHAR(128), 
	PRODUCT 	VARCHAR(128), 
	CONTENT_NAME 	VARCHAR(128), 
	CONTENT_CODE 	VARCHAR(128), 
	RUN_TIME 	VARCHAR(128), 
	START_DATE 	VARCHAR(128), 
	CHANNEL_CODE 	varchar(64),
	ID 		bigint(20) not null AUTO_INCREMENT,
	primary key (ID)
);

alter table EPG_CONTENT_TIMESHIFT comment '频道时移表';