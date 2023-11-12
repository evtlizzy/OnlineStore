--CREATING TABLES WITH CONSTRAINTS

SET datestyle TO german;

CREATE TABLE IF NOT EXISTS goods
(
	goods_id serial,
    g_article character varying(25) NOT NULL,
    name_good character varying(64) NOT NULL,
    base_price numeric NOT NULL,
    curr_price numeric NOT NULL,
	g_amount integer CHECK (g_amount>0),
    min_amount integer NOT NULL,
    stock_amount integer NOT NULL,
    sh_desc character varying(256) NOT NULL,
    full_desc character varying(512) NOT NULL,
    PRIMARY KEY (goods_id)
);

CREATE TABLE IF NOT EXISTS categories
(
    category_c_id serial,
    name character varying(64) NOT NULL,
    pos integer NOT NULL,
    parent_id integer,
    PRIMARY KEY (category_c_id),
    UNIQUE (pos, parent_id)
);

CREATE TABLE IF NOT EXISTS customers
(
    id_customer serial,
    name_customer character varying(32) NOT NULL,
    phone_customer character varying(24) NOT NULL,
    address character varying(64) NOT NULL,
    email character varying(20),
    PRIMARY KEY (id_customer)
);

CREATE TABLE IF NOT EXISTS orders
(
    order_id serial,
    id_o_customer integer NOT NULL,
    number_order character varying(20) NOT NULL,
    type_pay character varying(20) NOT NULL,
    curr_o_price numeric NOT NULL,
    full_o_price numeric NOT NULL,
    date_o date NOT NULL,
    delivery_type character varying NOT NULL,
    PRIMARY KEY (order_id)
);

CREATE TABLE IF NOT EXISTS pictures
(
    id_p serial,
    goods_id integer NOT NULL,
    PRIMARY KEY (id_p)
);

CREATE TABLE IF NOT EXISTS colors
(
    color_id character varying(25),
    color character varying(20) NOT NULL,
    PRIMARY KEY (color_id)
);

CREATE TABLE IF NOT EXISTS sizes
(
    size_id character varying(25),
    size character varying(10),
    PRIMARY KEY (size_id)
);

CREATE TABLE IF NOT EXISTS colors_goods
(
    colors_goods_id serial,
    color_id character varying(25) NOT NULL,
    goods_id integer NOT NULL,
    PRIMARY KEY (colors_goods_id),
	UNIQUE (color_id,goods_id)
);

CREATE TABLE IF NOT EXISTS sizes_goods
(
    sizes_goods_id serial,
    size_id character varying(25) NOT NULL,
    goods_id integer NOT NULL,
    PRIMARY KEY (sizes_goods_id),
	 UNIQUE (size_id,goods_id)
);

CREATE TABLE IF NOT EXISTS categories_goods
(
    categories_goods_id serial,
    category_c_id serial NOT NULL,
    goods_id integer NOT NULL,
    PRIMARY KEY (categories_goods_id),
	 UNIQUE (category_c_id,goods_id)
);

CREATE TABLE IF NOT EXISTS goods_orders
(
    goods_orders_id serial,
    goods_id integer NOT NULL,
    order_id serial NOT NULL,
    g_amount integer NOT NULL,
    curr_price_go integer NOT NULL,
    PRIMARY KEY (goods_orders_id),
	 UNIQUE (order_id,goods_id)
);

ALTER TABLE goods ADD UNIQUE(name_good, g_article);
ALTER TABLE goods_orders ADD UNIQUE(goods_id, order_id, g_amount);
ALTER TABLE orders ADD UNIQUE(id_o_customer, number_order);
ALTER TABLE customers ADD UNIQUE(name_customer, phone_customer);

ALTER TABLE IF EXISTS goods ALTER COLUMN g_article SET NOT NULL;
ALTER TABLE IF EXISTS goods ADD CHECK (base_price > 0);
ALTER TABLE IF EXISTS goods ADD CHECK (curr_price > 0);
ALTER TABLE IF EXISTS goods ADD CHECK (min_amount > 0);
ALTER TABLE IF EXISTS goods ADD CHECK (stock_amount > 0);

ALTER TABLE IF EXISTS categories ADD CHECK (pos > 0);
ALTER TABLE IF EXISTS categories ADD CHECK (parent_id > 0);

ALTER TABLE IF EXISTS orders ADD CHECK (id_o_customer > 0);
ALTER TABLE IF EXISTS orders ADD CHECK (curr_o_price > 0);
ALTER TABLE IF EXISTS orders ADD CHECK (full_o_price > 0);

ALTER TABLE IF EXISTS pictures ADD CHECK (goods_id > 0);

ALTER TABLE IF EXISTS colors_goods ADD CHECK (goods_id > 0);

ALTER TABLE IF EXISTS sizes_goods ADD CHECK (goods_id > 0);

ALTER TABLE IF EXISTS categories_goods ADD CHECK (category_c_id > 0);
ALTER TABLE IF EXISTS categories_goods ADD CHECK (goods_id > 0);

ALTER TABLE IF EXISTS goods_orders ADD CHECK (goods_id > 0);
ALTER TABLE IF EXISTS goods_orders ADD CHECK (order_id > 0);
ALTER TABLE IF EXISTS goods_orders ADD CHECK (g_amount > 0);

ALTER TABLE IF EXISTS categories
    ADD FOREIGN KEY (parent_id)
    REFERENCES categories (category_c_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS orders
    ADD FOREIGN KEY (id_o_customer)
    REFERENCES customers (id_customer) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS pictures
    ADD FOREIGN KEY (goods_id)
    REFERENCES goods (goods_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS colors_goods
    ADD FOREIGN KEY (color_id)
    REFERENCES colors (color_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS colors_goods
    ADD FOREIGN KEY (goods_id)
    REFERENCES goods (goods_id) MATCH SIMPLE
    ON UPDATE NO cascade
    ON DELETE NO cascade
    NOT VALID;


ALTER TABLE IF EXISTS sizes_goods
    ADD FOREIGN KEY (goods_id)
    REFERENCES goods (goods_id) MATCH SIMPLE
    ON UPDATE NO cascade
    ON DELETE cascade
    NOT VALID;


ALTER TABLE IF EXISTS sizes_goods
    ADD FOREIGN KEY (size_id)
    REFERENCES sizes (size_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS categories_goods
    ADD FOREIGN KEY (goods_id)
    REFERENCES goods (goods_id) MATCH SIMPLE
    ON UPDATE cascade
    ON DELETE cascade
    NOT VALID;


ALTER TABLE IF EXISTS categories_goods
    ADD FOREIGN KEY (category_c_id)
    REFERENCES categories (category_c_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS goods_orders
    ADD FOREIGN KEY (goods_id)
    REFERENCES goods (goods_id) MATCH SIMPLE
    ON UPDATE cascade
    ON DELETE cascade
    NOT VALID;


ALTER TABLE IF EXISTS goods_orders
    ADD FOREIGN KEY (order_id)
    REFERENCES orders (order_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;



INSERT INTO goods VALUES
(default,'10211', 'Пуховое полупальто Beauty',12790, 9720, 123,25,45, 'Женское полупальто-балахон, в стиле "оверсайз", о-образного силуэта, с трикотажным воротником-стойкой и втачным капюшоном, оборудованным кулисой.','Женское полупальто-балахон, в стиле "оверсайз", о-образного силуэта, с трикотажным воротником-стойкой и втачным капюшоном, оборудованным кулисой. Рукава покроя "летучая мышь". Основная застежка на молнии. На полочках, в горизонтальных, рельефных швах расположены карманы на магните. По низу изделия проложена кулиса. Водонепроницаемость. Ветронепродуваемость. Морозоустойчивость. Лёгкость' ),
 (default,'10078', 'Пуховое пальто Winter',25990 , 15800 ,342,40,78, 'Женское пальто, прямого силуэта, с воротником-стойкой и съемным капюшоном, оборудованным кулисой.', 'Женское пальто, прямого силуэта, с воротником-стойкой и съемным капюшоном, оборудованным кулисой. Капюшон оторочен съемным, натуральным мехом енота. Основная застежка на молнии с ветрозащитной планкой на кнопках. На полочках расположены нагрудные, вертикальные карманы на молнии и нижние, косые, прорезные карманы с клапаном на магните. В рукавах, декорированных хлястиком на кнопке, - трикотажные манжеты. В боковых швах - разрезы, застегивающиеся на кнопки. Изделие отделано контрастными элементами.'),
 (default,'9335', 'Шерстяное полупальто Autumn',17017, 8080,234, 80,164,'Женское, шерстяное полупальто, прямого силуэта, с английским воротником и спущенными рукавами. Основная застежка на пуговицах.', 'Женское, шерстяное полупальто, прямого силуэта, с английским воротником и спущенными рукавами. Основная застежка на пуговицах. На полочках расположены накладные карманы. В комплект входит съемный пояс из основной ткани.'),
 (default,'9340', 'Шерстяное пальто Pretty', 17808, 8450,198,32, 145,'Женское, шерстяное пальто, прямого силуэта, с английским воротником. Основная застежка на пуговицу и потайные кнопки.', 'Женское, шерстяное пальто, прямого силуэта, с английским воротником. Основная застежка на пуговицу и потайные кнопки. На полочках расположены прорезные, косые карманы с листочкой. На спинке имеется шлица. В комплект входит съемный пояс из основной ткани.'),
 (default,'10193', 'Куртка Fun',9490 , 7210,268,64 ,46, 'Женская куртка, прямого силуэта. Втачной капюшон с отворотом, оборудован кулисой.', 'Женская куртка, прямого силуэта. Втачной капюшон с отворотом, оборудован кулисой. Основная застежка на молнии. На полочках расположены вертикальные, прорезные карманы на молнии. Низ рукавов, при желании, можно отвернуть. В боковых швах - шлицы, застегивающиеся на кнопки.');
 SELECT * FROM goods;
 
INSERT INTO customers VALUES
(default,'Иванов Иван Петрович','89156782231','г.Москва, ул. Тверская, дом 3, квартира 65','ivaniva@mail.ru'),
(default,'Петрова Мария Николаевна','89851234567','г.Новокузнецк, ул. Дружбы, дом 8, квартира 14','petrmar@ya.ru'),
(default,'Сидорова Дарья Сергеевна','89239876543','г.Нижний Новгород, ул. Солнечная, дом 10, квартира 678','sidordar23@mail.ru'),
(default,'Гафаров Тимур Александрович','89045674352','г.Подольск, ул. Победы, дом 7, квартира 32','gaphtim@yandex.ru'),
(default,'Егорова Анастасия Артемовна','89150167892','г.Зеленоград, ул. Александровка, дом 5, квартира 98','egorovaan@mail.ru');
SELECT * FROM customers;


INSERT INTO orders VALUES
(default,(select id_customer from customers where phone_customer = '89156782231' and name_customer = 'Иванов Иван Петрович'),'123456','Наличные',9720,10720,'13.05.2023','Курьер'),
(default,(select id_customer from customers where phone_customer = '89851234567' and name_customer = 'Петрова Мария Николаевна'),'654321','Наличные',15800,17800,'15.08.2023','Самовывоз'),
(default,(select id_customer from customers where phone_customer = '89239876543' and name_customer = 'Сидорова Дарья Сергеевна'),'321654','Карта',8080,18080,'18.09.2023','Почта'),
(default,(select id_customer from customers where phone_customer = '89045674352' and name_customer = 'Гафаров Тимур Александрович'),'123654','Карта',8450,20000,'10.06.2023','Почта'),
(default,(select id_customer from customers where phone_customer = '89150167892' and name_customer = 'Егорова Анастасия Артемовна'),'325461','Наличные',7210,7800,'11.05.2023','Самовывоз'),
(default,(select id_customer from customers where phone_customer = '89150167892' and name_customer = 'Егорова Анастасия Артемовна'),'98948','Наличные',9720,13987,'24.05.2023','Курьер'),
(default,(select id_customer from customers where phone_customer = '89150167892' and name_customer = 'Егорова Анастасия Артемовна'),'242456','Карта',15800,24763,'30.06.2023','Курьер'),
(default,(select id_customer from customers where phone_customer = '89150167892' and name_customer = 'Егорова Анастасия Артемовна'),'1P29874','Наличные',8080,12374,'13.09.2023','Курьер'),
(default,(select id_customer from customers where phone_customer = '89150167892' and name_customer = 'Егорова Анастасия Артемовна'),'38724','Карта',8450,10234,'23.06.2023','Курьер'),
(default,(select id_customer from customers where phone_customer = '89150167892' and name_customer = 'Егорова Анастасия Артемовна'),'28949','Наличные',7210,12384,'18.07.2023','Курьер'),
(default,(select id_customer from customers where phone_customer = '89045674352' and name_customer = 'Гафаров Тимур Александрович'),'1934','Карта',15800,18734,'16.08.2023','Курьер'),
(default,(select id_customer from customers where phone_customer = '89239876543' and name_customer = 'Сидорова Дарья Сергеевна'),'10938','Наличные',8080,12000,'19.11.2023','Курьер'),
(default,(select id_customer from customers where phone_customer = '89851234567' and name_customer = 'Петрова Мария Николаевна'),'10980','Карта',9720,12345,'10.12.2023','Курьер'),
(default,(select id_customer from customers where phone_customer = '89851234567' and name_customer = 'Петрова Мария Николаевна'),'109408','Наличные',7210,13290,'04.10.2023','Курьер');
SELECT * FROM orders;

INSERT INTO pictures VALUES
(default,(select goods_id from goods where g_article = '10211') ),
(default,(select goods_id from goods where g_article = '10078') ),
(default,(select goods_id from goods where g_article = '9335') ),
(default,(select goods_id from goods where g_article = '9340') ),
(default,(select goods_id from goods where g_article = '10193') );
SELECT * FROM pictures;


INSERT INTO colors VALUES
('2345','Красный'),
('5432','Синий'),
('1234','Коричневый'),
('4321','Черный'),
('7890', 'Желтый'),
('1243','Серый');
SELECT * FROM colors;

INSERT INTO sizes VALUES
('985677','36'),
('987456','38'),
('697854','40'),
('097659','41'),
('386048','37');
SELECT * FROM sizes;

INSERT INTO colors_goods VALUES
(default,(select color_id from colors where color = 'Красный'),(select goods_id from goods where g_article = '10211')),
(default,(select color_id from colors where color = 'Синий'),(select goods_id from goods where g_article = '10078')),
(default,(select color_id from colors where color = 'Коричневый'),(select goods_id from goods where g_article = '9335')),
(default,(select color_id from colors where color = 'Черный'),(select goods_id from goods where g_article = '9340')),
(default,(select color_id from colors where color = 'Синий'),(select goods_id from goods where g_article = '10193'));
SELECT * FROM colors_goods VALUES;


INSERT INTO sizes_goods VALUES
(default,(select size_id from sizes where size = '36'),(select goods_id from goods where g_article = '10211')),
(default,(select size_id from sizes where size = '38'),(select goods_id from goods where g_article = '10078')),
(default,(select size_id from sizes where size = '40'),(select goods_id from goods where g_article = '9335')),
(default,(select size_id from sizes where size = '41'),(select goods_id from goods where g_article = '9340')),
(default,(select size_id from sizes where size = '37'),(select goods_id from goods where g_article = '10193'));
SELECT * FROM sizes_goods;


INSERT INTO goods_orders VALUES
(default,(select goods_id from goods where g_article = '10211'),(select order_id from orders where number_order = '123456'),(select g_amount from goods where goods_id = 1),(select curr_o_price from orders where number_order = '123456')),
(default,(select goods_id from goods where g_article = '10078'),(select order_id from orders where number_order = '654321'),(select g_amount from goods where goods_id = 2),(select curr_o_price from orders where number_order = '654321')),
(default,(select goods_id from goods where g_article = '9335'),(select order_id from orders where number_order = '321654'),(select g_amount from goods where goods_id = 3),(select curr_o_price from orders where number_order = '321654')),
(default,(select goods_id from goods where g_article = '9340'),(select order_id from orders where number_order = '123654'),(select g_amount from goods where goods_id = 4),(select curr_o_price from orders where number_order = '123654')),
(default,(select goods_id from goods where g_article = '10193'),(select order_id from orders where number_order = '325461'),(select g_amount from goods where goods_id = 5),(select curr_o_price from orders where number_order = '325461')),
(default,(select goods_id from goods where g_article = '10211'),(select order_id from orders where number_order = '325461'),(select g_amount from goods where goods_id = 1),(select curr_o_price from orders where number_order = '325461')),
(default,(select goods_id from goods where g_article = '10078'),(select order_id from orders where number_order = '325461'),(select g_amount from goods where goods_id = 2),(select curr_o_price from orders where number_order = '325461')),
(default,(select goods_id from goods where g_article = '9335'),(select order_id from orders where number_order = '325461'),(select g_amount from goods where goods_id = 3),(select curr_o_price from orders where number_order = '325461')),
(default,(select goods_id from goods where g_article = '9340'),(select order_id from orders where number_order = '325461'),(select g_amount from goods where goods_id = 4),(select curr_o_price from orders where number_order = '325461'));
SELECT * FROM goods_orders;

--Delete from categories;
--ALTER TABLE categories ALTER COLUMN parent_id DROP NOT NULL;



INSERT INTO categories VALUES
(default,'Все',1,null),
(default,'Пальто',1,1),
(default,'Полупальто',2,1),
(default,'Куртка',3,1),
(default, 'Шерсть', 1,2),
(default, 'Пух', 2,2);
SELECT * FROM categories;





INSERT INTO categories_goods VALUES
(default,(select category_c_id from categories where name = 'Полупальто'),(select goods_id from goods where g_article = '10211')),
(default,(select category_c_id from categories where name = 'Пальто'),(select goods_id from goods where g_article = '10078')),
(default,(select category_c_id from categories where name = 'Пальто'),(select goods_id from goods where g_article = '9340')),
(default,(select category_c_id from categories where name = 'Полупальто'),(select goods_id from goods where g_article = '9335')),
(default,(select category_c_id from categories where name = 'Куртка'),(select goods_id from goods where g_article = '10193')),
(default, (select category_c_id from categories where name = 'Пух' and  parent_id = 2), (select goods_id from goods where g_article = '10211')),
(default, (select category_c_id from categories where name = 'Шерсть' and  parent_id = 2), (select goods_id from goods where g_article = '9335')),
(default, (select category_c_id from categories where name = 'Пух' and  parent_id = 2), (select goods_id from goods where g_article = '10078')),
(default, (select category_c_id from categories where name = 'Шерсть' and  parent_id = 2), (select goods_id from goods where g_article = '9340'));
SELECT * FROM categories_goods;

--TASKS
--0
SELECT sum(curr_price*stock_amount) as sum_price, sum(stock_amount) as sum_amount FROM goods;

--1
With t0(order_c) AS (Select count(order_id)::numeric as ord_c from orders),
t1(customer_c) AS (SELECT count (id_customer):: numeric FROM customers)
SELECT ROUND(order_c/customer_c, 2) FROM t1, t0;


--2
WITH t0(order_id, total_amount) AS (
		SELECT order_id, SUM(g_amount) AS total_amount FROM goods_orders GROUP BY order_id)
		SELECT order_id, total_amount FROM t0 WHERE total_amount IN (SELECT MAX(total_amount) FROM t0)
	UNION
		SELECT order_id, total_amount FROM t0 WHERE total_amount IN (SELECT MIN(total_amount) FROM t0);

--3

--delete from categories_goods where category_c_id = 5 and goods_id = 4;
--delete from categories_goods where category_c_id = 6 and goods_id = 2;
--delete from categories_goods where category_c_id = 4 and goods_id = 5;


DELETE FROM categories where category_c_id in
(select category_c_id from categories where category_c_id not in 
 (select distinct category_c_id from categories_goods union all
(select distinct parent_id from categories where category_c_id in 
 (select distinct category_c_id from categories_goods))));



--4
--ПЕРВЫЙ ВАРИАНТ РЕАЛИЗАЦИИ
INSERT INTO colors_goods (color_id, goods_id)
	SELECT (SELECT color_id FROM colors WHERE color = 'Желтый'), goods_id FROM colors_goods LEFT JOIN 
	goods USING(goods_id) WHERE name_good LIKE '%пальто%' AND goods_id NOT IN (
			SELECT goods_id FROM colors_goods 
			WHERE color_id = (
				SELECT color_id FROM colors
				WHERE color = 'Желтый')
		);


--ВТОРОЙ ВАРИАНТ РЕАЛИЗАЦИИ
/*CREATE OR REPLACE PROCEDURE update_color() AS $$
DECLARE
	d_attrs RECORD;
	clr_id character varying;
BEGIN
	SELECT color_id INTO clr_id FROM colors WHERE color = 'Желтый';
	FOR d_attrs IN
		SELECT goods_id FROM colors_goods LEFT JOIN goods USING(goods_id) 
		WHERE 
		name_good LIKE '%пальто%' 
		AND 
		goods_id NOT IN (
			SELECT goods_id FROM colors_goods 
			WHERE color_id = (
				SELECT color_id FROM colors
				WHERE color = 'Желтый')
		)
		LOOP
			INSERT INTO colors_goods (color_id, goods_id) VALUES (clr_id, d_attrs.goods_id);
			RAISE INFO 'successfull insert: color_id - %; goods_id - %', clr_id, d_attrs.goods_id;
		END LOOP;

	END
$$ LANGUAGE plpgsql;

CALL update_color();

DELETE FROM colors_goods WHERE color_id = '7890';

SELECT* FROM colors_goods;*/
	

--5
alter table customers add column discount numeric default 0;


--6
alter table customers add check (discount <= 75);
select * from goods;