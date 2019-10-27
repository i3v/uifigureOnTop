function wasOnTop = uifigureOnTop( uifig, isOnTop )
%UIFIGUREONTOP allows to trigger uifigure's "Always On Top" state
%
%% INPUT ARGUMENTS:
%
% * uifig    - Matlab uifigure handle, scalar
% * isOnTop  - logical scalar or empty array
%
%
%% USAGE:
%
% * uifigureOnTop(uifigure, true);   - switch on  "always on top"
% * uifigureOnTop(uifigure, false);  - switch off "always on top"
% * uifigureOnTop(uifigure);         - equal to uifigureOnTop( uifigure,true);
% * WasOnTop = uifigureOnTop(...);        - returns boolean value "if figure WAS on top"
% * isOnTop = uifigureOnTop(uifigure,[])  - get "if figure is on top" property
%
% For Matlab windows, created via `hf=figure()` use `WinOnTop()`, see: 
% https://www.mathworks.com/matlabcentral/fileexchange/42252-winontop
%
%% LIMITATIONS:
%
% * java enabled
% * figure must be visible
% * figure's "WindowStyle" should be "normal"
% * figureHandle should not be casted to double, if using HG2 (R2014b+)
%
%
% Based on https://undocumentedmatlab.com/blog/customizing-uifigures-part-1
% Written by Igor.
% i3v@mail.ru
%
% 2019.10.27 - Initial version


%% Parse Inputs

assert(...
          isscalar(  uifig ) &&...
          isa( uifig,'matlab.ui.Figure'),...
          ...
          'uifigureOnTop:Bad_uifig_input',...
          '%s','Provided uifig input is not an uifigure'...
       );

assert(...
            strcmp('on',get(uifig,'Visible')),...
            'uifigureOnTop:FigInisible',...
            '%s','Figure Must be Visible'...
       );

assert(...
            strcmp('normal',get(uifig,'WindowStyle')),...
            'uifigureOnTop:FigWrongWindowStyle',...
            '%s','WindowStyle Must be Normal'...
       );
   
if ~exist('isOnTop','var'); isOnTop=true; end

assert(...
          islogical( isOnTop ) && ...
          isscalar(  isOnTop ) || ...
          isempty(   isOnTop ),  ...
          ...
          'uifigureOnTop:Bad_isOnTop_input',...
          '%s','Provided isOnTop input is neither boolean, nor empty'...
      );

%% Flush the Event Queue of Graphic Objects and Update the Figure Window.
drawnow expose
  
%% Disable warnings and dig into uifigure object
% Using undocumented private properties is the only(?) way through.

% Warning 1:
%    -----
%    Warning: figure JavaFrame property will be obsoleted in a future 
%    release. <...>
%    -----

warn1_id = 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame';
prev_warn1 = warning('query',warn1_id);
clnup1=onCleanup(@() warning(prev_warn1.state,warn1_id));
warning('off',warn1_id);

% Warning 2:
%    -----
%    Warning: Calling STRUCT on an object prevents the object from hiding
%    its implementation details <...>
%    -----
warn2_id = 'MATLAB:structOnObject';
prev_warn2 = warning('query',warn2_id);
clnup2=onCleanup(@() warning(prev_warn2.state,warn2_id));
warning('off',warn2_id);


figProps = struct(uifig); 
delete(clnup1);    


controller = figProps.Controller; 
controllerProps = struct(controller);

if isfield(controllerProps,'Container')
    % older Matlab versions (see Yair's version)
    container = controllerProps.Container;
else
    % works in R2018b
    container = struct(controllerProps.PlatformHost);
end
delete(clnup2);

%% Action
win = container.CEF;
wasOnTop = win.isAlwaysOnTop;

if isempty(wasOnTop)
    wasOnTop = false;
end

if ~isempty(isOnTop)
    win.setAlwaysOnTop(isOnTop);
end

end

