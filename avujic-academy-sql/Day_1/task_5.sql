select * from "title_basics" limit 5;
select * from "name_basics" limit 5;
select * from "title_crew" limit 5;

select tc."tconst", tb."primarytitle" , tc."directors", nb."primaryname"
from "title_crew" as tc 
full join "title_basics" as tb
    on tc."tconst"=tb."tconst"
left join "name_basics" as nb
    on tc."directors"=nb."nconst"
where not "directors" = '\N'
limit 20;