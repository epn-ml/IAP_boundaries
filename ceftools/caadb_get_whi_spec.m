function [ep, spec, freq, extras] = caadb_get_whi_spec(ep_start, len, sc)


[ep, dt, meta] = caadb_get_data(ep_start, len, 'whisper_natural', sc);

if (isempty(ep))
    spec = [];
    freq = [];
    extras.overflow = [];
    extras.average  = [];
    extras.antenna  = [];
    return;
end
    

freq = meta.freq_axis{1};
nbin = dt(2,1);

extras.fft_size = dt(1,:);
extras.overflow = dt(5,:);
extras.average  = dt(6,:);
extras.antenna  = dt(4,:);

spec = dt(7:(6+nbin),:);
