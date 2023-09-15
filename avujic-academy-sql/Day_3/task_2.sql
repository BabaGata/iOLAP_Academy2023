create or replace view "title_actors_rpt__v" as
(
    select distinct("tp"."tconst"), "nb"."nconst", "nb"."primary_name", "nb"."birth_year"
    from
        "title_principals__v" as "tp"
        join
        "name_basics__v" as "nb"
        on "tp"."nconst"="nb"."nconst"
    where
        "tp"."tconst" like '%27'
        and
        "nb"."primary_profession" like '%act%'
    order by "nb"."birth_year" desc
);