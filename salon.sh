#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

CUSTOMER_NAME=""
CUSTOMER_PHONE=""
D_SERVICE=$($PSQL "select service_id, name from services order by service_id")

CREATE_APPT(){
  S_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  C_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  C_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  S_NAME_FORMAT=$(echo -E $S_NAME | sed 's/\s//g')
  C_NAME_FORMAT=$(echo -E $C_NAME | sed 's/\s//g')
  echo -e "\nWhat time would you like your $S_NAME_FORMAT, $C_NAME_FORMAT?"
  read SERVICE_TIME
  T_INSERT=$($PSQL "insert into appointments(customer_id, service_id, time) values($C_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $S_NAME_FORMAT at $SERVICE_TIME, $C_NAME_FORMAT."
}

SALON_MENU(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  GOT_CUSTOM=$($PSQL "select customer_id, name from customers where phone='$CUSTOMER_PHONE'")

  if [[ -z $GOT_CUSTOM ]]
  then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  C_INSERT=$($PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  
  
  CREATE_APPT
  else

  CREATE_APPT

  fi
  }


L_SERVICE(){
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi

  echo "$D_SERVICE" | while read SERVICE_ID BAR NAME
  do
  echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
   L_SERVICE "I could not find that service. What would you like today?"
  else

  AV_SERVICE=$($PSQL "select service_id, name from services where service_id=$SERVICE_ID_SELECTED")

  if [[ -z $AV_SERVICE ]]
  then
  L_SERVICE "I could not find that service. What would you like today?"
  else
  SALON_MENU
    fi
  fi
}

L_SERVICE
