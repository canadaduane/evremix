found=$(gunzip -c $1 | egrep '\bammah\b|\bavengeth\b|\bcondescensions\b|\bconsiderest\b|\bcovenanteth\b|\bcumbered\b|\bdelightsome\b|\bdeniest\b|\bdisputings\b|\bengulf\b|\benticeth\b|\bexerciseth\b|\bfatlings\b|\bfighteth\b|\bforgettest\b|\bglutting\b|\bgrievousness\b|\bgroaneth\b|\bhash\b|\bhilts\b|\bhindereth\b|\bkib\b|\bkumen\b|\bmaher\b|\bmigron\b|\bmoron\b|\bmournings\b|\bnimrah\b|\bpester\b|\bpleadeth\b|\bprocrastinate\b|\bprovoketh\b|\bredeemeth\b|\brejecteth\b|\breuniting\b|\brewardeth\b|\bshalal\b|\bsheddeth\b|\bsimpleness\b|\bsinim\b|\bsmiter\b|\bsobbings\b|\bsorrowed\b|\bstraightness\b|\bstraiten\b|\bsufficeth\b|\bsupposeth\b')
if [[ $found != "" ]]; then
  echo "$1"
  echo $found
fi