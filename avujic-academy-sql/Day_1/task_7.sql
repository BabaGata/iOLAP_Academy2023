# "name_basics"
select * from "name_basics" limit 5;
describe name_basics;

create view "name_basics__v" as
select
    "nconst" as "n_const",
    "primaryname" as "primary_name",
    if("birthyear"='\N', null, cast("birthyear" as int)) as "birth_year",
    if("deathyear"='\N', null, cast("deathyear" as int)) as "death_year",
    "primaryprofession" as "primary_profession",
    "knownfortitles" as "known_for_titles"
from "name_basics";

select * from "name_basics__v" limit 20;

# "title_basics"
select * from "title_basics" limit 5;
describe name_basics;

create view "title_basics__v" as
select
    "tconst" as "t_const",
    case
        when "titletype"='tvSeries' then 'TV Series'
        when "titletype"='videoGame' then 'Video Game'
        when "titletype"='tvEpisode' then 'TV Episode'
        when "titletype"='tvMiniSeries' then 'TV Mini Series'
        when "titletype"='movie' then 'Movie'
        when "titletype"='tvMovie' then 'TV Movie'
        when "titletype"='video' then 'Video'
        when "titletype"='short' then 'Short'
        when "titletype"='tvSpecial' then 'TV Special'
        when "titletype"='tvShort' then 'TV Short'
    end as "title_type",
    "primarytitle" as "primary_title",
    "originaltitle" as "original_title",
    cast("isadult" as boolean) as "is_adult",
    if(cast("startyear" as varchar)='\N', null, cast("startyear" as int)) as "start_year",
    if(cast("endyear" as varchar)='\N', null, cast("endyear" as int)) as "end_year",
    "runtimeminutes" as "run_time_minutes",
    "genres"
from "title_basics";

select distinct("title_type") from "title_basics__v" limit 20;

# "title_crew"
select * from "title_crew" limit 5;
describe title_crew;

create view "title_crew__v" as
select
    "tconst" as "t_const",
    "directors",
    "writers"
from "title_crew";

select * from "title_crew__v" limit 20;

# "title_episode"
select * from "title_episode" limit 5;
describe title_episode;

create view "title_episode__v" as
select
    "tconst" as "t_const",
    "parenttconst" as "parent_t_const",
    if("seasonnumber"='\N', null, cast("seasonnumber" as int)) as "season_number",
    if("episodenumber"='\N', null, cast("episodenumber" as int)) as "episode_number"
from "title_episode";

select * from "title_episode__v" limit 20;

# "title_principals"
select * from "title_principals" limit 5;
select distinct("category") from "title_principals";
describe title_principals;

create view "title_principals__v" as
select
    "tconst" as "t_const",
    if(cast("ordering"as varchar)='\N', null, cast("ordering" as int)) as "ordering",
    "nconst" as "n_const",
    case
        when category='archive_sound' then 'Archive Sound'
        when category='archive_footage' then 'Archive Footage'
        when category='production_designer' then 'Production Designer'
        else concat(upper(substring("category", 1, 1)), lower(substring("category", 2)))
    end as "category",
    "job",
    "characters"
from "title_principals";

select * from "title_principals__v" limit 20;
select distinct("category") from "title_principals__v";

# "title_ratings"
select * from "title_ratings" limit 5;
describe title_ratings;

create view "title_ratings__v" as
select
    "tconst" as "t_const",
    cast("averagerating" as double) as "average_rating",
    cast("numvotes" as int) as "num_votes"
from "title_ratings";

select * from "title_ratings__v" limit 20;