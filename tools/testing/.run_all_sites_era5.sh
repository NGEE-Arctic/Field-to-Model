#!/bin/bash -f

sites=(
    kougarok
    teller
    council
    beo
    trail_valley_creek
    toolik_lake
    abisko
    samoylov_island
    bayelva
    imnaviat_creek
    upper_kuparuk
)

# a couple assumptions here that are different
# than from what we are otherwise using for the workshop:
# 1) for testing I'd like to keep things on local folders
#    and not docker volumes, so I'm not using volumes.
# 2) I am redirecting output to log files so I can run all sites at once

job_count=0

for site in "${sites[@]}"; do

    cpu=${job_count}
    echo "Running control for ${site} on CPU ${job_count}"
    docker run --pull always --cpuset-cpus "${cpu}" -v inputdata:/mnt/inputdata \
        -v output:/mnt/output \
        -v $(pwd)/model_examples:/home/modex_user/model_examples \
        -v $(pwd)/E3SM:/home/modex_user/E3SM \
        -u modex_user \
        -e USER=modex_user \
        yuanfornl/ngee-arctic-modex26:models-main-latest \
        /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
        --site_name=${site} --case_prefix="cntl" > logs/${site}-era5-cntl.log 2>&1 &

    ((job_count++))
    sleep 600

    cpu=${job_count}
    echo "Running arctic initialization for ${site} on CPU ${job_count}"
    docker run --cpuset-cpus "${cpu}" --rm -v inputdata:/mnt/inputdata \
        -v output:/mnt/output \
        -v $(pwd)/model_examples:/home/modex_user/model_examples \
        -v $(pwd)/E3SM:/home/modex_user/E3SM \
        -u modex_user \
        -e USER=modex_user \
        yuanfornl/ngee-arctic-modex26:models-main-latest \
        /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
        --site_name=${site} --case_prefix="ArcInit" --use_arctic_init \
        > logs/${site}-era5-arcinit.log 2>&1 &

    sleep 600
    ((job_count++))

done

wait
