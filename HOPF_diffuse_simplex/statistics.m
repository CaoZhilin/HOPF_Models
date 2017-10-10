fileDirectory = 'C:\Users\DELL\Desktop\ntu2000experiment\20-10-mu50-01h\';
fileName = 'C:\Users\DELL\Desktop\ntu2000experiment\h20-10-50-01.xlsx';
files = dir(fileDirectory);
percision_list =zeros(10,10); %zeros(10,10);
%fid_title = table('');
for i = 1:100%100
    load([fileDirectory files(i+2).name]);
    if i == 1
       writetable(parameter,fileName,'Range','A1');
    end
    round = mod(i,10);
    if round == 0
        round = 10;
    end
    percision_list(parameter.fid_num,round)=precision{end,1};
    %disp(percision_list(6,:));
    %place = [char(int16('A')+persent) num2str(4+round)];
    %xlswrite(fileName,[precision{end,1}],'Sheet1',place);
end
fid_5_persent =  mean(percision_list(1,:));
fid_10_persent = mean(percision_list(2,:));
fid_20_persent = mean(percision_list(3,:));
fid_30_persent = mean(percision_list(4,:));
fid_40_persent = mean(percision_list(5,:));
fid_50_persent = mean(percision_list(6,:));
fid_60_persent = mean(percision_list(7,:));
fid_70_persent = mean(percision_list(8,:));
fid_80_persent = mean(percision_list(9,:));
fid_90_persent = mean(percision_list(10,:));
percision_table = table(fid_5_persent,fid_10_persent,fid_20_persent,fid_30_persent,fid_40_persent,fid_50_persent, ...
    fid_60_persent,fid_70_persent,fid_80_persent,fid_90_persent);
writetable(percision_table,fileName,'Range','A3');