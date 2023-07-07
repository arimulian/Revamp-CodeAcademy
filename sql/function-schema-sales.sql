-- FUNCTION: sales.create_special_offter(character varying, numeric, character varying, timestamp without time zone, timestamp without time zone, integer, integer, integer)
--Create special offter
--
CREATE OR REPLACE FUNCTION sales.create_special_offter(
	description character varying,
	discount numeric,
	offter_type character varying,
	start_date timestamp without time zone,
	end_date timestamp without time zone,
	min_qty integer,
	max_qty integer,
	cate_id integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare 
offter_id integer;
begin

insert into sales.special_offter(spof_description, spof_discount, spof_type, spof_start_date, spof_end_date,spof_min_qty, spof_max_qty spof_cate_id) values(description, discount, offter_type, start_date, end_date, min_qty, max_qty, cate_id)	
returning spof_id into offter_id;

return offter_id;
end;
$BODY$;

--
-- FUNCTION: sales.create_special_offter_program(integer, integer, character varying, timestamp without time zone)
-- create special offter programs
--
CREATE OR REPLACE FUNCTION sales.create_special_offter_program(
	soco_spof_id integer,
	soco_program_entity_id integer,
	soco_status character varying,
	soco_modified_date timestamp without time zone)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
program_entity_id integer;
begin

insert into sales.special_offter_programs(soco_spof_id, soco_program_entity_id, soco_status , soco_modified_date) 
       values(soco_spof_id, soco_program_entity_id, soco_status, soco_modified_date)
returning soco_program_entity_id into program_entity_id;

return program_entity_id;
end;
$BODY$;

--
-- FUNCTION: sales.offter_program_open(integer)
-- set status = 'OPEN'
--
CREATE OR REPLACE FUNCTION sales.offter_program_open(
	offter_program_id integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
update sales.special_offter_programs set soco_status = 'OPEN', soco_modified_date = now()
where sales.special_offter_programs.soco_id = offter_program_id;
if not found then return 0;
end if;
return 1;
end;
$BODY$;

--
-- FUNCTION: sales.offter_program_cancelled(integer)
-- set status = 'CANCELLED'
--
CREATE OR REPLACE FUNCTION sales.offter_program_cancelled(
	offter_program_id integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
update sales.special_offter_programs set soco_status = 'CANCELLED', soco_modified_date = now()
where sales.special_offter_programs.soco_id = offter_program_id;
if not found then return 0;
end if;
return 1;
end;
$BODY$;

--
-- FUNCTION: sales.offter_program_closed(integer)
-- Set Status = 'CLOSED'
--
CREATE OR REPLACE FUNCTION sales.offter_program_closed(
	offter_program_id integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
update sales.special_offter_programs set soco_status = 'CLOSED', soco_modified_date = now()
where sales.special_offter_programs.soco_id = offter_program_id;
if not found then return 0;
end if;
return 1;
end;
$BODY$;

--
-- FUNCTION: sales.search_offter_programs(character varying)
-- Search programs
-- 
CREATE OR REPLACE FUNCTION sales.search_offter_programs(search_term character varying)
    RETURNS TABLE(soco_id integer, soco_spof_id integer, soco_prog_entity_id integer, soco_status character varying, soco_modified_date timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN
  RETURN QUERY
  SELECT sales.special_offter_programs.soco_id,  sales.special_offter_programs.soco_spof_id,  sales.special_offter_programs.soco_prog_entity_id,  sales.special_offter_programs.soco_status,  sales.special_offter_programs.soco_modified_date
  FROM sales.special_offter_programs
  WHERE sales.special_offter_programs.soco_status = 'OPEN' AND ( sales.special_offter_programs.soco_prog_entity_id::TEXT ILIKE '%' || search_term || '%' OR  sales.special_offter_programs.soco_status ILIKE '%' || search_term || '%');
END;
$BODY$;

--
-- FUNCTION: sales.add_cart(integer, numeric, integer, integer)
--Add to cart
--
CREATE OR REPLACE FUNCTION sales.add_cart(quantity integer, price numeric, user_entity_id integer, prog_entity_id integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE

AS $BODY$
begin
insert into sales.cart_items(cait_quantity, cait_unit_price, cait_user_entity_id, cait_prog_entity_id) 
values (quantity, price,user_entity_id, prog_entity_id);
return quantity;
end;
$BODY$;



