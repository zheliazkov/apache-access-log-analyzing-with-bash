#/bin/bash

# Getting all uniq pairs of Month an Year in their natural order - sorted
months=$(awk '{print substr($4,5,3)"/"substr($4,9,4)}' access.log | uniq)

# Maximum characters at one line
total_columns=$(tput cols);

# Define maximum bar units that fit in one line
max_chart_point_per_row=$((total_columns-30));

# Grepping the log month by month 
while 
	read -r month; 
do 
	printf "\n$month\n\n"; # Printing period title

	top=0; # This holds maximum hits for the current month
	current_month_hits=$(grep "$month" access.log | awk '{print $1}' | sort | uniq -c |  sort -nr | head -10) # Get Top 10 IP for the month

	while
		read -r line
	do
		this_ip_hits_count=$(awk '{print $1}' <<< "$line")

		# Setting the coefficient K
		if [[ $this_ip_hits_count -gt $top ]]; then
			top=$this_ip_hits_count;
			k=$(expr $top/$max_chart_point_per_row | bc -l); # This is the number of hits that one bar point represents
		fi
		current_row_points=$( expr $this_ip_hits_count/$k | bc -l);

		line="$line ";

		for i in $(seq 1 $current_row_points); do line="$line#"; done

		# Printing beautified
		read hits ip points <<< "$line";
		printf '%-10s %-15s %s\n' $hits $ip $points
		
	done <<< "$current_month_hits"

done <<< "$months"
