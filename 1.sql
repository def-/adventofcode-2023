--/.. 2>/dev/null; exec psql "postgres://materialize@localhost:6875/materialize" -f "$0"
create temporary table t (c text);
\copy t from '1.in' with (format csv);
select sum(left(r, 1)::int * 10 + right(r, 1)::int) as part1 from (select regexp_replace(c, '[^\d]', '', 'g') as r from t);
select sum(left(r, 1)::int * 10 + right(r, 1)::int) as part2 from (select regexp_replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(c, 'one', 'one1one'), 'two', 'two2two'), 'three', 'three3three'), 'four', 'four4four'), 'five', 'five5five'), 'six', 'six6six'), 'seven', 'seven7seven'), 'eight', 'eight8eight'), 'nine', 'nine9nine'), '[^\d]', '', 'g') as r from t);
