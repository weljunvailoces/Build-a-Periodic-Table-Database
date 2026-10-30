#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align"
element_data=$($PSQL -v search="$1" <<'SQL'
SELECT 'The element with atomic number ' || e.atomic_number || ' is ' || e.name ||
       ' (' || e.symbol || '). It''s a ' || t.type || ', with a mass of ' ||
       p.atomic_mass::text || ' amu. ' || e.name || ' has a melting point of ' ||
       p.melting_point_celsius::text || ' celsius and a boiling point of ' ||
       p.boiling_point_celsius::text || ' celsius.'
FROM elements AS e
JOIN properties AS p USING (atomic_number)
JOIN types AS t USING (type_id)
WHERE e.atomic_number::text = :'search'
   OR e.symbol = :'search'
   OR e.name = :'search';
SQL
)
if [[ -z "$element_data" ]]; then
  echo "I could not find that element in the database."
else
  printf '%s\n' "$element_data"
fi