## SQL Challenges
In this repository there are some problems provided in file `problems.pdf` and also some queries to satisfy the needs of questions

## run the Queries
first you need to set up a postgresql server and upload the data for that specific section. in order to set up the server just run the following command
```bash
sudo docker-compose up
```
this creates a container-based postgresql server that lessons on port 8080.
your server's username and password are respectively `user` and `pass` (you can change them in docker-compose.yml)

now you should import the data provided for the specified section. first define tables using provided queries,then using pycharm just add the connection to your database and import the data from `data` folder in the provided panel

then just run the Queries and see what happens :)