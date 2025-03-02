function [falff_amp] = get_falff_amp_only(timeseries,TR,f0,fc)

timeseries=double(timeseries);
[px,f] = pwelch(timeseries, [], [], [], 1/TR);
nfseries = ((f>=f0)&(f<=fc));
nftotal = (f>=f0);
px1 = sqrt(px);
falff_amp = mean(px1(nfseries, :))./mean(px1(nftotal, :), 1);
% When calculating the normalized ALFF (fALFF), the square root operation is used because the calculation of fALFF requires the ALFF amplitude to be normalized to the entire frequency band to eliminate the power difference between different frequency bands.
% In the normalization process, the use of square root can ensure that when calculating the normalized ALFF amplitude, the power of each frequency band has an equal impact on the result.

% Specifically, the normalized ALFF (fALFF) is the average power spectral density in the f0 to fc frequency band divided by the average power spectral density in the entire frequency band (0 to half the sampling frequency), so the ALFF amplitude needs to be squared.
% This is because in the calculation of power spectral density, the square root operation can convert power to amplitude, thereby retaining the information of amplitude while eliminating the influence of power, so that the amplitudes of different frequency bands can be directly compared. Therefore, the square root operation is necessary when calculating fALFF.