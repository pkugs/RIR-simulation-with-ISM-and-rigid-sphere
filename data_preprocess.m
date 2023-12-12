function [ ht ] = data_preprocess( data )
%   将从二进制文件中读取的冲激响应转换成正确的格式
%   此处显示详细说明
    row = length(data)/5;
    ht = zeros(row, 5);
    for i=1:row
        ht(i,:) = data((i-1)*5+1:i*5);
    end
    ht = sortrows(ht, 1);  % 按时间到达顺序排序，第一行为直达声
end

