function [ep, odata] = clust_panel_timeseries(ep0, tlen, ep, data, opts)

% [ep, odata] = clust_panel_timeseries(ep0, tlen, ep, data, opts)
%
% Plots generic time-series data in a form compatible with other panels
%
% Options (opts)
%  opts.yaxis         - two element vector [Ymin Ymax]
%  opts.show_xlabel   - if true, show label on X axis [def= 1]
%  opts.time_seconds  - if true, time axis is labeled in seconds
%                       otherwise datetick is used. [def = 0]
%  opts.colors        - line colors [def = 'krgb']
%  opts.line_style    - line style [matlab string - e.g. '*-']
%  opts.log_y         - if true, use log Y axis [def=0]
%  opts.convert_with_flow_speed - use flow speed to comnvert time to distance [def=0]
%  opts.time_shift    - shift time axis by X seconds [def=0]
%

% default parameters
yaxis = [];
log_y = 0;
show_xlabel = 1;
time_datenum = 1;
ccolor = 'krgbym';
line_style = [];
show_xticks = 1;
tshift = 0;
% convert time to space
flowspeed = 0;

if isempty(ep) || isempty(data)
    fprintf(1,'No data for this panel\n');
    plot(0);
    odata = [];
    return;
end

if exist('opts','var') && ~isempty(opts)
	if isfield(opts,'yaxis')
		yaxis = opts.yaxis;
	end
	if isfield(opts,'show_xlabel')
		show_xlabel = opts.show_xlabel;
    end
    if isfield(opts,'show_xticks')
		show_xticks = opts.show_xticks;
    end
	if isfield(opts,'time_seconds')
		time_datenum = ~opts.time_seconds;
	end
	if isfield(opts,'colors')
		ccolor = opts.colors;
    end
    if isfield(opts,'line_style')
		line_style = opts.line_style;
    end
    if isfield(opts,'log_y')
		log_y = opts.log_y;
    end
    if isfield(opts,'time_shift')
		tshift = opts.time_shift;
    end
    if isfield(opts,'convert_with_flow_speed')
		flowspeed = opts.convert_with_flow_speed;
	end
end

ep = ep + tshift/86400;

ep_start = ep0;
if (flowspeed)
    xx = flowspeed*(ep - ep0)*86400;
else    
    if (~time_datenum)
        % create time axis in seconds
        ep = (ep - ep0)*86400;
        ep0 = 0;
        ep1 = tlen;
    else
        ep1 = ep0 + tlen/86400;
    end
end

   
ncomp = size(data,1);
if (log_y)
    semilogy(ep, data(1,:),[ccolor(1), line_style]);
else
    if (flowspeed)
        plot(xx, data(1,:),[ccolor(1), line_style]);
    else
        plot(ep, data(1,:),[ccolor(1), line_style]);
    end
end
if (ncomp > 1)
	for i=2:ncomp
        hold on;
        if (flowspeed)
            plot(xx, data(i,:),[ccolor(i), line_style]);
        else
            plot(ep, data(i,:), [ccolor(i), line_style]);
        end
        hold off;
	end
end

set(gca,'FontSize',12);
if ~isempty(yaxis)
	ylim(yaxis);
end

if (0 == flowspeed)    
    if (~show_xticks)
        set(gca, 'XTick',[]);
    elseif (time_datenum)
        datetick;
    end
else
%    plot(xx, data(i,:),[ccolor(i), line_style]);
    ax = gca;
    ax.XRuler.Exponent = 0;
end

if (flowspeed)
else
    xlim([ep0 ep1]);
end

if (show_xlabel)
    if (flowspeed)
        xlabel('distance [km]','FontSize',12);
    else
        if time_datenum
            if (tshift == 0)
                xlabel(sprintf('UT %s',datestr(ep_start,1)),'FontSize',12);
            else
                xlabel(sprintf('UT %s [shifted by %d sec]',datestr(ep_start,1), tshift),'FontSize',12);
            end
        else
            xlabel('time [seconds]','FontSize',12);
        end
    end
end

