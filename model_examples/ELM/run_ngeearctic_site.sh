#!/bin/bash
# =======================================================================================
# Setup and run an ELM OLMT simulation for an NGEE Arctic site
#
#
# Phase 3 availible site names: kougarok, teller, council, beo
# Phase 4 additional sites: Toolik_Lake, Abisko, Trail_Valley_Creek, Samoylov_Island, Bayelva
# =======================================================================================

cwd=$(pwd)
cd /home/modex_user/tools/OLMT

# =======================================================================================
# Get the input options from the command line
for i in "$@"
do
# coerce to lowercase to prevent case issues:
i="${i,,}"
case $i in
    -sn=*|--site_name=*)
    site_name="${i#*=}"
    shift
    ;;
    -sg=*|--site_group=*)
    site_group="${i#*=}"
    shift 
    ;;
    -cp=*|--case_prefix=*)
    case_prefix="${i#*=}"
    shift
    ;;
    -adsy=*|--ad_spinup_years=*)
    ad_spinup_years="${i#*=}"
    shift
    ;;
    -fsy=*|--final_spinup_years=*)
    final_spinup_years="${i#*=}"
    shift
    ;;
    -trsy=*|--transient_years=*)
    transient_years="${i#*=}"
    shift
    ;;
    -tsp=*|--timestep=*)
    timestep="${i#*=}"
    shift
    ;;
    -addt=*|--add_temperature=*)
    add_temperature="${i#*=}"
    shift
    ;;
    -sdaddt=*|--startdate_add_temperature=*)
    startdate_add_temperature="${i#*=}"
    shift
    ;;    
    -addco2=*|--add_co2=*)
    add_co2="${i#*=}"
    shift
    ;;
    -sdaddco2=*|--startdate_add_co2=*)
    startdate_add_co2="${i#*=}"
    shift
    ;;    
    -sclr=*|--scale_rain=*)
    scale_rain="${i#*=}"
    shift
    ;;
    -sdsclr=*|--startdate_scale_rain=*)
    startdate_scale_rain="${i#*=}"
    shift
    ;;    
    -scls=*|--scale_snow=*)
    scale_snow="${i#*=}"
    shift
    ;;
    -sdscls=*|--startdate_scale_snow=*)
    startdate_scale_snow="${i#*=}"
    shift
    ;;
    -scln=*|--scale_ndep=*)
    scale_ndep="${i#*=}"
    shift
    ;;
    -sdscln=*|--startdate_scale_ndep=*)
    startdate_scale_ndep="${i#*=}"
    shift
    ;;
    -sclp=*|--scale_pdep=*)
    scale_pdep="${i#*=}"
    shift
    ;;
    -sdsclp=*|--startdate_scale_pdep=*)
    startdate_scale_pdep="${i#*=}"
    shift
    ;;
    -ms=*|--met_source=*)
    met_source="${i#*=}"
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
site_name="${site_name:-kougarok}"
site_group="${site_group:-NGEEArctic}"
case_prefix="${case_prefix:-NGEE-Arctic}"
ad_spinup_years="${ad_spinup_years:-200}"
final_spinup_years="${final_spinup_years:-600}"
transient_years="${transient_years:--1}"
met_source="${met_source:-era5}"
# -1 is the default
timestep="${timestep:-1}"
# temp and co2 additions:
add_temperature="${add_temperature:-0.0}"
add_co2="${add_co2:-0.0}"
startdate_add_temperature="${startdate_add_temperature:-99991231}"
startdate_add_co2="${startdate_add_co2:-99991231}"
# precipitation scaling defaults
scale_rain="${scale_rain:-1.0}"
scale_snow="${scale_snow:-1.0}"
startdate_scale_rain="${startdate_scale_rain:-99991231}"
startdate_scale_snow="${startdate_scale_snow:-99991231}"
# N/P dep scaling
scale_ndep="${scale_ndep:-1.0}"
startdate_scale_ndep="${startdate_scale_ndep:-99991231}"
scale_pdep="${scale_pdep:-1.0}"
startdate_scale_pdep="${startdate_scale_pdep:-99991231}"

# print back selected or set options to the user
echo " "
echo " "
echo "*************************** OLMT run options ***************************"
echo "Site Name = ${site_name}"
echo "Site Group = ${site_group}"
echo "Case Prefix = ${case_prefix}"
echo "Number of AD Spinup Simulation Years = ${ad_spinup_years}"
echo "Number of Final Spinup Simulation Years = ${final_spinup_years}"
echo "Number of Transient Simulation Years = ${transient_years}"
echo "Model Timestep = ${timestep}"
if [ ${add_temperature} != 0.0 ]; then
  echo "Adding ${add_temperature} degreesC to forcing temperature starting on ${startdate_add_temperature}"
  scaling_args="--add_temperature ${add_temperature} --startdate_add_temperature ${startdate_add_temperature}"
fi
if [ ${add_co2} != 0.0 ]; then
  echo "Adding ${add_co2} ppm to forcing CO2 starting on ${startdate_add_co2}"
  scaling_args="$scaling_args --add_co2 ${add_co2} --startdate_add_co2 ${startdate_add_co2}"
fi
if [ ${scale_rain} != 1.0 ]; then
  echo "Forcing rainfall scaled by factor of ${scale_rain} starting on ${startdate_scale_rain}"
  scaling_args="$scaling_args --scale_rain ${scale_rain} --startdate_scale_rain ${startdate_scale_rain}"
fi
if [ ${scale_snow} != 1.0 ]; then
  echo "Forcing snowfall scaled by factor of ${scale_snow} starting on ${startdate_scale_snow}"
  scaling_args="$scaling_args  --scale_snow ${scale_snow} --startdate_scale_snow ${startdate_scale_snow}"
fi
if [ ${scale_ndep} != 1.0 ]; then
  echo "N deposition scaled by factor of ${scale_ndep} starting on ${startdate_scale_ndep}"
  scaling_args="$scaling_args --scale_ndep ${scale_ndep} --startdate_scale_ndep ${startdate_scale_ndep}"
fi 
if [ ${scale_pdep} != 1.0 ]; then
  echo "P deposition scaled by factor of ${scale_pdep} starting on ${startdate_scale_pdep}"
  scaling_args="$scaling_args --scale_pdep ${scale_pdep} --startdate_scale_pdep ${startdate_scale_pdep}"
fi
if [ ${transient_years} != -1 ]; then
  sim_years="--nyears_ad_spinup ${ad_spinup_years} --nyears_final_spinup ${final_spinup_years} \
  --nyears_transient ${transient_years}"
else
  sim_years="--nyears_ad_spinup ${ad_spinup_years} --nyears_final_spinup ${final_spinup_years}"
fi
echo " "
# =======================================================================================

# =======================================================================================
# specify met dir prefix
# Set site codes for OLMT
# EACH OF THESE SITES ALSO NEEDS THE SURFFILE, LU FILE, DOMAIN FILE SPECIFIED>
if [ ${site_name} = beo ]; then
  site_code="AK-BEOG"
  surf_file="surfdata_1x1pt_beo-GRID_simyr1850_c360x720_c171002.nc"
  landuse_file="landuse.timeseries_1x1pt_beo-GRID_simyr1850-2015_c180423.nc"
  domain_file="domain.lnd.1x1pt_beo-GRID_navy.nc"
  if [ ${met_source} = era5 ]; then
    met_path="/mnt/inputdata/atm/datm7/dapper/utq"
  elif [ ${met_source} = gswp3 ]; then
    met_path=
  fi
elif [ ${site_name} = council ]; then
  site_code="AK-CLG"
  surf_file="surfdata_1x1pt_council-GRID_simyr1850_c360x720_c171002.nc"
  landuse_file="MISSING"
  domain_file="domain.lnd.1x1pt_council-GRID_navy.nc"
  if [ ${met_source} = era5 ]; then
    met_path="/mnt/inputdata/atm/datm7/dapper/cnl"
  elif [ ${met_source} = gswp3 ]; then
    met_path=
  fi
elif [ ${site_name} = kougarok ]; then
  site_code="AK-K64G"
  surf_file="surfdata_1x1pt_kougarok-GRID_simyr1850_c360x720_c171002.nc"
  landuse_file="landuse.timeseries_1x1pt_kougarok-GRID_simyr1850-2015_c180423.nc"
  domain_file="domain.lnd.1x1pt_kougarok-GRID_navy.nc"
  met_path="/mnt/inputdata/atm/datm7/dapper/kg"
elif [ ${site_name} = teller ]; then
  site_code="AK-TLG"
  surf_file="surfdata_1x1pt_teller-GRID_simyr1850_c360x720_c171002.nc"
  landuse_file="landuse.timeseries_1x1pt_teller-GRID_simyr1850-2015_c180423.nc"
  domain_file="domain.lnd.1x1pt_teller-GRID_navy.nc"
  if [ ${met_source} = era5 ]; then
    met_path="/mnt/inputdata/atm/datm7/dapper/tl"
  elif [ ${met_source} = gswp3 ]; then
    met_path=
  fi
elif [ ${site_name} = toolik_lake ]; then
  site_code="AK-Tlk"
  surf_file="surfdata_1x1pt_ToolikLake-GRID_simyr1850_c360x720_c250306.nc"
  landuse_file="landuse.timeseries_1x1pt_ToolikLake-GRID_simyr1850-2015_c250306.nc"
  domain_file="domain.lnd.1x1pt_ToolikLake-GRID.nc"
  if [ ${met_source} = era5 ]; then
    met_path="/mnt/inputdata/atm/datm7/dapper/tfs"
  elif [ ${met_source} = gswp3 ]; then
    met_path=
  fi
elif [ ${site_name} = trail_valley_creek ]; then
  site_code="CA-TVC"
  surf_file="surfdata_1x1pt_TrailValleyCreek-GRID_simyr1850_c360x720_c250306.nc"
  landuse_file="landuse.timeseries_1x1pt_TrailValleyCreek-GRID_simyr1850-2015_c250306.nc"
  domain_file="domain.lnd.1x1pt_TrailValleyCreek-GRID.nc"
  if [ ${met_source} = era5 ]; then
    met_path="/mnt/inputdata/atm/datm7/dapper/tvc"
  elif [ ${met_source} = gswp3 ]; then
    met_path=
  fi
elif [ ${site_name} = abisko ]; then
  site_code="SE-Abi"
  surf_file="surfdata_1x1pt_Abisko-GRID_simyr1850_c360x720_c250306.nc"
  landuse_file="landuse.timeseries_1x1pt_Abisko-GRID_simyr1850-2015_c250306.nc"
  domain_file="domain.lnd.1x1pt_Abisko-GRID.nc"
  if [ ${met_source} = era5 ]; then
    met_path="/mnt/inputdata/atm/datm7/dapper/abs"
  elif [ ${met_source} = gswp3 ]; then
    met_path=
  fi
elif [ ${site_name} = bayelva ]; then
  site_code="NO-SJB"
  surf_file="surfdata_1x1pt_SJ-BlvBayelva-GRID_simyr1850_c360x720_c250306.nc"
  landuse_file="landuse.timeseries_1x1pt_SJ-BlvBayelva-GRID_simyr1850-2015_c250306.nc"
  domain_file="domain.lnd.1x1pt_SJ-BlvBayelva-GRID.nc"
  if [ ${met_source} = era5 ]; then
    met_path="/mnt/inputdata/atm/datm7/dapper/bs"
  elif [ ${met_source} = gswp3 ]; then
    met_path=
  fi
elif [ ${site_name} = samoylov_island ]; then
  site_code="RU-Sam"
  surf_file="surfdata_1x1pt_SamoylovIsland-GRID_simyr1850_c360x720_c250306.nc"
  landuse_file="landuse.timeseries_1x1pt_SamoylovIsland-GRID_simyr1850-2015_c250306.nc"
  domain_file="domain.lnd.1x1pt_SamoylovIsland-GRID.nc"
  if [ ${met_source} = era5 ]; then
    met_path="MISSING"
  elif [ ${met_source} = gswp3 ]; then
    met_path=
  fi
else 
  echo " "
  echo "**** EXECUTION HALTED ****"
  echo "Please select a Site Name from:"
  echo "ALASKA: beo, council, kougarok, teller, toolik_lake"
  echo "CANADA: trail_valley_creek"
  echo "SWEDEN: abisko"
  echo "NORWAY/SVALBARD: bayelva" 
  echo "RUSSIA: samoylov_island"
  exit 0
  echo " "
fi
echo "OLMT Site Code: ${site_code}"
# =======================================================================================

# =======================================================================================
# pause to show options before continuing
sleep 5
echo " "
echo " "
# =======================================================================================

# =======================================================================================
# create the OLMT run command
echo " "
echo "**** User OLMT run command: "
runcmd="python3 ./site_fullrun.py \
      --site ${site_code} --sitegroup ${site_group} --caseidprefix ${case_prefix} \
      ${sim_years} --tstep ${timestep} --machine docker \
      --compiler gnu --mpilib openmpi \
      --cpl_bypass --${met_source} \
      --model_root /E3SM \
      --caseroot /mnt/output \
      --ccsm_input /mnt/inputdata \
      --runroot /mnt/output \
      --spinup_vars \
      --nopointdata \
      --metdir ${met_path} \
      --domainfile /mnt/inputdata/share/domains/domain.clm/${domain_file} \
      --surffile /mnt/inputdata/lnd/clm2/surfdata_map/${surf_file} \
      --landusefile /mnt/inputdata/lnd/clm2/surfdata_map/${landuse_file} \
      --srcmods_loc /home/modex_user/tools/OLMT/srcmods_era5cb /
      ${scaling_args} \
      & sleep 10"
echo ${runcmd}
echo " "
echo " "

echo "**** Running OLMT: "
if /opt/conda/bin/python ./site_fullrun.py \
      --site ${site_code} --sitegroup ${site_group} --caseidprefix ${case_prefix} \
      ${sim_years} --tstep ${timestep} --machine docker \
      --compiler gnu --mpilib openmpi \
      --cpl_bypass --${met_source} \
      --model_root ~/E3SM \
      --caseroot /mnt/output \
      --ccsm_input /mnt/inputdata \
      --runroot /mnt/output \
      --spinup_vars \
      --nopointdata \
      --metdir ${met_path} \
      --domainfile /mnt/inputdata/share/domains/domain.clm/${domain_file} \
      --surffile /mnt/inputdata/lnd/clm2/surfdata_map/${surf_file} \
      --landusefile /mnt/inputdata/lnd/clm2/surfdata_map/${landuse_file} \
      --srcmods_loc /home/modex_user/tools/OLMT/srcmods_era5cb \
      ${scaling_args} \
      & sleep 10

then
  wait

  echo "DONE docker ELM runs !"

else
  exit &?
fi
# =======================================================================================

# =======================================================================================
#### Postprocess
### Collapse transient simulation output into a single netCDF file
echo " "
echo " "
echo " "
echo "**** Postprocessing ELM output in: "
echo "/mnt/output/cime_run_dirs/${case_prefix}_${site_code}_ICB20TRCNPRDCTCBC/run"
echo " "
echo " "
cd /mnt/output/cime_run_dirs/${case_prefix}_${site_code}_ICB20TRCNPRDCTCBC/run
echo "**** Concatenating netCDF output - Hang tight this can take awhile ****"
ncrcat --ovr *.h0.*.nc ELM_output.nc
chmod 666 ELM_output.nc
echo "**** Concatenating netCDF output: DONE ****"
sleep 2
# =======================================================================================
