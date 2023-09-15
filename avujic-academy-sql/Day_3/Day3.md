# SQL - Day 3

## Task submissions

1. Create a new folder called `Day 3` in your project repository `C:\Users\<YourUser>\Projects\<user>-academy-sql\`
2. Save the files you create (`task_n.sql`) while developing to the appropriate day


## Tasks

1. Create a view `average_rating_rpt__v` using these guidelines:
     - Create ranges per each full rating over the *averagerating* values. Values like 2.3, 2.4, 2.7 should fall into the 2-3 range while similarly values like 5.4, 5.6, and 5.7 should fall into the 5-6 range.
     - For each *rating* range, count the number of *titles* and the sum of total *votes*.
     - A view should contain three columns: *rating_range* (1-2, 2-3, ...), *total_titles*, and *total_votes*.

2. Create a view `title_actors_rpt__v` using these guidelines:
     - Choose all distinct *titles* with tconst ending in '27' from the `title_principals__v` view.
     - For each of those *titles*, filter out all actors and actress whose *primary profession* is *acting*, and sort it in the descending order by *birth year*.

3. Create a view `top_rated_movies_rpt__v` using these guidelines:
     - Find all *movies* that have at least 1000 *votes* or more, along with their *primary titles*, *average ratings*, and *number of votes*.
     - Display the *movies* with the most *votes* at the top.

4. Create a view `top_rated_shows_rpt__v` using these guidelines:
     - Find all *TV shows* (series, mini series) that have two or more words in their *primary title*.
     - For each *genre*, list the *genre name*, and the *average rating*.

5. Create a view `top_actor_rpt__v` using these guidelines:
     - Find all *actors* who are also *writers*. 
     - For each *actor*, list their *name*, *primary profession*, *genres* and the count of unique *genres* they have acted in.
