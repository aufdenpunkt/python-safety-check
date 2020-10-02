#!/bin/bash
# Omits 'set -e' because short-circuiting this script fails the GitHub action unintentionally

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_OFF='\033[0m'

REQS=${GITHUB_WORKSPACE}/${DEP_PATH}
SAFETY_ARGS=${INPUT_SAFETY_ARGS}
SCAN_REQUIREMENTS_FILE_ONLY=${INPUT_SCAN_REQUIREMENTS_FILE_ONLY}

echo -e "\n----------------- Variables -------------------"
echo -e "${COLOR_YELLOW}INFO${COLOR_OFF} Requirements path: ${REQS}"
echo -e "${COLOR_YELLOW}INFO${COLOR_OFF} Scan requirements file only: ${SCAN_REQUIREMENTS_FILE_ONLY}"
echo -e "${COLOR_YELLOW}INFO${COLOR_OFF} Safety args: ${SAFETY_ARGS:-Not provided}"

echo -e "\n------------ Install requirements -------------"
if [ "$SCAN_REQUIREMENTS_FILE_ONLY" == "false" ]
then
    echo -e "${COLOR_YELLOW}INFO${COLOR_OFF} Call command: pip install -r ${REQS}"
    pip install -r $REQS
else
    echo -e "${COLOR_YELLOW}INFO${COLOR_OFF} Skip installing python packages"
    SAFETY_ARGS="${SAFETY_ARGS} -r ${REQS}"
fi

echo -e "\n-------------- Do safety checks ---------------"
echo -e "${COLOR_YELLOW}INFO${COLOR_OFF} Call command: safety check --short-report ${SAFETY_ARGS} &> output.txt"
safety check --short-report $SAFETY_ARGS &> output.txt
EXIT_CODE=$?

echo -e "\n--------- Python Safety Check results ---------"
echo -e "${COLOR_YELLOW}INFO${COLOR_OFF} Call command: cat output.txt"
cat output.txt

if [ "$EXIT_CODE" -eq 0 ]
then
    echo -e "\n${COLOR_GREEN}SUCCESS${COLOR_OFF} exit 0"
    exit 0
else
    echo -e "\n${COLOR_RED}ERROR${COLOR_OFF} exit ${EXIT_CODE}"
    exit 1
fi
