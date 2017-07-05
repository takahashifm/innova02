#!/bin/bash
#
# Date:20170705
# Purpose:カレンダーを作成する
#
#------------------------------------------------------
FUNC=$0
tdate=`date +%Y%m%d`
tdate=20170630
#tdate=20170730
year=`echo $tdate|cut -c1-4`
month=`echo $tdate|cut -c5-6`
TLC=$( date +%h --date="$tdate" )
YM=$( date +%Y%m --date="$tdate" )
#ofile=/misc/usb2t/DNB/testc.html
#ofile=/misc/usb2t/DNB/dnb_tmon_pass_brs.html
ofile=/var/www/html/dnbcont/dnb_tmon_${YM}.html
imagedir=/misc/usb2t/DNB
filecrit=npp_viirs_dynamic_dnb_????????_hok.jpg
#FILELISTS=$( find  ${imagedir} -name ${filecrit} | xargs basename )
#FILELISTS=$( find  ${imagedir} -name ${filecrit} -exec basename {} \; )

echo $FILELISTS



echo "${FUNC}: if ope [$month] [$year]"

[ $month == 01 ] && month2=January
[ $month == 02 ] && month2=February
[ $month == 03 ] && month2=March
[ $month == 04 ] && month2=April
[ $month == 05 ] && month2=May
[ $month == 06 ] && month2=June
[ $month == 07 ] && month2=July
[ $month == 08 ] && month2=August
[ $month == 09 ] && month2=September
[ $month == 10 ] && month2=October
[ $month == 11 ] && month2=November
[ $month == 12 ] && month2=December
echo $month


cat << EOF > $ofile
<HTML><head>
<META http-equiv=Content-Type content=text/html; charset=Shift_JIS>
<META name=GENERATOR>
<META http-equiv=Content-Style-Type content=text/css>
<Title>$year,$month2</Title>
<STYLE type=text/css>
<!---
td{border-width : 1pt 1pt 1pt 1pt;border-style : solid solid solid solid;border-color : blue blue blue blue;}
-->
</STYLE>
</head>
  <script type="text/javascript">
    function LinkClick(param) {
      var elem = document.getElementById("image01");
        elem.src = param;
    }
  </script>
<body>

<div style="float:right;">
  <FONT size=6 face=Arial>$year/$month2</FONT> 
  <FONT size=4 face=tahoma>____Time:GMT, Platform []
  </FONT>
<Table border=1>
 <TR bgcolor=Navy>
 <td rowspan="7">
 <img id="image01" src="img/win10.jpg" height="351px" width="570px">
 </td>

  <TH><FONT color=#ffffff>Sun</FONT></TH>
  <TH><FONT color=#ffffff>Mon</FONT></TH>
  <TH><FONT color=#ffffff>Tue</FONT></TH>
  <TH><FONT color=#ffffff>Wed</FONT></TH>
  <TH><FONT color=#ffffff>Thu</FONT></TH>
  <TH><FONT color=#ffffff>Fri</FONT></TH>
  <TH><FONT color=#ffffff>Sat</FONT></TH>
 </TR>" 
EOF

#日曜をスタートとした何日目なのか

START_DAY_OF_WEEK=$( date +%w --date="$year/$month/01")
END_DAY_OF_WEEK=$( date +%w --date="$year/$month/01 next month 1 day ago")
LAST_DAY_OF_MONTH=$( date --date="$year/$month/01 next month 1 day ago" +%d)
DAYFLAG=0
DDAY=0

for numweek  in $( seq 0 5)
do echo -n ""
	echo "<TR>" >> $ofile
	for numday in $( seq 0 6 )
	do echo  ""
		[ ${numweek} == 0 ] && [ ${START_DAY_OF_WEEK} == $numday ] &&  DAYFLAG=1 && KOTEI=$numday 
		DDAY=$(( ( numweek * 7  + numday - KOTEI + 1 ) * DAYFLAG ))
		[ $DDAY -gt ${LAST_DAY_OF_MONTH} ] && DDAY=0
		echo -n month [$month]  week no. [ $numweek ] day no. [ $numday ] FLAG [ $DAYFLAG ] KOTEI [$KOTEI]
		##
		## 変数　０の場合、カレンダーに日付がない、それ以外の場合月の中の日にちとなる
		##
		if [ $DDAY -ne 0 ] ; then 
			echo "<TD width=100 height=100 valign=top align=center cellspacing=0 cellpadding=0><B><FONT size=3 face=tahoma>" >> $ofile
			echo "$DDAY <br>"  >> $ofile
			
			filecrit=npp_viirs_dynamic_dnb_`date +%Y%m%d --date="$year/$month/01 $DDAY days 1 day ago"`_hok.jpg
			FILELISTS=$( find  ${imagedir} -name ${filecrit} -exec basename {} \; )
			for i in $FILELISTS
			do echo -n ""
				echo  "<a href=javascript:void(0); onclick=LinkClick('/DNB/"$i"');>Image</a></br>" >> $ofile
				#echo  "<a href=/DNB/"$i" target=contents>Image</a></br>"  >> $ofile
			done
			#echo ${FILELISTS}  >> $ofile
			echo "</TD>" >> $ofile
		else
			echo "<TD width=100 height=100 valign=top align=center cellspacing=0 cellpadding=0><B><FONT size=3 face=tahoma>" >> $ofile
			echo "---</TD>" >> $ofile
		fi

#		echo "- </TD>" >> $ofile
		#echo "</FONT></B><BR>"  >> $ofile
		#echo "<FONT size=0.5 face=Arial>">> $ofile
		#echo "<TD width=100 height=100 valign=top align=center>-</TD>"                  >> $ofile
	done
done

cat << EOF >> $ofile
</TR></Table></DIV></body></HTML>
EOF


echo ""


exit

cat << EOF 
EOF
