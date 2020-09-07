#!/bin/bash
# Omits 'set -e' because short-circuiting this script fails the GitHub action unintentionally

REQS=${GITHUB_WORKSPACE}/${DEP_PATH}
SAFETY_ARGS=${INPUT_SAFETY_ARGS}


echo -e "\n----------------- Variables -------------------"
echo -e "Requirements path: " $REQS
echo -e "Safety args: ${SAFETY_ARGS:-Not provided}"

echo -e "\n---------- Install pip requirements -----------"
echo -e "Call command: pip install safety"
pip install safety
echo -e "Call command: pip install -r ${REQS}"
pip install -r $REQS

echo -e "\n-------------- Do safety checks ---------------"
echo -e "Call command: safety check --short-report ${SAFETY_ARGS} &> output.txt"
safety check --short-report $SAFETY_ARGS &> output.txt
EXIT_CODE=$?

echo -e "\n--------- Python Safety Check results ---------"
echo -e "cat output.txt"
cat output.txt

if [ "$EXIT_CODE" -eq 0 ]; then
    exit 0
else
    exit 1
fi
