create or replace view top_actor_rpt__v as
(
    select 
        "nb"."primary_name",
        "nb"."primary_profession",
        array_join(array_agg(distinct "y"."genre"),',') as "genres",
        count(distinct "y"."genre") as "count_of_unique_genres"
    from
        "name_basics__v" as "nb"
        cross join unnest(split("nb"."known_for_titles", ',')) as x("tconst")
        join
        "title_basics__v" as "tb"
        on "x"."tconst"="tb"."tconst"
        cross join unnest(split("tb"."genres", ',')) as y("genre")
    where
        "nb"."primary_profession" like '%act%'
        and
        "nb"."primary_profession" like '%writer%'
    group by "nb"."nconst", "nb"."primary_name", "nb"."primary_profession"
);