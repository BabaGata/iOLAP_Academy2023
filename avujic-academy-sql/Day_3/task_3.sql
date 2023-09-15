create or replace view top_rated_movies_rpt__v as
(
    select "tb"."tconst", "tb"."primary_title", "tr"."average_rating", "tr"."num_votes"
    from
        "title_ratings__v" as "tr"
        join
        "title_basics__v" as "tb"
        on "tr"."tconst"="tb"."tconst"
    where
        "tr"."num_votes" >= 1000
        and
        "tb"."title_type" like '%Movie%'
    order by "tr"."num_votes" desc
);