clear;
clc;



Q_r1 = 5;
Q_r2 = 5;
Q_r3 = 5;   % initially all bufferes are full.

Q1_max = 5;
Q2_max = 5;
Q3_max = 5; % Max size of buffers.

lambda1 = 3.5;
lambda2 = 3.5;
lambda3 = 3.5;

eta = 0.6;

C = 10; % initial consumption.

state = [C,Q_r1,Q_r2,Q_r3]; % initial state construction

index = 1; % initial index;

max_prod =5;

Q = zeros(648,6,6,6,6); % Q-function to be updated.

total_iterations = 1000050;

iter = 1;

total_production = 0;


Y(1) = 0;
Y(2)=0;
Y(3) = 0;
gamma(1) = 0;
gamma(2) = 0;
gamma(3) = 0;

a = 1;
c= 1;
tot =0;
rew = 0;

while iter < total_iterations
    
    
  
        
    
if iter > 1000000
fprintf('\n %d %d %d %d',C,Q_r1,Q_r2,Q_r3);
end

 
    
    
 % Get new state index
 

 
 % Get feasible set of actions.
 
 temp =1;
 
 for l = max_prod:-1:0
   for i = 0:Q_r1
       for j = 0:Q_r2
          for k = 0:Q_r3
             
                 
                 actionspace(temp,:) = Q(index,i+1,j+1,k+1,l+1);
                 action1(temp,:) = i;
                 action2(temp,:) = j;
                 action3(temp,:) = k;
                 action4(temp,:) = l;
                 
                 temp = temp +1;
           end
        end
    end
 end
 
p = find(actionspace == 0);

%p(1)
si = size(actionspace,1);

if isempty(p)
   % fprintf('\n yes\n');
  [~,max_ind] = max(actionspace); 
  
  random = randi(si);
  
  if rand() > 0.8
      max_ind = random;
  end
  
  
  % Max action found. Update to softmax.
else
    max_ind = p(1);
end
 
 %Observe that we have taken negative reward.
 
 R = -1*(0.6*(C - (action1(max_ind) + action2(max_ind)+action3(max_ind)+action4(max_ind)))^2 + 0.4*action1(max_ind));
 
 %r = gamma(1)*(Q_r1 - Q1_max) + gamma(2) * (Q_r2 - Q2_max) + gamma(3) * (Q_r3 - Q3_max);
 
 Reward = R;
 
 
 
 % Q-Learning Updates 
 
 
 
 
 % Update Buffers. Possion gives random number of renewable energy.
 
 Q_r1 = Q_r1 - action1(max_ind) + poisson(lambda1);
 Q_r2 = Q_r2 - action2(max_ind) + poisson(lambda2);
 Q_r3 = Q_r3 - action3(max_ind) + poisson(lambda3);
 
 % Limit them, otherwise infinite space to compute.
 
 if Q_r1 > 5
     Q_r1 = 5;
 end
 
  if Q_r2 > 5
     Q_r2 = 5;
  end
  if Q_r3 > 5
     Q_r3 = 5;
 end
 
 
%  if Q_r1 > Q1_max
%      Q_r1 = Q1_max;
%  end
%  
%  if Q_r2 > Q2_max
%      Q_r2 = Q2_max;
%  end
%  
%  if Q_r3 > Q3_max
%      Q_r3 = Q3_max;
%  end
%  
 
 total_production = total_production + action4(max_ind);
 

iter = iter + 1;

new_cons = getConsumption(C);  


 vector = [new_cons,Q_r1,Q_r2,Q_r3];
 
 ind = find(ismember(state,vector,'rows')); 
 
 if isempty(ind) 
 
     index2 = size(state,1)+ 1;
     state(index2,:) = vector;
     
 else
     
     index2 = ind;
 
 end



Q(index,action1(max_ind)+1,action2(max_ind)+1,action3(max_ind)+1,action4(max_ind)+1) = Q(index,action1(max_ind)+1,action2(max_ind)+1,action3(max_ind)+1,action4(max_ind)+1) + eta *(Reward + max(max(max(max(Q(index2,:,:,:,:))))) - Q(index,action1(max_ind)+1,action2(max_ind)+1,action3(max_ind)+1,action4(max_ind)+1));  

% Y(1) = Y(1) + a *(Q_r1 - Y(1));
% Y(2) = Y(2) + a *(Q_r2 - Y(2));
% Y(3) = Y(3) + a *(Q_r3 - Y(3));
% 
% gamma(1) = gamma(1) + c* (Y(1) - Q1_max);
% gamma(2) = gamma(2) + c* (Y(2)- Q2_max);
% gamma(3) = gamma(3) + c* (Y(3) - Q3_max);
% 
% 
% tot = tot + 1;
% 
% a = 1/ ((tot)^0.55) ;
% c = 1/ (tot) ;

%Q(index,action1(max_ind)+1,action2(max_ind)+1,action3(max_ind)+1,action4(max_ind)+1)

C = new_cons;
index = index2;

if iter > 1000000
%fprintf('\n %d %d %d \n',Q_r1,Q_r2,Q_r3);
fprintf('\n %d %d %d %d',action1(max_ind),action2(max_ind),action3(max_ind),action4(max_ind));
pause;
end

rew = rew + Reward;


clear actionspace;
end

average_reward = rew/total_iterations ;
average_production = total_production/total_iterations ;


%Actual process begins





fprintf('\n Avg.Production and Avg. Reward is %f , %f',average_production,average_reward);





