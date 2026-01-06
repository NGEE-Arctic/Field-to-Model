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
)

# a couple assumptions here that are different
# than from what we are otherwise using for the workshop:
# 1) for testing I'd like to keep things on local folders
#    and not docker volumes, so I'm not using volumes.
# 2) I am redirecting output to log files so I can run all sites at once

for site in "${sites[@]}"; do
    docker run --rm -v /code/field-to-model-inputdata:/mnt/inputdata \
        -v /data/ngee-baseline-runs:/mnt/output \
        -v $(pwd):/home/modex_user \
        -u modex_user \
        -e USER=modex_user \
        yuanfornl/ngee-arctic-modex26:models-main-latest \
        /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
        --site_name=${site} --case_prefix="cntl" > logs/${site}-cntl.log 2>&1 &

    sleep 120

    docker run --rm -v /code/field-to-model-inputdata:/mnt/inputdata \
        -v /data/ngee-baseline-runs:/mnt/output \
        -v $(pwd):/home/modex_user \
        -u modex_user \
        -e USER=modex_user \
        yuanfornl/ngee-arctic-modex26:models-main-latest \
        /home/modex_user/model_examples/ELM/run_ngeearctic_site.sh \
        --site_name=${site} --case_prefix="ArcInit" --use_arctic_init \
        > logs/${site}-arcinit.log 2>&1 &

   sleep 120

done

wait
