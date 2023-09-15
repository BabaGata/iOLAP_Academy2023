SELECT * FROM "imdb_redshift_db"."avujic_academy_imdb"."name_basics";

select "rating_range", count("tconst") as "total_titles", sum("numvotes") as "total_votes"
from (select
    "tconst",
    "numvotes",
    case
        when "averagerating"<1 then '0-1'
        when "averagerating">=1 and "averagerating"<2 then '1-2'
        when "averagerating">=2 and "averagerating"<3 then '2-3'
        when "averagerating">=3 and "averagerating"<4 then '3-4'
        when "averagerating">=4 and "averagerating"<5 then '4-5'
        when "averagerating">=5 and "averagerating"<6 then '5-6'
        when "averagerating">=6 and "averagerating"<7 then '6-7'
        when "averagerating">=7 and "averagerating"<8 then '7-8'
        when "averagerating">=8 and "averagerating"<9 then '8-9'
        when "averagerating">=9 then '9-10'
    end as "rating_range"
    from (
        select "tconst", cast("averagerating" as float) as "averagerating", cast("numvotes" as int) as "numvotes"
        from "imdb_redshift_db"."avujic_academy_imdb"."title_ratings"
        )
    )
group by "rating_range"


select distinct "titletype",
    max("start_year") OVER (PARTITION BY "titletype") AS "startyear_max",
    min("start_year") OVER (PARTITION BY "titletype") AS "startyear_min",
    max("start_year") OVER (PARTITION BY "titletype") - min("start_year") OVER (PARTITION BY "titletype") as "startyear_difference",
    max("run_time_minutes") OVER (PARTITION BY "titletype") AS "runtimeminutes_max",
    min("run_time_minutes") OVER (PARTITION BY "titletype") AS "runtimeminutes_min",
    max("run_time_minutes") OVER (PARTITION BY "titletype") - min("run_time_minutes") OVER (PARTITION BY "titletype") as "runtimeminutes_difference"
from (
    select 
    if("startyear"= '\N', null, cast("startyear" as int)) as "start_year",
    if("runtimeminutes"= '\N', null, cast("runtimeminutes" as int)) as "run_time_minutes",
    "primarytitle",
    "originaltitle",
    "titletype"
    from "imdb_redshift_db"."avujic_academy_imdb"."title_basics"
    )
where "primarytitle"="originaltitle"
limit 5