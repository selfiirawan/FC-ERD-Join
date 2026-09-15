create database kpop;

use kpop;

create table group_table(
	id int auto_increment primary key,
    group_name varchar(255) not null,
    agency varchar(255),
    fandom_name varchar(255)
);

select * from group_table;

insert into group_table (group_name, agency, fandom_name) values
('BIGBANG', 'YG Entertainment', 'V.I.P'),
('SHINee', 'SM Entertainment', 'Shawol'),
('Girls Generation', 'SM Entertainment', 'Sone');

insert into group_table (group_name, agency, fandom_name) values
('2NE1', 'YG Entertainment', 'Blackjack');

update group_table set group_name = 'BigBang' where id = 1;

create table idol(
	id int auto_increment primary key,
    stage_name varchar(100) not null,
    real_name varchar(255) not null,
    nationality varchar(255),
    debut_year int,
    group_id int,
    constraint fk_idol_group foreign key (group_id) references group_table(id)
);

select * from idol;

insert into idol(stage_name, real_name, nationality, debut_year, group_id) values
('G-Dragon', 'Kwon Ji-yong', 'South Korean', 2006, 1),
('Taeyeon', 'Kim Tae-yeon', 'South Korean', 2007, 3),
('Taeyang', 'Dong Young-bae', 'South Korean', 2006, 1),
('Onew', 'Lee Jin-ki', 'South Korean', 2008, 2),
('IU', 'Lee Ji-eun', 'South Korean', 2008, null),
('Yoona', 'Im Yoon-ah', 'South Korean', 2007, 3),
('Key', 'Kim Ki-bum', 'South Korean', 2008, 2),
('BoA', 'Kwon Bo-ah', 'South Korean', 2000, null);

insert into idol(stage_name, real_name, nationality, debut_year, group_id) values
('CL', 'Lee Chae-rin', 'South Korean', 2009, 4),
('Dara', 'Sandara Park', 'Filipino-Korean', 2009, 4);

insert into idol(stage_name, real_name, nationality, debut_year, group_id) values
('Daesung', 'Kang Dae-sung', 'South Korean', 2006, 1),
('Minho', 'Choi Min-ho', 'South Korean', 2008, 2),
('Taemin', 'Lee Tae-min', 'South Korean', 2008, 2);


create table album(
	id int auto_increment primary key,
    title varchar(255) not null,
    release_date date,
    genre varchar(100),
    group_id int not null,
    constraint fk_album_group foreign key (group_id) references group_table(id)
);

select * from album;

insert into album (title, release_date, genre, group_id) values
('Made', '2016-01-01', 'Hip-hop', 1),
('1 of 1', '2016-10-05', 'Pop', 2),
('Alive', '2012-02-29', 'Pop', 1),
('Odd', '2015-05-18', 'Electronic', 2),
('1 of 1 (Repackage)', '2016-11-17', 'R&B', 2);


create table schedule(
	id int auto_increment primary key,
    event_type varchar(255) not null,
    event_date date,
    location varchar(255),
    group_id int not null,
    constraint fk_schedule_group foreign key (group_id) references group_table(id)
);

select * from schedule;

insert into schedule (event_type, event_date, location, group_id) values
('Award show', '2026-11-28', 'Seoul, South Korea', 3),
('Concert', '2026-11-01', 'Seoul, South Korea', 1),
('Fan Meeting', '2026-10-30', 'Bangkok, Thailand', 3),
('Concert', '2026-09-20', 'Seoul, South Korea', 2),
('Fan Meeting', '2026-10-05', 'Osaka, Japan', 1),
('Variety Show', '2026-12-15', 'Seoul, South Korea', 2);

# 1.
select idol.id, idol.stage_name, idol.debut_year, group_table.group_name
from idol left join group_table 
on idol.group_id = group_table.id;

# 2.
select group_table.id, group_table.group_name, count(idol.group_id) as member_count
from group_table join idol
on group_table.id = idol.group_id
group by group_table.id;

# 3.
select group_table.id, group_table.group_name, count(album.group_id) as total_album
from group_table left join album
on group_table.id = album.group_id
group by group_table.id;

# 4.
select album.id, album.title, album.release_date, group_table.group_name
from album join group_table
on album.group_id = group_table.id
where year(release_date) > 2015;

# 5.
select group_table.id, group_table.group_name, schedule.event_type, schedule.event_date, schedule.location
from group_table left join schedule
on schedule.group_id = group_table.id
and schedule.event_date = (select max(event_date) from schedule where group_id = group_table.id);

# 6.
select group_table.id, group_table.group_name, count(idol.group_id) as idol_count
from group_table left join idol
on group_table.id = idol.group_id
group by group_table.id
having idol_count > 2;

# 7.
select g.group_name, s.event_type, s.event_date, s.location
from group_table g join schedule s 
on g.id = s.group_id
where s.event_type = 'Concert';

# 8. 
select g.group_name, count(album.group_id) as album_count
from group_table g join album 
on g.id = album.group_id
group by g.group_name 
order by album_count desc
limit 1;



