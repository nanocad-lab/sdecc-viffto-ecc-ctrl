function swd_ecc_offline_data_heuristic_recovery(architecture, benchmark, n, k, num_words, words_per_block, input_filename, output_filename, n_threads, code_type, policy, tiebreak_policy)
% This function iterates over a series of data cache lines that are statically extracted
% from a compiled program that was executed and produced a dynamic memory trace.
% We choose a cache line and word within a cache line randomly.
% The script encodes the data/message in a specified SECDED encoder.
% The script then iterates over all possible 2-bit error patterns on the
% resulting codeword. Each of these 2-bit patterns are decoded by our
% SECDED code and should all be "detected but uncorrectable." For each of
% these 2-bit errors, we flip a single bit one at a time and decode again.
% We should obtain X received codewords that are indicated as corrected.
% These X codewords are "candidates" for the original encoded message.
% The function then tries to determine which of
% the X candidate messages was the most likely one to recover.
%
% Input arguments:
%   architecture --     String: '[mips|alpha|rv64g]'
%   benchmark --        String
%   n --                String: '[39|72]'
%   k --                String: '[32|64]'
%   num_words --        String: '[1|2|3|...]'
%   words_per_block --  String: '[1|2|3|...]'
%   input_filename --   String
%   output_filename --  String
%   n_threads --        String: '[1|2|3|...]'
%   code_type --        String: '[hsiao1970|davydov1991]'
%   policy --           String: '[hamming|longest_run|delta]'
%   tiebreak_policy --String: '[pick_first|pick_last|pick_random]'
%
% Returns:
%   Nothing.
%
% Author: Mark Gottscho
% Email: mgottscho@ucla.edu

architecture
benchmark
n = str2num(n)
k = str2num(k)
num_words = str2num(num_words)
words_per_block = str2num(words_per_block)
input_filename
output_filename
n_threads = str2num(n_threads)
code_type
policy
tiebreak_policy

r = n-k;

if ~isdeployed
    addpath ecc common rv64g % Add sub-folders to MATLAB search paths for calling other functions we wrote
end

%% Read data as hex-strings from file.

% Because the file may have a LOT of data, we don't want to read it into a buffer, as it may fail and use too much memory.
% Instead, we get the number of instructions by using the 'wc' command, with the assumption that each line in the file will
% contain a cache line.
display('Reading inputs...');
[wc_return_code, wc_output] = system(['wc -l ' input_filename]);
if wc_return_code ~= 0
    display(['FATAL! Could not get line count (# cache lines) from ' input_filename '.']);
    return;
end
total_num_cachelines = str2num(strtok(wc_output));
display(['Number of randomly-sampled words to test SWD-ECC: ' num2str(num_words) '. Total cache lines in trace: ' num2str(total_num_cachelines) '.']);

%% Randomly choose cache lines from the trace, and load them
rng('shuffle'); % Seed RNG based on current time
sampled_cacheline_indices = sortrows(randperm(total_num_cachelines, num_words)'); % Randomly permute the indices of cachelines. We will choose the first num_words of the permuted list to evaluate. Then, from each of these cachelines, we randomly pick one word from within it.
sampled_blockpos_indices = randi(words_per_block, 1, num_words); % Randomly generate the block position within the cacheline

fid = fopen(input_filename);
if fid == -1
    display(['FATAL! Could not open file ' input_filename '.']);
    return;
end

% Loop over each line in the file and read it.
% Only save data from the line if it matches one of our sampled indices.
sampled_trace_raw = cell(num_words,1);
j = 1;
for i=1:total_num_cachelines
    line = fgets(fid);
    if strcmp(line,'') == 1 || j > size(sampled_cacheline_indices,1)
        break;
    end
    if i == sampled_cacheline_indices(j)
        sampled_trace_raw{j,1} = line;
        j = j+1;
    end
end
fclose(fid);

%% Parse the raw trace
% It is in CSV format, as output by our memdatatrace version of RISCV Spike simulator of the form
% STEP,OPERATION,MEM_ACCESS_SEQ_NUM,VADDR,PADDR,USER_PERM,SUPER_PERM,ACCESS_SIZE,PAYLOAD,CACHE_BLOCKPOS,CACHE_BLOCK0,CACHE_BLOCK1,...,
% like so:
% 1805000,D$ RD fr MEM,1898719,VADDR 0x0000000000001718,PADDR 0x0000000000001718,u---,sRWX,4B,PAYLOAD 0x63900706,BLKPOS 3,0x33d424011374f41f,0x1314340033848700,0x0335040093771500,0x63900706638e0908,0xeff09ff21355c500,0x1315a50013651500,0x2330a4001355a500,0x1b0979ff9317c500,
% ...
% NOTE: memdatatrace payloads and cache blocks are in NATIVE byte order for
% the simulated architecture. For RV64G this is LITTLE-ENDIAN!
% NOTE: we only expect data cache lines to be in this file!
% NOTE: addresses and decimal values in these traces are in BIG-ENDIAN
% format.
sampled_trace_step = cell(num_words,1);
sampled_trace_operation = cell(num_words,1);
sampled_trace_seq_num = cell(num_words,1);
sampled_trace_vaddr = cell(num_words,1);
sampled_trace_paddr = cell(num_words,1);
sampled_trace_user_perm = cell(num_words,1);
sampled_trace_supervisor_perm = cell(num_words,1);
sampled_trace_payload_size = cell(num_words,1);
sampled_trace_payload = cell(num_words,1);
sampled_trace_demand_blockpos = cell(num_words,1);
sampled_trace_cachelines_hex = cell(num_words,words_per_block);
sampled_trace_cachelines_bin = cell(num_words,words_per_block);
for i=1:num_words
    remain = sampled_trace_raw{i,1};
    [sampled_trace_step{i,1}, remain] = strtok(remain,',');
    [sampled_trace_operation{i,1}, remain] = strtok(remain,',');
    [sampled_trace_seq_num{i,1}, remain] = strtok(remain,',');
    [sampled_trace_vaddr{i,1}, remain] = strtok(remain,',');
    [sampled_trace_paddr{i,1}, remain] = strtok(remain,',');
    [sampled_trace_user_perm{i,1}, remain] = strtok(remain,',');
    [sampled_trace_supervisor_perm{i,1}, remain] = strtok(remain,',');
    [sampled_trace_payload_size{i,1}, remain] = strtok(remain,',');
    [sampled_trace_payload{i,1}, remain] = strtok(remain,',');
    [sampled_trace_demand_blockpos{i,1}, remain] = strtok(remain,',');
    for j=1:words_per_block
        [block, remain] = strtok(remain,',');
        sampled_trace_cachelines_hex{i,j} = block(3:end);
        sampled_trace_cachelines_bin{i,j} = my_hex2bin(sampled_trace_cachelines_hex{i,j});
    end
end

%% Construct a matrix containing all possible 2-bit error patterns as bit-strings.
display('Constructing error-pattern matrix...');
num_error_patterns = nchoosek(n,2);
error_patterns = repmat('0',num_error_patterns,n);
num_error = 1;
for i=1:n-1
    for j=i+1:n
        error_patterns(num_error, i) = '1';
        error_patterns(num_error, j) = '1';
        num_error = num_error + 1;
    end
end

results_candidate_messages = NaN(num_words,num_error_patterns); % Init
success = NaN(num_words, num_error_patterns); % Init
could_have_crashed = NaN(num_words, num_error_patterns); % Init
success_with_crash_option = NaN(num_words, num_error_patterns); % Init
verbose_recovery = '0';

display('Evaluating SWD-ECC...');

%% Set up parallel computing
pctconfig('preservejobs', true);
mypool = parpool(n_threads);

%% Do the hard work
parfor i=1:num_words % Parallelize loop across separate threads, since this could take a long time. Each word is a totally independent procedure to perform.
    %% Get the cacheline and "message," which is the original word, i.e., the ground truth from input file.
    cacheline_hex  = sampled_trace_cachelines_hex(i,:);
    cacheline_bin  = sampled_trace_cachelines_bin(i,:);
    message_hex = cacheline_hex{sampled_blockpos_indices(i)};
    message_bin = cacheline_bin{sampled_blockpos_indices(i)};
    
    %% Iterate over all possible 2-bit error patterns.
    for j=1:num_error_patterns
        error = error_patterns(j,:);

        %% Do heuristic recovery for this message/error pattern combo.
        [original_codeword, received_string, num_candidate_messages, recovered_message, suggest_to_crash, recovered_successfully] = data_recovery('rv64g', num2str(n), num2str(k), message_bin, error, code_type, policy, tiebreak_policy, cacheline_bin, sampled_blockpos_indices(i), verbose_recovery);

        %% Store results for this message/error pattern pair
        results_candidate_messages(i,j) = num_candidate_messages;
        success(i,j) = recovered_successfully;
        could_have_crashed(i,j) = suggest_to_crash;
        if suggest_to_crash == 1
            success_with_crash_option(i,j) = ~success(i,j); % If success is 1, then we robbed ourselves of a chance to recover. Otherwise, if success is 0, we saved ourselves from corruption and potential failure!
        else
            success_with_crash_option(i,j) = success(i,j); % If we decide not to crash, success rate is same.
        end
    end

    %% Progress indicator
    % This will not show accurate progress if the loop is parallelized
    % across threads with parfor, since they can execute out-of-order
    display(['Completed word # ' num2str(i) ' is index ' num2str(sampled_cacheline_indices(i)) ' cacheline in the program, block position ' num2str(sampled_blockpos_indices(i)) '. hex: ' message_hex]);
end

%% Save all variables
display('Saving outputs...');
save(output_filename);
display('Done!');

%% Shut down parallel computing pool
delete(mypool);

end
