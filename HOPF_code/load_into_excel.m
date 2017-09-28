fileName = 'C:\Users\DELL\Desktop\result_excel\NTU2021.xlsx';
writetable(parameter,fileName,'Range','A1');
%xlswrite(fileName,[precision{end,1}],'Sheet1','A3');
writetable(cell2table(precision),fileName,'Range','A3');