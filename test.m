packet_info = zeros(60,3);
que = Queue(packet_info);

que.Arrive(51,16);
que.Arrive(3,17);
disp('quelength')
que.Get_Que_Length
que.Leave(60,18);
que.Arrive(4,19);
disp('quelength')
que.Get_Que_Length
que.Leave(5,20);
disp('quelength')
que.Get_Que_Length

que.packet_info
que.Get_Que_Length



