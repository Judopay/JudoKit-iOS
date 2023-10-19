function info {
  echo "[$(basename "${0}")] [INFO] ${1}"
}

function error {
  echo "[$(basename "${0}")] [ERROR] ${1}"
  exit 1
}
