#!/bin/bash

DEBUG="${INPUT_DEBUG}"

if [[ "$DEBUG" == "true" ]]; then
  set -x
fi

mkdir -p /root/.ssh
echo "${INPUT_DST_KEY}" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa

eval "$(ssh-agent -s)"
ssh-add - <<< "${INPUT_SSH_PRIVATE_KEY}"
ssh -T git@github.com

pip3 install -r /hub-mirror/requirements.txt

python3 /hub-mirror/hubmirror.py --src "${INPUT_SRC}" --dst "${INPUT_DST}" \
--dst-token "${INPUT_DST_TOKEN}" \
--account-type "${INPUT_ACCOUNT_TYPE}" \
--src-account-type "${INPUT_SRC_ACCOUNT_TYPE}" \
--dst-account-type "${INPUT_DST_ACCOUNT_TYPE}" \
--clone-style "${INPUT_CLONE_STYLE}" \
--cache-path "${INPUT_CACHE_PATH}" \
--black-list "${INPUT_BLACK_LIST}" \
--white-list "${INPUT_WHITE_LIST}" \
--static-list "${INPUT_STATIC_LIST}" \
--force-update "${INPUT_FORCE_UPDATE}" \
--debug "${INPUT_DEBUG}" \
--timeout  "${INPUT_TIMEOUT}" \
--mappings  "${INPUT_MAPPINGS}"


# Skip original code
exit $?
