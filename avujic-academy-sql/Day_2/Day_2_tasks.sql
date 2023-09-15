-- Task 1
select avg("average_rating") as Average_of_average_rating
from "title_ratings__v"
where "tconst" like 'tt0000%';

-- Task 2
select "tconst", "average_rating"
from "title_ratings__v"
where "num_votes" > 1000
limit 10;

-- Task 3
select "primary_title", "original_title"
from "title_basics__v"
where
    "genres" like '%Comedy%'
    and
    "run_time_minutes">90
limit 10;

-- Task 4
select "primary_title", "original_title"
from "title_basics__v"
where
    "title_type"='Movie'
    and
    "start_year" between 1900 and 1920
limit 10;

-- Task 5
-- a)
select 
    "primary_name",
    if("death_year"!=null,cast(date_format(now(), '%Y') as int) - "birth_year","death_year"-"birth_year") as "age"
from "name_basics__v"
where "primary_profession" like '%actor%'
order by "age" desc
limit 25;

-- b)
select *
from "name_basics__v"
where
    "primary_profession" like '%producer%'
    and
    "primary_name" like 'M%';
    
-- c)
select *
from "name_basics__v"
where
    "primary_profession" like '%producer%'
    and
    split_part(reverse("primary_name"),' ',1) like '%N';
    
-- Task 6
-- a)
select "tconst", "average_rating"
from "title_ratings__v"
where "average_rating" between 7 and 10
limit 10;

-- b)
select "tconst", "average_rating"
from "title_ratings__v"
where
    "average_rating">7
    and 
    "average_rating"<10
limit 10;

-- Task 7
select "tc"."directors", "nb"."nconst", "nb"."primary_name", "nb"."primary_profession", "tc"."tconst", "tr"."average_rating"
from
    "name_basics__v" as "nb"
    right join
    "title_crew__v" as "tc"
    on "nb"."nconst" like concat(concat('%',"tc"."directors"),'%')
    full join
    "title_ratings__v" as "tr"
    on "tc"."tconst"="tr"."tconst"
where
    "nb"."primary_profession" like '%act%'
    and
    "tr"."average_rating" between 2.5 and 5.5
order by "tr"."average_rating" desc;

-- Task 8
select *
from "title_basics__v"
where
    not "is_adult"
    and
    (length("genres") - length(replace("genres", ',', '')) + 1)>1
limit 10;

-- Task 9
select "tconst","primary_title","original_title","genres"
from "title_basics__v"
where
    "start_year" between 1900 and 2000
    and
    "genres" like '%Romance%'
order by "start_year"
limit 10;

-- Task 10
select
    "parent_const",
    count("episode_number")
from "title_episode__v"
where "season_number"=2
group by "parent_const"
limit 10;

-- Task 11
select *
from "name_basics__v"
limit 10;

select
    "nconst",
    "primary_name",
    concat(upper(substring(value, 1, 1)), lower(substring(value, 2))) as "Primary_profession"
from "name_basics__v"
cross join unnest(split("primary_profession", ',')) as x(value);

-- Task 12
select *
from "name_basics__v"
where
    "death_year" is null
    and
    (length("known_for_titles") - length(replace("known_for_titles", ',', '')) + 1)>5
limit 10;

-- Task 13
select "tb"."primary_title", case
    when "tr"."average_rating">7.5 and "tb"."genres" like '%Animation%' then 'Family Friendly'
    when "tr"."average_rating">=6 and not "tb"."is_adult" then 'General Auidence'
    when "tr"."average_rating">=5 and "tb"."is_adult" then 'Mature'
    else 'Watch at your own risk'
end as "age_rating"
from
    "title_ratings__v" as "tr"
    join
    "title_basics__v" as "tb"
    on "tr"."tconst"="tb"."tconst"
limit 10;

-- Task 14
select floor("start_year"/10)+1 as "decade", avg("run_time_minutes") as "avg_run_time"
from "title_basics__v"
group by floor("start_year"/10)
order by avg("run_time_minutes") desc;