set cov_html_report_dir sim_cov_report
xml2ucdb -format Excel test_plan.xml test_plan.ucdb
vcover merge -testassociated -multiuserenv -out merged.ucdb *.ucdb 
file delete -force $cov_html_report_dir
vcover report -html merged.ucdb -details -annotate -testdetails -showexcluded -output $cov_html_report_dir

vcover ranktest -stats=none -rankfile vsim.rank -logfile ranked_tests.txt merged.ucdb