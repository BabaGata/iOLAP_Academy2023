select *
from "title_basics"
limit 20;

select
    count(distinct("primarytitle")) as count_of_primarytitles,
    count(distinct("originaltitle")) as count_of_originaltitles,
    count("tconst") as count_of_all
from "title_basics";