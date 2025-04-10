# Internship Portal - Database Setup Guide

To set up the MySQL database on your system, follow these steps:

## Downloading and Importing the Database

1. Clone or download the project repository and locate the `internship.sql` file.
2. Ensure MySQL is installed on your system. You can download it from [MySQL Community Downloads](https://dev.mysql.com/downloads/).
3. Open a terminal or MySQL command line and create the database by running:
   ```sql
   CREATE DATABASE internship;
   ```
4. Import the database dump using the following command:
   ```sh
   mysql -u root -p internship < internship.sql
   ```
   Enter your MySQL root password when prompted.
5. Verify the database setup by running:
   ```sql
   USE internship;
   SHOW TABLES;
   ```

## Troubleshooting

- If you get an access denied error, check your MySQL credentials.
- If the `internship.sql` file is missing, request the latest dump from the project owner.
- Ensure MySQL service is running before importing the dump.

Once the database is set up, you can proceed with running the web application!

