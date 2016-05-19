CREATE VIEW `CONTENT_WITH_PIC` AS select `b`.`CONTENT_ID` AS `content_id`,`b`.`CONTENT_CODE` AS `content_code`,`b`.`TITLE` AS `title`,`b`.`TITLE_BRIEF` AS `title_brief`,`b`.`ENABLE_STATUS` AS `enable_status`,`b`.`COUNTRY_OF_ORIGIN` AS `country_of_origin`,`b`.`YEAR` AS `year`,`b`.`DIRECTOR` AS `director`,`b`.`ACTORS` AS `actors`,`b`.`SUMMARY_MEDIUM` AS `summary_medium`,`b`.`SUMMARY_SHORT` AS `summary_short`,`b`.`KEY_WORD` AS `key_word`,`b`.`REMARK` AS `remark`,`b`.`PROGRAM_LEVEL` AS `program_level`,`b`.`RESERVE1` AS `reserve1`,`b`.`CREATION_DATE` AS `creation_date`,`b`.`POSTER` AS `poster`,`b`.`STILL` AS `still`,`b`.`ICON` AS `icon`,`b`.`EPISODE_NUMBER` AS `episode_number`,`b`.`SEARCH_NAME` AS `search_name`,`b`.`MAIN_FOLDER` AS `main_folder`,`b`.`SUB_FOLDER` AS `sub_folder`,NULL AS `run_time`,NULL AS `display_run_time`,'series' AS `content_type`,'series' AS `program_type`,`b`.`PROVIDER` AS `provider`,NULL AS `product`,0 AS `SUGGESTED_PRICE`,'vod' AS `title_type` from `EPG_CONTENT_SERIES` `b` union select `a`.`CONTENT_ID` AS `content_id`,`a`.`CONTENT_CODE` AS `content_code`,`a`.`TITLE` AS `title`,`a`.`TITLE_BRIEF` AS `title_brief`,`a`.`ENABLE_STATUS` AS `enable_status`,`a`.`COUNTRY_OF_ORIGIN` AS `country_of_origin`,`a`.`YEAR` AS `year`,`a`.`DIRECTOR` AS `director`,`a`.`ACTORS` AS `actors`,`a`.`SUMMARY_MEDIUM` AS `summary_medium`,`a`.`SUMMARY_SHORT` AS `summary_short`,`a`.`KEY_WORD` AS `key_word`,`a`.`REMARK` AS `remark`,`a`.`PROGRAM_LEVEL` AS `program_level`,`a`.`RESERVE1` AS `reserve1`,`a`.`CREATION_DATE` AS `creation_date`,`a`.`POSTER` AS `poster`,`a`.`STILL` AS `still`,`a`.`ICON` AS `icon`,1 AS `episode_number`,`a`.`SEARCH_NAME` AS `search_name`,`a`.`RUN_TIME` AS `run_time`,`a`.`DISPLAY_RUN_TIME` AS `display_run_time`,'vod' AS `content_type`,`a`.`TYPE` AS `program_type`,`a`.`PROVIDER` AS `provider`,`a`.`PRODUCT` AS `product`,`a`.`SUGGESTED_PRICE` AS `SUGGESTED_PRICE`,`a`.`TITLE_TYPE` AS `title_type`,`a`.`MAIN_FOLDER` AS `main_folder`,`a`.`SUB_FOLDER` AS `sub_folder` from `EPG_CONTENT_PROGRAM` `a`









CREATE  VIEW `CONTENT_FOR_SEARCH` AS
  select distinct(p.content_id),p.title,p.content_code,'vod' as content_type,p.enable_status, p.search_name from EPG_CONTENT_PROGRAM p,EPG_CONTENT_OFFERING f,EPG_CATEGORY_ITEM item where p.content_code=f.content_code and p.TITLE_TYPE!='RTV'
and p.type='vod'
and f.service_type !='MOD'
and item.item_code=p.content_code
and p.ENABLE_STATUS=1
and item.STATUS=0
union
select distinct(s.content_id),s.title,s.content_code,'series' as content_type,s.enable_status, s.search_name from EPG_CONTENT_SERIES s,EPG_CONTENT_EPISODE e,EPG_CONTENT_OFFERING f,EPG_CATEGORY_ITEM item where s.content_id = e.series_id
and e.content_code = f.content_code
and s.content_code = item.item_code
and f.service_type !='MOD'
and s.enable_status=1
and item.STATUS=0
