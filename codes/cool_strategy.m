function simObj =cool_strategy(simObj, lambda,k,lambda_0)
    % Pick best-performing stocks each period
    [a,n] = mapl2a(lambda, simObj.d, k, lambda_0);
    b = 1-a;
    if nargin<2
        lambda = 0.5;
    end
    simObj.reset(); % reset simulation environment   
    for x=1:simObj.T
        if x==1
            w_const = ones(simObj.d,1)/simObj.d;
            simObj.step(w_const);
        end
        if x>1
            w = zeros(simObj.d,1);
            [~, sortedInds] = sort(simObj.s_cur(:),'descend');
            w(sortedInds(1:n))=a/n;
            w(sortedInds(n+1:end))=b/(simObj.d-n);
            w = w / sum(w);
            simObj.step(w);
        end          
    end
end

function [a,n] = mapl2a(lambda, d, k, lambda_0)
    n = mapl2n(lambda,d, k, lambda_0);
    if lambda < lambda_0
        a = 1+((-1+n/d)/(lambda_0))*lambda;
    else
        a=n/d;
    end
end

function n = mapl2n(lambda, d, k,lambda_0)
    n = round(1+((d-1)/(1+exp(-k*(lambda-lambda_0)))));
end