监控语句：
查询session信息状态：
set lines 200 pages 999
col username for a20
col OSUSER for a10D
col program for a20
col event for a25
col wait_class for a20
col ora_user for a20
col machine for a15
col PROGRAM for a20
col event for a40
select sid,serial#,inst_id,event,sql_id,machine,last_call_et esca_time,osuser,username ora_user,wait_class from gv$session where type not like 'BACK%' and status='ACTIVE' and wait_class<>'Idle' and username<>'SYS'  order by 5;


set lines 200
col file_name for a55
select file_name,bytes/1024/1024 MB,tablespace_name,AUTOEXTENSIBLE from dba_data_files order by 1;

select file_name,bytes/1024/1024 MB,tablespace_name,AUTOEXTENSIBLE from dba_data_files where tablespace_name='&tname' order by 1;

select name,TOTAL_MB,FREE_MB,trunc((TOTAL_MB-FREE_MB)/TOTAL_MB*100) usage from v$asm_diskgroup;
查询并行pz：
 select inst_id,sid, program,status from gv$session where program like '%PZ%';

非活跃链接：
select sid,serial#,inst_id,event,sql_id,machine,last_call_et esca_time,osuser,username ora_user,wait_class from gv$session where type not like 'BACK%' and status='INACTIVE' and wait_class='Idle'  order by 5;


select sid,serial#,inst_id,event,sql_id,machine,last_call_et esca_time,osuser,username ora_user,wait_class from gv$session where type not like 'BACK%'  and username='OMS_FRONT_R';

查看系统帐号：
select sid,serial#,inst_id,event,sql_id,machine,last_call_et esca_time,osuser,username ora_user,wait_class from gv$session where type not like 'BACK%' and status='INACTIVE' and wait_class ='Idle'  order by 5;

select sid,serial#,inst_id,event,sql_id,machine,last_call_et esca_time,osuser,username ora_user,wait_class from gv$session where type not like 'BACK%' and status='INACTIVE' and wait_class='Idle' and username='LIVE_SSOUSER_SIT'  order by 5;

wait_time时间定位：
select sid,serial#,inst_id,event,sql_id,machine,last_call_et esca_time,osuser,username ora_user,wait_class from gv$session where type not like 'BACK%' and status='ACTIVE' and wait_class<>'Idle' and username<>'SYS'  order by 5;

program:
select sid,serial#,inst_id,event,sql_id,machine,last_call_et esca_time,osuser,username ora_user,program from gv$session where type not like 'BACK%' and status='ACTIVE' and wait_class<>'Idle' and username<>'SYS' order by 5;

按照等待事件查询：
select sid,serial#,inst_id,event,sql_id,machine,last_call_et esca_time,osuser,username ora_user,wait_class from gv$session where type not like 'BACK%' and status='ACTIVE' and wait_class<>'Idle' and event='cursor: mutex S' order by 5;


select event,inst_id,last_call_et,sid,machine,user from gv$session where last_call_et>10 and status='ACTIVE' AND EVENT LIKE 'cursor: mutex%' AND TYPE NOT LIKE 'BACK%';

--查看当前哪些用户使用撤销段以及段的大小，启动时间，活动状态等
SELECT t.xidusn,t.start_time,t.used_ublk,t.status,s.username,r.segment_name FROM v$transaction t  JOIN v$session s ON t.ses_addr = s.saddr
JOIN dba_rollback_segs r  ON r.segment_id = t.xidusn ;

默认表空间：
col property_value for a10
col description for a40
select * from database_properties where property_name = 'DEFAULT_PERMANENT_TABLESPACE';

查看机器连接：
netstat -anpl|grep :31521|awk {'print $5'}|cut -d":" -f1|sort|uniq -c|sort -n
ps -ef|grep LOCAL|wc -l 
查看状态数量：
netstat -na |awk '{print $6}'|sort |uniq -c |sort -nr
根据数量异常过滤：
netstat -na |grep CLOSE_WAIT|awk '{print $5}'|awk -F":" '{print $1}'|sort |uniq -c |sort -nr |wc -l

Oracle错误之Process(m000) creation failed
PMON进程无法启动该进程。一般情况下，PMON无法启动进程原因有3个：1、Oracle连接数超过进程数限制。2、进程死锁。3、bug
alert日志错误，正是由于Oracle达到了进程数限制，进而PMON无法创建m000进程

select sid, serial#, username
  from v$session
 where machine = 'S1PA45'
   and username = 'LIVE_PUB'
   and type not like 'BACK%'
   and status = 'ACTIVE'
   and wait_class <> 'Idle'
   and username <> 'SYS';
   
ogg-01820:WORKSPACE:
grant execute on DBMS_WM to CATB_OGG;
grant execute on DBMS_AQ to CATB_OGG ;
grant execute on DBMS_AQADM to CATB_OGG ;
GRANT WM_ADMIN_ROLE TO CATB_OGG;
EXECUTE DBMS_WM.GrantSystemPriv ('ACCESS_ANY_WORKSPACE', 'CATB_OGG', 'YES');


BOUNDED RECOVERY: reset to initial or altered checkpoint.

错误信息：BOUNDED RECOVERY: reset to initial or altered checkpoint. 数据库问题，不能读取第2个节点的archivelog文件;


OGG logretention:
 Unregister extract LOGRETENTION
 
GGSCI (server41) 16> register extract EXT125 logretention
 select first_change#,next_change#,sequence# from v$archived_log;
 
 select capture_name,capture_user,start_scn,status from dba_capture;

SQL> col first_scn for 999999999999999
SQL> col start_scn for 99999999999999999
SQL> select first_scn,start_scn from dba_capture;

       FIRST_SCN          START_SCN
---------------- ------------------
    346333199371       346333199371

SQL> 

DEFSFILE ./dirdef/source.def,?PURGE

 SELECT * FROM dba_profiles s WHERE s.profile='DEFAULT'
忘记密码：
 select name,user#,password,SPARE4 from user$ where name='&name';
根据SPARE4修改：
alter user RW_ORA_MYSQL_BIGDATA identified by values '&SPARE4';
 
alter user WEBSERVICE  identified by "oJvDRcP2";


检查内存抖动：
set linesize 1000
set pagesize 1000
select component, oper_type, oper_mode, initial_size/1024/1024 "INITIAL", TARGET_SIZE/1024/1024
"TARGET", FINAL_SIZE/1024/1024 "FINAL", status, TO_CHAR(end_time, 'DD/MM/YYYY HH:MI:SS') "DATE" from V$SGA_RESIZE_OPS order by end_time;

查看组件大小：
select component,current_size/1024/1024/1024 GB from v$memory_dynamic_components where component like '%Target%';


快速回滚参数：
ALTER SYSTEM SET fast_start_parallel_rollback='HIGH' SCOPE=BOTH;

统计索引优化参数值optimizer_index_cost_adj：
asktom中给出一个查询OPTIMIZER_INDEX_COST_ADJ 方法：
select round((select average_wait
                from v$system_event
               where event='db file sequential read')/
             (select average_wait
                from v$system_event
               where event='db file scattered read')
            * 100)
  from dual;

这个数反映执行多块IO（全表扫描）的成本与执行单个IO（索引读取）的成本。保持为100，则多块IO与单块IO成本相同。设为50优化程序认为访问单块IO的成本为多块IO的一半。
OPTIMIZER_INDEX_CACHING参数说明：
这个表明的是在nested loops joins and IN-list iterators的时候,如果使用了OPTIMIZER_INDEX_CACHING参数,
表明两个表关联的时候优化器考虑index cache的比例,从而选择不同的执行计划.
而不是网上所说的优化器考虑所有情况下的index的cache情况(
这个参数只有在nested loops joins and IN-list iterators表关联的时候的index才会被优化器考虑[index cache的比例]).
进一步说明:这个参数影响两个表关联的时候是选择hash jion还是nested loops joins/sort-merge joins
  
SELECT a.average_wait AS "Full Scan Read I/O-Waits",
       b.average_wait AS "Index Read I/O-Waits",
       a.total_waits / (a.total_waits + b.total_waits)
       * 100 AS "Full Scan-I/O-Waits %",
       b.total_waits / (a.total_waits + b.total_waits)
       * 100 AS "Index Scan-I/O-Waits %",
       (b.average_wait / a.average_wait)
       * 100 AS "=> optimizer_index_cost_adj"
  FROM v$system_event a, v$system_event b
 WHERE a.event = 'db file scattered read'
   AND b.event = 'db file sequential read';


还原系统参数：
alter system reset open_cursors scope=memory sid='*';
 alter system set memory_max_target=0 scope=spfile;
 alter system reset memory_target scope=spfile;


 alter database rename file '/oracle/base/oradata/orcl/users01.dbf'  to '/data/oradata/users01.dbf'; 

create spfile='+DATADISK/eccdb/spfileeccdb.ora' from pfile='/tmp/spflileecc.ora';


Oracle 查询方法：
SELECT /* + RULE */ df.tablespace_name "Tablespace",
df.bytes / (1024 * 1024) "Size (MB)",
SUM(fs.bytes) / (1024 * 1024) "Free (MB)",
Nvl(Round(SUM(fs.bytes) * 100 / df.bytes),1) "% Free",
Round((df.bytes - SUM(fs.bytes)) * 100 / df.bytes) "% Used"
FROM dba_free_space fs,
(SELECT tablespace_name,SUM(bytes) bytes
FROM dba_data_files
GROUP BY tablespace_name) df
WHERE fs.tablespace_name (+) = df.tablespace_name
GROUP BY df.tablespace_name,df.bytes
UNION ALL
SELECT /* + RULE */ df.tablespace_name tspace,
fs.bytes / (1024 * 1024),
SUM(df.bytes_free) / (1024 * 1024),
Nvl(Round((SUM(fs.bytes) - df.bytes_used) * 100 / fs.bytes), 1),
Round((SUM(fs.bytes) - df.bytes_free) * 100 / fs.bytes)
FROM dba_temp_files fs,
(SELECT tablespace_name,bytes_free,bytes_used
FROM v$temp_space_header
GROUP BY tablespace_name,bytes_free,bytes_used) df
WHERE fs.tablespace_name (+) = df.tablespace_name
GROUP BY df.tablespace_name,fs.bytes,df.bytes_free,df.bytes_used
ORDER BY 4 DESC;


 
select NVL(b.free,0.0),a.total,100 - trunc(NVL(b.free,0.0)/a.total *
1000) / 10 prc from ( select tablespace_name,sum(bytes)/1024/1024 total
from dba_data_files group by tablespace_name) A LEFT OUTER JOIN (
select tablespace_name,sum(bytes)/1024/1024 free from dba_free_space
group by tablespace_name) B ON a.tablespace_name=b.tablespace_name
WHERE a.tablespace_name='BIZ_DATA';

表空间使用情况：
select 
b.file_name 物理文件名,
b.tablespace_name 表空间,
b.bytes/1024/1024 大小M,
(b.bytes-sum(nvl(a.bytes,0)))/1024/1024  已使用M,
substr((b.bytes-sum(nvl(a.bytes,0)))/(b.bytes)*100,1,5)  利用率 
from dba_free_space a,dba_data_files b 
where a.file_id=b.file_id 
group by b.tablespace_name,b.file_name,b.bytes 
order by b.tablespace_name;

--查看当前的undo空闲
select tablespace_name,sum(bytes/1024/1024) from dba_free_space where tablespace_name='UNDOTBS1' group by tablespace_name;

select tablespace_name,sum(bytes/1024/1024) from dba_free_space where tablespace_name='PSAPUNDO' group by tablespace_name;

查看回滚段：
select SEGMENT_NAME,TABLESPACE_NAME,STATUS from dba_rollback_segs where TABLESPACE_NAME = 'UNDOTBS2' and status = 'ONLINE';  
select SEGMENT_NAME,TABLESPACE_NAME,STATUS from dba_rollback_segs where TABLESPACE_NAME = 'PSAPUNDO2' and status = 'ONLINE';

  SELECT DISTINCT STATUS, SUM(BYTES)/1024/1024, COUNT(*) FROM DBA_UNDO_EXTENTS where tablespace_name = 'PSAPUNDO1' GROUP BY STATUS;
 select SEGMENT_NAME,TABLESPACE_NAME,STATUS from dba_rollback_segs where TABLESPACE_NAME = 'PSAPUNDO' and status = 'ONLINE';

查看占用undo大的sql_id：

select s.sid,s.serial#,s.sql_id,v.usn,segment_name,r.status, v.rssize/1024/1024 mb
      From dba_rollback_segs r, gv$rollstat v,gv$transaction t,gv$session s
      Where r.segment_id = v.usn and v.usn=t.xidusn and t.addr=s.taddr
      order by segment_name ;

再查sql：
select * from table(dbms_xplan.display_awr('&sql_id'));
查看回滚进度
set linesize 100 
  alter session set NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS'; 
  select usn, state, undoblockstotal "Total", undoblocksdone "Done", undoblockstotal-undoblocksdone "ToDo",
         decode(cputime,0,'unknown',sysdate+(((undoblockstotal-undoblocksdone) / (undoblocksdone / cputime)) / 86400)) "Estimated time to complete" 
  from v$fast_start_transactions;

加快undo速度：
alter system set fast_start_parallel_rollback='HIGH' sid='omsdb2';

回滚段正在处理的事务 

select a.name, b.xacts, c.sid, c.serial#, d.sql_text  
   from v$rollname    a,  
        v$rollstat    b,  
        v$session     c,  
        v$sqltext     d,  
        v$transaction e  
  where a.usn = b.usn  
    and b.usn = e.xidusn  
    and c.taddr = e.addr  
    and c.sql_address = d.address  
    and c.sql_hash_value = d.hash_value  
  order by a.name, c.sid, d.piece;  


gamp：查询链接：
select *
  from GAMP.CONN_MONITOR_SESS_TOTAL t
 where t.server_addr = '10.58.12.204'
   and t.sample_date > to_date('2016-03-10 00:00:00','yyyy-mm-dd hh24:mi:ss')

检查临时表空间大小：
SELECT TABLESPACE_NAME,TABLESPACE_SIZE/1024/1024/1024 AS TABLESPACE_SIZE_G,ALLOCATED_SPACE/1024/1024/1024 AS ALLOCATED_SPACE_G,FREE_SPACE/1024/1024/1024 AS FREE_SPACE_G FROM DBA_TEMP_FREE_SPACE;

查看占用临时段的信息：
select * from (
select
a.sid,a.username,a.machine,a.program,a.status,a.sql_id,
b.tablespace,b.segfile#,b.blocks
from v$session a,v$sort_usage b
where a.saddr = b.session_addr
      and a.sql_id is not null
order by a.status,b.blocks desc)
where rownum < 21
order by blocks desc,machine,program;

set lines 200
col "BYTES_M" for a15
col "USED_%" for a15
col "NAME" for a15
col  "USED_M" for a15
SELECT d.status "STATUS",d.tablespace_name "NAME",d.contents "LEIXING",d.extent_management "MANAGEMENT",
TO_CHAR(NVL(a.bytes/1024/1024,0),'99,999,990.900') "BYTES_M",
NVL(t.bytes,0)/1024/1024 || '/' || NVL(a.bytes/1024/1024,0) "USED_M",
TO_CHAR(NVL(t.bytes/a.bytes*100,0),'990.00') "USED_%"
FROM sys.dba_tablespaces d,
(select tablespace_name,sum(bytes) bytes from dba_temp_files group by tablespace_name) a,
(select tablespace_name,sum(bytes_cached) bytes from v$temp_extent_pool group by tablespace_name) t
WHERE d.tablespace_name=a.tablespace_name(+)
AND d.tablespace_name=t.tablespace_name(+)
AND d.contents like 'TEMPORARY';

查看引起latch: cache buffers chains的sql：
 select * from (select 
    count(*), 
    sql_id, 
    nvl(o.object_name,ash.current_obj#) objn,
    substr(o.object_type,0,10) otype,
    CURRENT_FILE# fn,
    CURRENT_BLOCK# blockn
   from  gv$active_session_history ash, all_objects o
   where event like 'latch: cache buffers chains'
     and o.object_id (+)= ash.CURRENT_OBJ#
   group by sql_id, current_obj#, current_file#,
                  current_block#, o.object_name,o.object_type
   order by  count(*) desc )where rownum <=10;

查询热点快的对象：
SELECT *
  FROM (SELECT O.OWNER, O.OBJECT_NAME, O.OBJECT_TYPE, SUM(TCH) TOUCHTIME
          FROM X$BH B, DBA_OBJECTS O
         WHERE B.OBJ = O.DATA_OBJECT_ID
           AND B.TS# > 0
         GROUP BY O.OWNER, O.OBJECT_NAME, O.OBJECT_TYPE
         ORDER BY SUM(TCH) DESC)
 WHERE ROWNUM <= 10;


清理临时表空间数据：
 select ts#, name FROM v$tablespace; 定位临时表空间文件号：

SELECT su.username,sid,serial#,sql_address,machine,program,tablespace,segtype, contents 
FROM v$session se,v$sort_usage su
WHERE se.saddr=su.session_addr;
执行清理：
alter session set events 'immediate trace name DROP_SEGMENTS level 4' ;
  
SELECT PROPERTY_NAME, PROPERTY_VALUE FROM DATABASE_PROPERTIES WHERE  property_name='DEFAULT_TEMP_TABLESPACE'; 
查看临时表空间：
select tablespace_name,file_name,bytes/1024/1024 file_size,autoextensible from dba_temp_files;
alter tablespace temp  add  tempfile '+OPS_DATA/atpops/temp02.dbf' size 30G;

alter database tempfile '/data/oradata/lhdwdb/temp02.dbf' resize 20G;
修改自动扩展：
alter database tempfile '/data/oradata/lhdwdb/temp02.dbf' autoextend on next 10G;

SELECT TABLESPACE_NAME, FREE_SPACE/1024/1024 AS "FREE SPACE(M)"
  FROM DBA_TEMP_FREE_SPACE
 WHERE TABLESPACE_NAME = '&tablespace_name';

ALTER TABLESPACE &tablespace_name ADD TEMPFILE '&datafile_name' SIZE 30G;

alter database tempfile '/data/oradata/orcl/temp02.dbf' resize 30G;

ALTER TABLESPACE &tablespace_name ADD datafile '&datafile_name' SIZE 30G;
/data/oradata/undotbs01.dbf


或者：
SELECT A.tablespace_name tablespace,
       D.mb_total,
       SUM(A.used_blocks * D.block_size) / 1024 / 1024 mb_used,
       D.mb_total - SUM(A.used_blocks * D.block_size) / 1024 / 1024 mb_free
  FROM v$sort_segment A,
       (SELECT B.name, C.block_size, SUM(C.bytes) / 1024 / 1024 mb_total
          FROM v$tablespace B, v$tempfile C
         WHERE B.ts# = C.ts#
         GROUP BY B.name, C.block_size) D
 WHERE A.tablespace_name = D.name
 GROUP by A.tablespace_name, D.mb_total;

查询所有临时表空间：
col file_name for a50
select file_name,tablespace_name,bytes/1024/1024 "MB",autoextensible from dba_temp_files;

扩充临时表空间：
alter tablespace TEMP add TEMPFILE '/data/oradata/afcusdw/temp04.dbf' size 32000M autoextend off;
alter tablespace TEMP add TEMPFILE '/app/data/oradata/afcusdw/temp05.dbf' size 10240M autoextend off;
alter database tempfile '/oracle/app/oradata/ORCL/datafile/temp02.dbf' resize 20G;

alter database tempfile '/data1/oradata/bodb2/temp02.dbf' resize 20G;

alter tablespace TEMP add TEMPFILE '/fdata2/slavedb/temp04.dbf' size 20G autoextend off;

检查使用临时表空间排序：
SELECT se.username,
       sid,
       serial#,
       sql_address,
       machine,
       program,
       tablespace,
       segtype,
       contents
  FROM gv$session se, gv$sort_usage su
 WHERE se.saddr = su.session_addr;
或者：
SELECT se.username,
       sid,
       serial#,
       sql_address,
       machine,
       program,
       tablespace,
       segtype,
       contents
  FROM gv$session se, gv$sort_usage su
 WHERE se.saddr = su.session_addr and se.USERNAME<>'GOLDENGATE';

查看数据库默认表空间：
col DESCRIPTION for a50
col PROPERTY_VALUE for a40
select * from database_properties  where property_name like 'DEFAULT%';

收缩表空间：
col file_name for a50
select file_name,bytes/1024/1024 MB ,tablespace_name from dba_data_files

alter database datafile '+BBC_DATA/bbcdb/spop_index01.dbf' resize 100M;

删除表空间：
DROP TABLESPACE SPOP_DATA INCLUDING CONTENTS AND DATAFILES;

查询ASM磁盘组使用空间：
 select name, total_mb, free_mb,(1 - free_mb/total_mb)*100 from v$asm_diskgroup;
 select name,TOTAL_MB,FREE_MB,trunc((TOTAL_MB-FREE_MB)/TOTAL_MB*100) usage from v$asm_diskgroup;

select name,TOTAL_MB/1024 GB,FREE_MB,trunc((TOTAL_MB-FREE_MB)/TOTAL_MB*100) usage from v$asm_diskgroup;

select group_number,name,total_mb/1024 total_G,free_mb/1024 free_G from v$asm_diskgroup;
查询ASM磁盘对应盘符：
col path for a45
SELECT a.name GRPNAME,b.group_number GR_NUMBER,b.disk_number DK_NUMBER,b.name ASMFILE,b.path,b.mount_status,b.state 
FROM v$asm_diskgroup a,v$asm_disk b;

 select name, path, group_number from v$asm_disk_stat;
 select name,state,path from v$asm_disk;

查询增长速度快的表：
column owner format a16
column object_name format a36
column start_day format a11
column block_increase format 9999999999
select * from 
(select   obj.owner, obj.object_name,
        to_char(sn.BEGIN_INTERVAL_TIME,'RRRR-MON-DD') start_day,
        dta.tablespace_name,
        sum(a.db_block_changes_delta) block_increase
from     dba_hist_seg_stat a,
        dba_hist_snapshot sn,
        dba_objects obj,
        dba_tables dta
where    sn.snap_id = a.snap_id
and      obj.object_id = a.obj#
and      obj.owner not in ('SYS','SYSTEM')
and      obj.OBJECT_TYPE='TABLE'
and      obj.OBJECT_NAME=dta.table_name
and      dta.tablespace_name='DRG_CORE_PRD_DATA'
and      end_interval_time between to_timestamp('01-JAN-2016','DD-MON-RRRR')
        and to_timestamp('26-JAN-2016','DD-MON-RRRR')
group by obj.owner, obj.object_name,dta.tablespace_name,
        to_char(sn.BEGIN_INTERVAL_TIME,'RRRR-MON-DD'),sn.BEGIN_INTERVAL_TIME
order by sum(a.db_block_changes_delta) desc,sn.BEGIN_INTERVAL_TIME desc)
where rownum<100;

或：

select * from 
(select   obj.owner, obj.object_name,
        to_char(sn.BEGIN_INTERVAL_TIME,'RRRR-MON-DD') start_day,
        dta.tablespace_name,
        sum(a.db_block_changes_delta) block_increase
from     dba_hist_seg_stat a,
        dba_hist_snapshot sn,
        dba_objects obj,
        dba_tables dta
where    sn.snap_id = a.snap_id
and      obj.object_id = a.obj#
and      obj.owner not in ('SYS','SYSTEM')
and      obj.OBJECT_TYPE='TABLE'
and      obj.OBJECT_NAME=dta.table_name
and      dta.tablespace_name='DRG_CORE_PRD_DATA'
and      end_interval_time between to_timestamp('01-01-2016','DD-MM-YYYY')
        and to_timestamp('26-01-2016','DD-MM-YYYY')
group by obj.owner, obj.object_name,dta.tablespace_name,
        to_char(sn.BEGIN_INTERVAL_TIME,'yyyy-MM-DD'),sn.BEGIN_INTERVAL_TIME
order by sum(a.db_block_changes_delta) desc,sn.BEGIN_INTERVAL_TIME desc)
where rownum<100;




创建磁盘组：
create diskgroup datagroup3 normal redundancy
disk
'/dev/oracleasm/disks/ASMDISK7' NAME DATAGROUP3_DISK7,
'/dev/oracleasm/disks/ASMDISK8' NAME DATAGROUP3_DISK8,
'/dev/oracleasm/disks/ASMDISK9' NAME DATAGROUP3_DISK9,
'/dev/oracleasm/disks/ASMDISK10' NAME DATAGROUP3_DISK10
ATTRIBUTE 'au_size'='1M',
'compatible.rdbms'='11.2',
'compatible.asm'='11.2',
'sector_size'='512';


*****RAC udev挂载：
for i in ARCH1 ARCH2 ARCH3 DATA1 DATA2 DATA3 DATA4 DATA5 DATA6 DATA7 DATA8 DATA9 DATA10 DATA11  DATA12  \
DATA13 DATA14 DATA15 DATA16 INDEX1 INDEX2 INDEX3 INDEX4 VOTOCR1 VOTOCR2 VOTOCR3; 
do
printf " "KERNEL==\"dm-*\"\,ENV\{DM_UUID\}==\"%s\"\,NAME=\"asm_%s\"\,OWNER=\"grid\"\,\"GROUP="oinstall"\"\,\"MODE=\"0660\""\n"  \
"$(udevadm info --query=all --name=/dev/mapper/$i | grep -i DM_UUID | awk -F "=" '{print $2}')"  "$i" ; 
done

for file in /dev/mapper/*
do
 var=$(echo ${file##*/}| tr '[A-Z]' '[a-z]')
 printf " "KERNEL==\"dm-*\"\,ENV\{DM_UUID\}==\"%s\"\,NAME=\"asm_%s\"\,OWNER=\"grid\"\,\GROUP="\"oinstall"\"\,\MODE=\"0660\""\n"  \
 "$(udevadm info --query=all --name=$file | grep -i DM_UUID | awk -F "=" '{print $2}')"  "$var" | grep -i 'mpath'; 
done 



SELECT A.NAME G_NAME, B.NAME D_NAME,B.OS_MB,B.TOTAL_MB,B.FREE_MB,B.STATE, FAILGROUP, B.FAILGROUP_TYPE, PATH
FROM V$ASM_DISKGROUP A, V$ASM_DISK B
  WHERE A.GROUP_NUMBER = B.GROUP_NUMBER
   AND B.NAME LIKE 'DATAGROUP3%';

指定故障组创建磁盘组：
create diskgroup datagroup3 normal redundancy
 failgroup failgroup_1 disk
 '/dev/oracleasm/disks/ASMDISK7' NAME DATAGROUP3_DISK7
 failgroup failgroup_2 disk
 '/dev/oracleasm/disks/ASMDISK8' NAME DATAGROUP3_DISK8,
 '/dev/oracleasm/disks/ASMDISK9' NAME DATAGROUP3_DISK9
 failgroup failgroup_3 disk
'/dev/oracleasm/disks/ASMDISK10' NAME DATAGROUP3_DISK10
  ATTRIBUTE 'au_size'='1M',
'compatible.rdbms'='11.2',
 'compatible.asm'='11.2',
  'sector_size'='512';

注意故障磁盘组有两种一种是quorum一种是regular，不同之处是quorum不包含用户数据。
 
 
SELECT dg.name AS diskgroup,SUBSTR(a.name,1,18) AS name,
SUBSTR(a.value,1,24) AS value, read_only FROM V$ASM_DISKGROUP_STAT dg,
V$ASM_ATTRIBUTE a WHERE dg.name = 'ATGDATA'
AND dg.group_number = a.group_number;

 SELECT dg.name AS diskgroup, f.file_number, f.primary_region,f.mirror_region, f.hot_reads,f.hot_writes, f.cold_reads, f.cold_writes
FROM V$ASM_DISKGROUP_STAT  dg, V$ASM_FILE f
WHERE dg.group_number = f.group_number and dg.name ='ATGDATA';

收缩表空间：
ALTER DATABASE 
  DATAFILE '+ATGINDEX/pro_index07.dbf'
 RESIZE 5120M;
ALTER DATABASE 
  DATAFILE '+ATGINDEX/pro_index07.dbf'
  AUTOEXTEND ON
  NEXT 1024M
  MAXSIZE 10240M;

检查表空间内所包含的对象信息：
SELECT t.owner, t.segment_name,t.segment_type,SUM(bytes)/1024/1024 MB From dba_segments t 
WHERE t.tablespace_name = 'PRO_INDEX'
GROUP BY t.owner,t.segment_name,t.segment_type
ORDER BY SUM(bytes) desc;


--所有数据文件所占磁盘空间
SELECT D.TABLESPACE_NAME,SPACE "SUM_SPACE(M)",BLOCKS SUM_BLOCKS,SPACE-NVL(FREE_SPACE,0) "USED_SPACE(M)",
ROUND((1-NVL(FREE_SPACE,0)/SPACE)*100,2) "USED_RATE(%)",FREE_SPACE "FREE_SPACE(M)"
FROM 
(SELECT TABLESPACE_NAME,ROUND(SUM(BYTES)/(1024*1024),2) SPACE,SUM(BLOCKS) BLOCKS
FROM DBA_DATA_FILES
GROUP BY TABLESPACE_NAME) D,
(SELECT TABLESPACE_NAME,ROUND(SUM(BYTES)/(1024*1024),2) FREE_SPACE
FROM DBA_FREE_SPACE
GROUP BY TABLESPACE_NAME) F
WHERE D.TABLESPACE_NAME = F.TABLESPACE_NAME(+)
UNION ALL --if have tempfile 
SELECT D.TABLESPACE_NAME,SPACE "SUM_SPACE(M)",BLOCKS SUM_BLOCKS, 
USED_SPACE "USED_SPACE(M)",ROUND(NVL(USED_SPACE,0)/SPACE*100,2) "USED_RATE(%)",
NVL(FREE_SPACE,0) "FREE_SPACE(M)"
FROM 
(SELECT TABLESPACE_NAME,ROUND(SUM(BYTES)/(1024*1024),2) SPACE,SUM(BLOCKS) BLOCKS
FROM DBA_TEMP_FILES
GROUP BY TABLESPACE_NAME) D,
(SELECT TABLESPACE_NAME,ROUND(SUM(BYTES_USED)/(1024*1024),2) USED_SPACE,
ROUND(SUM(BYTES_FREE)/(1024*1024),2) FREE_SPACE
FROM V$TEMP_SPACE_HEADER
GROUP BY TABLESPACE_NAME) F
WHERE D.TABLESPACE_NAME = F.TABLESPACE_NAME(+);

监控表空间使用率以及碎片化：
 Tablespace free space and fragmentation

      set linesize 150
        column tablespace_name format a20 heading 'Tablespace'
     column sumb format 999,999,999
     column extents format 9999
     column bytes format 999,999,999,999
     column largest format 999,999,999,999
     column Tot_Size format 999,999 Heading 'Total| Size(Mb)'
     column Tot_Free format 999,999,999 heading 'Total Free(MB)'
     column Pct_Free format 999.99 heading '% Free'
     column Chunks_Free format 9999 heading 'No Of Ext.'
     column Max_Free format 999,999,999 heading 'Max Free(Kb)'
     set echo off
     PROMPT  FREE SPACE AVAILABLE IN TABLESPACES
     select a.tablespace_name,sum(a.tots/1048576) Tot_Size,
     sum(a.sumb/1048576) Tot_Free,
     sum(a.sumb)*100/sum(a.tots) Pct_Free,
     sum(a.largest/1024) Max_Free,sum(a.chunks) Chunks_Free
     from
     (
     select tablespace_name,0 tots,sum(bytes) sumb,
     max(bytes) largest,count(*) chunks
     from dba_free_space a
     group by tablespace_name
     union
     select tablespace_name,sum(bytes) tots,0,0,0 from
      dba_data_files
     group by tablespace_name) a
     group by a.tablespace_name
order by pct_free;

根据ADDM建议进行优化收缩空间：

select *
  from (select b.ATTR1 as SQL_ID, max(a.BENEFIT) as "Benefit",A.task_id
          from DBA_ADVISOR_RECOMMENDATIONS a, DBA_ADVISOR_OBJECTS b
         where a.REC_ID = b.OBJECT_ID
           and a.TASK_ID = b.TASK_ID
           and a.TASK_ID in
               (select distinct b.task_id
                  from dba_hist_snapshot a,
                       dba_advisor_tasks b,
                       dba_advisor_log   l
                 where a.begin_interval_time > sysdate - 7
                   and a.dbid = (select dbid from v$database)
                   and a.INSTANCE_NUMBER =
                       (select INSTANCE_NUMBER from v$instance)
                   and to_char(a.begin_interval_time, 'yyyymmddHH24') =
                       to_char(b.created, 'yyyymmddHH24')
                   and b.advisor_name = 'ADDM'
                   and b.task_id = l.task_id
                   and l.status = 'COMPLETED')
           and length(b.ATTR4) > 1
         group by b.ATTR1,A.task_id
         order by max(a.BENEFIT) desc)
 where rownum < 10;

删除表空间数据文件：
col name for a55
set lines 200
select file#,status,name from v$datafile;
ALTER TABLESPACE BILL drop datafile 334;

根据表空间名称回收数据文件：
select 'alter database datafile ' || chr(39) ||file_name|| chr(39) || ' resize 5G;'  from dba_data_files where tablespace_name='ATGSYS_DATA' order by 1;



查看统计信息定时任务执行时间：
select to_char(t.job_start_time, 'yyyy-MM-dd hh24:mm:ss'), t.job_duration
  from dba_autotask_job_history t
 where t.client_name = 'auto space advisor'
 order by to_char(t.job_start_time, 'yyyy-MM-dd') desc;

使用存储过程游标计数更新：
CREATE OR REPLACE PROCEDURE proc_update is
  p_file_name VARCHAR2(100);
  fhandle     utl_file.file_type;
  V_ROWNUM    NUMBER(9);
begin
  p_file_name := 'proc_update_' || to_char(sysdate, 'YYYYMMDDHH24') || '.log';
  fhandle     := utl_file.fopen('DIR_DP', p_file_name, 'w', 32000);
  V_ROWNUM    := 0;
  for x in (select ORDER_ID,STATE from tempomsq) loop
   update  live_omsq.omsq_order t1 set t1.state = x.STATE where T1.order_id = x.ORDER_ID;
    utl_file.put_line(fhandle, x.ORDER_ID);
    V_ROWNUM := SQL%ROWCOUNT + 1;
  end loop;
  utl_file.put_line(fhandle,
                    CONVERT('TABLE-omsq_order-UPDATE NUMBERS:' || V_ROWNUM,
                            'AL32UTF8'));
  commit;
  utl_file.fclose(fhandle);
end;
/

定位消耗资源的Top SQL from ASH ：
select ash.SQL_ID,
       sum(decode(ash.session_state, 'ON CPU', 1, 0)) "CPU",
       sum(decode(ash.session_state, 'WAITING', 1, 0)) -
       sum(decode(ash.session_state,
                  'WAITING',
                  decode(en.wait_class, 'User I/O', 1, 0),
                  0)) "WAIT",
       sum(decode(ash.session_state,
                  'WAITING',
                  decode(en.wait_class, 'User I/O', 1, 0),
                  0)) "IO",
       sum(decode(ash.session_state, 'ON CPU', 1, 1)) "TOTAL"
  from v$active_session_history ash, v$event_name en
 where SQL_ID is not NULL
   and en.event# = ash.event#
 group by sql_id
 order by sum(decode(session_state, 'ON CPU', 1, 1)) desc
 
 


抓取SQL语句按piece排序：
select sql_text from v$sql where sql_id='&a';         
select sql_text from v$sqltext a where a.hash_value = ( select sql_hash_value from v$session b where b.sid = '&sid') order by piece;  

RAC：
select sql_text from gv$sqltext a where a.hash_value = ( select sql_hash_value from v$session b where b.sid = '&sid' and inst_id= '&inst_id') order by piece; 




kill session:

根据sql_id杀：
select 'alter system kill session ' || chr(39) || sid || ',' || serial# ||
       chr(39) || ';'
  from gv$session
 where type not like 'BACK%'
   and status = 'ACTIVE'
   and wait_class <> 'Idle'
   and username <> 'SYS'
   and sql_id='29ktaqfdhpjhu'
   --and event = 'SQL*Net message from dblink'
   and inst_id = '2';

杀掉死进程：
set pagesize 1000
  select 'kill -9 ' || spid || ';' from v$process where addr not in (select paddr from v$session);