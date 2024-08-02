#!/bin/bash

filename=$(basename "${0}")

PYTHON_VERSION=12
if [ -n "${1}" ]; then
    PYTHON_VERSION=${1}
fi

cmd="python${PYTHON_VERSION}"

if command -v "${cmd}"; then
    echo "${filename}: Python not found at: ${res}"
    exit 1
fi

python -m venv ./venv

source ./venv/bin/activate

python -m pip install -q -r ./requirements.txt

res=$?

if [ ${res} -ne 0 ]; then
    echo "${filename}: Failed to install requirements."
    exit 1
fi

echo "${filename}: Success. Venv installed to $(pwd)/venv."
exit 0
