#!/bin/csh -f
#  offline_entropy.cmd
#
#  UGE job for offline_entropy built Tue Aug  2 15:05:22 PDT 2016
#
#  The following items pertain to this script
#  Use current working directory
#$ -cwd
#  input           = /dev/null
#  output          = /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID
#$ -o /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID
#  error           = Merged with joblog
#$ -j y
#  The following items pertain to the user program
#  user program    = /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.m
#  arguments       = -m -R -singleCompThread -I common -I ecc
#  program input   = Specified by user program
#  program output  = Specified by user program
#  Resources requested
#
#$ -l h_data=5000M,h_rt=00:20:00
#
#  Name of application for log
#$ -v QQAPP=mcc
#  Email address to notify
#$ -M mgottsch@mail
#  Notify at beginning and end of job
#$ -m bea
#  Job is not rerunable
#$ -r n
#
# Initialization for serial execution
#
  unalias *
  set qqversion = 
  set qqapp     = "mcc serial"
  set qqidir    = /u/project/puneet/mgottsch/eccgrp-ecc-ctrl
  set qqjob     = offline_entropy
  set qqodir    = /u/project/puneet/mgottsch/eccgrp-ecc-ctrl
  cd     /u/project/puneet/mgottsch/eccgrp-ecc-ctrl
  source /u/local/bin/qq.sge/qr.runtime
  if ($status != 0) exit (1)
#
  echo "UGE job for offline_entropy built Tue Aug  2 15:05:22 PDT 2016"
  echo ""
  echo "  offline_entropy directory:"
  echo "    "/u/project/puneet/mgottsch/eccgrp-ecc-ctrl
  echo "  Submitted to UGE:"
  echo "    "$qqsubmit
  echo "  SCRATCH directory:"
  echo "    "$qqscratch
#
  echo ""
  echo "offline_entropy started on:   "` hostname -s `
  echo "offline_entropy started at:   "` date `
  echo ""
#
# Run the user program
#
  source /u/local/Modules/default/init/modules.csh	
  module load matlab
  setenv LM_LICENSE_FILE /u/local/licenses/license.matlab
  set path = ( $path /sbin )
#
  echo mcc offline_entropy.m -m -R -singleCompThread -I common -I ecc
requeue:
  /u/local/apps/matlab/8.6/bin/mcc offline_entropy.m -m -R -singleCompThread -I common -I ecc
  set rc = $status
#
# if( `grep -c 'Maximum number of users' /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID` > 0 || `grep -c 'License checkout failed' /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID` > 0 ) then
  if( `grep -c 'Maximum number of users' /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID` > 0 || `grep -c 'License checkout failed' /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID` > 0 || `grep -c 'Could not check out a Compiler license' /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID` > 0 ) then
    head -n 13 /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID > /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/.$$
    echo "------------ waiting for a license. retrying mcc command." >> /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/.$$
    sleep 90
    mv /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/.$$ /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID
    goto requeue
  endif
#
  echo ""
  if( $rc != 0 || ! -e /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy ) then
    echo ============================================================
    echo ERROR: mcc.queue failed with status $rc
    echo ============================================================
  endif
#
  echo ""
  echo "offline_entropy finished at:  "` date `
#
# Cleanup after serial execution
#
  source /u/local/bin/qq.sge/qr.runtime
#
  echo "-------- /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID --------" >> /u/local/apps/queue.logs/mcc.log.serial
 if (`wc -l /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID  | awk '{print $1}'` >= 1000) then
        head -50 /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID >> /u/local/apps/queue.logs/mcc.log.serial
        echo " "  >> /u/local/apps/queue.logs/mcc.log.serial
        tail -10 /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID >> /u/local/apps/queue.logs/mcc.log.serial
  else
        cat /u/project/puneet/mgottsch/eccgrp-ecc-ctrl/offline_entropy.joblog.$JOB_ID >> /u/local/apps/queue.logs/mcc.log.serial
  endif
  exit (0)
