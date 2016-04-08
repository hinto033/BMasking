function test
B=rand(576,576,150);

fig=figure(100);
set(fig,'Name','Image','Toolbar','figure',...
    'NumberTitle','off')
% Create an axes to plot in
axes('Position',[.15 .05 .7 .9]);
% sliders for epsilon and lambda
slider1_handle=uicontrol(fig,'Style','slider','Max',150,'Min',1,...
    'Value',2,'SliderStep',[1/(150-1) 10/(150-1)],...
    'Units','normalized','Position',[.02 .02 .14 .05]);
uicontrol(fig,'Style','text','Units','normalized','Position',[.02 .07 .14 .04],...
    'String','Choose frame');
% Set up callbacks
vars=struct('slider1_handle',slider1_handle,'B',B);
set(slider1_handle,'Callback',{@slider1_callback,vars});
plotterfcn(vars)
% End of main file

% Callback subfunctions to support UI actions
function slider1_callback(~,~,vars)
    % Run slider1 which controls value of epsilon
    vars.slider1_handle
    plotterfcn(vars)

function plotterfcn(vars)
    % Plots the image
    imshow(vars.B(:,:,get(vars.slider1_handle,'Value')));
    title(num2str(get(vars.slider1_handle,'Value')));