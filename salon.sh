#! /bin/bash
PSQL="psql -t -A -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~ MY SALON ~~"
echo -e "\nWelcome to my salon, how can I help you?"

SERVICE_SELECTION() {
  if [[ $1 ]]; then
    echo -e "\n$1"
  fi
  echo -e "\n1) cut\n2) color\n3) perm"
  read SERVICE_ID_SELECTED
  if [[ $SERVICE_ID_SELECTED -ge 1 && $SERVICE_ID_SELECTED -le 3 ]]; then
    APPOINTMENT
  else
    SERVICE_SELECTION "I could not find that service. What would you like today?"
  fi
}

APPOINTMENT() {
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]; then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' AND phone='$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

SERVICE_SELECTION
