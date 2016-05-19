drop view CONTENT_WITH_PIC;//

CREATE TABLE  CONTENT_WITH_PIC(
  content_id bigint(20) not null,
  content_code varchar(128) not null,
  title varchar(256) ,
  title_brief varchar(256) ,
  enable_status int(11) ,
  country_of_origin varchar(64) ,
  year varchar(4) ,
  director varchar(128) ,
  actors varchar(128) ,
  summary_medium varchar(1024),
  summary_short varchar(1024),
  key_word varchar(256) ,
  remark varchar(512) ,
  program_level int(11) ,
  reserve1 varchar(128) ,
  creation_date date ,
  poster varchar(512) ,
  still varchar(512) ,
  icon varchar(512) ,
  episode_number bigint(11) ,
  search_name varchar(128) ,
  run_time varchar(8) ,
  display_run_time varchar(8) ,
  content_type varchar(6) ,
  program_type varchar(128) ,
  provider varchar(64) ,
  product varchar(32) ,
  SUGGESTED_PRICE bigint(20) ,
  title_type varchar(128)
);//

/*==============================================================*/
/* Index: viewContentCodeIndex                                  */
/*==============================================================*/
create index viewContentCodeIndex on CONTENT_WITH_PIC
(
   content_code
);//


delimiter //
create trigger insert_program_trigger
 after insert on EPG_CONTENT_PROGRAM FOR EACH ROW
begin
     insert into CONTENT_WITH_PIC(`content_id`, `content_code`, `title`, `title_brief`, `enable_status`, `country_of_origin`, `year`, `director`, `actors`, `summary_medium`, `summary_short`, `key_word`, `remark`, `program_level`, `reserve1`, `creation_date`, `poster`, `still`, `icon`, `episode_number`, `search_name`, `run_time`, `display_run_time`, `content_type`, `program_type`, `provider`, `product`, `SUGGESTED_PRICE`, `title_type`) values(new.content_id,new.content_code,new.title,new.title_brief,new.enable_status,new.country_of_origin,new.year,new.director,new.actors,new.summary_medium,new.summary_short,new.key_word,new.remark,new.program_level,new.reserve1,new.creation_date,new.poster,new.still,new.icon,1,new.search_name,new.run_time,new.display_run_time,'vod',new.type,new.provider,new.product,new.SUGGESTED_PRICE,new.title_type);
end; //  

delimiter //
create trigger update_program_trigger
 after update on EPG_CONTENT_PROGRAM FOR EACH ROW
begin
     UPDATE CONTENT_WITH_PIC SET `content_code`=new.content_code, `title`=new.title, `title_brief`=new.title_brief, `enable_status`=new.enable_status, `country_of_origin`=new.country_of_origin, `year`=new.year, `director`=new.director, `actors`=new.actors, `summary_medium`=new.summary_medium, `summary_short`=new.summary_short, `key_word`=new.key_word, `remark`=new.remark, `program_level`=new.program_level, `reserve1`=new.reserve1, `creation_date`=new.creation_date, `poster`=new.poster, `still`=new.still, `icon`=new.icon, `episode_number`=1, `search_name`=new.search_name, `run_time`=new.run_time, `display_run_time`=new.display_run_time, `content_type`='vod', `program_type`=new.type, `provider`=new.provider, `product`=new.product, `SUGGESTED_PRICE`=new.SUGGESTED_PRICE, `title_type`=new.title_type where `content_id` = new.content_id;
end; //  

delimiter //
create trigger delete_program_trigger
 after delete on EPG_CONTENT_PROGRAM FOR EACH ROW
begin
     DELETE FROM CONTENT_WITH_PIC  where `content_id` = old.content_id;
end; // 



delimiter //
create trigger insert_series_trigger
 after insert on EPG_CONTENT_SERIES FOR EACH ROW
begin
     insert into CONTENT_WITH_PIC(`content_id`, `content_code`, `title`, `title_brief`, `enable_status`, `country_of_origin`, `year`, `director`, `actors`, `summary_medium`, `summary_short`, `key_word`, `remark`, `program_level`, `reserve1`, `creation_date`, `poster`, `still`, `icon`, `episode_number`, `search_name`, `run_time`, `display_run_time`, `content_type`, `program_type`, `provider`, `product`, `SUGGESTED_PRICE`, `title_type`) values(new.content_id,new.content_code,new.title,new.title_brief,new.enable_status,new.country_of_origin,new.year,new.director,new.actors,new.summary_medium,new.summary_short,new.key_word,new.remark,new.program_level,new.reserve1,new.creation_date,new.poster,new.still,new.icon,episode_number,new.search_name,null,null,'series','series',new.provider,null,0,'vod');
end; //  

delimiter //
create trigger update_series_trigger
 after update on EPG_CONTENT_SERIES FOR EACH ROW
begin
     UPDATE CONTENT_WITH_PIC SET `content_code`=new.content_code, `title`=new.title, `title_brief`=new.title_brief, `enable_status`=new.enable_status, `country_of_origin`=new.country_of_origin, `year`=new.year, `director`=new.director, `actors`=new.actors, `summary_medium`=new.summary_medium, `summary_short`=new.summary_short, `key_word`=new.key_word, `remark`=new.remark, `program_level`=new.program_level, `reserve1`=new.reserve1, `creation_date`=new.creation_date, `poster`=new.poster, `still`=new.still, `icon`=new.icon, `episode_number`=new.episode_number, `search_name`=new.search_name, `run_time`=null, `display_run_time`=null, `content_type`='series', `program_type`='series', `provider`=new.provider, `product`=null, `SUGGESTED_PRICE`=0, `title_type`='vod' where `content_id` = new.content_id;
end; //  

delimiter //
create trigger delete_series_trigger
 after delete on EPG_CONTENT_SERIES FOR EACH ROW
begin
     DELETE FROM CONTENT_WITH_PIC  where `content_id` = old.content_id;
end; //  

CREATE VIEW `CONTENT_WITH_PIC1` AS select `b`.`CONTENT_ID` AS `content_id`,`b`.`CONTENT_CODE` AS `content_code`,`b`.`TITLE` AS `title`,`b`.`TITLE_BRIEF` AS `title_brief`,`b`.`ENABLE_STATUS` AS `enable_status`,`b`.`COUNTRY_OF_ORIGIN` AS `country_of_origin`,`b`.`YEAR` AS `year`,`b`.`DIRECTOR` AS `director`,`b`.`ACTORS` AS `actors`,`b`.`SUMMARY_MEDIUM` AS `summary_medium`,`b`.`SUMMARY_SHORT` AS `summary_short`,`b`.`KEY_WORD` AS `key_word`,`b`.`REMARK` AS `remark`,`b`.`PROGRAM_LEVEL` AS `program_level`,`b`.`RESERVE1` AS `reserve1`,`b`.`CREATION_DATE` AS `creation_date`,`b`.`POSTER` AS `poster`,`b`.`STILL` AS `still`,`b`.`ICON` AS `icon`,`b`.`EPISODE_NUMBER` AS `episode_number`,`b`.`SEARCH_NAME` AS `search_name`,NULL AS `run_time`,NULL AS `display_run_time`,'series' AS `content_type`,'series' AS `program_type`,`b`.`PROVIDER` AS `provider`,NULL AS `product`,0 AS `SUGGESTED_PRICE`,'vod' AS `title_type` from `EPG_CONTENT_SERIES` `b` union select `a`.`CONTENT_ID` AS `content_id`,`a`.`CONTENT_CODE` AS `content_code`,`a`.`TITLE` AS `title`,`a`.`TITLE_BRIEF` AS `title_brief`,`a`.`ENABLE_STATUS` AS `enable_status`,`a`.`COUNTRY_OF_ORIGIN` AS `country_of_origin`,`a`.`YEAR` AS `year`,`a`.`DIRECTOR` AS `director`,`a`.`ACTORS` AS `actors`,`a`.`SUMMARY_MEDIUM` AS `summary_medium`,`a`.`SUMMARY_SHORT` AS `summary_short`,`a`.`KEY_WORD` AS `key_word`,`a`.`REMARK` AS `remark`,`a`.`PROGRAM_LEVEL` AS `program_level`,`a`.`RESERVE1` AS `reserve1`,`a`.`CREATION_DATE` AS `creation_date`,`a`.`POSTER` AS `poster`,`a`.`STILL` AS `still`,`a`.`ICON` AS `icon`,1 AS `episode_number`,`a`.`SEARCH_NAME` AS `search_name`,`a`.`RUN_TIME` AS `run_time`,`a`.`DISPLAY_RUN_TIME` AS `display_run_time`,'vod' AS `content_type`,`a`.`TYPE` AS `program_type`,`a`.`PROVIDER` AS `provider`,`a`.`PRODUCT` AS `product`,`a`.`SUGGESTED_PRICE` AS `SUGGESTED_PRICE`,`a`.`TITLE_TYPE` AS `title_type` from `EPG_CONTENT_PROGRAM` `a`;//

insert into CONTENT_WITH_PIC select * from CONTENT_WITH_PIC1;//

drop view CONTENT_WITH_PIC1; //

