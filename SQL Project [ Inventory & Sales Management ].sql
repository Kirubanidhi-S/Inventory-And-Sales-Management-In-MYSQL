create database retail_db;
use retail_db;
drop database retail_db;
create table suppliers (
    supplier_id int primary key,
    supplier_name varchar(50)
);

create table products (
    product_id int primary key,
    product_name varchar(50),
    price decimal(10,2),
    supplier_id int,
    foreign key (supplier_id) references suppliers(supplier_id)
);

create table inventory (
    product_id int primary key,
    stock int,
    foreign key (product_id) references products(product_id)
);

create table sales (
    sale_id int primary key,
    product_id int,
    qty int,
    foreign key (product_id) references products(product_id)
);
insert into suppliers values
(1,'abc traders'),
(2,'global supply');

insert into products values
(101,'laptop',55000,1),
(102,'mouse',500,2),
(103,'keyboard',800,null);

insert into inventory values
(101,10),
(102,50),
(103,5);
select 
p.product_name,
s.supplier_name
from products p
left join suppliers s
on p.supplier_id = s.supplier_id;
select 
product_name,
stock,
case
    when stock = 0 then 'out of stock'
    when stock < 10 then 'low stock'
    else 'available'
end as stock_status
from inventory i
join products p
on i.product_id = p.product_id;
with stock_cte as (
    select 
    p.product_name,
    i.stock
    from products p
    join inventory i
    on p.product_id = i.product_id
)
select * from stock_cte
where stock < 10;
start transaction;

insert into sales values (1,101,2);

update inventory
set stock = stock - 2
where product_id = 101;

commit;
start transaction;

insert into sales values (1,101,1);

rollback;
delimiter $$

create procedure make_sale (
    in p_id int,
    in p_qty int
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
        select 'error occurred' as message;
    end;

    start transaction;

    insert into sales values (null,p_id,p_qty);

    update inventory
    set stock = stock - p_qty
    where product_id = p_id;

    commit;
end$$

delimiter ;
call make_sale(102,5);
