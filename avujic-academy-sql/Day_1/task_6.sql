select * from "title_principals" limit 20;

select count("nconst")
from "title_principals"
group by "tconst"
having count("nconst") > 8
limit 20;

select count_nc
from (
    select count("nconst") as count_nc
    from "title_principals"
    group by "tconst"
)
where count_nc > 8
limit 20;