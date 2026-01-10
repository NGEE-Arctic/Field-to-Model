#!/bin/bash
# =======================================================================================
# re-run an ELM case for an NGEE Arctic site
#
#
# Phase 3 availible site names: kougarok, teller, council, beo
# Phase 4 additional sites: Toolik_Lake, Abisko, Trail_Valley_Creek, Samoylov_Island, Bayelva
# =======================================================================================
set -euo pipefail
# Print out options and help statements
Help()
{
    echo "Usage: $(basename $0) [-h|--help] [additional options]"
    echo "Options:"
    echo "  -h, --help                Display this help message"
    echo "  --site_name               Which NGEE site would you like to run? Available options:"
    echo "                            Phase 3 sites: kougarok, teller, council, beo"
    echo "                            Phase 4 sites: abisko, trail_valley_creek, toolik_lake,"
    echo "                              samoylov_island, bayelva"
    echo "  --site_group              OLMT allows different site groups to be specified - for the "
    echo "                              workshop this will always be NGEE-Arctic"
    echo "  --case_prefix             What should be appended to the beginning of the casename to distinguish"
    echo "                              between two runs at the same site?"
    echo "  -ms, --met_source         Select which meteorological forcing you would like to use. ERA5 or GSWP3 (Default: era5, Otherwise: gswp3)"
    echo "  --case_dirs               full path to an already setup and built case, under which --case_name can be found"
    echo "                            NOTE: if blanket, will be generated from --site_name, site_group, case_prefix, met_source"
    echo "  --case_name               full name of an already setup and built case, usually also a directory under --case_dir"
    echo "                            NOTE: if blanket, will be generated from --site_name, site_group, case_prefix, met_source"
    echo "  --continue_run_yrs        How many years to continue run of the case? (Default: 10)"
    echo "  -finit, --init_ncfile     a full name of initial netcdf file. "
    echo "                            Full path/file starting with /, otherwise under --restart_path. "
    echo "                            (Default: -, i.e. as what already setup in case_dirs/case_name)"
    echo "  --rest_yrs                How often (years) to produce restart files? (Default: -1, i.e. as what already setup)"
    echo "  --run_type                RUN_TYPE (Default: startup. Valid: startup, branch, hybrid, restart)"
    echo "  --restart_path            full path to restart case, in which restart data/files can be found"
    echo "  --restart_case            restart case name"
    echo "  --restart_date            restart date/time"
    echo "  --merged_ncfile           user-provided file name for TR20 hists merged"
    echo "                            (Default:blanketed. Example: --merged_ncfile=MasterE3SM_subgrid.out.nc "
    echo "  --user_namelist           user-provided additional ELM namelist to re-run a case"
    echo "                            (in comma-separated string double-quotated, e.g. "
    echo "                             topounit, topounit_atm_downscaling, topounit_IM2 or use_IM2_hillslope_hydrology)"
    exit 0
}

cwd=$(pwd)
cd /home/modex_user/tools/

# =======================================================================================
# Get the input options from the command line
for i in "$@"
do
case $i in
    -h|--help)
    Help
    shift
    ;;
    --site_name=*)
    site_name="${i#*=}"
    site_name="${site_name,,}"
    shift
    ;;
    --site_group=*)
    site_group="${i#*=}"
    shift 
    ;;
    --case_prefix=*)
    case_prefix="${i#*=}"
    shift
    ;;
    -ms=*|--met_source=*)
    met_source="${i#*=}"
    shift
    ;;
    --case_dirs=*)
    case_dirs="${i#*=}"
    shift
    ;;
    --case_case=*)
    case_case="${i#*=}"
    shift
    ;;
    --continue_run_yrs=*)
    stop_years="${i#*=}"
    shift
    ;;
    --rest_yrs=*)
    rest_years="${i#*=}"
    shift
    ;;
    --run_type=*)
    run_type="${i#*=}"
    shift
    ;;
    -finit=*|--init_ncfile=*)       # full-path and file name, starting with /; otherwise under --restart_path
    ncfile_init="${i#*=}"
    shift
    ;;
    -rest_path=*|--restart_path=*)  # must be full-path
    restart_path="${i#*=}"
    shift
    ;;
    -rest_case=*|--restart_case=*)  # case name of restart file
    restart_case="${i#*=}"
    shift
    ;;
    -rest_date=*|--restart_date=*)  # YYYY-MM-DD
    restart_date="${i#*=}"
    shift
    ;;
    --user_namelist=*)  # in format,e.g. topounit, topounit_atm_downscaling, topounit_IM2, or exactly ELM namelist if you know
    user_namelist="${i#*=}"
    shift
    ;;
    --merged_ncfile=*)
    merged_ncfile="${i#*=}"
    shift
    ;;
    *)
        # unknown option
    ;;
esac
done
# =======================================================================================

# =======================================================================================

# Set defaults and print the selected options back to the screen before running
site_name="${site_name:-council}"
site_group="${site_group:-NGEEArctic}"
case_prefix="${case_prefix:-topounit}"
case_dirs="${case_dirs:-/mnt/output/cime_case_dirs}"
case_name="${case_name:-topounit_gswp3_AK-SP-CL71_ICB20TRCNPRDCTCBC}"
stop_years="${stop_years:-10}"
rest_years="${rest_years:--1}"
ncfile_init="${ncfile_init:-' '}"
run_type="${run_type:-startup}"
options="${options:-}"

# restart reference path and case
restart_path="${restart_path:-/mnt/inputdata/E3SM/lnd/clm2/inidata/council/}"
restart_case="${restart_case:-topounit_gswp3_AK-SP-CL71_ICB20TRCNPRDCTCBC}"
restart_date="${restart_date:-2005-01-01}"

# user provided additional namelist
user_namelist="${user_namelist:-""}"

merged_ncfile="${merged_ncfile:-""}"

# =======================================================================================

# =======================================================================================
# Set site codes
if [ ${site_name} = beo ]; then
  site_code="AK-BEOG"
elif [ ${site_name} = council ]; then
  site_code="AK-SP-CL71"
elif [ ${site_name} = kougarok ]; then
  site_code="AK-SP-K64G"
elif [ ${site_name} = teller ]; then
  site_code="AK-SP-T27"
elif [ ${site_name} = toolik_lake ]; then
  site_code="AK-TFS"
elif [ ${site_name} = trail_valley_creek ]; then
  site_code="CA-TVC"
elif [ ${site_name} = abisko ]; then
  site_code="SE-ASRS"
elif [ ${site_name} = bayelva ]; then
  site_code="NO-BS"
elif [ ${site_name} = samoylov_island ]; then
  site_code="RU-SI"
elif [ ${site_name} = upper_kuparuk ]; then
  site_code="AK-TFS-UPK"
elif [ ${site_name} = imnaviat_creek ]; then
  site_code="AK-TFS-IMC"
else
  echo " "
  echo "**** EXECUTION HALTED ****"
  echo "Please select a Site Name from:"
  echo "ALASKA: beo, council, kougarok, teller, toolik_lake, imnaviat_creek, upper_kuparuk"
  echo "CANADA: trail_valley_creek"
  echo "SWEDEN: abisko"
  echo "NORWAY/SVALBARD: bayelva" 
  echo "RUSSIA: samoylov_island"
  exit 0
fi

# building case_dirs and case_name if needed (e.g. case_dirs, case_name are both blanketed)
if [[ "${case_dirs}" = "" || "${case_name}" = "" ]]; then
  case_prefix = ${case_prefix}_${met_source}
  case_dirs = /mnt/output/cime_case_dirs
  case_name = ${case_prefix}_${site_code}_ICB20TRCNPRDCTCBC # TR20 compset assumed
fi

# =======================================================================================
# print back selected or set options to the user
echo " "
echo " "
echo "*************************** ELM case re-run options ***************************"
echo "Case root dir = ${case_dirs}"
echo "Case name = ${case_name}"
echo "RUN_TYPE = ${run_type}"
if [ ${run_type} = "branch" ]; then
echo "Restart ref path = ${restart_path}"
echo "Restart ref case name = ${restart_case}"
echo "Restart ref case date = ${restart_date}"
fi
echo "Number of Continue Simulation Years = ${stop_years}"
echo "frequency of restart file saving (Years) = ${rest_years}"

if ! [ "${user_namelist}" = " " ]; then
  echo "Additional namelist = ${user_namelist}"
fi

echo " "
# =======================================================================================

# =======================================================================================
# pause to show options before continuing
sleep 10
echo " "
echo " "
# =======================================================================================

# =======================================================================================

# explicitly make the two output directories, 
# else these will be placed in /E3SM/root
mkdir -p /mnt/output/cime_case_dirs 
mkdir -p /mnt/output/cime_run_dirs

# =======================================================================================

# go to case directory
cd ${case_dirs}/${case_name}
case_run_dir=$(./xmlquery --value RUNDIR)

case_elm_bldnml=$(./xmlquery --value ELM_BLDNML_OPTS)
echo "case ELM_BLDNML_OPTS: "${case_elm_bldnml}
    
if [ ${run_type} = "restart" ]; then
  # no matter what RUN_TYPE (startup, branch, or hybrid)

  #cp ${restart_path}/* ${case_run_dir}/
  ./xmlchange CONTINUE_RUN=TRUE


# branch run, if restart_path and files are there
elif [ ${run_type} = "branch" ]; then
  if [[ -f ${restart_path}/rpointer.lnd && -f ${restart_path}/rpointer.drv ]]; then
    # 'restart' data packages, usually include:
    #         rpointer.lnd, rpointer.drv, rpointer.datm (rpointer.atm) (optional)
    #         *.elm.r.yyyy-mm-dd-todss.nc, *.cpl.r.yyyy-mm-dd-todss.nc
    #         *.elm.rh0.yyyy-mm-dd-todss.nc, *.elm.h0.yyyy-mm-dd-todss.nc
    # but here, we only check if 2 rpointer.* exist.
    
    ./xmlchange RUN_TYPE=branch
    ./xmlchange RUN_REFDIR=${restart_path}
    ./xmlchange RUN_REFCASE=${restart_case}
    ./xmlchange RUN_REFDATE=${restart_date}
    ./xmlchange GET_REFCASE=TRUE
 
    ./xmlchange CONTINUE_RUN=FALSE
 
    # a possible bug: finidat already in user_nl_elm
    #if [ ! ${ncfile_init} = " " ]; then
    #  echo "
    #      finidat = '${ncfile_init}'
    #  ">>user_nl_elm
    #fi
  
  else
    echo "NO REFCASE for branch type run!"
    exit
  fi

else
  echo " re-run from begining! "
  
  # make sure continue run is off
  ./xmlchange CONTINUE_RUN=FALSE
fi

# example adding of output list and flag
case_continue_run=$(./xmlquery --value CONTINUE_RUN)
echo "CONINUE_RUN: "${case_continue_run}
echo "re-run type: "${run_type}
subgrid_hid=" "
if ! [[ "${run_type}" = "restart" || "${case_continue_run}" = "TRUE" ]]; then
  # additional outputs, non-grid-aggregated, by adding namelist into user_nl_elm
  # NOTE: this can only be done with a fresh run
  if grep -q "hist_fincl1" "user_nl_elm" || ! grep -q "hist_empty_htapes" "user_nl_elm"; then
    echo "
      hist_fincl2 = 'SOILWATER_10CM','GPP','CH4PROD','QRUNOFF','FINUNDATED','FH2OSFC','H2OSFC'
      hist_dov2xy = .true.,.false.
    ">>user_nl_elm
    echo " Adding output var list or flag as hist_fincl2! "
    subgrid_hid="h1"
    rm -f ${case_run_dir}/*.elm.${subgrid_hid}.*.nc

  elif grep -q "hist_empty_htapes" "user_nl_elm"; then
    echo "
      hist_fincl1 = 'SOILWATER_10CM','GPP','CH4PROD','QRUNOFF','FINUNDATED','FH2OSFC','H2OSFC'
      hist_dov2xy = .false.
    ">>user_nl_elm
  
    echo " Adding output var list or flag as hist_fincl1! "
    subgrid_hid="h0"
    rm -f ${case_run_dir}/*.elm.${subgrid_hid}.*.nc

  fi
fi

#
if [[ $stop_years -gt 0 ]]; then
  echo "changing STOP_N to "$((stop_years+0))
  ./xmlchange STOP_N=$((stop_years))
  # pass as integer. ${stop_year} is a string
fi
# the following arithmatic operation is preferred. But the above style is good too.
if ((rest_years > 0)); then
  echo "changing RESt_N to "$((rest_years+0))
  ./xmlchange REST_N=$((rest_years))
fi

# namelist if provided by a string, separated by comma.
if ! [ "${user_namelist}" = " " ]; then
    
  # the following is hard-weired now, because OLMT cannot setup a case with surfdata of topounit only
  # any namelist string, starting with 'topounit'
  if [[ "${user_namelist}" == "topounit"* ]]; then
      # since topounit included surfdata separates 17 natpfts into 15 natpfts and 2 generic cfts
      # 'create_crop_landunit' must set to .true.
      if grep -q "create_crop_landunit" "user_nl_elm"; then
        echo " "
      else
        echo " create_crop_landunit = .true. " >>user_nl_elm
      fi
      
      # setting namelist: use_atmdownscaling_to_topounit, which is actually configured by ELM_BLDNML_OPTS '-topounit'
      if [[ "${user_namelist}" == *"topounit_atm_downscaling"* ]]; then
        #adding -topounit to ELM_NML_OPTS, if not there
        if ! [[ "${case_elm_bldnml}" == *" -topounit"* ]]; then
          echo "appending? "
          ./xmlchange --append --id ELM_BLDNML_OPTS --val " -topounit"
        fi
      else
        #remove -topounit from ELM_NML_OPTS, if in there already
        if [[ ${case_elm_bldnml} == *" -topounit"* ]]; then
          echo "removing? "
          case_elm_bldnml=${case_elm_bldnml//" -topounit"/}
          echo "new: "${case_elm_bldnml}
          ./xmlchange ELM_BLDNML_OPTS="${case_elm_bldnml}"
        fi
      fi
      
      echo "topounit changed case ELM_BLDNML_OPTS: "$(./xmlquery --value ELM_BLDNML_OPTS)
  fi
  # setting namelist: use_IM2_hillslope_hydrology (in user_nl_elm)
  if [[ "${user_namelist}" == *"use_IM2_hillslope_hydrology"* || "${user_namelist}" == *"topounit_IM2"* ]]; then
      # since topounit included surfdata separates 17 natpfts into 15 natpfts and 2 generic cfts
      # 'create_crop_landunit' must set to .true.
      if grep -q "create_crop_landunit" "user_nl_elm"; then
        echo " INFO: topounit included surfdata is used already! "
      else
        echo " create_crop_landunit = .true. " >>user_nl_elm
      fi

      if grep -q "use_IM2_hillslope_hydrology" "user_nl_elm"; then
        echo " INFO: use_IM2_hillslope_hydrology is True already!"
      else
        echo " use_IM2_hillslope_hydrology = .true. " >>user_nl_elm
      fi
  fi
  
  # expert-level namelist adding (exactly namelist) (TODO)
  
fi

# if not yet built (TODO)
# ./case.build

# submit model run
./case.submit


# =======================================================================================
#### Postprocess
### Collapse transient simulation output into a single netCDF file
echo " "
echo " "
echo " "
echo "**** Postprocessing ELM output in: "
echo "${case_run_dir}"
echo " "
echo " "

# note: we may only need to ncrcat TR20 run outputs

# can do better to get RUN_DIR for the following line (TODO)
cd ${case_run_dir}

echo "**** Concatenating netCDF output - Hang tight this can take awhile ****"

if [ ! ${subgrid_hid} = " " ]; then
  echo "subgrid/patch output files: elm.${subgrid_hid}"
  ncrcat --ovr *.elm.${subgrid_hid}.*.nc ELM_output_PFT.nc
  chmod 666 ELM_output_PFT.nc
  # rename merged output files for convenience
  if [ ! ${merged_ncfile} = " " ]; then
    mv ELM_output_PFT.nc ${merged_ncfile}
  fi
fi

ncrcat --ovr *.h0.*.nc ELM_output.nc
chmod 666 ELM_output.nc

echo "**** Concatenating netCDF output: DONE ****"
sleep 2
# =======================================================================================

cd ${cwd}
