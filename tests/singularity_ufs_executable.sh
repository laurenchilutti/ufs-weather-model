#!/bin/bash -x
. /etc/profile.d/01-locale-fix.sh
. /opt/intel/oneapi/setvars.sh
. /etc/profile.d/z10_spack_environment.sh


./fv3.exe
