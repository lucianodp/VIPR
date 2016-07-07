function mat2csv(filename)
%MAT2CSV Summary of this function goes here
%   Detailed explanation goes here
    load(filename);
    D = [X,Y];
    filename = strrep(filename,'.mat','.csv'); 
    f = fopen(filename,'w');
    header = cellfun(@(x) [x ', '], Features, 'UniformOutput', false);
    header = cell2mat(header);
    header(end-1:end) = [];
    fprintf(f,'%s\n',header);
    dlmwrite(filename, D, '-append', 'precision', '%.6f', 'delimiter', ',');
    fclose(f);
end