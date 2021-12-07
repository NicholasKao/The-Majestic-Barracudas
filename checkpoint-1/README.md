Directions on how to run the provided queries in checkpoint-1_queries.sql.

Connect to a remote version of the CPDB database.

Copy and paste the desired query (or queries) from checkpoint-1_queires.sql into the query window. To run the queries, hit the "Execute" (green triangle) button in DataGrip or use the command (command + return). 

Specific Questions to Answer:

•	How large is each police unit?
        To answer this, run the second query that has the comment "/*Query to get the number of active LEOs per active police unit*/"

•	How large is the average police units?
        To answer this, run the third query with the comment "/*Query to get the average number of LEOs per active police unit*/"

•	Many background questions such as, for each unit, the average: age, years on force, % male vs. female, number of      different races, etc.
        To answer this, run the fourth query with the comment "/*Query to get a table with background data about each active police unit*/"

•	Number of complaints filed against members of each different unit, aggregating to average number of complaints        per LEO in each unit
        To answer this, run the fifth query with the comment "/*Query to get the average number of allegations, disciplines, and trr's per unit*/"

•	How often are members of the same unit coaccused/how many different units are identified on an allegations?
        To answer this, run the last query with the comment "/*Query to give the number of different units indicated on allegations, allowing us to back into number of co-accused members of the same unit*/"