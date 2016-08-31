% This script plots the rate of heuristic recovery for a given benchmark/code/instruction sample.
% Each point in the resulting plot is the arithmetic mean rate of recovery for each error pattern, averaged over all instructions that were sampled.
% The colors represent the bit(s) that were in error. If a point has errors in multiple subfields, the last of them in the legend takes color predence.
% The appropriate variables are assumed to already have been loaded in the
% workspace.
%
% Author: Mark Gottscho
% Email: mgottscho@ucla.edu

x = mean(results_candidate_messages);
y = mean(success);

figure;
scatter(x,y,'k');

xlim([0 30]);
ylim([0 1]);

xlabel('Average Number of Candidate Messages', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Average Rate of Recovery', 'FontSize', 12, 'FontName', 'Arial');
title(['Rate of Heuristic Recovery for ' code_type ' -- ' benchmark ' -- ' policy], 'FontSize', 12, 'FontName', 'Arial');

print(gcf, '-depsc2', [output_directory filesep architecture '-' benchmark '-data-heuristic-recovery.eps']);
close(gcf);
    
z=1;
success_2d = NaN(n+1,n+1);
mean_success = mean(success);
for err_bitpos_1=1:n-1
    for err_bitpos_2=err_bitpos_1+1:n
        success_2d(err_bitpos_1,err_bitpos_2) = mean_success(z);
        z=z+1;
    end
end
success_2d(end,:) = NaN;
success_2d(:,end) = NaN;

figure;
pcolor(success_2d);
xlim([1 n]);
ylim([1 n]);

xlabel('Index of 1st bit in error', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Index of 2nd bit in error', 'FontSize', 12, 'FontName', 'Arial');
title(['Rate of Heuristic Recovery for ' code_type ' -- ' benchmark ' -- ' policy], 'FontSize', 12, 'FontName', 'Arial');

print(gcf, '-depsc2', [output_directory filesep architecture '-' benchmark '-data-heuristic-recovery-heatmap.eps']);
close(gcf);



figure;
surf(success_2d);
xlim([1 n]);
ylim([1 n]);
zlim([0 1]);

xlabel('Index of 1st bit in error', 'FontSize', 12, 'FontName', 'Arial');
ylabel('Index of 2nd bit in error', 'FontSize', 12, 'FontName', 'Arial');
zlabel('Average Rate of Heuristic Recovery');
title(['Rate of Heuristic Recovery for ' code_type ' -- ' benchmark ' -- ' policy], 'FontSize', 12, 'FontName', 'Arial');

print(gcf, '-depsc2', [output_directory filesep architecture '-' benchmark '-data-heuristic-recovery-surf.eps']);
close(gcf);