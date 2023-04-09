set s {title: Mr. name: Peter surname: Lewerin}
puts $s
puts [dict values $s]
puts [lindex $s end]
set val [dict get $s title:]
puts $val

set colours [dict create colour1 "black" colour2 "white"]
foreach item [dict keys $colours] {
    set value [dict get $colours $item]
    puts $value
}

set HOSTS(pc,name) "my linux pc"
set HOSTS(pc,note) "my test box 111C"
set HOSTS(pc,ip) "192.168.1.121"

set HOSTS(box,name) "my linux pc"
set HOSTS(box,note) "my test box VM64"
set HOSTS(box,ip) "192.168.1.99"
set HOSTS(box,ip) "192.168.1.99"
set HOSTS(box,ip) "192.168.1.99"

puts $HOSTS(1,name)
