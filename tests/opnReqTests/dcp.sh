set -eu
source $PATHRT/opnReqTests/std.sh

if [[ $application == 'global' ]]; then
  if [[ $CI_TEST == 'true' ]]; then
    temp=$INPES
    INPES=$JNPES
    JNPES=$temp
  else
    INPES=6
    JNPES=4
  fi
elif [[ $application == 'regional' ]]; then
  if [[ $CI_TEST == 'true' ]]; then
    INPES=10
    JNPES=3
    TASKS=$((INPES*JNPES))
    NODES=$(((TASKS+TPN-1)/TPN))
  else
    INPES=5
    JNPES=12
  fi
elif [[ $application == 'cpld' ]]; then
  if [[ $CI_TEST == 'true' ]]; then
    INPES=3
    JNPES=1
    NPROC_ICE=6
    med_petlist_bounds="0 17"
    atm_petlist_bounds="0 23"
    ocn_petlist_bounds="24 33"
    ice_petlist_bounds="34 39"
    TASKS=$((INPES*JNPES*6 + WRITE_GROUP*WRTTASK_PER_GROUP + 10 + 6))
  else
    temp=$INPES
    INPES=$JNPES
    JNPES=$temp
  fi
fi

(test $CI_TEST == 'true') && source $PATHRT/opnReqTests/cmp_proc_bind.sh
source $PATHRT/opnReqTests/wrt_env.sh
