#!/bin/bash -x
. /etc/profile.d/01-locale-fix.sh
. /opt/intel/oneapi/setvars.sh
. /etc/profile.d/z10_spack_environment.sh



#export UFS_MODEL_DIR=/lustre/f2/dev/gfdl/Lauren.Chilutti/ufs-weather-model

#export CMAKE_FLAGS="-DAPP=ATM -DCCPP_SUITES=FV3_GFS_v16,FV3_GFS_v15_thompson_mynn,FV3_GFS_v15_thompson_mynn_RRTMGP,FV3_GSD_v0,FV3_RAP,FV3_HRRR,FV3_RRFS_v1beta,FV3_RRFS_v1alpha,FV3_GFS_v16_nsstNoahmpUGWPv1 -D32BIT=ON -DMPI=ON -DCMAKE_BUILD_TYPE=Release"



cmake ${UFS_MODEL_DIR} ${CMAKE_FLAGS}

