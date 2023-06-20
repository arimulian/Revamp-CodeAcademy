--
-- create schema 
--
create schema sales

--
-- create table sales.Special_Offter
--
create table sales.special_offter(
	spof_id serial,
	spof_description varchar(256),
	spof_discount numeric,
	spof_type varchar(15),
	spof_start_date timestamp,
	spof_end_date timestamp,
	spof_min_qty integer,
	spof_max_qty integer,
	spof_cate_id integer references sales.special_offter(spof_id),
	constraint pk_special_ofter_id primary key(spof_id)	
)

--
-- create table sales.Special_Offter_Program
--
create table sales.special_offter_programs(
	soco_id serial,
	soco_spof_id serial references sales.special_offter(spof_id) ,
	soco_prog_entity_id integer, -- references curicullum.prog_entity_id
	soco_status varchar(15),
	soco_modified_date timestamp,
	primary key(soco_id, soco_spof_id, soco_prog_entity_id)
)
alter table sales.special_offter set constraint fk_special_offter_program foreign key (soco_prog_entity_id) references curicullum.program_entity(prog_entity_id)

--
--create table Cart_Items 
--
create table sales.cart_items(
	cait_id serial primary key,
	cait_quantity integer,
	cait_unit_price numeric,
	cait_modified_date timestamp,
	cait_user_entity_id integer, --references curriculum.program_entity.prog_entity_id
	cait_prog_entity_id integer --references users.users.user_entity_id
)
alter table sales.cart_items set constraint fk_cait_prog_entity_id foreign key (cait_prog_entity_id) references curicullum.program_entity(prog_entity_id)
alter table sales.cart_items set constraint fk_cait_user_entity_id foreign key (cait_user_entity_id) references users.users(user_entity_id)

--
--create table Sales_order_Header
--
create table sales.sales_order_header(
	sohe_id serial primary key,
	sohe_order_date timestamp,
	sohe_due_date timestamp,
	sohe_ship_date timestamp,
	sohe_order_number varchar(25) unique,
	sohe_account_number varchar(25),
	sohe_trpa_code_number varchar(55), --diambil dari trpa_code_number transaction payment
	sohe_subtotal numeric,
	sohe_tax numeric,
	sohe_total_due numeric,
	sohe_license_code varchar(512) unique,
	sohe_modified_date timestamp,
	sohe_user_entity_id integer, -- references users.users.user_entity_id
	sohe_status varchar(15) -- references master.status.status
)
alter table sales.sales_order_header set constraint fk_sohe_user_entity_id foreign key(sohe_user_entity_id) references users.users(user_entity_id)
alter table sales.sales_order_header set constraint fk_sohe_status foreign key(sohe_status) references master.status(status)

--
-- create table Sales_Order_Detail
--
create table sales.sales_order_detail(

	sode_id integer primary key,
	sode_qty integer,
	sode_unit_price numeric,
	sode_unit_discount numeric,
	sode_line_total numeric,
	sode_modified_date timestamp,
	sode_sohe_id integer references sales.sales_order_header(sohe_id),
	sode_prog_entity_id integer --references  curiculum.program_entity.prog_entity_id

)
alter table sales.sales_order_detail set constraint fk_sode_prog_entity_id foreign key(sode_prog_entity_id) references curicullum.program_entity(prog_entity_id)