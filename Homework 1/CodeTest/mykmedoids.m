function [ class, centroid ] = mykmedoids( pixels, K )
%
% Your goal of this assignment is implementing your own K-medoids.
% Please refer to the instructions carefully, and we encourage you to
% consult with other resources about this algorithm on the web.
%
% Input:
%     pixels: data set. Each row contains one data point. For image
%     dataset, it contains 3 columns, each column corresponding to Red,
%     Green, and Blue component.
%
%     K: the number of desired clusters. Too high value of K may result in
%     empty cluster error. Then, you need to reduce it.
%
% Output:
%     class: the class assignment of each data point in pixels. The
%     assignment should be 1, 2, 3, etc. For K = 5, for example, each cell
%     of class should be either 1, 2, 3, 4, or 5. The output should be a
%     column vector with size(pixels, 1) elements.
%
%     centroid: the location of K centroids in your result. With images,
%     each centroid corresponds to the representative color of each
%     cluster. The output should be a matrix with size(pixels, 1) rows and
%     3 columns. The range of values should be [0, 255].
%     
%
% You may run the following line, then you can see what should be done.
% For submission, you need to code your own implementation without using
% the kmeans matlab function directly. That is, you need to comment it out.

	%[class, centroid] = kmeans(pixels, K);
    
    
    %initialize clusters
    randomClustersidx= randi([0,size(pixels,1)],K,1);
    randomClusters=pixels(randomClustersidx(:,1),:);
    checkClusters=zeros(K,1);
    class=zeros(size(pixels,1),1);
    maxiterations = 800;
    % 1st step - find the nearest cluster for each data point
    iter=0;
    while ~isequal(randomClusters,checkClusters)&& iter < maxiterations 
        iter=iter+1;
        checkClusters=randomClusters;
        % Expectation Step
%         for i = 1:size(pixels,1)
%         globaldist=Inf(1);
%             for j = 1:K
%                 dist= sqrt(sum((pixels(i,:)-randomClusters(j,:)).^2));
%                 if dist < globaldist
%                     globaldist=dist;
%                     class(i,1)=j;
%                 end
%             end
%         end
        [D, I] = pdist2(randomClusters, pixels, 'euclidean','smallest',1 );
        class = I';
        %Maximization Step
        for i = 1:K
            count=0;
            sumintensity=zeros(1,3);
            idx=find(class==i);
            for j =1:length(idx)
%                if class(j,1)==i
                    sumintensity=sumintensity+pixels(idx(j),:);
                    count=count+1;
            end
                randomClusters(i,:)=sumintensity/count;
                centerdist=inf;
                n=0;
                for k =1:length(idx)
                    dist=sqrt(sum((randomClusters(i,:)-pixels(k,:)).^2));
                    if dist < centerdist
                        centerdist=dist;
                        n=idx(k);
                    end
                end
                randomClusters(i,:)=pixels(n,:);
                    
            end
    end
       centroid=randomClusters;
    disp(iter);

    end
    