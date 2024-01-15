DROP TABLE IF EXISTS users;
create table users
(
    id       serial
        constraint users_pk
            primary key,
    username VARCHAR(255)
);

DROP TABLE IF EXISTS foods;
create table foods
(
    id     serial
        constraint foods_pk
            primary key,
    name   VARCHAR(255),
    recipe text
);

DROP TABLE IF EXISTS ingredients;
create table ingredients
(
    id             serial
        constraint ingredients_pk
            primary key,
    name           VARCHAR(255),
    price_per_unit decimal(10, 2)
);

DROP TABLE IF EXISTS food_ingredients;
create table food_ingredients
(
    id     serial
        constraint food_ingredients_pk
            primary key,
    food_id int
        constraint food_id
            references foods,
    ingredient_id int
        constraint ingredient_id
            references ingredients,
    amount decimal(10, 2)
);

DROP TABLE IF EXISTS user_ingredients;
create table user_ingredients
(
    id     serial
        constraint user_ingredients_pk
            primary key,
    user_id int
        constraint user_id
            references users,
    ingredient_id int
        constraint ingredient_id
            references ingredients,
    amount decimal(10, 2)
);

DROP TABLE IF EXISTS ratings;
create table ratings
(
    id     serial
        constraint ratings_pk
            primary key,
    user_id int
        constraint user_id
            references users,
    food_id int
        constraint food_id
            references foods,
    rate smallint
);
-- first part
UPDATE foods
SET recipe = REPLACE(recipe, '@hamid_ashpazbashi2', '@hamid_ashpazbashi')
WHERE recipe LIKE '%@hamid_ashpazbashi2%';

-- second part
SELECT foods.id, foods.name, COALESCE(X.rate_count, 0) AS rate_cuont, COALESCE(X.rating, 0) AS rating
FROM (
        SELECT food_id, count(*) AS rate_count, avg(rate) AS rating
        FROM ratings
        GROUP BY food_id
     ) AS X
RIGHT OUTER JOIN foods ON foods.id = X.food_id
ORDER BY COALESCE(X.rating, 0) DESC, COALESCE(X.rate_count, 0) DESC, id DESC;

-- third part
SELECT foods.*, coalesce(total_price, 0) AS total_price
FROM
    (
        SELECT food_ingredients.food_id, SUM(amount * price_per_unit) AS total_price
        FROM food_ingredients
                 JOIN ingredients ON food_ingredients.ingredient_id = ingredients.id
        GROUP BY food_ingredients.food_id
    ) AS X
RIGHT OUTER JOIN foods ON id = food_id
ORDER BY id;

-- forth part
SELECT foods.id
FROM foods
WHERE NOT EXISTS(
    SELECT X.username, X.food_id, X.ingredient_id, X.amount as needed_amount, user_ingredients.amount as owned_amount, user_ingredients.ingredient_id
    FROM(
        SELECT users.username, users.id as user_id, foods.id AS food_id, COALESCE(food_ingredients.ingredient_id, -1) AS ingredient_id, COALESCE(amount, 0) AS amount
        FROM food_ingredients
            RIGHT OUTER JOIN foods ON food_ingredients.food_id = foods.id
            JOIN users ON TRUE
    ) AS X
    LEFT OUTER JOIN  user_ingredients ON user_ingredients.ingredient_id = X.ingredient_id AND user_ingredients.user_id = X.user_id
    WHERE X.food_id = foods.id AND X.username = 'quera' AND ((user_ingredients.amount IS NULL) OR (user_ingredients.amount < X.amount))
)
ORDER BY id DESC;

