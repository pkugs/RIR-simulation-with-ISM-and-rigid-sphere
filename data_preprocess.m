function [ ht ] = data_preprocess( data )
%   ���Ӷ������ļ��ж�ȡ�ĳ弤��Ӧת������ȷ�ĸ�ʽ
%   �˴���ʾ��ϸ˵��
    row = length(data)/5;
    ht = zeros(row, 5);
    for i=1:row
        ht(i,:) = data((i-1)*5+1:i*5);
    end
    ht = sortrows(ht, 1);  % ��ʱ�䵽��˳�����򣬵�һ��Ϊֱ����
end

