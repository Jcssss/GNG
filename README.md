# GNG
An SQL Database and text-based Python UI for the fictitious company Green-Not-Greed. The database consists of Members, Campaigns, Campaign Phases, Donors, and Transactions. Equipped with the Python UI, users can add any of the previously listed entities to the database or browse existing entities.

## About
This program was written for my class: CSC 370 - Database Systems. The program was written in two phases:
 - Phase 1 involved designing the database using an E/R Diagram and relatonal structures. After the initial plannng the database was then generated using PostgreSQL. Finally once the database's tables were created, I wrote an automated Python script to populate the tables and also created a set of queries stored in views.
 - Phase 2 involved designing a text-based UI allowing users to add to and browse the database. The UI utilized psycopg2 to access the database and perform the necessary queries. With the database, users could create new events and members, while also assigning members to volunteer and lead events. The UI also allowed users to view and filter existing data, while presenting it in both a text-based list and ascii bar charts.
