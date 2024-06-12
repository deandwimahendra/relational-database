-- Part 1 - 
-- 1. Mengecek sistem dapat menyimpan data mengenai detail item product, yaitu product_type, product_description, merk, payment_methods
select product.product_name, product_type.type_name, product_description.description
from product
join product_type on product.product_type_id = product_type.id
join product_description on product.product_description_id = product_description.id;
-- 2. Mengecek sistem juga harus menyimpan data mengenai pelanggan yang akan membeli produk tsb diantaranya : nama, alamat, tanggal lahir, status_user, gender, created_at, updated_at
select nama, alamat, tanggal_lahir, status_user, gender, created_at, update_at 
from pengguna
select * from transaction_detail 
-- 3. Sistem dapat mencatat transaksi pembelian dari pelanggan
insert into transaksi (transaction_id, user_id, transaction_date, total_amount, payment_method_id)
values (1, 2, 2024-06-10, 10000, 3); -- Ini contoh transaksi dengan user_id 2, total pembayaran 10000, menggunakan payment_method_id 3
-- 4. Sistem dapat mencatat detail transaksi pembelian dari pelanggan
insert into transaction_detail (transaction_detail_id, transaction_id, product_id, quantity, price)
values 
    (1, 1, 2 ,2, 10000),  -- Produk ID 2 dengan jumlah 2 dan harga 10000
    (1, 2, 3, 3, 15000);  -- Produk ID 3 dengan jumlah 3 dan harga 15000
    
-- 5. Menggunakan draw.io untuk membuat ERD
    -- "https://drive.google.com/file/d/13QOa8Ni84OgTbFZgTMs_Up8qmpadheA9/view?usp=drive_link"



-- Part 2 - Data Definition Language

-- 1. Membuat database Alta
create database alta_online_shop_percobaan;

-- Pastikan untuk menggunakan database yang baru dibuat
\c alta_online_shop_percobaan;

-- 2. Membuat schema Olshop

-- a. membuat tabel users/pengguna
create table if not exists pengguna (
 user_id serial primary key,
 username varchar(50) not null,
 nama varchar (255),
 alamat varchar (255),
 tanggal_lahir date,
 status_user varchar (20),
 gender varchar (10),
 password varchar (255) not null,
 email varchar (100) not null,
 created_at timestamp default current_timestamp,
 update_at timestamp default current_timestamp
);
-- b. membuat tabel product, product_type, product_description, payment_method

-- tabel product_type
create table if not exists product_type (
    id serial primary key,
    type_name varchar(100) not null,
    description text
);

-- tabel product_description
create table if not exists product_description (
    id serial primary key,
    description text not null
);

-- tabel product
create table if not exists product (
    product_id serial primary key,
    product_name varchar(100) not null,
    product_type_id int,
    product_description_id int,
    harga decimal(10,2) not null,
    stock int not null,
    foreign key (product_type_id) references product_type(id) on delete cascade,
    foreign key (product_description_id) references product_description(id) on delete cascade
);

-- tabel payment_method
create table if not exists payment_method (
    payment_method_id serial primary key,
    method_name varchar(50) not null,
    created_at timestamp default current_timestamp
);

-- c. membuat tabel transaction, transaction_detail

-- tabel transaksi
create table transaksi (
    transaction_id serial primary key,
    user_id int,
    transaction_date timestamp default current_timestamp,
    total_amount decimal(10,2) not null,
    payment_method_id int,
    foreign key (payment_method_id) references payment_method (payment_method_id)
);

-- tabel transaksi detail
create table transaction_detail (
    transaction_detail_id serial primary key,
    transaction_id int,
    product_id int,
    quantity int not null,
    price decimal(10,2) not null,
    foreign key (transaction_id) references transaksi (transaction_id),
    foreign key (product_id) references product (product_id)
);

-- 3. Membuat tabel kurir dengan field id, name, created_at, updated_at
-- membuat tabel kurir
create table kurir(
    id serial primary key,
    name varchar(255),
    created_at timestamp,
    updated_at timestamp
);

-- 4. Menambahkan ongkos_dasar column di tabel transaksi
alter table transaksi 
add column ongkos_dasar int;

-- 5. Merename tabel kurir menjadi tabel shipping
alter table kurir rename to shipping;

-- 6. Menghapus tabel shipping karena ternyata tidak dibutuhkan
drop table shipping;

-- 7. Menambahkan entity baru dengan relation 1-to-1, 1-to-many, many-to-many

-- a. 1-to-1 : payment_method dengan description
create table if not exists payment_description (
    payment_method_id serial primary key,
    description text,
    foreign key (payment_method_id) references payment_method(payment_method_id) on delete cascade
);

-- b. 1-to-many : user dengan alamat
create table if not exists alamat (
    id serial primary key,
    user_id int,
    alamat varchar(255),
    kota varchar(100),
    negara varchar(100),
    foreign key (user_id) references pengguna(user_id) on delete cascade
);

-- c. many-to-many : user dengan payment_method menjadi user_payment_method_detail
create table user_payment_method_detail (
    user_id int,
    payment_method_id int,
    primary key (user_id, payment_method_id),
    foreign key (user_id) references pengguna(user_id) on delete cascade,
    foreign key (payment_method_id) references payment_method(payment_method_id) on delete cascade
);

-- Part 3 - Data Manipulation Language

	-- Release 1 : Create, Update dan Delete Data

		-- 1. Insert
			-- a. Insert 3 product type
insert into product_type (type_name) values ('Elektronik');
insert into product_type (type_name) values ('Clothing');
insert into product_type (type_name) values ('Food');

			-- b. Insert 2 product dengan product type id = 1
insert into product (product_name, product_type_id, product_description_id, harga, stock) 
values ('Sumsang', 1, 1, 599.99, 50);
insert into product (product_name, product_type_id, product_description_id, harga, stock)
values ('Huawawei', 1, 2, 15000, 500);
			-- c. Insert 3 product dengan product type id = 2
insert into product (product_name, product_type_id, product_description_id, harga, stock) 
values ('Naykie', 2, 3, 20000, 50);
insert into product (product_name, product_type_id, product_description_id, harga, stock)
values ('Uniklho', 2, 4, 45000, 100);
insert into product (product_name, product_type_id, product_description_id, harga, stock)
values ('Kereseda', 2, 5, 35000, 150);
			-- d. Insert 3 product dengan product type id = 3
insert into product (product_name, product_type_id, product_description_id, harga, stock) 
values ('Seblak', 3, 6, 10000, 50);
insert into product (product_name, product_type_id, product_description_id, harga, stock)
values ('Jasuke', 3, 7, 15000, 50);
insert into product (product_name, product_type_id, product_description_id, harga, stock)
values ('Cimol', 3, 8, 5000, 50);
			-- e. Insert product description pada setiap produk
insert into product_description (description) 
values ('Smartphone Sumsang ini punya fitur yang paling update dan kameranya nyaingin Iphone lho, cobalah!!');
insert into product_description (description) 
 values ('Smartphone Huwawei ini punya performa yang kece abizzz dan imeinya terdaftar, mantap mamenn!!');
insert into product_description (description) 
values ('Sepatu Naykie untuk olahraga dan lari');
insert into product_description (description) 
values ('Pakaian Uniklho yang nyaman dan stylish');
insert into product_description (description) 
values ('Kemeja Kereseda yang elegan dan cocok untuk acara formal');
insert into product_description (description) 
values ('Seblak pedas dan gurih khas Bandung');
insert into product_description (description) 
values ('Jasuke manis dengan jagung, susu, dan keju');
insert into product_description (description) 
values ('Cimol gurih dan renyah, jajanan khas Indonesia');
			-- f. Insert 3 payment methods
insert into payment_method (payment_method_id, method_name, created_at)
values (1, 'Credit Card', now());
insert into payment_method (payment_method_id, method_name, created_at)
values (2, 'Bank Transfer', now());
insert into payment_method (payment_method_id, method_name, created_at)
values (3, 'Tunai', now());
			-- g. Insert 5 user pada tabel user
insert into pengguna (user_id,username, nama, alamat, tanggal_lahir, status_user, gender, password, email, created_at, update_at)
values (1, 'STY1', 'SinTeYong', 'Jl. Merdeka No. 1', '1980-01-01', 'active', 'male', 'password1', 'user1@example.com', now(), current_timestamp),
	   (2, 'OppaJamali', 'Jamali', 'Jl. Kemerdekaan No. 2', '1985-02-02', 'active', 'female', 'password2', 'user2@example.com', now(), current_timestamp),
       (3, 'RogerSumatra', 'Wahyudi Dangsang', 'Jl. Proklamasi No. 3', '1990-03-03', 'inactive', 'female', 'password3', 'user3@example.com', now(), current_timestamp),
       (4, 'Bobyanakhebat', 'Boby Saputra', 'Jl. Pahlawan No. 4', '1995-04-04', 'active', 'male', 'password4', 'user4@example.com', now(), current_timestamp),
       (5, 'ST12charlie', 'Charlie', 'Jl. Kebangsaan No. 5', '2000-05-05', 'inactive', 'male', 'password5', 'user5@example.com', now(), current_timestamp);
			-- h. Insert 3 transaksi dimasing-masing user (min 3 user)
insert into transaksi (transaction_id, user_id, transaction_date, total_amount, payment_method_id)
values (1, 1, '2024-10-02', 10000, 1),
	   (2, 1, '2024-10-03', 15000, 3),
	   (3, 3, '2024-10-04', 12000, 2),
	   (4, 2, '2024-10-07', 5000, 3);
			-- i. Insert 3 product dimasing-masing transaksi
insert into transaction_detail (transaction_detail_id, transaction_id, product_id, quantity, price)
values 
    (5, 2, 2, 3, 12000),  
    (6, 4, 2, 4, 7000),   
    (7, 3, 3, 5, 18000),  
    (8, 4, 4, 5, 5000);  
		-- 2. Select
			-- a. Menampilkan nama user/ pelanggan dengan gender Laki-laki/ M
   select nama, gender from pengguna
   where gender = 'male';
			-- b. Menampilkan product dengan id = 3
  select * from product
  where product_id = 3
			-- c. Menampilkan data pelanggan yang created_at dalam 7 hari kebelakang yang mempunyai nama mengandung kata a.
select * from pengguna
where created_at >= current_date - interval '7 days'
and nama like '%a%';
			-- d. Menghitung jumlah user/ pelanggan dengan status gender perempuan
select count(*) from pengguna
where gender = 'female';
			-- e. Menampilkan data pelanggan dengan urutan sesuai nama abjad
select * from pengguna
order by nama asc;
			-- f. Menampilkan 5 data transaksi dengan product id = 3
select * from transaksi
where exists (
select 1 from transaction_detail
where transaksi.transaction_id = transaction_detail.transaction_id
and transaction_detail.product_id = 3)
limit 5;
		-- 3. Update
			-- a. Ubah data product id 1 dengan nama 'product dummy'
update product set product_name = 'product dummy'
where product_id = 1;
			-- b. Update qty = 3 pada transaction detail dengan product id 1
update transaction_detail set quantity = 3
where product_id = 1;

		-- 4. Delete
			-- a. Delete data pada tabel product dengan id 1
delete from product 
where product_id = 1;
			-- b. Delete pada tabel product dengan product_type id 1
delete from product
where product_type_id = 1;

	-- Release 2 : Join, Union, Sub-query, Function
		-- 1. Menggabungkan data transaksi dari user id 1 dan user id 2
select * from transaksi
where user_id = 1
union
select * from transaksi
where user_id = 2;
		-- 2. Menampilkan jumlah harga transaksi user id 1
select sum(total_amount) as total_harga_transaksi
from transaksi where user_id = 1;
		-- 3. Menampilkan total transaksi dengan product type 2
select sum(transaction_detail.price * transaction_detail.quantity) as total_transaksi
from transaction_detail
join product on transaction_detail.product_id = product.product_id
join transaksi on transaction_detail.transaction_id = transaksi.transaction_id
where product.product_type_id = 2;
		-- 4. Menampilkan semua field table product dan field name table product type yang saling berhubungan
select product.* , product_type.type_name
from product
join product_type on product.product_type_id = product_type.id;
		-- 5. Menampilkan semua field table transaction, field name table product dan field name table user
select transaksi.*, product.product_name, pengguna.username
from transaksi
join transaction_detail on transaksi.transaction_id = transaction_detail.transaction_id
join product on transaction_detail.product_id = product.product_id
join pengguna on transaksi.user_id = pengguna.user_id;
		-- 6. Menampilkan data product yang tidak pernah ada di tabel transaction_details dengan sub-query
select * from product 
where product.product_id not in (
	select transaction_detail.product_id
	from transaction_detail);
		-- 7. Menerapkan otomasi menggunakan function dan trigger pada column updated_at di semua tabel dan contohkan hasilnya
			-- a. membuat fungsi untuk memperbarui update_at
create or replace function update_updated_at()
returns trigger as $$
begin
	new.updated_at = now();
	return new;
end;
$$ language plpgsql;
			-- b. selanjutnya membuat trigger pada setiap tabel
				-- Untuk membuat pemicu, untuk setiap tabel yang memanggil fungsi 'update_update_at()' setiap kali ada pembaruan pada baris, maka saya mencoba menggunakan tabel 'product'
create trigger product_update_at_trigger
before update on product
for each row
execute function update_updated_at();
			-- c. untuk contoh penggunaannya, saya akan melihat bagaimana apakah ini berfungsi saat dijalankan. Misalnya kita memeiliki tabel 'product' dengan kolom 'updated_at'. Maka ketika kita melakukan pembaruan pada baris tabel 'product', nilai kolom 'updated_at' akan diperbarui secara otomatis.
				-- memperbarui harga product dengan id = 1
update product
set harga = 700
where product_id = 1;

		-- 8. Melakukan create view yang menghasilkan data yang sama dengan (menampilkan semua field table product dan field name table product type yang saling berhubungan)
create or replace view product_with_type as select product.*, product_type.type_name
from product
join product_type on product.product_type_id = product_type.id;

	
