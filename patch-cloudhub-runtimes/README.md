# CloudHub Runtime Patcher

This script will apply the latest available patch to all application runtimes in an specified environment.

Before running this script, make sure that [CURL](https://curl.haxx.se/) and [jq](https://stedolan.github.io/jq/) are installed.


## Usage

Run this script providing all parameters:

```shell
./patchCHRuntimes.sh <username> <password> <organizationId> <environment> 
```

### Parameters

| Name           | Description                 |
| -------------- | --------------------------- |
| username       | Anypoint's Username         |
| password       | Anypoint's Password         |
| organizationId | Anypoint's Business Group ID|
| environment    | CloudHub's Environment Name |
