

create table 用户(
    ID varchar2(20) primary key
);

create table 店铺(
    ID varchar2(20) primary key,
    所在地址 varchar2(50 char),
    店铺描述 varchar2(500 char)
);

create table 活动(
    ID varchar2(20) primary key,
    店铺ID varchar2(20) not null,
    活动时间 date default(sysdate),
    活动描述 varchar2(500 char),
    优惠形式 varchar2(50 char),
    折扣 numeric(3,2) default(1.00),
    foreign key(店铺ID) references 店铺(ID)
);

create table 图书(
    ID varchar2(20) primary key,
    所属活动ID varchar2(20),
    店铺ID varchar2(20) not null,
	价格 real default(0), 
	剩余数量 integer default(0), 
	收藏数 integer default(0), 
	浏览数 integer default(0), 
	上架日期 date default(sysdate),
    foreign key(所属活动ID) references 活动(ID),
    foreign key(店铺ID) references 店铺(ID)
);


create table 浏览历史记录(
    用户ID varchar2(20) not null,
    图书ID varchar2(20) not null,
    日期 date default(sysdate),
    位置 real,
    primary key(用户ID,图书ID),
    foreign key(用户ID) references 用户(ID),
    foreign key(图书ID) references 图书(ID)
);

create table 购物车(
    ID varchar2(20) primary key,
    用户ID varchar2(20) not null,
    foreign key (用户ID) references 用户(ID)
);

create table 购物车子项目(
    ID varchar2(20) primary key,
    购物车ID varchar2(20) not null,
    图书ID varchar2(20) not null,
    购买数量 integer,
    生成日期 date,
    foreign key (图书ID) references 图书(ID),
    foreign key (购物车ID) references 购物车(ID)
);

create table 订单(
    ID varchar2(20) primary key,
    用户ID varchar2(20) not null,
    生成日期 date default(sysdate),
    状态 integer,
    foreign key (用户ID) references 用户(ID)
);

create table 订单子项目(
    ID varchar2(20) primary key,
    订单ID varchar2(20) not null,
    图书ID varchar2(20) not null,
    购买数量 integer,
    生成日期 date,
    派送状态 varchar2(20 char),
    foreign key (图书ID) references 图书(ID),
    foreign key (订单ID) references 订单(ID)
);

create table 收货信息(
    收货地址  varchar2(50 char),
    收货人 varchar2(15 char),
    收货人电话 varchar2(20),
    用户ID varchar2(20) not null,
    foreign key(用户ID) references 用户(ID)
);

create table 发货信息(
    发货地址  varchar2(50 char),
    发货人 varchar2(15 char),
    发货人电话 varchar2(20),
    店铺ID varchar2(20) not null,
    foreign key(店铺ID) references 店铺(ID)
);

create table 评论(
    ID varchar2(20) primary key,
    用户ID varchar2(20) not null,
    图书ID varchar2(20) not null,
    评论日期 date default(sysdate),
    内容 varchar2(500 char),
    被回复评论ID varchar2(20),
    foreign key(用户ID) references 用户(ID),
    foreign key(图书ID) references 图书(ID),
    foreign key(被回复评论ID) references 评论(ID)
);

create table 图书信息(
    图书ID varchar2(20),
    目录 varchar2(1024 char),
    实物图片 varchar2(1024 char),
    图片内容 varchar2(1024 char),
    详细信息 varchar2(1024 char),
    出版信息 varchar2(500 char),
    foreign key(图书ID) references 图书(ID)
);

create table 收藏(
    用户ID varchar2(20) not null,
    图书ID varchar2(20) not null,
    foreign key(用户ID) references 用户(ID),
    foreign key(图书ID) references 图书(ID)
);


create or replace procedure 用户授权(ID in varchar2) is
begin
 execute immediate 'grant select on 用户 to ' || ID;
 execute immediate 'grant select on 店铺 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 订单 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 订单子项目 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 购物车 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 购物车子项目 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 浏览历史记录 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 收藏 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 图书 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 图书信息 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 活动 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 评论 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 发货信息 to ' || ID;
 execute immediate 'grant select on 收货信息 to ' || ID;
end;

create or replace procedure 店铺授权(ID in varchar2) is
begin
 execute immediate 'grant select on 用户 to ' || ID;
 execute immediate 'grant select,update on 店铺 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 图书 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 图书信息 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 活动 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 评论 to ' || ID;
 execute immediate 'grant select on 发货信息 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 收货信息 to ' || ID;
end;

create or replace procedure 删除图书相关数据(ID in varchar2) is
begin
 delete from 评论 where 图书ID = ID;
 delete from 收藏 where 图书ID = ID;
 delete from 浏览历史记录 where 图书ID = ID;
 delete from 图书信息 where 图书ID = ID;
end;

create or replace procedure 删除购物车(用户ID in varchar2) is
    购物车ID 购物车.ID%TYPE;
begin
 select ID into 购物车ID from 购物车 where 用户ID = 用户ID;
 delete from 购物车子项目 where 购物车ID = 购物车ID;
 delete from 购物车 where ID = 购物车ID;
end;

create or replace procedure 删除订单(用户ID in varchar2) is
    订单ID 订单.ID%TYPE;
begin
 select ID into 订单ID from 订单 where 用户ID = 用户ID;
 delete from 订单子项目 where 订单ID = 订单ID;
 delete from 订单 where ID = 订单ID;
end;

create or replace procedure 删除用户或店铺(ID in varchar2) is
    type T图书列表 is table of 图书.ID%TYPE;
    图书列表 T图书列表;
    type T订单列表 is table of 订单.ID%TYPE;
    订单列表 T订单列表;
begin
 delete from 发货信息 where 店铺ID =ID;
 delete from 收货信息 where 用户ID =ID;
 delete from 评论 where 用户ID =ID;
 delete from 收藏 where 用户ID =ID;
 delete from 浏览历史记录 where 用户ID =ID;
 
 删除购物车(ID);
 
 select ID bulk collect into 图书列表 from 图书 where 店铺ID = ID;
 for idx in 图书列表.first .. 图书列表.last loop
     delete from 图书 where ID = ID;
 end loop;
 
 select ID bulk collect into 订单列表 from 订单 where 用户ID = ID;
 for idx in 订单列表.first .. 订单列表.last loop
     删除订单(订单列表(idx));
 end loop;
 
 delete from 活动 where 店铺ID =ID;
 delete from 用户 where ID =ID;
 delete from 店铺 where ID =ID;
end;

create or replace trigger 用户插入 before insert or update on 用户
for each row
declare
pragma autonomous_transaction;
begin
    用户授权(:new.ID);
end;

create or replace trigger 店铺插入 before insert or update on 店铺
for each row
declare
pragma autonomous_transaction;
begin
    店铺授权(:new.ID);
end;

create or replace trigger 图书删除 before delete on 图书
for each row
declare
pragma autonomous_transaction;
begin
    删除图书相关数据(:new.ID);
    COMMIT;
end;

CREATE OR REPLACE TRIGGER 权限检查
BEFORE DROP or TRUNCATE ON DATABASE
begin
if ora_login_user not in ('SYS', 'RG') THEN
    if dictionary_obj_type in ('用户', '店铺', '订单', '订单子项目', '购物车') THEN
        Raise_application_error (-20001,'权限不足！');
    elsif dictionary_obj_type not in ('收货信息', '浏览历史记录', '收藏', '评论', '图书', '活动', '收货信息', '购物车子项目', '图书信息') THEN
        Raise_application_error (-20001,'权限不足！');
    elsif dictionary_obj_owner <> ora_login_user THEN
        Raise_application_error (-20001,'权限不足！');
    end if;
end if;
end;

select 
   'CREATE OR REPLACE TRIGGER '||table_name||'权限检查
   BEFORE DELETE or UPDATE on '||table_name||'
    FOR EACH ROW
     BEGIN
        if ora_login_user not in (''SYS'', ''RG'') THEN
            IF ora_login_user <> :old.用户ID  THEN
                Raise_application_error (-20001,''权限不足！'');
            END IF;
        end if;
     END;
    /
    alter trigger '||table_name||'权限检查 enable;' as triggerSql
from tabs where table_name in ('收货信息', '浏览历史记录', '收藏', '评论') order by table_name;

-- 生成结果开始
CREATE OR REPLACE TRIGGER 收藏权限检查
   BEFORE DELETE or UPDATE on 收藏
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.用户ID  THEN
                Raise_application_error (-20001,'权限不足！');
            END IF;
        end if;
     END;
    /
    alter trigger 收藏权限检查 enable;
CREATE OR REPLACE TRIGGER 收货信息权限检查
   BEFORE DELETE or UPDATE on 收货信息
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.用户ID  THEN
                Raise_application_error (-20001,'权限不足！');
            END IF;
        end if;
     END;
    /
    alter trigger 收货信息权限检查 enable;
CREATE OR REPLACE TRIGGER 浏览历史记录权限检查
   BEFORE DELETE or UPDATE on 浏览历史记录
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.用户ID  THEN
                Raise_application_error (-20001,'权限不足！');
            END IF;
        end if;
     END;
    /
    alter trigger 浏览历史记录权限检查 enable;
CREATE OR REPLACE TRIGGER 评论权限检查
   BEFORE DELETE or UPDATE on 评论
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.用户ID  THEN
                Raise_application_error (-20001,'权限不足！');
            END IF;
        end if;
     END;
    /
    alter trigger 评论权限检查 enable;
-- 生成结果结束

select 
   'CREATE OR REPLACE TRIGGER '||table_name||'权限检查
   BEFORE DELETE or UPDATE on '||table_name||'
    FOR EACH ROW
     BEGIN
        if ora_login_user not in (''SYS'', ''RG'') THEN
            IF ora_login_user <> :old.店铺ID  THEN
                Raise_application_error (-20001,''权限不足！'');
            END IF;
        end if;
     END;
    /
    alter trigger '||table_name||'权限检查 enable;' as triggerSql
from tabs where table_name in ('图书', '活动', '发货信息', '店铺') order by table_name;

-- 生成结果开始
CREATE OR REPLACE TRIGGER 发货信息权限检查
   BEFORE DELETE or UPDATE on 发货信息
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.店铺ID  THEN
                Raise_application_error (-20001,'权限不足！');
            END IF;
        end if;
     END;
    /
    alter trigger 发货信息权限检查 enable;
CREATE OR REPLACE TRIGGER 图书权限检查
   BEFORE DELETE or UPDATE on 图书
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.店铺ID  THEN
                Raise_application_error (-20001,'权限不足！');
            END IF;
        end if;
     END;
    /
    alter trigger 图书权限检查 enable;
CREATE OR REPLACE TRIGGER 店铺权限检查
   BEFORE DELETE or UPDATE on 店铺
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.ID  THEN
                Raise_application_error (-20001,'权限不足！');
            END IF;
        end if;
     END;
    /
    alter trigger 店铺权限检查 enable;
CREATE OR REPLACE TRIGGER 活动权限检查
   BEFORE DELETE or UPDATE on 活动
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.店铺ID  THEN
                Raise_application_error (-20001,'权限不足！');
            END IF;
        end if;
     END;
    /
    alter trigger 活动权限检查 enable;
-- 生成结果结束

CREATE OR REPLACE TRIGGER 购物车子项目权限检查
BEFORE DELETE or UPDATE ON 购物车子项目
FOR EACH ROW
DECLARE
    ALLOW_FLAG int;
begin
 if ora_login_user not in ('SYS', 'RG') THEN
    select count(*) into ALLOW_FLAG from 购物车 where 用户ID = ora_login_user and ID = :old.购物车ID;
    IF ALLOW_FLAG = 0 THEN
        Raise_application_error (-20001,'权限不足！');
    END IF;
 end if;
end;

CREATE OR REPLACE TRIGGER 图书信息权限检查
BEFORE DELETE or UPDATE ON 图书信息
FOR EACH ROW
DECLARE
    ALLOW_FLAG int;
begin
 if ora_login_user not in ('SYS', 'RG') THEN
    select count(*) into ALLOW_FLAG from 图书 where 店铺ID = ora_login_user and ID = :old.图书ID;
    IF ALLOW_FLAG = 0 THEN
        Raise_application_error (-20001,'权限不足！');
    END IF;
 end if;
end;

-- 测试数据开始
-- 为用户插入数据
insert into 订单 values('00000001', 'YH1', sysdate, 0);
insert into 订单子项目 values('00000001-001', '00000001', '昏睡原理', 1, sysdate, '待发货');

insert into 浏览历史记录 values('YH1', '昏睡原理', sysdate, 0.1919810);

insert into 收藏 values('YH1', '昏睡原理');


insert into 订单 values('00000002', 'YH2', sysdate, 0);
insert into 订单子项目 values('00000002-001', '00000002', '论红茶', 1, sysdate, '待发货');

insert into 浏览历史记录 values('YH2', '昏睡原理', sysdate, 0.5);
insert into 浏览历史记录 values('YH2', '论红茶', sysdate, 0.114514);

insert into 收藏 values('YH2', '昏睡原理');
insert into 收藏 values('YH2', '论红茶');

-- 测试数据结束







create user test identified by testpw;
insert into 用户(ID) values('test');
drop user test cascade;

DECLARE
    ALLOW_FLAG int;
begin
    execute immediate 'select count(*) from ' || '图书' || 'where 店铺ID = ''' || 'dp1' || '''' into ALLOW_FLAG;
    dbms_output.put_line(ALLOW_FLAG);
end;

select * from dba_network_acl_privileges ;

select 'drop table "'||table_name||'";'
from cat
where table_type='TABLE';

drop table "发货信息";
drop table "图书";
drop table "图书信息";
drop table "店铺";
drop table "收藏";
drop table "收货信息";
drop table "活动";
drop table "浏览历史记录";
drop table "用户";
drop table "订单";
drop table "订单子项目";
drop table "评论";
drop table "购物车";
drop table "购物车子项目";