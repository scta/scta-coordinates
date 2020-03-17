CODEXID=$1
start=$2
stop=$3

i=$start
while [ $i -le $stop ]
do
saxon "-warnings:silent" "-s:coord-line-count-check.xsl" "-xsl:coord-line-count-check.xsl" "-o:log/${CODEXID}/${i}r-report.txt" "codexName=${CODEXID}" "fileName=${i}r"
i=$(($i+1))
done
i2=$start
while [ $i2 -le $stop ]
do
saxon "-warnings:silent" "-s:coord-line-count-check.xsl" "-xsl:coord-line-count-check.xsl" "-o:log/${CODEXID}/${i2}v-report.txt" "codexName=${CODEXID}" "fileName=${i2}v"
i2=$(($i2+1))
done
