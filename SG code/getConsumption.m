function newstate = getConsumption(state)

consVec = [10;15;18];



prob = [0.1 0.5 0.4; 0.3 0.1 0.6; 0.4 0.3 0.3];

if state == 10
    temp = 1;
else if state == 15
        temp = 2;
    else if state == 18
            temp = 3;
        end
    end
end

mat = prob(temp,:);

mat2 = cumsum(mat) ;
x = rand();
%fprintf('\n random is %f\n',x);
temp2 = find(mat2 > x , 1);

newstate = consVec(temp2);


% Fill Markov Process

end