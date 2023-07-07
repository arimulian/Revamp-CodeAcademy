--
-- create schema 
--
create schema sales

--
-- create table sales.Special_Offter
--
-- Table: sales.special_offter

CREATE TABLE IF NOT EXISTS sales.special_offter
(
    spof_id serial,
    spof_description character varying(256),
    spof_discount numeric,
    spof_type character varying(15),
    spof_start_date timestamp without time zone,
    spof_end_date timestamp without time zone,
    spof_min_qty integer,
    spof_max_qty integer,
    spof_modified_date timestamp without time zone DEFAULT now(),
    spof_cate_id integer,
    CONSTRAINT pk_special_ofter_id PRIMARY KEY (spof_id),
    CONSTRAINT special_offter_spof_cate_id_fkey FOREIGN KEY (spof_cate_id)
        REFERENCES sales.special_offter (spof_id)
)

--
-- create table sales.Special_Offter_Program
--
-- Table: sales.special_offter_programs
CREATE TABLE IF NOT EXISTS sales.special_offter_programs
(
    soco_id serial,
    soco_spof_id serial,
    soco_prog_entity_id integer, -- references curicullum.program_entity(prog_entity_id)
    soco_status character varying(15)  DEFAULT 'OPEN',
    soco_modified_date timestamp without time zone DEFAULT now(),
    PRIMARY KEY (soco_id, soco_spof_id, soco_prog_entity_id),
    CONSTRAINT special_offter_programs_soco_spof_id_fk FOREIGN KEY (soco_spof_id)
        REFERENCES sales.special_offter (spof_id)
)

ALTER TABLE sales.special_offter ADD CONSTRAINT fk_special_offter_program FOREIGN KEY (soco_prog_entity_id) REFERENCES curicullum.program_entity(prog_entity_id)

--
--create table Cart_Items 
--
-- Table: sales.cart_items
CREATE TABLE IF NOT EXISTS sales.cart_items
(
    cait_id serial,
    cait_quantity integer,
    cait_unit_price numeric,
    cait_modified_date timestamp without time zone DEFAULT now(),
    cait_user_entity_id integer, -- references users.users(user_entity_id)
    cait_prog_entity_id integer, -- references  curicullum.program_entity(prog_entity_id)
    CONSTRAINT cart_items_pkey PRIMARY KEY (cait_id)
)

ALTER TABLE sales.cart_items ADD CONSTRAINT fk_cait_prog_entity_id FOREIGN KEY (cait_prog_entity_id) REFERENCES curicullum.program_entity(prog_entity_id)
ALTER TABLE sales.cart_items ADD CONSTRAINT fk_cait_user_entity_id FOREIGN KEY (cait_user_entity_id) REFERENCES users.users(user_entity_id)

--
--create table Sales_order_Header
--
-- Table: sales.sales_order_header
CREATE TABLE IF NOT EXISTS sales.sales_order_header
(
    sohe_id serial
    sohe_order_date timestamp without time zone,
    sohe_due_date timestamp without time zone,
    sohe_ship_date timestamp without time zone,
    sohe_order_number character varying(25) ,
    sohe_account_number character varying(25) ,
    sohe_trpa_code_number character varying(55),
    sohe_subtotal numeric,
    sohe_tax numeric,
    sohe_total_due numeric,
    sohe_license_code character varying(512) ,
    sohe_modified_date timestamp without time zone DEFAULT now(),
    sohe_user_entity_id integer, -- references  users.users(user_entity_id)
    sohe_status character varying(15), -- references status master.status(status)
    CONSTRAINT sales_order_header_pk PRIMARY KEY (sohe_id),
    CONSTRAINT sales_order_header_sohe_order_number_key UNIQUE (sohe_order_number)
    CONSTRAINT sales_order_header_sohe_license_code_key UNIQUE (sohe_license_code),
)
ALTER TABLE sales.sales_order_header ADD CONSTRAINT fk_sohe_user_entity_id FOREIGN KEY(sohe_user_entity_id) REFERENCES users.users(user_entity_id)
ALTER TABLE sales.sales_order_header ADD CONSTRAINT fk_sohe_status FOREIGN KEY(sohe_status)REFERENCES master.status(status)

--
-- create table Sales_Order_Detail
--
-- Table: sales.sales_order_detail
CREATE TABLE IF NOT EXISTS sales.sales_order_detail
(
    sode_id integer NOT NULL,
    sode_qty integer,
    sode_unit_price numeric,
    sode_unit_discount numeric,
    sode_line_total numeric,
    sode_modified_date timestamp without time zone DEFAULT now(),
    sode_sohe_id integer,
    sode_prog_entity_id integer, --references curicullum.program_entity(prog_entity_id)
    CONSTRAINT sales_order_detail_pk PRIMARY KEY (sode_id),
    CONSTRAINT sales_order_detail_sode_sohe_id_fk FOREIGN KEY (sode_sohe_id)
        REFERENCES sales.sales_order_header (sohe_id)
)
ALTER TABLE sales.sales_order_detail ADD CONSTRAINT fk_sode_prog_entity_id FOREIGN KEY(sode_prog_entity_id) REFERENCES curicullum.program_entity(prog_entity_id)