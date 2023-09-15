create or replace view "average_rating_rpt__v" as
(
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
        from "title_ratings"
        )
    group by "rating_range"
);