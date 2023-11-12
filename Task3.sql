--0
CREATE OR REPLACE FUNCTION check_category_level() RETURNS TRIGGER AS $$
BEGIN
IF EXISTS(SELECT * FROM categories WHERE category_c_id = NEW.parent_id) THEN
IF EXISTS(SELECT * FROM categories WHERE category_c_id = (SELECT parent_id FROM categories 
								 WHERE category_c_id = NEW.parent_id)) THEN
RAISE NOTICE 'Нельзя добавлять каталоги более чем третьего уровня вложенности';
END IF;
END IF;
RETURN NEW;
end
$$ LANGUAGE plpgsQl;

CREATE TRIGGER check_category_level_trigger 
BEFORE INSERT ON categories FOR EACH ROW 
EXECUTE FUNCTION check_category_level();


--1
CREATE OR REPLACE FUNCTION get_goods_total_price(integer)
RETURNS numeric AS $$
DECLARE
summ numeric:=0;
gid alias for $1;
BEGIN
SELECT SUM(curr_o_price) INTO summ
FROM orders
INNER JOIN goods_orders ON orders.order_id = goods_orders.order_id
WHERE goods_orders.goods_id = gid;
RETURN summ;
END
$$ language plpgsql

select get_goods_total_price(1);
select * from goods_orders where goods_id = 1;


--2(0)
CREATE OR REPLACE FUNCTION quantity_goods() RETURNS integer AS $$
DECLARE 
d_attrs record;
i integer:=0;
BEGIN 
FOR d_attrs IN
	SELECT DISTINCT goods_id FROM goods_orders
	LOOP
	i:=i+1;
	END LOOP;
	RAISE INFO '%',i;
	RETURN i;
	END
	
$$ LANGUAGE plpgsQl;
		
SELECT quantity_goods();


--2(1)
CREATE OR REPLACE FUNCTION quantity_goods(arr integer[]) RETURNS integer AS $$
DECLARE 
gid ALIAS FOR $1;
d_attrs record;
r integer;
i integer:=0;
BEGIN 
FOREACH r IN ARRAY arr LOOP
FOR d_attrs IN
	SELECT DISTINCT goods_id FROM goods_orders WHERE goods_id = r
	LOOP
	i:=i+1;
	END LOOP;
	RAISE INFO '%',i;
	END LOOP;
	RETURN i;
	END
		$$LANGUAGE plpgsql;
		
SELECT quantity_goods(ARRAY[1,2,3,4,5]);


--2(2)
CREATE OR REPLACE FUNCTION count_step(integer, integer) RETURNS integer AS $$
DECLARE
gid integer;
BEGIN
IF $2 IS NULL THEN RETURN $1;
ELSEIF $1 IS NULL THEN RETURN 1;
ELSE
SELECT goods_id INTO gid FROM goods_orders where goods_id = $2;
END IF;
IF gid IS NOT NULL THEN RETURN $1+1;
ELSE RETURN $1;
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE AGGREGATE count_goods(integer)
(
initcond = 0,
stype = integer,
sfunc = count_step
);

--3

CREATE OR REPLACE view name_article_amount as
	SELECT name_good, goods_id, g_article, g_amount, min_amount FROM goods ORDER BY goods_id; 
	SELECT * FROM name_article_amount;

CREATE OR REPLACE trigger update_g_amount_tr
INSTEAD OF UPDATE ON name_article_amount
FOR EACH ROW execute function update_g_amount();

CREATE OR REPLACE function update_g_amount()
RETURNS TRIGGER AS $$
BEGIN 
IF (TG_OP = 'UPDATE') THEN
UPDATE goods SET g_amount = new.g_amount
WHERE goods_id = old.goods_id;
END IF;
RETURN NEW;
END
$$ LANGUAGE plpgsql;

update name_article_amount set g_amount = 34 where g_amount = 123;




--инициализация
create or replace procedure init() as $$
begin
create table queue(id serial primary key, data varchar(64) not null);
raise info 'Таблица queue создана';
end
$$ language plpgsql

drop table queue cascade;

call init();

select * from queue;

--добавление в конец
--(1)
create or replace function enqueue(varchar) returns integer
as $$
declare
data alias for $1;
begin
insert into queue values (default, $1);
return 1;
return notice 'Добавление в конец очереди выполнено';
end
$$ language plpgsql

--(2)
create or replace function enqueue(data varchar(64)) returns integer
as $$
declare
last_id integer;
new_id integer;
begin
select id from queue where next_id is null into last_id;
insert into queue(value, next_id) values (data,null) returning id into new_id;
update queue set next_id = new_id where id = last_id;
end;
$$ language plpgsql


select enqueue('Второй');

--очистка очереди
create or replace procedure empty()
as $$
begin
delete from queue;
raise info 'Очередь очищена';
end
$$ language plpgsql

call empty();

--просмотр начала очереди

create or replace function top() returns table (id1 integer, data1 varchar(64))  
as $$
begin
return query
select * from queue order by id limit 1;
end
$$ language plpgsql


create or replace function top1() returns table (id1 integer, data1 varchar(64))  
as $$
begin
return query
select * from queue where id = (select min(id) from queue) order by id;
end
$$ language plpgsql

drop function top1();
select top();
select top1();


--удаление с начала
create or replace function dequeue() returns integer
as $$
begin
delete from queue where id = (select min(id) from queue);
return 1;
end
$$ language plpgsql

--удаление с конца очереди
create or replace function dequeue() returns integer
as $$
begin
delete from queue where id = (select min(id) from queue);
return 1;
end
$$ language plpgsql

select * from queue;