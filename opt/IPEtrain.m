function [IPE] = IPEtrain(L,Proj,k,method,params)
%TRAINIPEMODEL Train an informative projection ensemble
    switch lower(method)
        case 'ilp'
            csvwrite('loss.csv',L);
            status = system(['./optimize_selection.sh ',num2str(k)]);
            if status>0
                error('Could not run selection ILP.')
            end
            B = csvread('selection.csv');
        case 'ripr'
            B = OptimizeSelectionRIPR(L, params.lambda);
        %case '2step'
        case 'greedy'
            B = OptimizeSelectionGreedy(L, k);
        otherwise
            error('Invalid method argument. Please specify ILP, RIPR or greedy'); 
    end
    [B] = CorrectDuplicateSelection(B);
    IPE = struct;
    IPE.AllProj = Proj;
    IPE.L = L;
    IPE.B = B;
end
