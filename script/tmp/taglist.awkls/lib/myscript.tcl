# myscript.tcl

package require Tclx

proc makeKey {prefix key} {
    return [string trim "$prefix $key"]
}   

proc keyedlist2dict {klname {keyPrefix ""}} {
    upvar 1 $klname kl
    set d {}
    foreach key [keylkeys kl] {
        set value [keylget kl $key]
        if {[catch {keylkeys value}]} {
            # value is not a nested keyed list
            lappend d [makeKey $keyPrefix $key] $value
        } else {
            # value is a nested keyed list
            set d [concat $d [keyedlist2dict value $key]] ;# TCL 8.4
        }   
    }   

    return $d
}   

set contents [read [open data.txt]]
foreach item $contents { 
    # Each item starts with "TOKEN", which we need to remove otherwise
    # the keyed list is invalid
    set item [lrange $item 1 end]

    # Convert a keyed list to a dict, then to a csv row. We can then 
    # display the row or to write it to a file.
    set rec [keyedlist2dict item]

    # Display it
    foreach {key value} $rec { ;# TCL 8.4
        puts "$key: $value"
    }   
    puts ""
}   
