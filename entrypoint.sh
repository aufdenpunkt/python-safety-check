#!/bin/bash
# Omits 'set -e' because short-circuiting this script fails the GitHub action unintentionally

REQS=${GITHUB_WORKSPACE}/${DEP_PATH}
SAFETY_ARGS=${INPUT_SAFETY_ARGS}
USE_REQUIREMENTS_FILE_ONLY=${INPUT_USE_REQUIREMENTS_FILE_ONLY}

echo -e "\n----------------- Variables -------------------"
echo -e "Requirements path: " $REQS
echo -e "Use requirements only: " $USE_REQUIREMENTS_FILE_ONLY
echo -e "Safety args: ${SAFETY_ARGS:-Not provided}"

echo -e "\n------------ Install requirements -------------"
echo -e "Call command: pip install safety"
pip install safety

if [ "$USE_REQUIREMENTS_FILE_ONLY" -eq "false" ]; then
    echo -e "Call command: pip install -r ${REQS}"
    pip install -r $REQS
else
    SAFETY_ARGS="${SAFETY_ARGS} -r ${REQS}"
fi

echo -e "\n-------------- Do safety checks ---------------"
echo -e "Call command: safety check --short-report ${SAFETY_ARGS} &> output.txt"
safety check --short-report $SAFETY_ARGS &> output.txt
EXIT_CODE=$?

echo -e "\n--------- Python Safety Check results ---------"
echo -e "Call command: cat output.txt"
cat output.txt

if [ "$EXIT_CODE" -eq 0 ]; then
    echo -e "\nexit 0"
    exit 0
else
    echo -e "\nexit 1"
    exit 1
fi
