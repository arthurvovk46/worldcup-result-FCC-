#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams;")

echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1;")

echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do

  if [[ $YEAR != year ]]
  then
    
    NAME1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER';")

    if [[ $NAME1 != $WINNER ]]
    then

      INSERT_TEAM_RESULT1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")

      if [[ $INSERT_TEAM_RESULT1 == 'INSERT 0 1' ]]
      then

        echo Inserted into teams, $WINNER

      fi

    fi
    
    NAME2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT';")

    if [[ $NAME2 != $OPPONENT ]]
    then

      INSERT_TEAM_RESULT2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")

      if [[ $INSERT_TEAM_RESULT2 == 'INSERT 0 1' ]]
      then

        echo Inserted into teams, $OPPONENT

      fi

    fi

    # if [[ 
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")

    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

    INSERT_YEAR_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WINNER_GOALS, $OPPONENT_GOALS);")

  fi
  
done