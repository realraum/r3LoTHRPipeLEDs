function pp(t)local tt={}local i=0 for k,v in pairs(t)do i=i+1 tt[i]=tostring(k).." = "..tostring(v)end table.sort(tt)print(table.concat(tt,"\n"))end function ls()pp(file.list())end

