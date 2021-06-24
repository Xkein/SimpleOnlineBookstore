

create table �û�(
    ID varchar2(20) primary key
);

create table ����(
    ID varchar2(20) primary key,
    ���ڵ�ַ varchar2(50 char),
    �������� varchar2(500 char)
);

create table �(
    ID varchar2(20) primary key,
    ����ID varchar2(20) not null,
    �ʱ�� date default(sysdate),
    ����� varchar2(500 char),
    �Ż���ʽ varchar2(50 char),
    �ۿ� numeric(3,2) default(1.00),
    foreign key(����ID) references ����(ID)
);

create table ͼ��(
    ID varchar2(20) primary key,
    �����ID varchar2(20),
    ����ID varchar2(20) not null,
	�۸� real default(0), 
	ʣ������ integer default(0), 
	�ղ��� integer default(0), 
	����� integer default(0), 
	�ϼ����� date default(sysdate),
    foreign key(�����ID) references �(ID),
    foreign key(����ID) references ����(ID)
);


create table �����ʷ��¼(
    �û�ID varchar2(20) not null,
    ͼ��ID varchar2(20) not null,
    ���� date default(sysdate),
    λ�� real,
    primary key(�û�ID,ͼ��ID),
    foreign key(�û�ID) references �û�(ID),
    foreign key(ͼ��ID) references ͼ��(ID)
);

create table ���ﳵ(
    ID varchar2(20) primary key,
    �û�ID varchar2(20) not null,
    foreign key (�û�ID) references �û�(ID)
);

create table ���ﳵ����Ŀ(
    ID varchar2(20) primary key,
    ���ﳵID varchar2(20) not null,
    ͼ��ID varchar2(20) not null,
    �������� integer,
    �������� date,
    foreign key (ͼ��ID) references ͼ��(ID),
    foreign key (���ﳵID) references ���ﳵ(ID)
);

create table ����(
    ID varchar2(20) primary key,
    �û�ID varchar2(20) not null,
    �������� date default(sysdate),
    ״̬ integer,
    foreign key (�û�ID) references �û�(ID)
);

create table ��������Ŀ(
    ID varchar2(20) primary key,
    ����ID varchar2(20) not null,
    ͼ��ID varchar2(20) not null,
    �������� integer,
    �������� date,
    ����״̬ varchar2(20 char),
    foreign key (ͼ��ID) references ͼ��(ID),
    foreign key (����ID) references ����(ID)
);

create table �ջ���Ϣ(
    �ջ���ַ  varchar2(50 char),
    �ջ��� varchar2(15 char),
    �ջ��˵绰 varchar2(20)
);
create table ������Ϣ(
    ������ַ  varchar2(50 char),
    ������ varchar2(15 char),
    �����˵绰 varchar2(20),
    ����ID varchar2(20) not null,
    foreign key(����ID) references ����(ID)
);

create table ����(
    ID varchar2(20) primary key,
    �û�ID varchar2(20) not null,
    ͼ��ID varchar2(20) not null,
    �������� date default(sysdate),
    ���� varchar2(500 char),
    ���ظ�����ID varchar2(20),
    foreign key(�û�ID) references �û�(ID),
    foreign key(ͼ��ID) references ͼ��(ID),
    foreign key(���ظ�����ID) references ����(ID)
);

create table ͼ����Ϣ(
    ͼ��ID varchar2(20),
    Ŀ¼ varchar2(1024 char),
    ʵ��ͼƬ varchar2(1024 char),
    ͼƬ���� varchar2(1024 char),
    ��ϸ��Ϣ varchar2(1024 char),
    ������Ϣ varchar2(500 char),
    foreign key(ͼ��ID) references ͼ��(ID)
);

create table �ղ�(
    �û�ID varchar2(20) not null,
    ͼ��ID varchar2(20) not null,
    foreign key(�û�ID) references �û�(ID),
    foreign key(ͼ��ID) references ͼ��(ID)
);


create or replace procedure �û���Ȩ(ID in varchar2) is
begin
 execute immediate 'grant select on �û� to ' || ID;
 execute immediate 'grant select on ���� to ' || ID;
 execute immediate 'grant select,update,delete,insert on ���� to ' || ID;
 execute immediate 'grant select,update,delete,insert on ��������Ŀ to ' || ID;
 execute immediate 'grant select,update,delete,insert on ���ﳵ to ' || ID;
 execute immediate 'grant select,update,delete,insert on ���ﳵ����Ŀ to ' || ID;
 execute immediate 'grant select,update,delete,insert on �����ʷ��¼ to ' || ID;
 execute immediate 'grant select,update,delete,insert on �ղ� to ' || ID;
 execute immediate 'grant select,update,delete,insert on ͼ�� to ' || ID;
 execute immediate 'grant select,update,delete,insert on ͼ����Ϣ to ' || ID;
 execute immediate 'grant select,update,delete,insert on � to ' || ID;
 execute immediate 'grant select,update,delete,insert on ���� to ' || ID;
 execute immediate 'grant select,update,delete,insert on ������Ϣ to ' || ID;
 execute immediate 'grant select on �ջ���Ϣ to ' || ID;
end;

create or replace procedure ������Ȩ(ID in varchar2) is
begin
 execute immediate 'grant select on �û� to ' || ID;
 execute immediate 'grant select on ���� to ' || ID;
 execute immediate 'grant select,update,delete,insert on ͼ�� to ' || ID;
 execute immediate 'grant select,update,delete,insert on ͼ����Ϣ to ' || ID;
 execute immediate 'grant select,update,delete,insert on � to ' || ID;
 execute immediate 'grant select,update,delete,insert on ���� to ' || ID;
 execute immediate 'grant select on ������Ϣ to ' || ID;
 execute immediate 'grant select,update,delete,insert on �ջ���Ϣ to ' || ID;
end;

create or replace trigger �û����� before insert or update on �û�
for each row
declare
pragma autonomous_transaction;
begin
    �û���Ȩ(:new.ID);
end;

create or replace trigger ���̲��� before insert or update on ����
for each row
declare
pragma autonomous_transaction;
begin
    ������Ȩ(:new.ID);
end;



create or replace procedure ɾ���û������(ID in varchar2) is
begin
 execute immediate 'delete from �û� where ID =''' || ID || '''';
 execute immediate 'delete from ���� where ID =''' || ID || '''';
end;

create user test identified by testpw;
insert into �û�(ID) values('test');
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

drop table "������Ϣ";
drop table "ͼ��";
drop table "ͼ����Ϣ";
drop table "����";
drop table "�ղ�";
drop table "�ջ���Ϣ";
drop table "�";
drop table "�����ʷ��¼";
drop table "�û�";
drop table "����";
drop table "��������Ŀ";
drop table "����";
drop table "���ﳵ";
drop table "���ﳵ����Ŀ";