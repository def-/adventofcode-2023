AoC 2023 solved in Materialize
---

First run Materialize locally:
```
docker run -v mzdata:~/mzdata -p 6875:6875 -p 6876:6876 -p 6877:6877 -p 6878:6878 -p 6879:6879 materialize/materialized:latest
```

You can run each SQL file as a script, for example:
```
./1.sql
psql:1.sql:2: NOTICE:  TABLE "t" does not exist, skipping
DROP TABLE
CREATE TABLE
COPY 1000
 part1
-------
 55447
(1 row)

 part2
-------
 54706
(1 row)
```
