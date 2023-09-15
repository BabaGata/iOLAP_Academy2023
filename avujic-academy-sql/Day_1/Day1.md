# SQL - Day 1

## Task submissions

1. Create a new folder called `Day 1` in your project repository `C:\Users\<YourUser>\Projects\<user>-academy-sql\`
2. Save the files you create (`task_n.sql`) while developing to the appropriate day


## Tasks

1. Select all records from all tables. 
    - Describe the values in each of the columns, what are the data types associated with the columns?
    - Try to run some calculations on the columns containng numbers, if they are not working - why could that be, think about appropriate data types for all columns. 
    
2. Write a DQL statement to retrieve the distinct genres from the `title_basics` table, where primary title is not equal to original title, and in the comment note down the count. 

3. Write a DQL statement to count the number of titles in the `title_basics` table.

4. Write a DQL statement to retrieve the titles, and start year from the `title_basics` table that are not adult titles.
    In cases when startyear column contains '\N', cast that value to NULL. 
    Order the result set so that the newest movies show up on top.

5. Write a DQL statement to retrieve the titles and their directors from the `title_crew` table, excluding titles without values in "directors" column.


6. Write a DQL statement to get a count of nconst per each tconst from `title_principals` table, only taking into account instances where the count of nconst values is more than 8 per tconst. Write 2 queries, one filtering using WHERE, and one using HAVING.


7. Create views from the existing tables (`name_basics`, `title_basics`, `title_crew`, `title_episode`, `title_principals`, and `title_ratings`) in the following way:
    - Append `__v` to the name of the table for view names
    - Cast columns to their appropriate data types
    - Add underscores in columns' names where needed

        * Note for `name_basics` table: 
            - The columns *birthyear* and *deathyear* should be integers 
        * Note for `title_basics` table: 
            - The columns *startyear*, *deathyear*, and *runtimeminutes* should be integers.
            - The *isadult* column should be cast to boolean
            - For titletype column create the following labels:
                - *tvSeries* --> *TV Series*
                - *videoGame* --> *Video Game*
                - *tvEpisode* --> *TV Episode*
                - *tvMiniSeries* --> *TV Mini Series*
                - *movie* --> *Movie*
                - *tvMovie* --> *TV Movie*
                - *video* --> *Video*
                - *short* --> *Short*
                - *tvSpecial* --> *TV Special*
                - *tvShort* --> *TV Short*
        * Note for `title_crew` table: 
            - Check instructions above that apply to all tables
        * Note for `title_principals` table: 
            - Cast the *ordering* column to integer
            - For the *category* column, create labels for three values:
                - *archive_sound* --> *Archive Sound*
                - *archive_footage* --> *Archive Footage*
                - *production_designer* --> *Production Designer*
                - For the rest of the values, capitalize the first letter
            - For the *job* column, capitalize the first letter for all records
            - In the *characters* column, remove square brackets from the values where they exist and cast `\N` values to blank
                
        * Note for `title_ratings` table: 
            Cast the *averagerating* column to double, and the *numvotes* column to integer.
        * Note for `title_episode` table: 
            Cast the *seasonnumber* and *episodenumber* columns to integer.
