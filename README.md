# Apache access.log analyzein with BASH

## Description

This project is a result of linux sysadmin interview task.

## Tasks

There is an access.log. 

The task to write small piece of code to answer the following questions:

1. Top 10 requested urls sorted by hits
    
    Output example:
    ```
    "hits: uri:"
    25     /url1
    10     /url2
    9      /url3
    ...
    ```
    
    Answer:

    ```
    `awk '{print $7}' access.log | sort | uniq -c |  sort -nr | head -n 10` 

    `awk '{count[$7]++}; END { for (i in count) print count[i], i }' access.log | sort -nr | head -n 10 | column -t`
    ```

1. Top 10 visitors by ip sorted by hits
    
    Output example:
    ```
    "hits:  ip:"
    100    1.1.1.1.1
    50     2.2.2.2.2
    10     3.3.3.3.3
    ...
    ```
    
    Answer:

    ```
    awk '{print $1}' access.log | sort | uniq -c |  sort -nr | head -n 10

    awk '{count[$1]++}; END { for (i in count) print count[i], i }' access.log | sort -nr | head -n 10 | column -t
    ```

1. Total hits per month sorted by month
    
    Output example:
    ```
    Nov 2017 hits count - 12512
    Dec 2017 hits count - 10087
    Jan 2018 hits count - 12561
    ```
    
    Answer:

    ```
    awk '{print substr($4,5,3),substr($4,9,4)}' access.log | uniq -c | awk '{ print $2,$3,"hits count - ",$1}'
    ```

1. Unique visits (by ip) per month
    
    Output example:
    ```
    Aug 2018 unique visits - 1500
    Sep 2018 unique visits - 1356
    Oct 2018 unique visits - 1689
    ```
    
    Answer:

    ```
    awk '{print $1" "substr($4, 5,3)" "substr($4,9,4)}' access.log | awk '!a[$0]++' | uniq -c -f 1 | awk '{print $3" "$4" unique visits - "$1}'
    ```

1. Top 10 ips barchart per month
    
    Output example:
    ```
    Aug 2016
    23322 1.1.1.1 #####################################################################
    359   2.2.2.2 ##################
    354   3.3.3.3 ##################
    251   4.4.4.4 ##################
    239   5.5.5.5 ##################
    234   6.6.6.6 ##################
    227   7.7.7.7 ##################
    210   8.8.8.8 ##################
    196   9.9.9.9 ##################
    189   1.2.3.4 ##################

    Sep 2016
    36512 1.1.1.1 #########################################################################################################
    512   2.2.2.2 ###################
    571   3.3.3.3 ###################
    ```
    
    Answer:

    The script can be found at [task5.sh](task5.sh)

1. Have you noticed anything weird in the given log (hacking attempts, malicious activity, security scans etc)? Just write down what you think you could find.

    On 19/Jun/2018 there were DirBuster hits from 91.218.225.68 & 199.19.249.196.

    On the next day there are Nikto & GoLismero scans from 91.218.225.68.

    From the result of the 1st task I saw a lot of hits for access.log and administrator page.

    Also found the log file requested is with URL http://www.almhuette-raith.at/apache-log/access.log and returns 206 which is bad.

        ```
        1153588  /apache-log/access.log
        631142   /administrator/index.php
        61342    /administrator/
        31161    /
        26009    /templates/_system/css/general.css
        18046    http://almhuette-raith.at/administrator/index.php
        15962    /robots.txt
        13908    /favicon.ico
        9110     /apache-log/
        7540     /images/stories/slideshow/almhuette_raith_01.jpg
        ```

    The top hitters of access.log for example are these IP addresses and have a lot of requests mosty on these kind of resources:

        ```
        166324  5.112.235.245
        157726  5.114.231.216
        157016  5.113.18.208
        93669   5.114.64.184
        88822   5.113.216.211
        55740   5.113.7.77
        49897   5.113.35.73
        42576   88.202.188.67
        38614   5.114.237.218
        37347   80.84.55.206
        ```

    Looking the result of the 2nd task I looked in depth what these top hitter IP's are requesting:

    ```
    167812  198.50.156.189 - All of his requests are for "/administrator/index.php"
    166722  5.112.235.245 - As seen in the previous result he is requesting only apache-log and apache-log/access.log
    158258  5.114.231.216 - As above
    157674  5.113.18.208 - As above
    134376  91.218.225.68 - Scans and injects url params
    114799  79.62.229.212
    97533   149.56.83.40
    94043   5.114.64.184
    89125   5.113.216.211
    88875   158.69.5.181 - A lot of POST's to /administrator/index.php, trying to authenticate for the admin panel with a more than 3 attempts per second in the morning of 05/Apr/2018 for example
    ```

    Looking at the result of the 4th task May's and June's 2018 hits are with big differences compared to the average.

    For example for Jun 2018 more than 50% (529K) of the hits are for access.log and came from the same IP's seen in the 1st and 2nd task result:

    ```
    166324  5.112.235.245
    157726  5.114.231.216
    93669   5.114.64.184
    38064   88.202.188.67
    36500   5.112.66.178
    11678   5.112.187.24
    9575    5.112.185.176
    4765    5.113.16.156
    4400    156.216.124.117
    3618    5.112.105.194
    ```

    While viewing the result of the 4th task there is also big increments in the unique hits count in some months.
    Feb 2016 has a 14K unique hits while the monthly average is ~ 1500.

    The biggest change is at 18 Feb 2016 and the traffic for this day came from 13248 different IP addresses mostly GET and POST requests to the admin login page.

    The result of the 5nd task confirms all above showing big differences in the hits in monthly view.
