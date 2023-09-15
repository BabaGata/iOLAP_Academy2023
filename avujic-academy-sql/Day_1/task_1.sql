# name_basics
describe name_basics;
/*
nconst              	string              	                    
primaryname         	string              	                    
birthyear           	string              	                    
deathyear           	string              	                    
primaryprofession   	string              	                    
knownfortitles      	string 
*/
select "deathyear" - "birthyear" as GodineZivota
from name_basics;
/*
TYPE_MISMATCH: line 1:20: Cannot apply operator: varchar - varchar
Numericki stupci nisu numericki tipovi nego string tipovi i kako bi mogli
raditi kalkulacije moramo ih castat.
*/

# title_basics
describe title_basics;
/*
tconst              	string              	                    
titletype           	string              	                    
primarytitle        	string              	                    
originaltitle       	string              	                    
isadult             	bigint              	                    
startyear           	bigint              	                    
endyear             	string              	                    
runtimeminutes      	string              	                    
genres              	string    
*/
select "startyear" + 200 as Kalkulacija
from "title_basics"
limit 4;
/*
#   Kalkulacija
1	2094
2	2094
3	2092
4	2092
*/

# title_crew
describe title_crew;
/*
tconst              	string              	                    
directors           	string              	                    
writers             	string  
*/
select *
from "title_crew"
limit 4;
/*
#   tconst      directors   writers
1	tt0000001   nm0005690   \N
2	tt0000002   nm0721526   \N
3	tt0000003   nm0721526   \N
4	tt0000004   nm0721526   \N
*/

# title_episode
describe title_episode;
/*
tconst              	string              	                    
parenttconst        	string              	                    
seasonnumber        	string              	                    
episodenumber       	string 
*/
select *
from "title_episode"
limit 4;

select "seasonnumber" + "episodenumber"
from "title_episode"
limit 4;
# TYPE_MISMATCH: line 1:23: Cannot apply operator: varchar + varchar

# "title_principals"
describe title_principals;
/*
tconst              	string              	                    
ordering            	bigint              	                    
nconst              	string              	                    
category            	string              	                    
job                 	string              	                    
characters          	string         
*/
select *
from "title_principals"
limit 4;

select "ordering" * 2
from "title_principals"
limit 4;
/*
#   _col0
1	16
2	18
3	2
4	4
*/

# "title_ratings"
describe title_ratings;
/*
tconst              	string              	                    
averagerating       	double              	                    
numvotes            	bigint      
*/
select *
from "title_ratings"
limit 4;

select "averagerating" + "numvotes"
from "title_ratings"
limit 4;
/*
#   _col0
1	1995.7
2	270.8
3	1857.5
4	183.5
*/