# music_db_sql_development

This is a project to use some T-SQL on a theoretical application. In order to pratice some SQL in a project context. In addtition to just create a database and build queries to answer specific answers there was also a desire to play a little with the concepts of views, stored procedures, triggers, in-memory tables, filegroups, datafiles, temporary tables, compressions and partitions.

## Project Description:
Music streaming service.
Among other functionalities, the conceptual, logical, and physical solutions should include information and data structures required for the platform's operation, related to artists and/or bands, albums and their tracks, labels, music genres, and users.

The designed queries should answer the following questions.
- Alphabetical list of users
- Alphabetical list of music genres
- Alphabetical list of labels
- Alphabetical list of bands, by country
- Alphabetical list of band, label, genre, and album name
- List of the 5 countries with the most bands
- List of the 10 bands with the most albums
- List of the 5 labels with the most albums
- List of the 5 music genres with the most albums
- List of the 20 longest album tracks
- List of the 20 shortest album tracks
- List of the 10 albums that took the longest time to produce
- How many tracks each album has
- How many album tracks last longer than 5 minutes
- Which songs are the most played
- Which songs are the most played, by country, between 12:00 AM and 8:00 AM
- Which songs are the most played, by country, between 8:00 AM and 4:00 PM
- What is the most played music genre by country
- What is the most played music genre by country, between 12:00 AM and 8:00 AM
- What is the most played music genre by country, between 4:00 PM and 12:00 AM

In this project there has been some dummy data introduced to the database. This data has been used to essentially test the result of the queries and is not real.

## Milestones

- Choose a logical model
- Choose a physical model
- Define the information to extract from the database
- Determine the tables and columns to consider for each of the requested questions
- Develop queries based on the structured designs
- Convert queries into Views
- Convert queries into Stored Procedures
- Create a Trigger for INSERT/UPDATE/DELETE on the user table that writes to a log table to be created
- Convert a database table into an in-memory table
- Create Filegroups and Datafiles
- Create datafiles in the TempDB database
- Check database integrity (DBCC)
- Use variables of type @table
- Use temporary tables
- Partition the session table
- Compress the session table
