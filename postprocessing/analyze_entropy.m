input_directory = '/Users/mark/Dropbox/SoftwareDefinedECC/data/rv64g/entropy';
output_directory = [input_directory filesep 'postprocessed'];
mkdir(output_directory);

%% Read in data
dir_contents = dir(input_directory);
j=1;
benchmark_filenames = cell(1,1);
benchmark_names = cell(1,1);
for i=1:size(dir_contents,1)
    %if dir_contents(i).isdir || strcmp(dir_contents(i).name, '.') == 1 || strcmp(dir_contents(i).name, '..') == 1 || strcmp(dir_contents(i).name, '.DS_Store') == 1 || size(strfind(dir_contents(i).name,'.log'),1) > 0
    %    continue;
    %end
    
    % Skip all files except those containing '.mat'
    if dir_contents(i).isdir || size(strfind(dir_contents(i).name,'.mat'),1) <= 0
        continue;
    end
    
    benchmark_filenames{j,1} = dir_contents(i).name;
    benchmark_name = benchmark_filenames{j,1};
    [~, remain] = strtok(benchmark_name, '-');
    [benchmark_name, remain] = strtok(remain, '-');
    benchmark_names{j,1} = benchmark_name;
    j = j+1;
end

fig_handles = NaN(size(benchmark_filenames,1),1);
mean_benchmark_entropies = NaN(size(benchmark_filenames,1),1);
for i=1:size(benchmark_filenames,1)
    load([input_directory filesep benchmark_filenames{i}],'entropy');
    mean_benchmark_entropies(i) = mean(entropy);
    figure;
    histogram(entropy,50,'FaceColor','Black','EdgeColor','Black');
    xlim([0 6]);
    set(gca,'XTick',[0:1:6]);
    pos = get(gca,'Position');
    pos(3) = 0.25;
    pos(4) = 0.25;
    set(gca,'Position',pos,'XColor','Black','YColor','Black');
    %title(benchmark_names{i}, 'FontSize', 9, 'FontName', 'Arial');
    xlabel('Mean Intra-Cacheline Entropy (bits/byte)', 'FontSize', 9, 'FontName', 'Arial','Color','Black');
    ylabel('Count', 'FontSize', 9, 'FontName', 'Arial','Color','Black');
    set(gca, 'YTick', []);
    tmp = gcf;
    fig_handles(i) = tmp.Number;
    savefig(gcf,[output_directory filesep 'rv64g-' benchmark_names{i} '-entropy.fig']);
    print(gcf, '-depsc2', [output_directory filesep 'rv64g-' benchmark_names{i} '-entropy.eps']);
end
tilefig(fig_handles);
clear fig_handles;
%close all;
%save([output_directory '/postprocessed.mat'], '-v7.3');
mean_benchmark_entropies