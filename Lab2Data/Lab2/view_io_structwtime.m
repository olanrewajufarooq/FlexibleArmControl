function view_io(op)
% Save "ScopeData" to a .mat file
% To load a selected .mat file: save_data(1)

% Sept2023 JG

if nargin<1
    op= -1; %1; %0;
end

switch op
    case -1, show_data_in_workspace
    case {'save', 0}, save_data_to_mat_file
    case {'load', 1}, load_data_from_mat_file
    otherwise
        error('inv op')
end


function show_data_in_workspace
str= 'exist(''ScopeData'', ''var'')';
if ~evalin('base', str)
    % ask to download, or quit
    str= {'No data in the workspace to show.', ' Load data from file?'};
    str= questdlg(str, 'load data?', 'Yes','No','No');
    if ~strcmp(str, 'Yes')
        return
    else
        load_data_from_mat_file
    end
end

ScopeData= evalin('base', 'ScopeData')

figure(201); clf
plot(ScopeData.time, ScopeData.signals.values);
leg= {'ref'};
for i= 3:size(ScopeData.signals.values,2)
    leg{end+1}= sprintf('input %d', i-2);
end
xlabel('time [sec]');
legend(leg)


function save_data_to_mat_file
%pcname= getenv('COMPUTERNAME');
ScopeData= evalin('base', 'ScopeData');
%fname= mkfname(['ScopeData_' pcname '_'], 'mat', struct('outputFormat',2) );
fname = mkfname(['ScopeData_'], 'mat', struct('outputFormat',2) );
save( fname, 'pcname', 'ScopeData' )


function load_data_from_mat_file
[fname, pname]= uigetfile('*.mat');
load([pname fname], 'ScopeData');
assignin('base', 'ScopeData', ScopeData);
return


function fname= mkfname( basePath, extension, options )
%
% function fname= mkfname( basePath, extension, options )
%
% Create a filename based on the current date.
%
% The base name has the form yymmddtn (yy = year, mm = month,
%  dd = day, t = character t, n = number >=1) and is
%  prefixed with basePath and sufixed with
%  ['.' extension]
%
% If the generated file name already exists,
%   then mkfname increments n to generate a new filename
%
% Usage examples:
%   fname= mkfname
%   fname= mkfname( 'path/' )
%   fname= mkfname( 'path/', 'jpg')
%   fname= mkfname( 'prefix', 'jpg')
%   fname= mkfname( 'path/', 'jpg', struct('outputFormat',2) )
%   fname= mkfname( 'path/', 'jpg', struct('outputFormat',3) )
%   fname= mkfname( 'fname.mat', '', struct('baseHasExt',1) )
%
% Results of the usage examples (date= 18-Jun-2004, time= 01:23:45):
%   '040618t1', 'path/040618t1', 'path/040618t1.jpg', 'path/040618_012345.jpg'

% The first implementation was:
%
% The base name has the form yymmddab (yy = year, mm = month,
%  dd = day, a = f(hour), b = f(minute)) and is
%  prefixed with basePath and sufixed with
%  ['.' extension]
% e.g. '990701ua' (u codify the hour and a codify the minute)
%

% 12/8/99, 18/6/04 (doc++), 2020.09.03 (options), J. Gaspar

if nargin<1,
    basePath= [];
end
if nargin<2,
    extension= [];
end
if nargin<3
    options= [];
end

outputFormat= 1;
if isfield(options, 'outputFormat')
    outputFormat= options.outputFormat;
end
if isfield(options, 'baseHasExt') && options.baseHasExt
    [p, f, extension]= fileparts( basePath );
    basePath= strrep(basePath, extension, '');
end

if ~isempty(extension) && isempty(find(extension=='.', 1))
    extension= ['.' extension];
end

% make the filename using the current time
[y,m,d,h,mi,s]= datevec(now); n=1;

while 1,
    switch outputFormat
        case 1
            % original idea makes wrong ordering
            %str= sprintf('%02d%02d%02d%c%c', ...
            %    rem(y,100), m, d, char(97+h), codeMi(mi));
            
            % yymmddt1, yymmddt2, ...
            str= sprintf('%02d%02d%02dt%d', ...
                rem(y,100), m, d, n);
            
        case {2, 3}
            % yymmdd_hhmmss, yymmdd_hhmmss(1), ...
            if outputFormat==2
                str= sprintf('%02d%02d%02d_%02d%02d%02d', ...
                    rem(y,100), m, d, h, mi, round(s));
            else
                % do not include secs: yymmdd_hhmm, yymmdd_hhmm(1), ...
                str= sprintf('%02d%02d%02d_%02d%02d', ...
                    rem(y,100), m, d, h, mi);
            end
            if n>1
                str= [str '(' num2str(n-1) ')'];
            end
            
        otherwise
            error('invalid outputFormat');
    end
    
    fname= [basePath str extension];
    if ~exist(fname,'file'),
        break;
    else
        % mi= mi+1; % old idea
        n= n+1;
    end
end


% ----- aux function
% function chr= codeMi(mi)
% % mi is in 0..59
% % chr is in abbccdd..zz001122334
% mi= round(mi/2);
% if mi>25,
%    chr= num2str(mi-26);
% else
%    chr= char(97+mi);
% end
