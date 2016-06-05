%% read data
PSS_data = xlsread('PSS_total.xlsx', 1);
JND_data = xlsread('JND_total.xlsx', 1);
slope_data = 1./(JND_data./(log(3)));

%% draw PSS graph
subplot(3,3,5);
std_table = std(PSS_data)/sqrt(5);
result_table = [PSS_data(1:2); PSS_data(3:4)];
error_table = [std_table(1:2); std_table(3:4)];
barweb(result_table, error_table, [], {'Present';'Absent'}, [], 'Tone Presence', 'PSS(ms)', [], [], {'Left';'Right'});

%% draw JND graph
subplot(3,3,6);
std_table = std(JND_data)/sqrt(5);
result_table = [JND_data(1:2);JND_data(3:4)];
error_table = [std_table(1:2);std_table(3:4)];
barweb(result_table, error_table, [], {'Present';'Absent'}, [], 'Tone Presence', 'JND(ms)', [], [], {'Left';'Right'});

%% draw slope graph
subplot(3,3,4);
std_table = std(slope_data)/sqrt(5);
result_table = [slope_data(1:2);slope_data(3:4)];
error_table = [std_table(1:2);std_table(3:4)];
barweb(result_table, error_table, [], {'Present';'Absent'}, [], 'Tone Presence', 'slope', [], [], {'Left';'Right'});
