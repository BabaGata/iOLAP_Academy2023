create or replace view top_rated_shows_rpt__v as
(
    select "x"."genre", avg("tr"."average_rating") as "avg_rating"
    from
        "title_ratings__v" as "tr"
        join
        "title_basics__v" as "tb"
        on "tr"."tconst"="tb"."tconst"
        cross join unnest(split("tb"."genres", ',')) as x("genre")
    where
        (
            "tb"."title_type" like '%TV Se%'
            or
            "tb"."title_type" like '%TV Mi%'
        )
        and
        (length("tb"."primary_title") - length(replace("tb"."primary_title", ' ', '')) + 1)>1
    group by "x"."genre"
);