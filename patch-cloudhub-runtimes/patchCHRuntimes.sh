

#!/bin/bash

Help()
{
   # Display Help
   echo "The script will apply the latest available patch to the applications"
   echo
   echo "Syntax: ./patchCHRuntimes.sh <username> <password> <organizationId> <environment> "
   echo "parameters:"
   echo "username           Anypoint User Username"
   echo "password           Anypoint User Password"
   echo "organizationId     Anypoint Business Group ID"
   echo "environment        Cloudhub Environment Name"
   echo
}

#----- Intro
echo
tput rev
echo "| (\_/)  P A T C H    C L O U D H U B   R U N T I M E S                    |"
echo "| /   \                                                                    |"
tput sgr0

accountAPI=https://anypoint.mulesoft.com/accounts
cloudhubAPI=https://anypoint.mulesoft.com/cloudhub

####################
# Parameters section
####################

#----- Set username
if [[ -z $1 ]] ; then
    echo
    echo 'Error: Missed <username>'
    echo
    Help
    exit 1
else
   username=$1
fi

#----- Set password
if [[ -z $2 ]] ; then
    echo
    echo "Error: Missed <password>"
    echo
    Help
    exit 1
else
   password=$2
fi

#----- Set environment
if [[ -z $3 ]] ; then
    echo
    echo 'Error: Missed <organizationId>'
    echo
    Help
    exit 1
else
   orgId=$3
fi

#----- Set environment
if [[ -z $4 ]] ; then
    echo
    echo 'Error: Missed <environment>'
    echo
    Help
    exit 1
else
   envName=$4
fi


####################
# Start Execution
####################

# Authenticate with user credentials (Note the APIs will NOT authorize for tokens received from the OAuth call. A user credentials is essential)
echo "... Getting access token from $accountAPI/login..."
accessToken=$(curl -s $accountAPI/login -X POST -d "username=$username&password=$password" | jq --raw-output .access_token)

echo

# Pull env id from matching env name
echo " ... Getting env ID from $accountAPI/api/organizations/$orgId/environments..."
jqParam=".data[] | select(.name==\"$envName\").id"
envId=$(curl -s $accountAPI/api/organizations/$orgId/environments -H "Authorization:Bearer $accessToken" | jq --raw-output "$jqParam")

# Get the list of applications to patch
echo
echo "... Getting the list of cloudhub applications in the environment: $envName"
applications=$(curl -s --location -X GET $cloudhubAPI/api/v2/applications/ -H "Authorization: Bearer $accessToken" -H "X-ANYPNT-ORG-ID: $orgId" -H "X-ANYPNT-ENV-ID: $envId" | jq '[.[].domain]')

# Print the list of applications to patch
echo
echo "... The latest runtime pacth will be applied to the applications:"
jq . <<< $applications 
echo

# Patch the applications
echo "... Starting applications runtime update "
curl -s -X PUT $cloudhubAPI/api/v2/applications/ -H "Authorization: Bearer $accessToken" -H "X-ANYPNT-ENV-ID: $envId" -H "Content-Type: application/json" -d "{ \"action\": \"UPDATE\", \"domains\": ${applications}}"
echo "... Applications runtimes patch started."
echo "... Please check Anypont Runtime Manager to see the progress ..."

echo
tput rev
echo "|                          C O M P L E T E D                               |"
tput sgr0

