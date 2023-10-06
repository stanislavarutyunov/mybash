#!/bin/bash

# Проверка настроек в файлах /etc/pam.d/login, /etc/login.defs, /etc/profile

login_file="/etc/pam.d/login"
login_defs_file="/etc/login.defs"
profile_file="/etc/profile"

expected_login_params="onerr=fail deny=10 unlock_time=1800"
expected_login_retries="10"
expected_login_timeout="1800"
expected_tmout="TMOUT=3600"

# Check if the login file exists
if [ ! -f $login_file ]; then
  echo "Login file not found"
  exit 1
fi

# Check if the login file contains the expected parameters
if grep -Fxq "$expected_login_params" $login_file; then
  echo "The login file contains the expected parameters"
else
  # Update the login file with the expected parameters
  echo "$expected_login_params" > $login_file
  echo "Updated the login file with the expected parameters"
  echo "Please check and validate the changes"
fi

# Check if the login.defs file exists
if [ ! -f $login_defs_file ]; then
  echo "login.defs file not found"
  exit 1
fi

# Check if the login.defs file contains the expected values
if grep -Fxq "LOGIN_RETRIES $expected_login_retries" $login_defs_file && grep -Fxq "LOGIN_TIMEOUT $expected_login_timeout" $login_defs_file; then
  echo "The login.defs file contains the expected values"
else
  # Update the login.defs file with the expected values
  sed -i "s/^LOGIN_RETRIES .*/LOGIN_RETRIES $expected_login_retries/" $login_defs_file
  sed -i "s/^LOGIN_TIMEOUT .*/LOGIN_TIMEOUT $expected_login_timeout/" $login_defs_file
  echo "Updated the login.defs file with the expected values"
  echo "Please check and validate the changes"
fi

# Check if the profile file exists
if [ ! -f $profile_file ]; then
  echo "Profile file not found"
  exit 1
fi

# Check if the profile file contains the expected line
if grep -q "$expected_tmout" $profile_file; then
  echo "The profile file contains the expected line"
else
  # Update the profile file with the expected line
  echo "$expected_tmout" >> $profile_file
  echo "Updated the profile file with the expected line"
  echo "Please check and validate the changes"
fi