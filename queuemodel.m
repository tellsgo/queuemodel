clear;
clc;


%Chapter 1 M/M/1 simulation system initialization

simtime = input('please type the simulation time');
%Arriving event speed
lambda = 300; 
%Leaving event speed
mu=500;
%Max arrive packets in one time
maxarr = 1;
%Max leave packets in one time
maxleav = 1;
%arrive type is M
arrival_type = 1;
%leave type is D
leave_type = 2;
%Arrive time array, first element
t_arrive(1) = Interval_Time(lambda,arrival_type);
%the number of arriving
num_arrive = 1;
%get the number of arrive events before simetime end
while t_arrive(end) < simtime
    t_arrive = [t_arrive, t_arrive(end)+Interval_Time(lambda,arrival_type)];
    num_arrive = num_arrive +1;
end
%arriving number in one arrive event
arrive_packets = unidrnd(maxarr,1,num_arrive);
%leaving number in one leave event
leave_packets(1) = unidrnd(maxleav);
%calculate total packets generated
total_packets = 0;
for n = 1:num_arrive
    for m = 1:arrive_packets(n)
        total_packets = total_packets+1;
    end
end
%packet information matrix with arriving time, leaving time,and 
%drop(true or false), the forth is a test column 
packet_info = zeros(total_packets,4);
m = 1;
for n = 1:num_arrive
    for i = 1:arrive_packets(n)
        packet_info(m,4)=t_arrive(n);
        m = m+1;
    end   
end

%queue object
que = Queue(packet_info);
%leaving process is not independent Determine leaving time array by 
%setting a variable queuelength to get leaving time array.
t_leave(1) = t_arrive(1)+Interval_Time(mu,leave_type);

%get leave time array
%two situation
%first is t_leave(i)=t_arrive(i)+Interval_Service(i), which means empty
%queue.
%second is t_Leave(i)=t_Leave(i-1)+Interval_Service(i), which means queue
%is not empty
i = 2; 
num_current_arrive =2;
while t_leave(end) <simtime
    %in the begining of every loop, put arrive events after leave(i-2),
    %before leave(i-1) inside the queue, and pop-out leave(i-1) events.
    if(num_current_arrive <= total_packets)
        if(i >= 3)
            for k = 1:num_arrive
             if (t_leave(i-2)<t_arrive(k))&&(t_leave(i-1)>t_arrive(k))
                 que.Arrive(arrive_packets(k),t_arrive(k));
                 num_current_arrive = num_current_arrive+1;
             end          
         end
        else
         %put arrive events before leave(1) inside the queue
            for k = 1:num_arrive
                if t_arrive(k)<t_leave(1)
                    que.Arrive(arrive_packets(k),t_arrive(k));
                    num_current_arrive = num_current_arrive+1;
                end                
         end
        end 
    end
    que.Leave(leave_packets(i-1),t_leave(i-1))
    leave_packets = [leave_packets, unidrnd(maxleav)];
    %decide next leave time based on queue length
    if que.Get_Que_Length > 0
        t_leave(i) = t_leave(i-1)+Interval_Time(mu,leave_type);
    elseif que.Get_Que_Length == 0
        t_leave(i) = t_arrive(num_current_arrive)+Interval_Time(mu,leave_type);
    else
        error('queue length is negative');
    end            
    i = i+1;
end
%put arrive events after leave(end-2),
%before leave(end-1) which is just before the simetime inside the queue
for k = 1:num_arrive
    if(num_current_arrive == total_packets)
        break;
    end
    if (t_leave(i-2)<t_arrive(k))&&(t_leave(i-1)>t_arrive(k))
        que.Arrive(arrive_packets(k),t_arrive(k));
        num_current_arrive = num_current_arrive+1;
    end
end
%this is drop column
A = que.packet_info(1:total_packets,1:2);
B = que.packet_info(1:total_packets,2)-que.packet_info(1:total_packets,1);

%what we need to get, the array of waiting time for each packet, the array
%of drop for each packet.
