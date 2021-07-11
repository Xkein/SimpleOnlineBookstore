

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
    �ջ��˵绰 varchar2(20),
    �û�ID varchar2(20) not null,
    foreign key(�û�ID) references �û�(ID)
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
 execute immediate 'grant select,update on ���� to ' || ID;
 execute immediate 'grant select,update,delete,insert on ͼ�� to ' || ID;
 execute immediate 'grant select,update,delete,insert on ͼ����Ϣ to ' || ID;
 execute immediate 'grant select,update,delete,insert on � to ' || ID;
 execute immediate 'grant select,update,delete,insert on ���� to ' || ID;
 execute immediate 'grant select on ������Ϣ to ' || ID;
 execute immediate 'grant select,update,delete,insert on �ջ���Ϣ to ' || ID;
end;

create or replace procedure ɾ��ͼ���������(ID in varchar2) is
begin
 delete from ���� where ͼ��ID = ID;
 delete from �ղ� where ͼ��ID = ID;
 delete from �����ʷ��¼ where ͼ��ID = ID;
 delete from ͼ����Ϣ where ͼ��ID = ID;
end;

create or replace procedure ɾ�����ﳵ(�û�ID in varchar2) is
    ���ﳵID ���ﳵ.ID%TYPE;
begin
 select ID into ���ﳵID from ���ﳵ where �û�ID = �û�ID;
 delete from ���ﳵ����Ŀ where ���ﳵID = ���ﳵID;
 delete from ���ﳵ where ID = ���ﳵID;
end;

create or replace procedure ɾ������(�û�ID in varchar2) is
    ����ID ����.ID%TYPE;
begin
 select ID into ����ID from ���� where �û�ID = �û�ID;
 delete from ��������Ŀ where ����ID = ����ID;
 delete from ���� where ID = ����ID;
end;

create or replace procedure ɾ���û������(ID in varchar2) is
    type Tͼ���б� is table of ͼ��.ID%TYPE;
    ͼ���б� Tͼ���б�;
    type T�����б� is table of ����.ID%TYPE;
    �����б� T�����б�;
begin
 delete from ������Ϣ where ����ID =ID;
 delete from �ջ���Ϣ where �û�ID =ID;
 delete from ���� where �û�ID =ID;
 delete from �ղ� where �û�ID =ID;
 delete from �����ʷ��¼ where �û�ID =ID;
 
 ɾ�����ﳵ(ID);
 
 select ID bulk collect into ͼ���б� from ͼ�� where ����ID = ID;
 for idx in ͼ���б�.first .. ͼ���б�.last loop
     delete from ͼ�� where ID = ID;
 end loop;
 
 select ID bulk collect into �����б� from ���� where �û�ID = ID;
 for idx in �����б�.first .. �����б�.last loop
     ɾ������(�����б�(idx));
 end loop;
 
 delete from � where ����ID =ID;
 delete from �û� where ID =ID;
 delete from ���� where ID =ID;
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

create or replace trigger ͼ��ɾ�� before delete on ͼ��
for each row
declare
pragma autonomous_transaction;
begin
    ɾ��ͼ���������(:new.ID);
    COMMIT;
end;

CREATE OR REPLACE TRIGGER Ȩ�޼��
BEFORE DROP or TRUNCATE ON DATABASE
begin
if ora_login_user not in ('SYS', 'RG') THEN
    if dictionary_obj_type in ('�û�', '����', '����', '��������Ŀ', '���ﳵ') THEN
        Raise_application_error (-20001,'Ȩ�޲��㣡');
    elsif dictionary_obj_type not in ('�ջ���Ϣ', '�����ʷ��¼', '�ղ�', '����', 'ͼ��', '�', '�ջ���Ϣ', '���ﳵ����Ŀ', 'ͼ����Ϣ') THEN
        Raise_application_error (-20001,'Ȩ�޲��㣡');
    elsif dictionary_obj_owner <> ora_login_user THEN
        Raise_application_error (-20001,'Ȩ�޲��㣡');
    end if;
end if;
end;

select 
   'CREATE OR REPLACE TRIGGER '||table_name||'Ȩ�޼��
   BEFORE DELETE or UPDATE on '||table_name||'
    FOR EACH ROW
     BEGIN
        if ora_login_user not in (''SYS'', ''RG'') THEN
            IF ora_login_user <> :old.�û�ID  THEN
                Raise_application_error (-20001,''Ȩ�޲��㣡'');
            END IF;
        end if;
     END;
    /
    alter trigger '||table_name||'Ȩ�޼�� enable;' as triggerSql
from tabs where table_name in ('�ջ���Ϣ', '�����ʷ��¼', '�ղ�', '����') order by table_name;

-- ���ɽ����ʼ
CREATE OR REPLACE TRIGGER �ղ�Ȩ�޼��
   BEFORE DELETE or UPDATE on �ղ�
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.�û�ID  THEN
                Raise_application_error (-20001,'Ȩ�޲��㣡');
            END IF;
        end if;
     END;
    /
    alter trigger �ղ�Ȩ�޼�� enable;
CREATE OR REPLACE TRIGGER �ջ���ϢȨ�޼��
   BEFORE DELETE or UPDATE on �ջ���Ϣ
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.�û�ID  THEN
                Raise_application_error (-20001,'Ȩ�޲��㣡');
            END IF;
        end if;
     END;
    /
    alter trigger �ջ���ϢȨ�޼�� enable;
CREATE OR REPLACE TRIGGER �����ʷ��¼Ȩ�޼��
   BEFORE DELETE or UPDATE on �����ʷ��¼
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.�û�ID  THEN
                Raise_application_error (-20001,'Ȩ�޲��㣡');
            END IF;
        end if;
     END;
    /
    alter trigger �����ʷ��¼Ȩ�޼�� enable;
CREATE OR REPLACE TRIGGER ����Ȩ�޼��
   BEFORE DELETE or UPDATE on ����
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.�û�ID  THEN
                Raise_application_error (-20001,'Ȩ�޲��㣡');
            END IF;
        end if;
     END;
    /
    alter trigger ����Ȩ�޼�� enable;
-- ���ɽ������

select 
   'CREATE OR REPLACE TRIGGER '||table_name||'Ȩ�޼��
   BEFORE DELETE or UPDATE on '||table_name||'
    FOR EACH ROW
     BEGIN
        if ora_login_user not in (''SYS'', ''RG'') THEN
            IF ora_login_user <> :old.����ID  THEN
                Raise_application_error (-20001,''Ȩ�޲��㣡'');
            END IF;
        end if;
     END;
    /
    alter trigger '||table_name||'Ȩ�޼�� enable;' as triggerSql
from tabs where table_name in ('ͼ��', '�', '������Ϣ', '����') order by table_name;

-- ���ɽ����ʼ
CREATE OR REPLACE TRIGGER ������ϢȨ�޼��
   BEFORE DELETE or UPDATE on ������Ϣ
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.����ID  THEN
                Raise_application_error (-20001,'Ȩ�޲��㣡');
            END IF;
        end if;
     END;
    /
    alter trigger ������ϢȨ�޼�� enable;
CREATE OR REPLACE TRIGGER ͼ��Ȩ�޼��
   BEFORE DELETE or UPDATE on ͼ��
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.����ID  THEN
                Raise_application_error (-20001,'Ȩ�޲��㣡');
            END IF;
        end if;
     END;
    /
    alter trigger ͼ��Ȩ�޼�� enable;
CREATE OR REPLACE TRIGGER ����Ȩ�޼��
   BEFORE DELETE or UPDATE on ����
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.ID  THEN
                Raise_application_error (-20001,'Ȩ�޲��㣡');
            END IF;
        end if;
     END;
    /
    alter trigger ����Ȩ�޼�� enable;
CREATE OR REPLACE TRIGGER �Ȩ�޼��
   BEFORE DELETE or UPDATE on �
    FOR EACH ROW
     BEGIN
        if ora_login_user not in ('SYS', 'RG') THEN
            IF ora_login_user <> :old.����ID  THEN
                Raise_application_error (-20001,'Ȩ�޲��㣡');
            END IF;
        end if;
     END;
    /
    alter trigger �Ȩ�޼�� enable;
-- ���ɽ������

CREATE OR REPLACE TRIGGER ���ﳵ����ĿȨ�޼��
BEFORE DELETE or UPDATE ON ���ﳵ����Ŀ
FOR EACH ROW
DECLARE
    ALLOW_FLAG int;
begin
 if ora_login_user not in ('SYS', 'RG') THEN
    select count(*) into ALLOW_FLAG from ���ﳵ where �û�ID = ora_login_user and ID = :old.���ﳵID;
    IF ALLOW_FLAG = 0 THEN
        Raise_application_error (-20001,'Ȩ�޲��㣡');
    END IF;
 end if;
end;

CREATE OR REPLACE TRIGGER ͼ����ϢȨ�޼��
BEFORE DELETE or UPDATE ON ͼ����Ϣ
FOR EACH ROW
DECLARE
    ALLOW_FLAG int;
begin
 if ora_login_user not in ('SYS', 'RG') THEN
    select count(*) into ALLOW_FLAG from ͼ�� where ����ID = ora_login_user and ID = :old.ͼ��ID;
    IF ALLOW_FLAG = 0 THEN
        Raise_application_error (-20001,'Ȩ�޲��㣡');
    END IF;
 end if;
end;

-- �������ݿ�ʼ
-- Ϊ�û���������
insert into ���� values('00000001', 'YH1', sysdate, 0);
insert into ��������Ŀ values('00000001-001', '00000001', '��˯ԭ��', 1, sysdate, '������');

insert into �����ʷ��¼ values('YH1', '��˯ԭ��', sysdate, 0.1919810);

insert into �ղ� values('YH1', '��˯ԭ��');


insert into ���� values('00000002', 'YH2', sysdate, 0);
insert into ��������Ŀ values('00000002-001', '00000002', '�ۺ��', 1, sysdate, '������');

insert into �����ʷ��¼ values('YH2', '��˯ԭ��', sysdate, 0.5);
insert into �����ʷ��¼ values('YH2', '�ۺ��', sysdate, 0.114514);

insert into �ղ� values('YH2', '��˯ԭ��');
insert into �ղ� values('YH2', '�ۺ��');

-- �������ݽ���







create user test identified by testpw;
insert into �û�(ID) values('test');
drop user test cascade;

DECLARE
    ALLOW_FLAG int;
begin
    execute immediate 'select count(*) from ' || 'ͼ��' || 'where ����ID = ''' || 'dp1' || '''' into ALLOW_FLAG;
    dbms_output.put_line(ALLOW_FLAG);
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