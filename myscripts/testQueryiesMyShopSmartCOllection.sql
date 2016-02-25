select p.id as Product, p.user_id as User , p.created_at ,
        @user_sampling := IF(@curr_user = p.user_id,@user_sampling + 1, 1) AS user_sample,
        @curr_user :=  p.user_id
from treasureProduct.products p
INNER JOIN accounts.users u
ON p.user_id = u.id AND u.created_at > '2015-09-30 11:41:31 +0530'
order by p.user_id ASC,RAND()


select p.id as Product, p.user_id as User , p.created_at ,
        @user_sampling := IF(@curr_user = p.user_id,@user_sampling + 1, 1) AS user_sample,
        @curr_user :=  p.user_id as curr_user
from (select pd.*
      from treasureProduct.products pd
      INNER JOIN accounts.users u
      ON pd.user_id = u.id AND u.created_at > '2015-09-30 11:41:31 +0530'
      order by pd.user_id ASC,RAND()) p
 


BEST :-

select t.id as Product, t.user_id as User , t.created_at , t.user_sample
from (select p.*,
        @user_sampling := IF(@curr_user = p.user_id,@user_sampling + 1, 1) AS user_sample,
        @curr_user :=  p.user_id as curr_user
        from (select pd.*
              from treasureProduct.products pd
              INNER JOIN accounts.users u
              ON pd.user_id = u.id AND u.created_at > '2015-10-17 13:41:41 +0530'
              order by pd.user_id ASC,RAND()) p) t
where user_sample <= 3;

def my_sql
result = Product.find_by_sql("select t.* , t.user_sample
from (select p.*,
        @user_sampling := IF(@curr_user = p.user_id,@user_sampling + 1, 1) AS user_sample,
        @curr_user :=  p.user_id as curr_user
        from (select pd.*
              from treasureProduct.products pd
              INNER JOIN accounts.users u
              ON pd.user_id = u.id AND u.created_at > '2015-9-1 20:07:47 +0530' 
              INNER JOIN sellerdata.responsive_scores s 
              ON pd.user_id = s.user_id AND s.score > 50
              order by pd.user_id ASC,RAND()) p) t
where user_sample <= 1;").shuffle
end


def my_rails
   result = []
      Product.joins(:user,:score).where("users.created_at > '2015-9-1 20:07:47 +0530' and score > 50").select("distinct products.user_id").each do |p|
        result << Product.where("user_id = ?",p.user_id).sample(1)
      end

      max_arr = result.max_by(&:length)
      result -= [max_arr]
    bad = max_arr.zip(*result).flatten.compact
 end


 def my_rails_split
   result = []
   users = User.where("created_at > '2015-9-1 20:07:47 +0530'")
      users.each do |u|
        result << Product.where("user_id = ?",u.id).sample(1)
      end

      max_arr = result.max_by(&:length)
      result -= [max_arr]
      bad = max_arr.zip(*result).flatten.compact
 end

2015-9-1 20:07:47 +0530  sample =1 10k products
 a = my_sql 8:29:20 - 8:30:32 1min,12sec

 b = my_rails 8:30:45  - 8:32:40  1min,55sec

 c= my_rails_split 8:33:20 - 8:38:37 5min,17sec

