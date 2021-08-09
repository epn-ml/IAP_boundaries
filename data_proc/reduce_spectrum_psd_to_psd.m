function sred = reduce_spectrum_psd_to_psd(fin, spec_in, fout)

    delta_f = fin(2)-fin(1);
sred = nan(1,length(fout)-1);
for i=1:length(fout)-1
    ii = find((fin >= fout(i)) & (fin < fout(i+1)));
    if ~isempty(ii)
        sred(i) = sum(spec_in(ii))*delta_f/(fout(i+1)-fout(i));
    end
end



