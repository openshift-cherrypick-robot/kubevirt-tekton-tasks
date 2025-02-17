#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_DIR="$(realpath "${SCRIPT_DIR}/..")"

read -p "What is the name of the new task: " TASK_NAME

if ! echo "${TASK_NAME}" |  grep -qE "^[a-z-]+$"; then
  echo "Invalid name! Should comply with ^[a-z-]+$ regex" 1>&2
  exit 1
fi

read -p "What is the name of the env variable for this task: " TASK_ENV_VAR

if ! echo "${TASK_ENV_VAR}" |  grep -qE "^[A-Z_]+_IMAGE$"; then
  echo "Invalid env variable name! Should comply with ^[A-Z_]+_IMAGE$ regex" 1>&2
  exit 1
fi

read -p "Is it only OKD task? true/false: " ONLY_OKD

if ! echo "${ONLY_OKD}" |  grep -qE "^true$|^false$"; then
  echo "Invalid bool value! Should comply with ^true$|^false$ regex" 1>&2
  exit 1
fi

if ! grep -Fq "IMAGE_MODULE_NAME_TO_ENV_NAME[\"${TASK_NAME}\"]" "${SCRIPT_DIR}/common.sh"; then
echo "editing common.sh"
cat <<EOF >> "${SCRIPT_DIR}/common.sh"

export ${TASK_ENV_VAR}="\${${TASK_ENV_VAR}:-}"
IMAGE_MODULE_NAME_TO_ENV_NAME["${TASK_NAME}"]="${TASK_ENV_VAR}"
TASK_NAME_TO_IMAGE["${TASK_NAME}"]="\${${TASK_ENV_VAR}}"
EOF
fi

CONFIG_FILE="${REPO_DIR}/configs/${TASK_NAME}.yaml"

if [ ! -f "${CONFIG_FILE}" ]; then
echo "creating ${CONFIG_FILE}"
cat <<EOF > "${CONFIG_FILE}"
task_name: ${TASK_NAME}
task_category: ${TASK_NAME}
main_image: quay.io/kubevirt/tekton-task-${TASK_NAME}
EOF
fi

if [[ "${ONLY_OKD}" == "true" ]]; then
  echo "is_okd: true" >> "${CONFIG_FILE}"
fi

mkdir -p "${REPO_DIR}/modules/${TASK_NAME}"
mkdir -p "${REPO_DIR}/modules/${TASK_NAME}/build/${TASK_NAME}"

MAIN_TASK_DOCKERFILE="${REPO_DIR}/modules/${TASK_NAME}/build/${TASK_NAME}/Dockerfile"

if [ ! -f "${MAIN_TASK_DOCKERFILE}" ]; then
echo "creating ${MAIN_TASK_DOCKERFILE}"
cat <<EOF > "${MAIN_TASK_DOCKERFILE}"
FROM registry.access.redhat.com/ubi8/ubi-minimal AS builder
RUN microdnf install -y golang-1.16.* && microdnf clean all

FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
EOF
fi

echo
echo "Upon merging the task stub files, new image can be added to openshift/release CI with the following env variable: ${TASK_ENV_VAR}"
