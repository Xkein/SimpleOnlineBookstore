

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
    收货人电话 varchar2(20)
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
 execute immediate 'grant select on 店铺 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 图书 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 图书信息 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 活动 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 评论 to ' || ID;
 execute immediate 'grant select on 发货信息 to ' || ID;
 execute immediate 'grant select,update,delete,insert on 收货信息 to ' || ID;
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



create or replace procedure 删除用户或店铺(ID in varchar2) is
begin
 execute immediate 'delete from 用户 where ID =''' || ID || '''';
 execute immediate 'delete from 店铺 where ID =''' || ID || '''';
end;

create user test identified by testpw;
insert into 用户(ID) values('test');
drop user test cascade;


CREATE OR REPLACE TRIGGER TRIGGER_UNDROPTABLE
BEFORE DROP or TRUNCATE ON DATABASE
begin
if ora_login_user not in ('SYS') THEN
  if upper(dictionary_obj_type) ='TABLE'or upper(dictionary_obj_type)='INDEX' THEN
     Raise_application_error (-20001,'Please not do DROP Table or Index,do not Truncate table ,You will be Caught!!!');
  end if;
end if;
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