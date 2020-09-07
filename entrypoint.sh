#!/bin/bash
# Omits 'set -e' because short-circuiting this script fails the GitHub action unintentionally

REQS=${GITHUB_WORKSPACE}/${DEP_PATH}
SAFETY_ARGS=${INPUT_SAFETY_ARGS}
SCAN_REQUIREMENTS_FILE_ONLY=${INPUT_SCAN_REQUIREMENTS_FILE_ONLY}

echo -e "\n----------------- Variables -------------------"
echo -e "INFO: Requirements path ${REQS}"
echo -e "INFO: Scan requirements file only ${SCAN_REQUIREMENTS_FILE_ONLY}"
echo -e "INFO: Safety args ${SAFETY_ARGS:-Not provided}"

echo -e "\n------------ Install requirements -------------"
echo -e "INFO: Call command $ pip install safety"
pip install safety

if [ "$SCAN_REQUIREMENTS_FILE_ONLY" == "false" ]
then
    echo -e "INFO: Call command $ pip install -r ${REQS}"
    pip install -r $REQS
else
    echo -e "INFO: Skip installing python packages"
    SAFETY_ARGS="${SAFETY_ARGS} -r ${REQS}"
fi

echo -e "\n-------------- Do safety checks ---------------"
echo -e "INFO: Call command $ safety check --short-report ${SAFETY_ARGS} &> output.txt"
safety check --short-report $SAFETY_ARGS &> output.txt
EXIT_CODE=$?

echo -e "\n--------- Python Safety Check results ---------"
echo -e "INFO: Call command $ cat output.txt"
cat output.txt

if [ "$EXIT_CODE" -eq 0 ]
then
    echo -e "\nINFO: exit 0"
    exit 0
else
    echo -e "\nINFO: exit 1"
    exit 1
fi
