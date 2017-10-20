#! /bin/bash

if [ $# -eq 0 ]; then
    echo "usage: $0 [-h] -p <portion> -b <bitwidth> -r <pow_low> <pow_high> -f <files>"
    echo " "
    echo "options:"
    echo "-h, --help				show this message"
    echo "-p, --portion <portion>		portion to drop small data (in percentage 0~100)"
    echo "-b, --bitwidth <bitwidth>		bitwidth"
    echo "-r, --range <pow_low> <pow_high>	low and high end of power"
    echo "-f, --file <files>			files to process"
    exit 0
fi

portion="0"
bitwidth="4"
pow_low="-7"
pow_high="3"

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            echo "usage: $0 [-h] -p <portion> -b <bitwidth> -r <pow_low> <pow_high> -f <files>"
            echo " "
            echo "options:"
            echo "-h, --help				show this message"
            echo "-p, --portion <portion>		portion to drop small data (in percentage 0~100)"
            echo "-b, --bitwidth <bitwidth>		bitwidth"
            echo "-r, --range <pow_low> <pow_high>	low and high end of power"
            echo "-f, --file <files>			files to process"
            exit 0;;
        -p|--portion)
            portion=$2
            shift
            shift;;
        -b|--bitwidth)
            bitwidth=$2
            shift
            shift;;
        -r|--range)
            pow_low=$2
            pow_high=$3
            shift
            shift
            shift;;
        -f|--file)
            shift
            file=$@
            break;;
        *)
            exit 0
            break;;
    esac
done

# chmod +x convert.py datafilter.pl reshape.pl
# echo "./datafilter.pl $portion $abs $file"

perl ./scripts/datafilter.pl $portion $file

filepy=""
for f in $file
do
    filepy="$filepy ""$f""_float"
done

# echo "python convert.py $filepy"
python ./scripts/convert.py $bitwidth $pow_low $pow_high $filepy

perl ./scripts/reshape.pl $file

filesh=""
for f in $filepy
do
    filesh="$filesh ""$f""_convert"
done

printf "Removing temp files..."
rm -f $filepy $filesh
printf "done\n"
