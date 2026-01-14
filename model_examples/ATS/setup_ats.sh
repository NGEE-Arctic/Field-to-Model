cd /home/modex_user/model_examples/ATS
mkdir -p /mnt/output/ATS
for i in `ls *.xml`; do mkdir -p /mnt/output/ATS/`basename $i .xml`; done
ln -s /home/modex_user/model_examples/ATS /mnt/output/ATS/input
export ATS_DEMOS=/mnt/output/ATS
cd $ATS_DEMOS
