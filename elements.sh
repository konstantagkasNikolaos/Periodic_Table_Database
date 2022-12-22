#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# check input
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # check if number
  if ! [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'");
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1");
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
     echo "I could not find that element in the database."
  else
    echo $($PSQL "SELECT atomic_mass,melting_point_celsius,boiling_point_celsius,type,symbol,name FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE atomic_number=$ATOMIC_NUMBER") | while IFS="|" read ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE SYMBOL NAME 
      do 
        # trim results
        ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | xargs)
        ATOMIC_MASS=$(echo $ATOMIC_MASS | xargs)
        MELTING_POINT_CELSIUS=$(echo $MELTING_POINT_CELSIUS | xargs)
        BOILING_POINT_CELSIUS=$(echo $BOILING_POINT_CELSIUS | xargs)
        TYPE=$(echo $TYPE | xargs) 
        SYMBOL=$(echo $SYMBOL | xargs)
        NAME=$(echo $NAME | xargs)

        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
  fi
fi  
