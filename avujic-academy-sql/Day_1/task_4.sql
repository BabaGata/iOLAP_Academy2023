select 
    if (cast("endyear" as varchar) = '\N', null, "primarytitle") as primarytitle,
    "startyear",
    "endyear"
from "title_basics"
where "isadult" = 0
order by "startyear" desc
limit 20;