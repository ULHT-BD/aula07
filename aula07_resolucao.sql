USE hr;

-- 2. Qual o tipo de dados que utilizaria para representar:
-- 2.1 Nome próprio e apelido
-- first_name VARCHAR(20)
-- last_name VARCHAR(25)

-- 2.2 NIF, cartao do cidadão, telefone ou código postal
-- nif CHAR(9), extra CHECK(nif REGEXP '[0-9]{9}'); verificar que é composto por 9 digitos entre 0 e 9
-- cc CHAR(8)
-- tel CHAR(9)
-- CP CHAR(7), não é necessário guardar '-' ou CHAR(8) se quisermos guarda-lo CHECK(codigo_postal REGEXP '[0-9]{4}-[0-9]{3}');

-- 2.3 Idade, salário, data de nascimento
-- idade INT, podemos especificar UNSIGNED INT uma vez que é sempre positivo
-- salario FLOAT, podemos verificar que é superior ao salario minimo CHECK(salario > 760) 
-- data_nascimento DATE


-- 3. Para cada uma das alíneas seguintes, escreva a query que permite obter:
-- 3.1 A lista de empregados cujo primeiro nome é David, Peter ou John
SELECT * 
FROM employees e 
WHERE FIRST_NAME in ('David', 'Peter', 'John');

-- 3.2 A lista de empregados cujo primeiro nome começa e acaba com a letra d
SELECT * 
FROM employees e 
WHERE LOWER(FIRST_NAME) LIKE 'd%d';

-- ou com REGEXP
SELECT * 
FROM employees e 
WHERE LOWER(FIRST_NAME) REGEXP '^d.*d$';

-- 3.3 A lista de regiões cujo nome contém três ocorrêncas da letra 'a' (possivel resolver com LIKE ou REGEXP)
SELECT * 
FROM regions r  
WHERE LOWER(REGION_NAME) LIKE '%a%a%a%';

-- ou com REGEXP
SELECT * 
FROM regions r  
WHERE LOWER(REGION_NAME) REGEXP '(.*a){3}.*';

-- 3.4 A lista de países cujo nome contém três ocorrêncas da letra 'a' mas nenhum 'l' (possivel resolver com LIKE ou REGEXP)
SELECT * 
FROM countries c  
WHERE LOWER(COUNTRY_NAME) LIKE '%a%a%a%' AND NOT LOWER(COUNTRY_NAME) LIKE '%l%';

-- ou com REGEXP
SELECT * 
FROM countries c  
WHERE LOWER(COUNTRY_NAME) REGEXP '([^l]*a){3}[^l]*';

-- 4. Para cada uma das alíneas seguintes, escreva a query que permite obter:
-- 4.1 A lista dos nomes de empregados e um número id aleatório
SELECT CEIL(RAND()*1000000) id_aleatorio, FIRST_NAME
FROM employees e ;

-- 4.2 A lista dos nomes de empregados e respetivo salário com bonificação de 6% arredondado com duas casas décimais
SELECT FIRST_NAME, ROUND(SALARY*1.06,2) SALARIO_BONIFICADO
FROM employees e ;

-- 4.3 Os empregados cujo nome é David, com um número id aleatório e salário com bonificação de 6% arredondado com duas casas décimais
SELECT CEIL(RAND()*1000000) id_aleatorio, FIRST_NAME, ROUND(SALARY*1.06,2) SALARIO_BONIFICADO
FROM employees e 
WHERE FIRST_NAME = 'David';


-- 5. Para cada uma das alíneas seguintes, escreva a query que permite obter:
-- 5.1 Obter a lista de todos os nomes próprios em minúsculas e apelidos em maiúsculas
SELECT LOWER(FIRST_NAME), UPPER(LAST_NAME)
FROM employees e ;

-- 5.2 Obter a lista de todos os nomes completos concatenando primeiro nome e último nome, bem como um email no formato primeiro_nome.ultimo_nome@ulusofona.pt
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) FULL_NAME, LOWER(CONCAT(FIRST_NAME, '.', LAST_NAME, '@ulusofona.pt')) EMAIL
FROM employees e ;

-- 5.3 Obter a lista de nomes, apelidos e uma terceira coluna com as iniciais (e.g. Teresa, Carvalho, TC)
SELECT FIRST_NAME, LAST_NAME, CONCAT(SUBSTR(FIRST_NAME, 1, 1), SUBSTR(LAST_NAME, 1, 1)) NAME_INITIALS 
FROM employees e ;


-- 6. Para cada uma das alíneas seguintes, escreva a query que permite obter:
-- 6.1 Duas colunas com qual a data atual e qual a hora atual. (experimente tambéma função NOW)
SELECT CURDATE() data_atual, CURTIME() hora_atual, NOW() data_hora_atual;  

-- 6.2 A lista de todos os nomes de empregados e ano de data de contratação
SELECT FIRST_NAME, YEAR(HIRE_DATE)
FROM employees e ;

-- 6.3 O número de dias passados desde que o empregado foi contratado até hoje
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DATEDIFF(NOW(), HIRE_DATE) HIRED_SINCE_DAYS
FROM employees e ;

