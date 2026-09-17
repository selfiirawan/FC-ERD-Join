create database anime;
use anime;

create table user(
	id int auto_increment primary key,
    username varchar(100) not null,
    email varchar(50),
    join_date date not null
);

select * from user;

insert into user (username, email, join_date) values 
('otaku_kenji', 'kenji@mail.com', '2023-01-15'),
('miyuki_chan', 'miyuki@mail.com', '2023-03-22'),
('shonen_sam', 'sam@mail.com', '2023-05-10'),
('ai_watcher', 'ai.w@mail.com', '2024-01-05'),
('luna_reviews', 'luna@mail.com', '2024-02-18'),
('ghost_in_shell99', 'ghost99@mail.com', '2024-06-30');

insert into user (username, email, join_date) values 
('new_watcher22', 'newwatcher@mail.com','2024-08-10');


create table anime(
	id int auto_increment primary key,
    title varchar(255) not null,
    studio varchar(100) not null,
    episode_count int,
    status varchar(50)
);

select * from anime;

insert into anime (title, studio, episode_count, status) values
('Fullmetal Alchemist: Brotherhood', 'Bones', 64, 'Completed'),
('Death Note', 'Madhouse', 37, 'Completed'),
('Attack on Titan', 'Wit Studio', 87, 'Completed'),
('Your Lie in April', 'A-1 Pictures', 22, 'Completed'),
('Demon Slayer', 'Ufotable', 44, 'Ongoing'),
('Steins;Gate',	'White Fox', 24, 'Completed'),
('Violet Evergarden', 'Kyoto Animation', 13, 'Completed'),
('Chainsaw Man', 'MAPPA', 12, 'Ongoing');

insert into anime (title, studio, episode_count, status) values
('Mob Psycho 100', 'Bones',	12,	'Completed');


create table genre(
	id int auto_increment primary key,
    name varchar(50) not null
);

select * from genre;

insert into genre (name) values
('Action'),('Romance'),('Fantasy'),('Horror'),('Slice of Life');


create table review(
	id int auto_increment primary key,
    rating int not null check (rating between 1 and 10),
    comment text,
    review_date date,
    review_by int not null,
    anime_id int not null,
    constraint fk_review_user foreign key (review_by) references user(id),
    constraint fk_review_anime foreign key (anime_id) references anime(id)
);

select * from review;

insert into review (rating, comment, review_date, review_by, anime_id) values
(9, 'Best story arc ever, amazing pacing', '2024-03-01', 1,	1),
(10, 'A masterpiece from start to end', '2024-03-05', 1, 2),
(8, 'Intense and thought-provoking', '2024-04-10', 1, 3),
(9, 'Beautiful animation and heartbreaking story', '2024-04-15', 2,	4),
(7,	'Great action but slow start', '2024-05-02', 3,	5),
(6,	'Overhyped honestly', '2024-05-20',	4, 1),
(8,	'Loved the emotional depth', '2024-06-01', 5, 7),
(9,	'Rewatched it three times already',	'2024-06-15', 1, 5),
(5,	'Not my type of story',	'2024-07-01', 6, 3),
(10, 'Perfect blend of mystery and action',	'2024-07-10', 1, 4);


create table animeGenre(
	anime_id int not null,
    genre_id int not null,
    primary key (anime_id, genre_id),
    constraint fk_animegenre_anime foreign key (anime_id) references anime(id),
    constraint fk_animegenre_genre foreign key (genre_id) references genre(id)
);

select * from animeGenre;

insert into animeGenre (anime_id, genre_id) values
(1,1),(1,3),(2,1),(2,4),(3,1),(3,3),(3,4),(4,2),(4,5),
(5,1),(5,3),(6,3),(6,5),(7,2),(8,1),(8,4);


# 1. 
select anime.title as anime, genre.name as genre
from anime
left join animeGenre
on anime.id = animeGenre.anime_id
left join genre
on genre.id = animeGenre.genre_id;

# 2. 
select user.username, count(review.id) as total_review
from user left join review
on user.id = review.review_by
group by user.id, user.username;

# 3. 
select anime.title, avg(review.rating) as avg_rating
from anime left join review
on anime.id = review.anime_id
group by anime.title;

# 4. 
select anime.title, anime.status, count(review.id) as total_review
from anime left join review 
on anime.id = review.anime_id
where anime.status = 'Completed'
group by anime.title;

# 5. 
select anime.title, genre.name as genre
from anime
left join animeGenre 
on anime.id = animeGenre.anime_id
left join genre
on genre.id = animeGenre.genre_id
order by anime.title;

# 6. 
select user.username, count(review.id) as review_count
from user left join review 
on user.id = review.review_by
group by user.username
having count(review.id) > 2; 

# 7. 
select anime.title, review.rating, user.username as reviewer
from anime 
left join review
on anime.id = review.anime_id
left join user
on user.id = review.review_by
where review.rating >= 8;

# 8. 
select anime.title, anime.studio, avg(review.rating) as avg_rating
from anime left join review
on anime.id = review.anime_id
group by anime.title, anime.studio
order by avg_rating desc
limit 1;


