create table BS_zipcodes (
  zip int primary key,
  city  varchar(30),
  state varchar(20),
  dibuatoleh VARCHAR(10),
  waktudibuat DATETIME,
  diubaholeh VARCHAR(10),
  waktudiubah DATETIME)

create table BS_employees (
  employeeno  varchar(10)primary key,
  employeename  varchar(30),
  zip  int references BS_zipcodes,
  hire_date datetime,
  dibuatoleh VARCHAR(10),
  waktudibuat DATETIME,
  diubaholeh VARCHAR(10),
  waktudiubah DATETIME)

create table BS_books (
  bookno  int primary key,
  bookname  varchar(30),
  qoh  int not null,
  price  numeric(6,2) not null,
  dibuatoleh VARCHAR(10),
  waktudibuat DATETIME,
  diubaholeh VARCHAR(10),
  waktudiubah DATETIME)

create table BS_customers (
  customerno   int primary key,
  customername  varchar(30),
  street varchar(30),
  zip  int  references BS_zipcodes,
  phone  char(12),
  dibuatoleh VARCHAR(10),
  waktudibuat DATETIME,
  diubaholeh VARCHAR(10),
  waktudiubah DATETIME)

create table BS_orders (
  orderno  int  primary key,
  customerno  int  references BS_customers,
  employeeno  varchar(10)  references BS_employees,
  received DATETIME,
  shipped DATETIME,
  dibuatoleh VARCHAR(10),
  waktudibuat DATETIME,
  diubaholeh VARCHAR(10),
  waktudiubah DATETIME
)

create table BS_odetails (
  orderno  int  references BS_orders,
  bookno  int  references BS_books,
  quantity int not null,
  dibuatoleh VARCHAR(10),
  waktudibuat DATETIME,
  diubaholeh VARCHAR(10),
  waktudiubah DATETIME
  primary key (orderno, bookno))

insert into BS_zipcodes values (98225, 'Bellingham', 'WA','system', getdate(), 'system', getdate())
insert into BS_zipcodes values (95388, 'Winton', 'CA','system', getdate(), 'system', getdate())
insert into BS_zipcodes values (44242, 'Stow', 'OH','system', getdate(), 'system', getdate())
insert into BS_zipcodes values (61536, 'Hanna city', 'IL','system', getdate(), 'system', getdate())
insert into BS_zipcodes values (01254, 'Richmond', 'MA','system', getdate(), 'system', getdate())
insert into BS_zipcodes values (95124, 'San Jose', 'CA','system', getdate(), 'system', getdate())
insert into BS_zipcodes values (95382, 'Turlock', 'MA','system', getdate(), 'system', getdate())
insert into BS_zipcodes values (95380, 'Turlock', 'CA','system', getdate(), 'system', getdate())

insert into BS_employees values ('P0239400', 'Jones Hoffer',98225, '2000-12-12','system', getdate(), 'system', getdate())
insert into BS_employees values ('P0239401', 'Jeffrey Prescott',95388, '2006-01-01','system', getdate(), 'system', getdate())
insert into BS_employees values ('P0239402', 'Fred NcFaddeb',95124, '2008-09-01','system', getdate(), 'system', getdate())

insert into BS_books values (10506, 'Accounting 101',200, 129.99,'system', getdate(), 'system', getdate())
insert into BS_books values (10507, 'Management 101',159, 109.99,'system', getdate(), 'system', getdate())
insert into BS_books values (10508, 'Fraud Cases',190, 179.99,'system', getdate(), 'system', getdate())
insert into BS_books values (10509, 'CPA Review',65, 299.99,'system', getdate(), 'system', getdate())
insert into BS_books values (10601, 'Peachtree for Dummies',322, 49.99,'system', getdate(), 'system', getdate())
insert into BS_books values (10701, 'Financial Accounting',129, 164.99,'system', getdate(), 'system', getdate())
insert into BS_books values (10800, 'Managerial Accounting',155, 114.99,'system', getdate(), 'system', getdate())
insert into BS_books values (10900, 'Cost Accounting',122, 119.99,'system', getdate(), 'system', getdate())
insert into BS_books values (10901, 'Intermediate Accounting',123, 164.99,'system', getdate(), 'system', getdate())
insert into BS_books values (10902, 'XBRL in Nutshell',124, 109.99,'system', getdate(), 'system', getdate())

insert into BS_customers values (23511, 'Michelle Kuan', '123 Main St.',98225, '360-636-5555','system', getdate(), 'system', getdate())
insert into BS_customers values (23512, 'George Myer', '237 Ash Ave.',95124, '312-678-5555','system', getdate(), 'system', getdate())
insert into BS_customers values (23513, 'Richard Gold', '111 Inwood St.',95124, '312-883-7337','system', getdate(), 'system', getdate())
insert into BS_customers values (23514, 'Robert Smith', '54 Gate Dr.',95388, '206-832-1221','system', getdate(), 'system', getdate())
insert into BS_customers values (23515, 'Christopher David', '777 Loto St.',98225, '360-458-9878','system', getdate(), 'system', getdate())
insert into BS_customers values (23516, 'Adam Beethoven', '234 Park Rd..',95380, '209-546-7299','system', getdate(), 'system', getdate())
insert into BS_customers values (23517, 'Lidwig Bach', '5790 Walnut St.',95382, '209-638-2712','system', getdate(), 'system', getdate())

insert into BS_orders values (1020, 23511, 'P0239400', '2014-10-18', '2014-10-20','system', getdate(), 'system', getdate())
insert into BS_orders values (1021, 23511, 'P0239400', '2014-10-29', '2014-10-31','system', getdate(), 'system', getdate())
insert into BS_orders values (1022, 23512, 'P0239401', '2014-11-10', '2014-11-13','system', getdate(), 'system', getdate())
insert into BS_orders (orderno, customerno, employeeno, RECEIVED,dibuatoleh, waktudibuat, diubaholeh, waktudiubah)values (1023, 23513, 'P0239402', '2014-11-15','system', getdate(), 'system', getdate())
insert into BS_orders (orderno, customerno, employeeno, RECEIVED,dibuatoleh, waktudibuat, diubaholeh, waktudiubah)values (1024, 23511, 'P0239400', '2014-11-16','system', getdate(), 'system', getdate())

insert into BS_odetails values (1020, 10506,1,'system', getdate(), 'system', getdate())insert into BS_odetails values (1020, 10507,2,'system', getdate(), 'system', getdate())
insert into BS_odetails values (1020, 10508,2,'system', getdate(), 'system', getdate())insert into BS_odetails values (1020, 10509,3,'system', getdate(), 'system', getdate())
insert into BS_odetails values (1021, 10601,4,'system', getdate(), 'system', getdate())insert into BS_odetails values (1022, 10601,1,'system', getdate(), 'system', getdate())
insert into BS_odetails values (1022, 10701,2,'system', getdate(), 'system', getdate())insert into BS_odetails values (1023, 10800,4,'system', getdate(), 'system', getdate())
insert into BS_odetails values (1023, 10900,1,'system', getdate(), 'system', getdate())insert into BS_odetails values (1024, 10900,7,'system', getdate(), 'system', getdate())
