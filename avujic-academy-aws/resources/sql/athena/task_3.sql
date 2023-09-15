create or replace view "title_insights" as
(
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
        from "title_basics"
        )
    where "primarytitle"="originaltitle"
    limit 5
);

select * from "title_insights";