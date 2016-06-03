function int = Interval_Time( speed , type)
%INTERVAL_TIME Summary of this function goes here
%   Detailed explanation goes here
%type ==1 means M (Possion)
if(type == 1)
    int = -log(rand)/speed;
end
%type ==2 means D
if(type == 2)
    int = 1/speed;
end

end

