%clear;
%n_values = [50, 500];% 5000]% 5000];% 10000, 50000];
%m_values = [5, 10, 20, 50, 100];
%PrecisionTableILP = zeros(numel(n_values), numel(m_values));
%RecallTableILP = zeros(numel(n_values), numel(m_values));
%TimeILP = zeros(numel(n_values), numel(m_values));
%PrecisionTableRIPR = zeros(numel(n_values), numel(m_values));
%RecallTableRIPR = zeros(numel(n_values), numel(m_values));
%TimeRIPR = zeros(numel(n_values), numel(m_values));
%PrecisionTableGreedy = zeros(numel(n_values), numel(m_values));
%RecallTableGreedy = zeros(numel(n_values), numel(m_values));
%TimeGreedy = zeros(numel(n_values), numel(m_values));
for i=2:numel(n_values)
    for j=1:numel(m_values)
        % Generate data and loss matrix
        n = n_values(i); % samples per submodel
        q = 2; % number of submodels
        p = 25; % number of noisy samples
        m = m_values(j); % number of features
        d = 2; % number of relevant features in submodel
        [X,Y,PIcls] = GenerateData4(n,p,m,q,d);
        K = 3; % parameter for k-NN classifiers
        [L, Proj] = ComputeKNNlossMatrix(X,Y,K,d);

        % Solve using ILP
        if (i+j<6)
            tic;
            [IPE] = IPEtrain(L,Proj,q,'ILP');
            TimeILP(i,j) = toc;
            [Precision, Recall] = ComputePrecisionRecall(PIcls,Proj(sum(IPE.B)>0));
            fprintf('ILP Precision: %g\n', Precision);
            fprintf('ILP Recall: %g\n', Recall);
            PrecisionTableILP(i,j) = Precision;
            RecallTableILP(i,j) = Recall;
        end
        
        % Solve using RIPR
        params.lambda = 2;
        tic;
        [IPE] = IPEtrain(L,Proj,q,'RIPR',params);
        TimeRIPR(i,j) = toc;
        [Precision, Recall] = ComputePrecisionRecall(PIcls,Proj(sum(IPE.B)>0));
        fprintf('RIPR Precision: %g\n', Precision);
        fprintf('RIPR Recall: %g\n', Recall);
        PrecisionTableRIPR(i,j) = Precision;
        RecallTableRIPR(i,j) = Recall;
        
        % Solve using greedy
        tic;
        [IPE] = IPEtrain(L,Proj,q,'greedy');
        TimeGreedy(i,j) = toc;
        [Precision, Recall] = ComputePrecisionRecall(PIcls,Proj(sum(IPE.B)>0));
        fprintf('Greedy Precision: %g\n', Precision);
        fprintf('Greedy Recall: %g\n', Recall);
        PrecisionTableGreedy(i,j) = Precision;
        RecallTableGreedy(i,j) = Recall;
        
        save(strrep(['results/ArtificialIPE',datestr(clock, 0),'.mat'],' ','-'));
    end
end