% Pick samples to maximize information gain
function [idx_info_gain, InfoGain, InfoGain0, InfoGain1] = PickInfoGainSamples(RIPRactModel, RIPRclsTestResults, X, r, d)
    if (r > size(X,1))
        idx_info_gain = true(size(X,1),1);
        InfoGain = zeros(size(X,1),1);
        InfoGain0 = InfoGain;
        InfoGain1 = InfoGain;
    else
        [InfoGain, InfoGainCache, InfoGain0, InfoGain1] = ComputeInfoGain(RIPRactModel.X, RIPRactModel.Y, X, d);
        [sorted, idx] = sort(InfoGain,'descend');
        idx_info_gain = false(size(X,1),1);
        idx_info_gain(idx(1:r)) = true;
    end
end