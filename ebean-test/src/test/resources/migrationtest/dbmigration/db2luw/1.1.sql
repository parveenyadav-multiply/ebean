-- Migrationscripts for ebean unittest
-- drop dependencies
delimiter $$
begin
if exists (select constname from syscat.tabconst where tabschema = current_schema and ucase(constname) = 'FK_MIGTEST_FK_CASCADE_ONE_ID' and ucase(tabname) = 'MIGTEST_FK_CASCADE') then
  prepare stmt from 'alter table migtest_fk_cascade drop constraint fk_migtest_fk_cascade_one_id';
  execute stmt;
end if;
end$$;
delimiter $$
begin
if exists (select constname from syscat.tabconst where tabschema = current_schema and ucase(constname) = 'FK_MIGTEST_FK_SET_NULL_ONE_ID' and ucase(tabname) = 'MIGTEST_FK_SET_NULL') then
  prepare stmt from 'alter table migtest_fk_set_null drop constraint fk_migtest_fk_set_null_one_id';
  execute stmt;
end if;
end$$;
delimiter $$
begin
if exists (select constname from syscat.tabconst where tabschema = current_schema and ucase(constname) = 'CK_MIGTEST_E_BASIC_STATUS' and ucase(tabname) = 'MIGTEST_E_BASIC') then
  prepare stmt from 'alter table migtest_e_basic drop constraint ck_migtest_e_basic_status';
  execute stmt;
end if;
end$$;
delimiter $$
begin
if exists (select constname from syscat.tabconst where tabschema = current_schema and ucase(constname) = 'CK_MIGTEST_E_BASIC_STATUS2' and ucase(tabname) = 'MIGTEST_E_BASIC') then
  prepare stmt from 'alter table migtest_e_basic drop constraint ck_migtest_e_basic_status2';
  execute stmt;
end if;
end$$;
delimiter $$
begin
if exists (select constname from syscat.tabconst where tabschema = current_schema and ucase(constname) = 'UQ_MIGTEST_E_BASIC_INDEXTEST2' and ucase(tabname) = 'MIGTEST_E_BASIC') then
  prepare stmt from 'alter table migtest_e_basic drop constraint uq_migtest_e_basic_indextest2';
  execute stmt;
end if;
end$$
delimiter $$
begin
if exists (select indname from syscat.indexes where indschema = current_schema and ucase(indname) = 'UQ_MIGTEST_E_BASIC_INDEXTEST2') then
  prepare stmt from 'drop index uq_migtest_e_basic_indextest2';
  execute stmt;
end if;
end$$;
delimiter $$
begin
if exists (select constname from syscat.tabconst where tabschema = current_schema and ucase(constname) = 'UQ_MIGTEST_E_BASIC_INDEXTEST6' and ucase(tabname) = 'MIGTEST_E_BASIC') then
  prepare stmt from 'alter table migtest_e_basic drop constraint uq_migtest_e_basic_indextest6';
  execute stmt;
end if;
end$$
delimiter $$
begin
if exists (select indname from syscat.indexes where indschema = current_schema and ucase(indname) = 'UQ_MIGTEST_E_BASIC_INDEXTEST6') then
  prepare stmt from 'drop index uq_migtest_e_basic_indextest6';
  execute stmt;
end if;
end$$;
delimiter $$
begin
if exists (select constname from syscat.tabconst where tabschema = current_schema and ucase(constname) = 'CK_MIGTEST_E_ENUM_TEST_STATUS' and ucase(tabname) = 'MIGTEST_E_ENUM') then
  prepare stmt from 'alter table migtest_e_enum drop constraint ck_migtest_e_enum_test_status';
  execute stmt;
end if;
end$$;
delimiter $$
begin
if exists (select indname from syscat.indexes where indschema = current_schema and ucase(indname) = 'IX_MIGTEST_E_BASIC_INDEXTEST1') then
  prepare stmt from 'drop index ix_migtest_e_basic_indextest1';
  execute stmt;
end if;
end$$;
delimiter $$
begin
if exists (select indname from syscat.indexes where indschema = current_schema and ucase(indname) = 'IX_MIGTEST_E_BASIC_INDEXTEST5') then
  prepare stmt from 'drop index ix_migtest_e_basic_indextest5';
  execute stmt;
end if;
end$$;
delimiter $$
begin
if exists (select indname from syscat.indexes where indschema = current_schema and ucase(indname) = 'IX_MIGTEST_QUOTED_STATUS1') then
  prepare stmt from 'drop index ix_migtest_quoted_status1';
  execute stmt;
end if;
end$$;
-- apply changes
create table migtest_e_user (
  id                            integer generated by default as identity not null,
  constraint pk_migtest_e_user primary key (id)
);

create table migtest_mtm_c_migtest_mtm_m (
  migtest_mtm_c_id              integer not null,
  migtest_mtm_m_id              bigint not null,
  constraint pk_migtest_mtm_c_migtest_mtm_m primary key (migtest_mtm_c_id,migtest_mtm_m_id)
) in TESTTS index in TESTTS long in TESTTS;

create table migtest_mtm_m_migtest_mtm_c (
  migtest_mtm_m_id              bigint not null,
  migtest_mtm_c_id              integer not null,
  constraint pk_migtest_mtm_m_migtest_mtm_c primary key (migtest_mtm_m_id,migtest_mtm_c_id)
) in TSMASTER index in TSMASTER long in TSMASTER;

create table migtest_mtm_m_phone_numbers (
  migtest_mtm_m_id              bigint not null,
  value                         varchar(255) not null
) in TSMASTER index in TSMASTER long in TSMASTER;


update migtest_e_basic set status = 'A' where status is null;

-- db2 does not support parial null indices :( - so we have to clean;
update migtest_e_basic set status = 'N' where id = 1;

insert into migtest_e_user (id) select distinct user_id from migtest_e_basic;
CALL SYSPROC.ADMIN_MOVE_TABLE(CURRENT_SCHEMA,'MIGTEST_E_BASIC','USERSPACE1','USERSPACE1','USERSPACE1','','','','','','MOVE');

-- NOTE: table has @History - special migration may be necessary
update migtest_e_history2 set test_string = 'unknown' where test_string is null;
alter table migtest_e_history2 drop versioning;
alter table migtest_e_history3 drop versioning;
alter table migtest_e_history4 drop versioning;
alter table migtest_e_history5 drop versioning;

-- NOTE: table has @History - special migration may be necessary
update migtest_e_history6 set test_number1 = 42 where test_number1 is null;
alter table migtest_e_history6 drop versioning;
alter table "table" drop versioning;
CALL SYSPROC.ADMIN_MOVE_TABLE(CURRENT_SCHEMA,'MIGTEST_MTM_C','TESTTS','TESTTS','TESTTS','','','','','','MOVE');
CALL SYSPROC.ADMIN_MOVE_TABLE(CURRENT_SCHEMA,'MIGTEST_MTM_M','TSMASTER','TSMASTER','TSMASTER','','','','','','MOVE');
-- apply alter tables
alter table "table" add column "select" varchar(255);
alter table migtest_ckey_detail add column one_key integer;
alter table migtest_ckey_detail add column two_key varchar(127);
alter table migtest_ckey_parent add column assoc_id integer;
alter table migtest_e_basic alter column status set default 'A';
alter table migtest_e_basic alter column status set not null;
alter table migtest_e_basic alter column status2 set data type varchar(127);
alter table migtest_e_basic alter column status2 drop default;
alter table migtest_e_basic alter column status2 drop not null;
alter table migtest_e_basic alter column a_lob drop default;
alter table migtest_e_basic alter column a_lob drop not null;
alter table migtest_e_basic alter column user_id drop not null;
alter table migtest_e_basic add column new_string_field varchar(255) default 'foo''bar' not null;
alter table migtest_e_basic add column new_boolean_field boolean default true not null;
alter table migtest_e_basic add column new_boolean_field2 boolean default true not null;
alter table migtest_e_basic add column progress integer default 0 not null;
alter table migtest_e_basic add column new_integer integer default 42 not null;
call sysproc.admin_cmd('reorg table migtest_e_basic');
alter table migtest_e_history add column sys_period_start timestamp(12) not null generated always as row begin;
alter table migtest_e_history add column sys_period_end timestamp(12) not null generated always as row end;
alter table migtest_e_history add column sys_period_txn timestamp(12) generated always as transaction start id;
alter table migtest_e_history add period system_time (sys_period_start,sys_period_end);
alter table migtest_e_history alter column test_string set data type bigint;
call sysproc.admin_cmd('reorg table migtest_e_history');
alter table migtest_e_history2 alter column test_string set default 'unknown';
alter table migtest_e_history2 alter column test_string set not null;
alter table migtest_e_history2 add column test_string2 varchar(255);
alter table migtest_e_history2 add column test_string3 varchar(255) default 'unknown' not null;
alter table migtest_e_history2 add column new_column varchar(20);
call sysproc.admin_cmd('reorg table migtest_e_history2');
alter table migtest_e_history2_history alter column test_string set not null;
alter table migtest_e_history2_history add column test_string2 varchar(255);
alter table migtest_e_history2_history add column test_string3 varchar(255) default 'unknown' not null;
alter table migtest_e_history2_history add column new_column varchar(20);
call sysproc.admin_cmd('reorg table migtest_e_history2_history');
alter table migtest_e_history4 alter column test_number set data type bigint;
call sysproc.admin_cmd('reorg table migtest_e_history4');
alter table migtest_e_history4_history alter column test_number set data type bigint;
call sysproc.admin_cmd('reorg table migtest_e_history4_history');
alter table migtest_e_history5 add column test_boolean boolean default false not null;
alter table migtest_e_history5_history add column test_boolean boolean default false not null;
alter table migtest_e_history6 alter column test_number1 set default 42;
alter table migtest_e_history6 alter column test_number1 set not null;
alter table migtest_e_history6 alter column test_number2 drop not null;
call sysproc.admin_cmd('reorg table migtest_e_history6');
alter table migtest_e_history6_history alter column test_number1 set not null;
alter table migtest_e_history6_history alter column test_number2 drop not null;
call sysproc.admin_cmd('reorg table migtest_e_history6_history');
alter table migtest_e_softdelete add column deleted boolean default false not null;
alter table migtest_oto_child add column master_id bigint;
alter table table_history add column "select" varchar(255);
-- apply post alter
alter table migtest_e_basic add constraint ck_migtest_e_basic_status check ( status in ('N','A','I','?'));
create unique index uq_migtest_e_basic_description on migtest_e_basic(description) exclude null keys;
-- NOTE: table has @History - special migration may be necessary
update migtest_e_basic set new_boolean_field = old_boolean;

alter table migtest_e_basic add constraint ck_migtest_e_basic_progress check ( progress in (0,1,2));
create unique index uq_migtest_e_basic_status_indextest1 on migtest_e_basic(status,indextest1) exclude null keys;
create unique index uq_migtest_e_basic_name on migtest_e_basic(name) exclude null keys;
create unique index uq_migtest_e_basic_indextest4 on migtest_e_basic(indextest4) exclude null keys;
create unique index uq_migtest_e_basic_indextest5 on migtest_e_basic(indextest5) exclude null keys;
create table migtest_e_history_history as (select * from migtest_e_history) with no data in MAIN index in MAIN long in MAIN;
alter table migtest_e_history add versioning use history table migtest_e_history_history;
comment on column migtest_e_history.test_string is 'Column altered to long now';
comment on table migtest_e_history is 'We have history now';
alter table migtest_e_history2 add versioning use history table migtest_e_history2_history;
alter table migtest_e_history3 add versioning use history table migtest_e_history3_history;
alter table migtest_e_history4 add versioning use history table migtest_e_history4_history;
alter table migtest_e_history5 add versioning use history table migtest_e_history5_history;
alter table migtest_e_history6 add versioning use history table migtest_e_history6_history;
comment on column "table"."index" is 'this is an other comment';
alter table "table" add versioning use history table table_history;
create unique index uq_table_select on "table"("select") exclude null keys;
-- foreign keys and indices
create index ix_migtest_mtm_c_migtest_mtm_m_migtest_mtm_c on migtest_mtm_c_migtest_mtm_m (migtest_mtm_c_id);
alter table migtest_mtm_c_migtest_mtm_m add constraint fk_migtest_mtm_c_migtest_mtm_m_migtest_mtm_c foreign key (migtest_mtm_c_id) references migtest_mtm_c (id) on delete restrict on update restrict;

create index ix_migtest_mtm_c_migtest_mtm_m_migtest_mtm_m on migtest_mtm_c_migtest_mtm_m (migtest_mtm_m_id);
alter table migtest_mtm_c_migtest_mtm_m add constraint fk_migtest_mtm_c_migtest_mtm_m_migtest_mtm_m foreign key (migtest_mtm_m_id) references migtest_mtm_m (id) on delete restrict on update restrict;

create index ix_migtest_mtm_m_migtest_mtm_c_migtest_mtm_m on migtest_mtm_m_migtest_mtm_c (migtest_mtm_m_id);
alter table migtest_mtm_m_migtest_mtm_c add constraint fk_migtest_mtm_m_migtest_mtm_c_migtest_mtm_m foreign key (migtest_mtm_m_id) references migtest_mtm_m (id) on delete restrict on update restrict;

create index ix_migtest_mtm_m_migtest_mtm_c_migtest_mtm_c on migtest_mtm_m_migtest_mtm_c (migtest_mtm_c_id);
alter table migtest_mtm_m_migtest_mtm_c add constraint fk_migtest_mtm_m_migtest_mtm_c_migtest_mtm_c foreign key (migtest_mtm_c_id) references migtest_mtm_c (id) on delete restrict on update restrict;

create index ix_migtest_mtm_m_phone_numbers_migtest_mtm_m_id on migtest_mtm_m_phone_numbers (migtest_mtm_m_id);
alter table migtest_mtm_m_phone_numbers add constraint fk_migtest_mtm_m_phone_numbers_migtest_mtm_m_id foreign key (migtest_mtm_m_id) references migtest_mtm_m (id) on delete restrict on update restrict;

alter table migtest_ckey_detail add constraint fk_migtest_ckey_detail_parent foreign key (one_key,two_key) references migtest_ckey_parent (one_key,two_key) on delete restrict on update restrict;
create index ix_migtest_ckey_parent_assoc_id on migtest_ckey_parent (assoc_id);
alter table migtest_ckey_parent add constraint fk_migtest_ckey_parent_assoc_id foreign key (assoc_id) references migtest_ckey_assoc (id) on delete restrict on update restrict;

alter table migtest_fk_cascade add constraint fk_migtest_fk_cascade_one_id foreign key (one_id) references migtest_fk_cascade_one (id) on delete restrict on update restrict;
alter table migtest_fk_none add constraint fk_migtest_fk_none_one_id foreign key (one_id) references migtest_fk_one (id) on delete restrict on update restrict;
alter table migtest_fk_none_via_join add constraint fk_migtest_fk_none_via_join_one_id foreign key (one_id) references migtest_fk_one (id) on delete restrict on update restrict;
alter table migtest_fk_set_null add constraint fk_migtest_fk_set_null_one_id foreign key (one_id) references migtest_fk_one (id) on delete restrict on update restrict;
alter table migtest_e_basic add constraint fk_migtest_e_basic_user_id foreign key (user_id) references migtest_e_user (id) on delete restrict on update restrict;
alter table migtest_oto_child add constraint fk_migtest_oto_child_master_id foreign key (master_id) references migtest_oto_master (id) on delete restrict on update restrict;

create index ix_migtest_e_basic_indextest3 on migtest_e_basic (indextest3);
create index ix_migtest_e_basic_indextest6 on migtest_e_basic (indextest6);