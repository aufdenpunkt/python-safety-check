#!/bin/bash
# Omits 'set -e' because short-circuiting this script fails the GitHub action unintentionally

REQS=${GITHUB_WORKSPACE}/${DEP_PATH}
SAFETY_ARGS=${INPUT_SAFETY_ARGS}

echo -e "Requirements path set as: " $REQS
echo -e "Safety args set as: " $SAFETY_ARGS

echo -e "\n---------- Install pip requirements -----------"
pip install safety
pip install -r $REQS

echo -e "\n-------------- Do safety checks ---------------"
safety check --short-report $SAFETY_ARGS &> output.txt
EXIT_CODE=$?

echo -e "\n--------- Python Safety Check results ---------"
cat output.txt

if [ "$EXIT_CODE" -eq 0 ]; then
    exit 0
else
    exit 1
fi
