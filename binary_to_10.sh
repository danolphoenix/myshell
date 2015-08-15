#!/bin/sh
#vim: set sw=4 ts=4 et:
help()
{
echo "b2h -- convert binary to decimal \n 
USAGE: b2h [-h] binarynum \n
OPTIONS: -h help text  \n
EXAMPLE: b2h 111010 \n
will return 58 \n
HELP  "
exit 0
}

error()
{
    #pring an error and exit
    echo"$1"
    exit 1
}

lastchar()
{
    #
    if [ -z "$1" ]; then
            #empyt string
        rtval=""
        return
    fi
    #wc puts some space behind the output this is why we need sed:
    #sed 's/ //g'#去除所有空格
    #wc -c 统计字节数目
    numofchar=`echo -n "$1"|wc -c|sed 's/ //g'`
    echo "numofchar:$numofchar"
    #now cut out the last char
    rval=`echo -n "$1"|cut -b $numofchar`
}

shift_last_char()
{
    #remove the last character in string and return it in $rval
    if [ -z "$1" ]; then
        #empty string
        rval=""
    fi
    #we puts some space behind the output this is why we need sed
    numofchar=`echo -n "$1"|wc -c|sed 's/ //g'`
    if [ "$numofchar" = "1" ]; then
        #only ne char in string
        rval=""
        return
    fi
    numofcharminus1=`expr $numofchar - 1`
    #now cut all but the last char:
    rval=`echo -n "$1"|cut -b 1-${numofcharminus1}`
    echo "rval:$rval"
}
while [ -n "$1" ];do
    case $1 in 
        -h)help;shift1;; #function help is called
        --)shift;break;;#end of options
        -*)error "error:no such option $1.-h for help";;
        *)break;;
    esac
done

#the main program
sum=0
weight=1
#one art must be given:
[ -z "$1" ] && help
binnum="$1"
binnumorig="$1"
while [ -n "$binnum" ];do
    lastchar "$binnum"
    if [ "$rval" = "1" ];then
        sum=`expr $weight + $sum`
    fi
    #remove the last positon in $binnum
    shift_last_char "$binnum"
    binnum="$rval"
    weight=`expr $weight \* 2`
done
echo "binary $binnumorig is decimal $sum"


