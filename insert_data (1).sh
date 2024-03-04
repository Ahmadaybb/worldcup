#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE teams, games;"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
    if [[ $YEAR != 'year' ]]; then
      
        WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
        OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
        
      
        if [[ -z $WINNER_ID ]]; then
           i="$( $PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")"
            if [[ $i == "INSERT 0 1" ]]
  then 
  echo " $WINNER"
  fi
            WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
        fi
        if [[ -z $OPPONENT_ID ]]; then
           J="$( $PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")"
            if [[ $J == "INSERT 0 1" ]]
  then 
  echo " $OPPONENT"
  fi
            
            OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
        
        fi
        
        INSERT_RESULT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")"
        
    
        if [[ $INSERT_RESULT == *"INSERT 0 1"* ]]; then
            echo "Inserted game for year $YEAR"
        else
            echo "Failed to insert game for year $YEAR"
        fi
    fi
done