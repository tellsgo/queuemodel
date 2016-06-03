classdef Queue <handle
    %QUEUE Summary of this class goes here
    %Detailed explanation goes here
    
    properties 
        capacity = 50; %private or protected
        packet_info;
    end

    properties 
        %would better not.        current_number = 0; %private or protected 
        pointer_queoutend = 1;
        pointer_queinend = 1;
    end
    
    methods
        %add current_number or drop and mark the arriving time or drop
        function Queue_Obj = Queue(packet_info)
            if nargin == 0
                error('Queue must have access to all the packet information'); 
            end
            Queue_Obj.packet_info = packet_info;
        end
        
        function Arrive(Queue_Obj,n , arrive_time)
            for i = 1:n
                if Queue_Obj.Get_Que_Length >= Queue_Obj.capacity
                    Queue_Obj.packet_info(Queue_Obj.pointer_queinend,3) = 1; %drop
                end
                Queue_Obj.packet_info(Queue_Obj.pointer_queinend,1) = arrive_time;
                Queue_Obj.pointer_queinend = Queue_Obj.pointer_queinend+1;
            end
        end
        function Leave(Queue_Obj, n , leave_time)
            k = 1;
            while k<=n
                if Queue_Obj.Get_Que_Length == 0
                    break;
                end
                if Queue_Obj.packet_info(Queue_Obj.pointer_queoutend,3) == 1
                    Queue_Obj.pointer_queoutend = Queue_Obj.pointer_queoutend+1;
                    continue;
                end
                Queue_Obj.packet_info(Queue_Obj.pointer_queoutend,2) = leave_time;
                Queue_Obj.pointer_queoutend = Queue_Obj.pointer_queoutend+1;
                k = k+1;
            end

        end
        function out = Get_Que_Length(Queue_Obj)
            out =1;
            for k = Queue_Obj.pointer_queoutend:Queue_Obj.pointer_queinend
                if Queue_Obj.packet_info(k,3)
                    continue;
                end
                out=out+1;                
            end
            out = out-2;
        end
    end

    
end



