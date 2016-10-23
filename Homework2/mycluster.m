function [ class ] = mycluster( bow, K )
%
% Your goal of this assignment is implementing your own text clustering algo.
%
% Input:
%     bow: data set. Bag of words representation of text document as
%     described in the assignment.
%
%     K: the number of desired topics/clusters. 
%
% Output:
%     class: the assignment of each topic. The
%     assignment should be 1, 2, 3, etc. 
%
% For submission, you need to code your own implementation without using
% any existing libraries

% YOUR IMPLEMENTATION SHOULD START HERE!

initial_prob=1/K; %inital probability

mu_jc = rand(size(bow,2),K); % probability of a word belonging to a specific cluster
b=repmat(sum(mu_jc,2),1,K);
sum_across_rows=repmat(sum(mu_jc,2),1,K);
mu_jc = mu_jc./sum_across_rows;

%mu_jc
%mu_jc = initial_prob * mu_jc; % give equal values to each mu_jc
pi_c=rand(K,1); %probaility that any document derives from this cluster, mixture coefficient of cluster
pi_c=pi_c/sum(pi_c,1);

%pi_c


gamma_c=ones(size(bow,1),K); %for expectation step

mu_jc_updated=ones(size(bow,2),K);
pi_c_updated=ones(K,1);


iter=0;
while(~(isequal(mu_jc,mu_jc_updated) && isequal(pi_c,pi_c_updated)) && iter<1000)
%while(all(abs(mu_jc - mu_jc_updated)>0.0001) && all(abs(pi_c - pi_c_updated)>0.0001))
    iter=iter+1;
    %disp(iter);
    
    mu_jc_updated=mu_jc;
    pi_c_updated=pi_c;

%Expectation Step
    %sum_cluster=zeros(size(bow,1),1);
    
    
    
    
    for i=1:size(bow,1)
      
        for j=1:K
            gamma_c(i,j)=pi_c(j)*prod(mu_jc(:,j)'.^(bow(i,:)));
        end
      %gamma_c(i,:);
        sum_cluster = sum(gamma_c(i,:));
        gamma_c(i,:)=gamma_c(i,:)/sum_cluster;
    end
    
    

%Maximization Step

        %Updating the pi_c
        for i =1:size(pi_c,1)
            pi_c(i)=sum(gamma_c(:,i))/size(gamma_c,1);
        end
        
        %Updating the mu_jc
        %sum_docs=zeros(K,1);
        %for j=1:size(bow,2)
         %   for k=1:K
          %      for i=1:size(bow,1)
           %         mu_jc(j,k)=mu_jc(j,k)+gamma_c(i,k)*bow(i,j);
           %     end
                
           % end
        %end
        %sum_over_rows=sum(mu_jc,2);

        %size(sum_over_rows);
        
        %for i=1:size(bow,2)
         %   mu_jc(i,:)=mu_jc(i,:)/sum_over_rows(i,1);
        %end
        
        for j=1:size(bow,2)
            for c=1:K
                summation=0;
                for i=1:size(bow,1)
                    summation=summation+gamma_c(i,c)*bow(i,j);
                end
                mu_jc(j,c)=summation;
            end
        end
        
        mu_jc_column_sum=sum(mu_jc,1);
        mu_jc=mu_jc./repmat(mu_jc_column_sum,size(bow,2),1);
        
        

end

class =zeros(size(bow,1),1);

for i=1:size(bow,1)
    [M,I]=max(gamma_c(i,:));
    class(i)=I;
end

disp(iter);

end

