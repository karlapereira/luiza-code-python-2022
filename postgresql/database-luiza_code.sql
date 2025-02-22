create database luizacode;


create table users(
	id serial,
	email char(100),
	password char(45),
	is_active boolean default true,
	is_admin boolean default false,
	constraint email_uq unique (email),
	constraint users_pkey primary key (id)
);


create table address(
	id serial,
	user_id int, 
	street char(45),
	cep char(8),
	district char(45),
	city char(45),
	state char(24),
	is_delivery boolean default true,
	constraint address_pkey primary key(id),
	constraint fk_user foreign key(user_id) references users(id)
);

create table orders(
	id serial not null,
	user_id int,
	address_id int,
	price decimal(10,2),
	paid boolean default false,
	created_at timestamp not null default now(),
	authority char(100),
	constraint orders_pkey primary key(id),
	constraint order_uq unique(id),
	constraint fk_user FOREIGN KEY(user_id) references users(id),
	constraint fk_address FOREIGN KEY(address_id) references address(id)
);

create table products(
	id serial primary key,
	code integer not null,
	name char(100) not null,
	description char(100),
	price decimal(10,2) not null,
	image char(100)
);


create table order_items(
	code char(100) generated always as (CAST(id_order as char) || '_' || CAST(id_product as char)) stored,
	id_order int,
	id_product int,
	quantity integer not null default 1,
	constraint fk_order foreign key(id_order) references orders(id),
	constraint fk_product foreign key(id_product) references products(id),
	constraint order_product_uq unique(id_order, id_product),
	constraint order_product primary key(code)
);




select * from products;





/* DROP e DROP CASCADE*/
drop table products;
drop table orders_items cascade;





/* DCL - Gerenciamento de acessos e permissões */
create user karlapereira with password 'luizacode123';

grant all privileges on database luizacode to karlapereira;

SELECT * FROM pg_catalog.pg_user;






/* DCL - Add/Modify data */
insert into users (email, password)
	values ('karlapereira', 123);

insert into users (email, password, is_admin)
	values ('lu_domagalu@gmail.com', 12345, true);

select * from users;














insert into address (user_id, street, cep, district, city, state)
	values (1, 'rua xxxxxx, xx', '01311100', 'xxxx', 'sao paulo', 'sp');




insert into address (user_id, street, cep, district, city, state)
	values (10, 'rua xxxxxx, xx', '31630900', 'xxxx', 'belo horizonte', 'mg');










select * from address;







insert into products (code, name, description, price, image)
	values (1000, 'notebook', 'Acer Nitro 5 - core I7 - geforce GTX', 5500.00, 'notebook1.jpeg');





insert into products (code, name, description, price, image)
	values (2000, 'Iphone', 'Apple', 8500.00, 'iphone.jpeg'),
	       (3000, 'Monitor', 'Samsung', 2500.00, 'monitor.jpeg');





update products 
	set price = 5500.89
	where id=1;





select * from products;







insert into orders(user_id, address_id, price, paid)
	values (1, 1, 5500.89, true);



select * from orders;





insert into order_items (id_order, id_product, quantity)
	values (1,1,2),
			(1,2,1),
			(1,3,5);

select * from order_items oi;



select * 
	from users
	where id=1;

select *
	from address
	where user_id = 1;


/* comentario */
select 
	u.email,
	a.street,
	a.cep,
	a.state
	from users as u
	left join address as a
		on u.id = a.user_id;
	
	
select 
	u.email,
	a.street,
	a.cep,
	a.state
	from address as a
	left join users as u 
		on u.id = a.user_id;
	
	

select * from address;	
	


















/*JOINS*/
select 
	u.id,
	u.email,
	a.city,
	a.state,
	o.price,
	o.paid,
	oi.id_product,
	oi.quantity,
	p.name
	from users u
	inner join address a on a.user_id = u.id
	inner join orders o on o.user_id = u.id and o.address_id = a.id
	inner join order_items oi on oi.id_order = o.id
	inner join products p on p.id = oi.id_product;








/* Operadores Aritmeticos */
select *
	from products as p
	where p.price = 8500;








/* Operadores Booleanos */
select *
	from address as a
	where a.user_id = 1 and 
		a.state = 'sp';




/* Agregação */
select
	count(*), price
	from products p
	group by p.price;


select
	count(*) as quantity,
	a.user_id
	from address a
	group by a.user_id;



select
	max(price)
	from products p;

select
	sum(price)
	from products p;


select 
	sum(p.price)*0.9
	from order_items as oi
	inner join products as p
	on oi.id_product = p.id
	where oi.id_order = 1;


select distinct 
	p.price 
	from products p ;


select * from products;

insert into products(code, name, description, price)
	values (4000, 'Monitor LG', 'Monitor LG', 2500);




select 
	*
	from products p
	order by p.description DESC;



select 
	* from products p
	order by p.price desc, p.description asc;


update products 
	set name = 'abc'
	where id=4;

select *
	from address a
	where user_id = 1;

create index ix_address_user on address(user_id);



select *
from pg_indexes
where tablename not like 'pg%';




explain select * 
	from products c;


