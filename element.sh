#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#if no argument exit
if [[ -z $1 ]]
then
echo "Please provide an element as an argument."
exit
fi

#functions
PROPS(){
    #get type
    #TYP=$($PSQL "SELECT type FROM properties WHERE atomic_number=$AT_NUM")
    TYP=$($PSQL "SELECT t.type FROM properties AS p INNER JOIN types AS t USING(type_id) WHERE p.atomic_number=$AT_NUM")
    #get mass
    MAS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$AT_NUM")
    #get melting_point
    MEL=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$AT_NUM")
    #get boiling_point
    BOI=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$AT_NUM")
    echo -e "The element with atomic number $AT_NUM is $ELEM_NAM ($SYM). It's a $TYP, with a mass of $MAS amu. $ELEM_NAM has a melting point of $MEL celsius and a boiling point of $BOI celsius." 
}

# entering arguments

# if arg is numberic integer
if [[ $1 =~ ^[0-9]+$ ]]
then
  # get atomic number for arg
  AT_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  # if atomic number does not exists in DB
  if [[ -z $AT_NUM ]]
  then
    echo "I could not find that element in the database."
    else 
    # get element name for arg
    ELEM_NAM=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
    # get symbol for arg
    SYM=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1") 
    # call func props
    PROPS
  fi
fi 
    
# if arg is a character length up to 2 for symbols
if [[ $1 =~ ^[A-Za-z]{1,2}$ ]]
then
  # get symbol for arg
  SYM=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
  # if symbol does not exists in DB
  if [[ -z $SYM ]]
  then
    echo "I could not find that element in the database."
  else
    # get atomic number for arg
    AT_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    # get element name for arg
    ELEM_NAM=$($PSQL "SELECT name FROM elements WHERE symbol='$1'") 
    # call func props
    PROPS
  fi    
fi

# if arg is a character length from 3 to ?
if [[ $1 =~ ^[A-Za-z]{3,}$ ]]
then
  # get element name for arg
  ELEM_NAM=$($PSQL "SELECT name FROM elements WHERE name='$1'")
  # if element name does not exist in DB
  if [[ -z $ELEM_NAM ]]
  then
    echo "I could not find that element in the database."
  else
  # get atomic number for arg
  AT_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
  # get symbol
  SYM=$($PSQL "SELECT symbol FROM elements WHERE name='$1'") 
  # call function props
  PROPS
  fi    
fi
