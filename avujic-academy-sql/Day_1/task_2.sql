select distinct("genres")
from "title_basics"
where "primarytitle" != "originaltitle";

/*
select count(distinct("genres"))
from "title_basics"
where "primarytitle" != "originaltitle";

#   _col0
1	451
*/