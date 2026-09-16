create database pokemon;

use pokemon;

create table trainer(
	id int auto_increment primary key,
    name varchar(255) not null,
    region varchar(100),
    badge_count int
);

select * from trainer;

insert into trainer (name, region, badge_count) values
('Ash Ketchum', 'Kanto', 8),
('Misty', 'Kanto', 5),
('Brock', 'Kanto', 6),
('Gary Oak', 'Kanto', 10),
('May', 'Hoenn', 4),
('Dawn', 'Sinnoh', 0);


create table pokemon(
	id int auto_increment primary key,
    name varchar(255) not null,
    level int,
    hp int,
    trainer_id int not null,
    constraint fk_pokemon_trainer foreign key (trainer_id) references trainer(id)
);

select * from pokemon;

insert into pokemon (name, level, hp, trainer_id) values
('Pikachu', 50, 120, 1),
('Eevee', 22, 68, 4),
('Staryu', 28, 70, 2),
('Arcanine', 45, 130, 4),
('Onix', 35, 100, 3),
('Charizard', 58, 150, 1),
('Bulbasaur', 30, 90, 1),
('Geodude', 20, 60, 3),
('Psyduck', 25, 65, 2),
('Blastoise', 56, 145, 4),
('Skitty', 18, 55, 5),
('Gyarados', 48, 135, 4);

insert into pokemon (name, level, hp, trainer_id) values
('Magikarp', 5, 20, 5);


create table type(
	id int auto_increment primary key,
    name varchar(100) not null
);

select * from type;

insert into type (name) values
('Fire'),('Water'),('Grass'),('Electric'),('Flying'),('Rock');


create table pokemonType(
	pokemon_id int not null,
    type_id int not null,
    primary key (pokemon_id, type_id),
    constraint fk_pokemontype_pokemon foreign key (pokemon_id) references pokemon(id),
    constraint fk_pokemontype_type foreign key (type_id) references type(id)
);

select * from pokemonType;

insert into pokemonType (pokemon_id, type_id) values
(1,4),(2,1),(2,5),(3,3),(4,2),(5,2),(6,6),(7,6),(8,4),(9,1),(10,2),
(11,2),(11,5),(12,3);


create table battle(
	id int auto_increment primary key,
    date date,
    location varchar(255),
    outcome varchar(50),
    trainer_id int not null,
    constraint fk_battle_trainer foreign key (trainer_id) references trainer(id)
);

select * from battle;

insert into battle (date, location, outcome, trainer_id) values 
('2026-01-15', 'Saffron City', 'Win', 4),
('2026-01-20', 'Cerulean City', 'Win', 2),
('2026-02-05', 'Lavender Town', 'Draw', 5),
('2026-01-05', 'Pallet Town', 'Win', 1),
('2026-02-10', 'Viridian City', 'Loss', 1),
('2026-03-01', 'Pewter City', 'Draw', 3),
('2026-02-20', 'Fuchsia City', 'Win', 4),
('2026-03-10', 'Cinnabar Island', 'Loss', 4);


# 1.
select trainer.id, trainer.name, trainer.region, trainer.badge_count, pokemon.name as pokemon_name
from trainer left join pokemon
on trainer.id = pokemon.trainer_id;

# 2. 
select trainer.id, trainer.name, trainer.region, trainer.badge_count, count(pokemon.id) as total_pokemon
from trainer left join pokemon
on trainer.id = pokemon.trainer_id
group by trainer.id;

# 3. 
select pokemon.name as pokemon_name, type.name as type_name
from pokemon 
left join pokemonType
on pokemon.id = pokemonType.pokemon_id
left join type 
on type.id = pokemonType.type_id
order by pokemon.name asc;

# 4. 
select pokemon.name as pokemon, pokemon.level, trainer.name as trainer
from pokemon join trainer
on pokemon.trainer_id = trainer.id 
where pokemon.level > 30;

# 5. 
select trainer.name, trainer.region, count(battle.id) as battle_count
from trainer left join battle 
on trainer.id = battle.trainer_id
group by trainer.id;

# 6. 
select trainer.name, count(battle.id) as win_count
from trainer join battle 
on trainer.id = battle.trainer_id
where battle.outcome = 'Win'
group by trainer.id, trainer.name
having count(battle.id) >= 2;

# 7. 
select trainer.name, battle.date, battle.location, battle.outcome
from trainer join battle 
on trainer.id = battle.trainer_id
where battle.outcome = 'Win';

# 8. 
select trainer.name, count(pokemon.id) as total_pokemon
from trainer join pokemon
on trainer.id = pokemon.trainer_id
group by trainer.id, trainer.name
order by total_pokemon desc
limit 1;

