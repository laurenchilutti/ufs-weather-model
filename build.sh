#!/bin/bash
set -eu

if [[ $(uname -s) == Darwin ]]; then
  readonly UFS_MODEL_DIR=$(cd "$(dirname "$(greadlink -f -n "${BASH_SOURCE[0]}" )" )" && pwd -P)
else
  readonly UFS_MODEL_DIR=$(cd "$(dirname "$(readlink -f -n "${BASH_SOURCE[0]}" )" )" && pwd -P)
fi

export CC=mpiicc
export CXX=mpiicpc
export FC=mpiifort

export ESMFMKFILE=${ESMFMKFILE:?"Please set ESMFMKFILE environment variable"}

BUILD_DIR=${BUILD_DIR:-${UFS_MODEL_DIR}/build}
mkdir -p ${BUILD_DIR}

[[ -n "${MAPL_ROOT:-""}" ]] && CMAKE_FLAGS+=" -DCMAKE_MODULE_PATH=${MAPL_ROOT}/share/MAPL/cmake"

cd ${BUILD_DIR}
echo ${UFS_MODEL_DIR}
echo ${CMAKE_FLAGS}
export SINGULARITYENV_CC=${CC}
export SINGULARITYENV_CXX=${CXX}
export SINGULARITYENV_FC=${FC}
export SINGULARITYENV_UFS_MODEL_DIR=${UFS_MODEL_DIR}
export SINGULARITYENV_CMAKE_FLAGS=${CMAKE_FLAGS}
#export SINGULARITYENV_ESMFMKFILE=${ESMFMKFILE}

#singularity exec -B ${DEV}/gfdl/${USER},${SCRATCH}/gfdl/${USER},${PDATA} ${DEV}/gfdl/Thomas.Robinson/containers/environment_container_intel2021.4.sif cmake ${UFS_MODEL_DIR} ${CMAKE_FLAGS}

singularity exec -B ${PDATA},${DEV}/gfdl/${USER},${SCRATCH}/gfdl/${USER} /lustre/f2/dev/gfdl/Thomas.Robinson/containers/environment_container_intel2021.4.sif /lustre/f2/dev/gfdl/Lauren.Chilutti/ufs-weather-model/tests/singularity_compile_ufs_cmail.sh
#singularity exec -B ${PDATA},${DEV}/gfdl/${USER},${SCRATCH}/gfdl/${USER},/lustre/f2/dev/gfdl/Thomas.Robinson/containers  /lustre/f2/dev/gfdl/Thomas.Robinson/containers/intel2021.2_netcdfc4.7.4_ubuntu.sif /lustre/f2/dev/gfdl/Thomas.Robinson/containers/ufs/singularity_compile_ufs_cmail.sh
# Turn off OpenMP threading for parallel builds
# to avoid exhausting the number of user processes
#OMP_NUM_THREADS=1 make -j ${BUILD_JOBS:-4} VERBOSE=${BUILD_VERBOSE:-}
export BUILD_JOB_NUMBER=${BUILD_JOBS:-4}
export VERBOSE_VAR=${BUILD_VERBOSE:-}
export SINGULARITYENV_VERBOSE=${VERBOSE_VAR}
export SINGULARITYENV_BUILD_JOBS=${BUILD_JOB_NUMBER}
singularity exec -B ${PDATA},${DEV}/gfdl/${USER},${SCRATCH}/gfdl/${USER} /lustre/f2/dev/gfdl/Thomas.Robinson/containers/environment_container_intel2021.4.sif /lustre/f2/dev/gfdl/Lauren.Chilutti/ufs-weather-model/tests/singularity_compile_ufs_make.sh
