create database Registration;

create table Professor(
    pid varchar(8) not null,
    pname varchar(256) not null,
    salary int not null,
    primary key (pid)
);

insert into Registration.Professor(pid, pname, salary)
    values ('001', 'Michael', 35000),
           ('002', 'Simon', 4200),
           ('003', 'William', 25000),
           ('004', 'Ken', 40000),
           ('005', 'Steve', 50000);

insert into Registration.Professor(pid, pname, salary)
    values ('006', 'Tanyawat', 27000);
