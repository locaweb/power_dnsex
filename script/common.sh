function power_dnsex_env {
  local envs=$(env | egrep '^POWER_DNSEX_' | sed 's/^/ -e /')
  local test_env=$( [[ -n "${BUILD_TAG}" ]] && printf " -e MIX_ENV=test" )
  printf "%s " "$envs $test_env" | xargs printf " %s"
}

export WORKDIR="$(dirname "${BASH_SOURCE[0]}")/.."
export DOCKER_COMPOSE="docker-compose -f $WORKDIR/docker-compose.yml"
