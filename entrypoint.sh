#!/bin/bash
# Omits 'set -e' because short-circuiting this script fails the GitHub action unintentionally

FAIL=${FAIL_LEVEL:=ERROR}
MANAGE_PATH=${GITHUB_WORKSPACE}/${APP_PATH}
REQS=${GITHUB_WORKSPACE}/${DEP_PATH}

echo -e "Path to manage.py set as: " $MANAGE_PATH
echo -e "Requirements path set as: " $REQS

if [[ "$ENV_TYPE" == "venv" ]]; then
    pip install safety
    pip install -r $REQS
    cd $MANAGE_PATH && safety check -o output.txt
fi
if [[ -z "$ENV_TYPE" ]]; then
    echo "No virtual environment specified."
    pip install django
    cd $MANAGE_PATH && safety check -o output.txt
fi

echo -e "\n--------- Python Safety Check results ---------"
cat output.txt
