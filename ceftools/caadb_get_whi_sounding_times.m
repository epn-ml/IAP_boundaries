function [ep_start, ep_end, snd_len] = caadb_get_whi_sounding_times(ep_start, len, sc)

% [ep_start, ep_end, snd_len] = caadb_get_whi_sounding_times(ep_start, len, sc)
%
% Returns WHISPER density sounding time intervals. Merges 2 closely
% separated intervals into a single one.
% 
% V0.1 JS Aug 2010

product = 'whisper_sounding_times';
toler = 0.5/86400;

[ep, data] = caadb_get_data(ep_start, len, product, sc);

if (isempty(ep))
	ep_start = [];
	ep_end   = [];
	snd_len  = [];
	return;
end

snd_len  = data(1,:);
ep_start = ep - snd_len/86400;
ep_end   = ep + snd_len/86400;

% merge
i2rem = [];
for i=1:length(ep_start)-1
	if ((ep_start(i+1) - ep_end(i))	< toler)
		ep_end(i) = ep_end(i+1);
		snd_len(i) = (ep_end(i) - ep_start(i))*86400;
		i2rem = [i2rem, i+1];
	end
end

if ~isempty(i2rem)
	ep_start(i2rem) = [];
	ep_end(i2rem) = [];
	snd_len(i2rem) = [];
end
