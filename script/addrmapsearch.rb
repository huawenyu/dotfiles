#!/usr/bin/ruby

require 'getoptlong'

def print_usage()
     puts "#{$0}\n"
     puts "\t--addressfile,-f <addressfile> - list of file offsets\n"
     puts "\t--valgrindfile,-g <valgrindfile> - list of file offsets\n"
     puts "\t--mapfile,-m <map file from executable>\n"
     puts "\t--address,-a <single address>\n"
     puts "\t--help,-h - this help\n"
end

def buildmap(mapfilename)
    addrmap = []
    File.open(mapfilename) do |f|
        state = 0
        cnt = 0
        f.each_line do |line|
            case state
            when 0
                if(line =~ /^Symbol table '.symtab' contains/)
                    state = 1
                end
            when 1
                if(line =~ /^\s+\d+: ([0-9a-fA-F]+)\s+(\d+) FUNC\s+\w+\s+\w+\s+\d+ (.*)/)
                    offset = $1.hex
                    size = $2.to_i
                    endoffset = offset + size
                    funcname = $3
                    startpoint = $1
                    addrmap[cnt] = [offset, endoffset, funcname, startpoint]
                    cnt += 1
                    #puts "offset: #{offset} size: #{size} function: #{funcname}\n"
                end
            end
        end
    end
    addrmap = addrmap.sort {|a,b| a[0] <=> b[0] }
    #x.each {|item|
        #puts "start: #{item[0]} end: #{item[1]} function: #{item[2]}\n"
    #}
    return addrmap
end

def scanAddressBSearch(addrmap, address)
    offset = address.hex

    found = false
    start = 0
    stop = addrmap.length

    while true do
    #puts "start: #{start}\n"
    #puts "stop: #{stop}\n"
        if(stop - start) <= 2
            (start..(stop-1)).to_a.each do |idx|
                ainfo = addrmap[idx]
                #puts "#{offset}: #{ainfo[0]}-#{ainfo[1]}\n"
                if(offset >= ainfo[0] && offset <= ainfo[1])
                  offstr = (offset - ainfo[0]).to_s(16)
                  puts "[#{address}] #{ainfo[2]} [0x#{ainfo[3]}] [0x#{offstr}]\n"
                    return
                end
            end

            #puts "[#{address}] Not found!\n"
            return
        else
            idx = (stop - start) / 2 + start
            ainfo = addrmap[idx]
            #puts "#{offset}: #{ainfo[0]}-#{ainfo[1]}\n"

            if(offset >= ainfo[0] && offset <= ainfo[1])
              offstr = (offset - ainfo[0]).to_s(16)
              puts "[#{address}] #{ainfo[2]} [0x#{ainfo[3]}] [0x#{offstr}]\n"
                return
            elsif(offset < ainfo[0])
                stop = idx
            else
                start = idx
            end
        end
    end
end

def scanAddress(addrmap, address)
    offset = address.hex
    addrmap.each_index { |idx|
        ainfo = addrmap[idx]

        # if offset is in range of function then print and return
        if(offset >= ainfo[0] && offset <= ainfo[1])
          offstr = (offset - ainfo[0]).to_s(16)
          puts "[#{address}] #{ainfo[2]} [0x#{ainfo[3]}] [0x#{offstr}]\n"
            return
        end
    }
end

def scanAddressList(addrmap, addressfilename)
    File.open(addressfilename) do |f|
        state = 0
        cnt = 0
        f.each_line do |line|
            case state
            when 0
                if(line =~ / application (\w+)/)
                    puts "\nApplication: #{$1}\n"
                    state = 1
                end
            when 1
                if(line =~ /\* signal (\d+) \((.*)\)/)
                    puts "Signal: #{$1} #{$2}\n"
                end
                if(line =~ / Backtrace:/)
                    puts "Backtrace:\n"
                    state = 2
                end
            when 2
                if(line =~ /\[(0x[0-9a-fA-F]+)\]/)
                    offset = $1
                    scanAddressBSearch(addrmap, offset)
                end

                if(line =~ /\> firmware /)
                    state = 0
                end
            end
        end
    end
end

def scanAddressValgrind(addrmap, addressfilename)
  File.open(addressfilename) do |f|
    f.each_line do |line|
      if (line =~ /^==[0-9]+== ([A-Z].+)$/)
        puts "\n\n#{$1}\n"
      end
      if (line =~ /^==[0-9]+==  ([A-Z].+)$/)
        puts "\n #{$1}\n"
      end
      if (line =~ /^==[0-9]+== +[^0]+(0x[0-9a-fA-F]+)/)
        offset = $1
        scanAddressBSearch(addrmap, offset)
      end
    end
  end
end

def main
    opts = GetoptLong.new(
        [ "--addressfile", "-f", GetoptLong::REQUIRED_ARGUMENT],
        [ "--valgrindfile", "-g", GetoptLong::REQUIRED_ARGUMENT],
        [ "--mapfile", "-m", GetoptLong::REQUIRED_ARGUMENT],
        [ "--address", "-a", GetoptLong::REQUIRED_ARGUMENT],
        [ "--help", "-h", GetoptLong::NO_ARGUMENT ]
    )

    afilename = nil
    gfilename = nil
    mfilename = nil
    address = nil

    opts.each do |opt, arg|
        case opt
        when "--addressfile","-f"
            afilename = arg;
        when "--valgrindfile","-g"
            gfilename = arg;
        when "--mapfile","-m"
            mfilename = arg;
        when "--address","-a"
            address = arg;
        when "--help","-h"
            print_usage()
            exit
        end
    end

    if(!afilename.nil? && !mfilename.nil?)
        # open map file an process list of addresses

        # first build address ranges from map file
        amap = buildmap(mfilename)

        # TODO open address file 
        scanAddressList(amap, afilename)
    end

    if(!gfilename.nil? && !mfilename.nil?)
        # open map file an process list of addresses

        # first build address ranges from map file
        amap = buildmap(mfilename)

        # TODO open address file 
        scanAddressValgrind(amap, gfilename)
    end

    if(!address.nil? && !mfilename.nil?)
        # open map file and find individual address
        amap = buildmap(mfilename)

        scanAddress(amap, address)
    end

    if(mfilename.nil?)
        puts "Please input a map filename and either an address or list of addresses\n"
        print_usage()
        exit
    end


end

main

