# aula07
Nas aulas anteriores utilizámos a linguagem SQL para efetuar consultas de dados, recuperando dados e efetuando operações sobre estes de forma a obter a informação desejada. Nesta aula olhamos para a cláusula CREATE que permite criar novas relações.
Bom trabalho!

[0. Requisitos](#0-requisitos)

[1. Função IF e CASE](#1-função-if-e-case)

[2. Conversão de Tipos de Dados](#2-conversão-de-tipos-de-dados)

[3. Funções de Agregação](#3-funções-de-agregação)

[4. GROUP BY](#4-group-by)

[5. HAVING](#5-having)

[6. Operações UNION, INTERSECT e MINUS](#6-operações-union-intersect-e-minus)

[7. Trabalho de Casa](#7-trabalho-de-casa)

[Bibliografia e Referências](#bibliografia-e-referências)

[Outros](#outros)

## 0. Requisitos
Requisitos: Para esta aula, precisa de ter o ambiente de trabalho configurado ([Docker](https://www.docker.com/products/docker-desktop/) com [base de dados HR](https://github.com/ULHT-BD/aula03/blob/main/docker_db_aula03.zip) e [DBeaver](https://dbeaver.io/download/)). Caso ainda não o tenha feito, veja como fazer seguindo o passo 1 da [aula03](https://github.com/ULHT-BD/aula03/edit/main/README.md#1-prepare-o-seu-ambiente-de-trabalho).

Caso já tenha o docker pode iniciá-lo usando o comando ```docker start mysgbd``` no terminal, ou através do interface gráfico do docker-desktop:
<img width="1305" alt="image" src="https://user-images.githubusercontent.com/32137262/194916340-13af4c85-c282-4d98-a571-9c4f7b468bbb.png">

Deve também ter o cliente DBeaver.

## 1. Função IF e CASE
Como vimos na aula anterior, podemos usar a função ```IFNULL``` para testar a condição se um dado valor é ```NULL``` e devolver caso a comparação seja verdadeira, então retornamos outro valor. Podemos usar a função ```IF``` para testar outras condições sendo assim possivel devolver valores diferentes na função de acordo com o resultado do teste da condição. 

A sintaxe é 
``` sql
IF(<<condição>>, <<valor-se-verdadeiro>>, <<valor-se-falso>>)
```

Por exemplo:

``` sql
 SELECT IF(idade >=18, 'Maior de Idade', 'Menor de Idade') FROM estudante;
```

A função CASE permite testar um conjunto de várias condições e devolver valores diferentes segundo resultado do teste. O valor devolvido é o retornado pela primeira condição que teste verdadeiro. A sintaxe pode assumir duas formulações:

1. testar vários valores para uma condição
```
CASE condição
 WHEN valor-1 THEN resultado-1
 WHEN valor-2 THEN resultado-2
 WHEN valor-N THEN resultado-N
 ELSE resultado
END;
```
Exemplo:
``` sql
SELECT
 CASE ano_curso
  WHEN 1 THEN 'Caloiro'
  WHEN 3 THEN 'Finalista de Licenciatura'
  WHEN 5 THEN 'Finalista de Mestrado'
  ELSE 'Inscrito em anos intermédios'
 END
FROM
 estudante;
```

2. testar várias condições diferentes
```
CASE
 WHEN condição-1 THEN resultado-1
 WHEN condição-2 THEN resultado-2
 WHEN condição-N THEN resultado-N
 ELSE resultado
END;
```

Exemplo:
``` sql
SELECT
 CASE
  WHEN nota_final >= 10 THEN 'Aprovado'
  WHEN nota_final >=8 THEN 'Exame Oral'
  ELSE 'Reprovado'
 END
FROM
 estudante;
```

### Exercícios
Para cada uma das alíneas seguintes, escreva a query que permite obter:
1. Para cada empregado apresente o seu nome, salário e indicação sobre se o seu salário está "acima da média" caso seja superior a 6500 ou "abaixo da média" no caso contrário 
2. Para cada empregado apresente o seu nome, salário e qual o seu periodo de contratação sendo: "1º período" se até 2002 (incluindo), "2º período" entre 2002 e 2004 (incluindo), "3 período" entre 2004 e 2006 (incluindo) e "4º período" nos restantes casos. Ordene por ordem decrescente de salário


## 2. Conversão de Tipos de Dados
Verificámos, nas aulas anteriores, que podemos usar em SQL vários tipos de dados (e.g. texto, numérico, data). O SQL disponibiliza funções que permitem efetuar conversões entre os tipos de dados.

Podemos usar os operadores:
|Função|Descrição|Exemplo|
|--------|---------|-------|
|FORMAT|Converter um número para uma string com n casas decimais|Apresentar nota final como string com 2 casas decimais: ```SELECT FORMAT(nota_final, 2) FROM aluno;```|
|CAST|Converter um valor num dado tipo de dados (DATE, DATETIME, TIME, CHAR, SIGNED, UNSIGNED, BINARY)|Apresentar nota final como string com 2 casas decimais: ```SELECT CAST(ROUND(nota_final, 2) AS CHAR) FROM aluno;```|

### Exercícios
Para cada uma das alíneas seguintes, escreva a query que permite obter:
1. O valor do salário dos trabalhadores incluindo a respetiva comissão como string com duas casas decimais
2. A data '2022-10-25 8:00:00' como data e hora, assim como qual será a data após 27 dias


## 3. Funções de Agregação
As funções de agregação são funções que são aplicadas sobre um conjunto de tuplos e retornam um único valor. Várias funções existem:
|Função|Descrição|Exemplo|
|--------|---------|-------|
|MIN, MAX|Obter o valor máximo ou mínimo|Qual o aluno mais velho e mais novo: ```SELECT MAX(idade) mais_velho, MIN(idade) mais_novo FROM alunos;```|
|AVG|Calcular o valor médio de um conjunto de valores|Qual a idade média dos alunos: ```SELECT AVG(idade) FROM alunos;```|
|COUNT|Contar o número de ocorrências de tuplos diferentes de NULL|Quantos alunos existem e para quantos conhecemos a idade: ```SELECT COUNT(eid) total_alunos, COUNT(idade) idade_conhecida FROM alunos;```|
|SUM|Calcular a soma de valores de um conjunto de tuplos|Qual a soma das classificacoes do aluno numero 213: ```SELECT SUM(nota_exercicio) FROM alunos WHERE eid = 213;```|

### Exercícios
Para cada uma das alíneas seguintes, escreva a query que permite obter:
1. Qual o salário base mínimo, máximo e médio recebido pelos empregados
2. Quantos empregados recebem alguma comissão, quantos recebem uma comissão acima de 25% e quantos não recebem qualquer comissão
3. Qual o salário mínimo, máximo e médio recebido pelos empregados com e sem comissão


## 4. GROUP BY
A cláusula ```GROUP BY``` permite aplicar funções de agregação agrupando por subconjuntos segundo um ou vários atributos. A sintaxe é:

``` sql
 SELECT FUNCAO(atributo), atributo-1
 FROM relação
 WHERE condição
 GROUP BY atributo-1, ..., atributo-n
```

Exemplo:

Qual a idade média para cada nome próprio dos alunos
``` sql
 SELECT nome, AVG(idade)
 FROM alunos
 GROUP BY nome
```

### Exercícios
Para cada uma das alíneas seguintes, escreva a query que permite obter:
1. Qual o salário base mínimo, máximo e médio recebido pelos empregados para cada função ordenado por salário médio
2. Para cada departamento, quantos empregados recebem alguma comissão, quantos recebem uma comissão acima de 25% e quantos não recebem qualquer comissão
3. Para cada departamento indique a distribuição dos nomes por número de caracteres do nome próprio nos seguintes grupos: quantos trabalhadores têm menos até 3 caracteres, entre 3 e 5, entre 5 e 7 ou mais de 7.


## 5. HAVING
Não podemos usar a cláusula WHERE para filtrar tuplos com base no valor das funções de agregação. Em alternativa, a cláusula HAVING permite filtrar tuplos segundo o valor de funções de agregação. A sintaxe é:

``` sql
 SELECT FUNCAO(atributo), atributo-1
 FROM relação
 WHERE condição
 GROUP BY atributo-1, ..., atributo-n
 HAVING condição-FUNCAO(atributo)
```

Exemplo:

Quais os nomes de alunos e respetiva idade média quando esta é superior a 23
``` sql
 SELECT nome, AVG(idade)
 FROM alunos
 GROUP BY nome
 HAVING AVG(idade) > 23
```

### Exercícios
Para cada uma das alíneas seguintes, escreva a query que permite obter:
1. Qual o salário base mínimo, máximo e médio recebido pelos empregados para cada função ordenado por salário médio apenas para os empregos onde o salário médio esteja entre 10000 e 15000
2. Para cada departamento que empregue pelo menos 6 empregados, quantos empregados recebem alguma comissão, quantos recebem uma comissão acima de 25% e quantos não recebem qualquer comissão
3. Para cada departamento indique a distribuição dos nomes por número de caracteres do nome próprio nos seguintes grupos: quantos trabalhadores têm até 3 caracteres, entre 3 e 5, entre 5 e 7 ou mais de 7 para os departamentos tenham algum trabalhador cujo nome tenha pelo menos 9 catacteres.

## 6. Operações UNION, INTERSECT e MINUS
Em SQL podemos efetuar operações entre vários conjuntos. 
![image](https://user-images.githubusercontent.com/32137262/197638351-749da169-af37-4809-b1e3-b0e8f4d3fc2f.png)

Exemplos:
|Operador|Descrição|Exemplo|
|--------|---------|-------|
|UNION|Conjunto de tuplos que estão no primeiro e/ou no segundo conjunto, sem duplicados|Obter diferentes nomes de alunos e nomes de professores: ```SELECT nome FROM alunos UNION SELECT nome FROM professores;```|
|UNION ALL|Conjunto de tuplos que estão no primeiro e/ou no segundo conjunto, incluindo duplicados|Obter nomes de alunos e nomes de professores mantendo repetições entre grupos: ```SELECT nome FROM alunos UNION ALL SELECT nome FROM professores;```|
|INTERSECT|Obter nomes de alunos que também são nomes de professores: ```SELECT nome FROM alunos INTERSECT SELECT nome FROM professores;```|

```MINUS``` não existe em MySQL mas veremos como podemos implementar utilizando o ```LEFT JOIN``` na aula 10.

### Exercícios
Para cada uma das alíneas seguintes, escreva a query que permite obter:
1. Uma única lista com os nomes próprios e os apelidos de todos os trabalhadores
2. A lista de nomes próprios que sejam nome de pelo menos um trabalhador que recebe comissão e de um trabalhador que não recebe


## 7. Trabalho de Casa
Para cada uma das alíneas seguintes, escreva a query que permite obter:

1. Para cada região (id de região), qual o número total de países, bem como o tamanho mínimo, médio e máximo em número de caracteres do nome dos países.

2. Para cada ano, quais as funções (JOB_ID) para as quais foram contratados mais do que um empregado e qual a quantidade.

Exemplo de resultado parcial:
|ANO|FUNCAO|QTD|
|----|--------|-|
|2003|ST_CLERK|2|
|2004|SA_REP|4|
|2004|SH_CLERK|2|
|2005|FI_ACCOUNT|2|
|2005|PU_CLERK|2|
|2005|SA_MAN|2|
|2005|SA_REP|8|
|2005|SH_CLERK|4|
|...|...|...|

3. Para cada letra vogal (a,e,i,o,u), quantos nomes próprios contêm pelo menos uma ocorrência dessa vogal

Exemplo de resultado para uma lista de nomes (Pedro, Teresa, Joana, Marta):
|a|3|
|-|-|
|e|2|
|i|0|
|o|2|
|u|0|

Bom trabalho!

SUGESTÃO: se o problema parecer difícil ou estiver com dificuldades em obter o resultado final correto, tente subdividir o problema em partes obtendo isoladamente cada uma das condições pedidas.

NOTA: submeta a sua resposta ao trabalho de casa no moodle, um exercício por linha, num ficheiro de texto com o nome TPC_a06_[N_ALUNO].sql (exemplo: TPC_a06_12345.sql para o aluno número 12345).

## Bibliografia e Referências
* [w3schools - MySQL WHERE Clause](https://www.w3schools.com/mysql/mysql_where.asp)
* [w3schools - MySQL IN Operator](https://www.w3schools.com/mysql/mysql_in.asp)
* [w3schools - MySQL LIKE Operator](https://www.w3schools.com/mysql/mysql_like.asp)
* [geeksforgeeks - Regular Expressions REGEXP](https://www.geeksforgeeks.org/mysql-regular-expressions-regexp/)
* [w3schools - MySQL Functions](https://www.w3schools.com/mysql/mysql_ref_functions.asp)

## Outros
Para dúvidas e discussões pode juntar-se ao grupo slack da turma através do [link](
https://join.slack.com/t/ulht-bd/shared_invite/zt-1iyiki38n-ObLCdokAGUG5uLQAaJ1~fA) (atualizado 2022-11-03)
