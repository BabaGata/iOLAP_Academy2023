# SQL - Day 2

## Task submissions

1. Create a new folder called `Day 2` in your project repository `C:\Users\<YourUser>\Projects\<user>-academy-sql\`
2. Put all solutions into a single file (`Day_2_tasks.sql`), save it to the appropriate day.


## Tasks

1. Write a DQL statement to retrieve the average of average rating from the `title_ratings__v` view for all records that have *tconst* starting with `tt0000`.

2. Write a DQL statement to retrieve ids of the titles and their average ratings from the `title_ratings__v` view, selecting only titles with more than 1000 votes.

3. Write a DQL statement to retrieve the titles from the `title_basics__v` view that are in the genre *Comedy* and have a *runtime* greater than 90 minutes.

4. Write a DQL statement to retrieve the titles from the `title_basics__v` view that have a *title type* of *Movie* and have a *start year* between 1900 and 1920.

5. Write 3 separate queries:
    - List 25 longest living actors in movie industry and their age, oldest persons first.
    - List all producers whose names start with a letter M.
    - List all producers whose surnames start with a letter N.


6. Write 2 separate queries:
    - Select title ids and title ratings for movies with rating between 7 and 10 using the BETWEEN statement
    - Do the same thing as above WITHOUT using the BETWEEN statement.
    Order the results by average rating descending


7. Select actors who have also directed movies, along with average ratings between 2.5 and 5.5. 
Display the data in a way that the highest rating movies are on the top. 


8. List movie details for movies with two genres which are not adult movies.

9. List title ids, titles, and genres that contain "Romance" for movies released in 20th century chronologically ordered.

10. Find the total number of TV show episodes for every TV show’s season 2.


11. Since the `primary_profession` column in `name_basics__v` view has comma delimited values, show distinct primary profession per `nconst`, and `primary_name`. 
Split the array and capitalize first letter in profession values. 
For example: 
    this:
nconst          primary_name        profession 
nm0000011       Gary Cooper         actor,soundtrack,stunts

    should look like this:
nconst          primary_name        profession 
nm0000011       Gary Cooper         Actor
nm0000011       Gary Cooper         Soundtrack
nm0000011       Gary Cooper         Stunts
