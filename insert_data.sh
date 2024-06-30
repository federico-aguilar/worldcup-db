#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi


tail -n +2 games.csv | while read p;
do
  IFS=',' read -r -a arr <<< "$p"

  echo "$($PSQL "INSERT INTO teams(name) VALUES ('${arr[2]}') ON CONFLICT (name) DO NOTHING")"
  winner_id="$($PSQL "SELECT team_id FROM teams WHERE name='${arr[2]}' ")"
  
  echo "$($PSQL "INSERT INTO teams(name) VALUES ('${arr[3]}') ON CONFLICT (name) DO NOTHING")"
  opponent_id="$($PSQL "SELECT team_id FROM teams WHERE name='${arr[3]}' ")"
  
  echo "$($PSQL "INSERT INTO 
  games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
  VALUES(${arr[0]}, '${arr[1]}', $winner_id, $opponent_id, ${arr[4]}, ${arr[5]})
  ")"
done
