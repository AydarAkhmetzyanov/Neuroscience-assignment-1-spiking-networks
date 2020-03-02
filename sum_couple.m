function sum = sum_couple(V,arr,ind)
sum=0;
for i=1:length(arr)
    if (i~=ind)
        sum = sum +(-V+arr(i));
    end
end
end