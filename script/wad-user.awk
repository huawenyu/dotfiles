#!/usr/bin/awk -f
#awk '/^ID: / { IDX += 1; ip=$0; getline user; getline dur; getline type; getline; getline method; getline pol; getline g_id; getline; getline exp; print IDX " " $ip; print $user; print $dur;}'

# actions before reading text stream - initiate counters
BEGIN{
    IDX = 0;
    RS="\n"
}

# at every line ruleblock
/^ID: / {
    IDX += 1;
    ip=$0; gsub("\r","",ip)
    getline user; gsub("\r","",user)
    getline dur; gsub("\r","",dur)
    getline type; gsub("\r","",type)
    getline;
    getline method; gsub("\r","",method)
    getline pol; gsub("\r","",pol)
    getline g_id; gsub("\r","",g_id)
    getline;
    getline expire; gsub("\r","",expire)

    print "index="IDX " " ip

    #print user
    #print dur
    #print method
    #print expire
    printf("%s  %s  %s  %s\n", user, dur, method, expire);
}

# final text stream statistics
END{
    printf("Total %d lines.\n", IDX);
    print " - DONE -"
}
