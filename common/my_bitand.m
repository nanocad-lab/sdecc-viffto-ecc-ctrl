function [out] = my_bitand(bin1,bin2)
% Perform the bitwise-and (AND) operation on two binary strings comprised of '0' and '1' characters. Argument sizes must be matched.
%
% Arguments:
%   bin1 --   String of k characters, where each is either '0' or '1'.
%   bin2 --   String of k characters, where each is either '0' or '1'.
%
% Returns:
%   out --   String of k characters, where each is either '0' or '1' and are computed as bitwise-AND of bin1 and bin2. Upon error, out is set to a string of k 'X'es if bin1 and bin2 are matched lengths, and a single 'X' otherwise.
%
% Author: Mark Gottscho
% Email: mgottscho@ucla.edu

%% Input dimension check
% commented out for speed
%if size(bin1) ~= size(bin2)
%    out = 'X';
%    return;
%end

k = size(bin1,2);

%% Check input validity to ensure each character is either '0' or '1' and no other value
% commented out for speed
%if (sum(bin1== '1')+sum(bin1== '0')) ~= size(bin1,2)
%    out = repmat('X',1,k);
%    return;
%end
%
%if (sum(bin2== '1')+sum(bin2== '0')) ~= size(bin2,2)
%    out = repmat('X',1,k);
%    return;
%end

%% Truth table using characters as inputs
out = bin1;
for i=1:size(bin1,2)
    if bin2(i) == '0'
        out(i) = '0';
    end
    %else % Error
    %    out = repmat('X',1,k);
    %    return;
    %end
end

end

