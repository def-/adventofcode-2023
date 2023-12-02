--/.. 2>/dev/null; exec psql "postgres://materialize@localhost:6875/materialize" -f "$0"
create temporary table t (g text, r text);
\copy t from '2.in' with (delimiter ':');

select sum(gameid) as part1 from (select gameid from (select gameid from (select replace(g, 'Game ', '')::int as gameid, regexp_split_to_table(regexp_replace(regexp_replace(regexp_replace(r, '(\d+) red', '$1,', 'g'), '(\d+ blue|\d+ green|,|;| )+', ' ', 'g'), '^ +| +$', '', 'g'), ' ')::int as red from t) group by gameid having max(red) <= 12)
intersect (select gameid from (select replace(g, 'Game ', '')::int as gameid, regexp_split_to_table(regexp_replace(regexp_replace(regexp_replace(r, '(\d+) green', '$1,', 'g'), '(\d+ blue|\d+ red|,|;| )+', ' ', 'g'), '^ +| +$', '', 'g'), ' ')::int as green from t) group by gameid having max(green) <= 13)
intersect (select gameid from (select replace(g, 'Game ', '')::int as gameid, regexp_split_to_table(regexp_replace(regexp_replace(regexp_replace(r, '(\d+) blue', '$1,', 'g'), '(\d+ red|\d+ green|,|;| )+', ' ', 'g'), '^ +| +$', '', 'g'), ' ')::int as blue from t) group by gameid having max(blue) <= 14));

with red as (select gameid, max(red) as r from (select replace(g, 'Game ', '')::int as gameid, regexp_split_to_table(regexp_replace(regexp_replace(regexp_replace(r, '(\d+) red', '$1,', 'g'), '(\d+ blue|\d+ green|,|;| )+', ' ', 'g'), '^ +| +$', '', 'g'), ' ')::int as red from t) group by gameid),
green as (select gameid, max(green) as g from (select replace(g, 'Game ', '')::int as gameid, regexp_split_to_table(regexp_replace(regexp_replace(regexp_replace(r, '(\d+) green', '$1,', 'g'), '(\d+ blue|\d+ red|,|;| )+', ' ', 'g'), '^ +| +$', '', 'g'), ' ')::int as green from t) group by gameid),
blue as (select gameid, max(blue) as b from (select replace(g, 'Game ', '')::int as gameid, regexp_split_to_table(regexp_replace(regexp_replace(regexp_replace(r, '(\d+) blue', '$1,', 'g'), '(\d+ red|\d+ green|,|;| )+', ' ', 'g'), '^ +| +$', '', 'g'), ' ')::int as blue from t) group by gameid)
select sum(r*g*b) as part2 from red join green on red.gameid = green.gameid join blue on red.gameid = blue.gameid;
