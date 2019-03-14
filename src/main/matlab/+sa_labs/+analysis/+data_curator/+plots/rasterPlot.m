function rasterPlot(epochData, parameter, axes)

% description : Raster plot
% xAxis:
%   default : duration
%   description: Protocol properties can be visualized for above deafault properties
% yAxis:
%   default: "@(epochData) keys(epochData.parentCell.getEpochValuesMap('displayName'))"
%   description: List of protocol name
% ---

import sa_labs.analysis.*;
util.clearAxes(axes);

epochs = epochData.parentCell.epochs;
selectedEpochsIdx = arrayfun(@(epoch) strcmp(epoch.get('displayName'), parameter.yAxis), epochs);
selectedEpochs = epochs(selectedEpochsIdx);

devices = parameter.devices;
axesArray = util.getNewAxesForSublot(axes, numel(devices));
n = numel(devices);

for i = 1 : n
    device = devices{i};
    rasters = getBinnedResponses(selectedEpochs, 2e-3, device);
    
    axes = axesArray(i);
    subplot(n, 1, i, axes);
    pcolor(axes, (rasters'>0)');
    shading(axes, 'flat')
    cMap = 1 - colormap(axes, 'gray');
    colormap(axes, cMap)
    set(axes, 'Layer', 'top')
    set(axes, 'XTick', [], 'YTick', [])
    set(axes, 'XLim', [1, size(rasters, 2)],'YLim', [1, size(rasters, 1)]);
    ylabel(axes, device);
end
xlabel(axes, parameter.xAxis)
title(axesArray(1), ['Raster plot for protocol (' parameter.yAxis ')']);
hold(axes, 'off');
end

function responses = getBinnedResponses(epochs, binWidth, device)
  
  preTime = epochs(1).get('preTime')/1e3;
  stimTime = epochs(1).get('stimTime')/1e3;
  tailTime = epochs(1).get('tailTime')/1e3;
  binEdges = 0:binWidth:(preTime+stimTime+tailTime);
  responses = cell2mat(arrayfun(@(e) histcounts(e.getDerivedResponse('spikeTimes', device)/1e4, binEdges), epochs, 'UniformOutput', false)');
end