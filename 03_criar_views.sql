create view vw_analise_demografica_2022 as 
SELECT idade,
       CASE
           WHEN Idade BETWEEN 17 AND 24 THEN '17-24'
           WHEN Idade BETWEEN 25 AND 34 THEN '25-34'
           WHEN Idade BETWEEN 35 AND 44 THEN '35-44'
           WHEN Idade BETWEEN 45 AND 54 THEN '45-54'
           ELSE '55+'
       END AS faixa_etaria,
       genero,
       cor_raca_etnia,
       pcd,
       estado_onde_mora,
       regiao_onde_mora,
       uf_onde_mora,
       nivel_ensino,
       area_de_formacao,
       situacao_atual_de_trabalho,
       gestor,
       COALESCE(cargo_como_gestor, cargo_atual) AS cargo,
       faixa_salarial,
       anos_experiencia_na_area_dados
FROM state_of_data_2022;



  CREATE VIEW vw_experiencia_area_dados As
  SELECT DISTINCT anos_experiencia_na_area_dados,
    CASE
      WHEN anos_experiencia_na_area_dados = 'Não tenho experiência na área de dados' THEN 0
      WHEN anos_experiencia_na_area_dados = 'Menos de 1 ano' THEN 0.5
      WHEN anos_experiencia_na_area_dados = 'de 1 a 2 anos' THEN 1.5
      WHEN anos_experiencia_na_area_dados = 'de 3 a 4 anos' THEN 3.5
      WHEN anos_experiencia_na_area_dados = 'de 4 a 6 anos' THEN 5
      WHEN anos_experiencia_na_area_dados = 'de 7 a 10 anos' THEN 8.5
      WHEN anos_experiencia_na_area_dados = 'Mais de 10 anos' THEN 10
      ELSE NULL
    END AS media_experiencia_em_anos
  FROM
    vw_analise_demografica_2022 
WHERE
  media_experiencia_em_anos IS NOT NULL
ORDER BY  media_experiencia_em_anos ;


CREATE VIEW vw_media_salarial_por_faixa AS
SELECT
    faixa_salarial,
    CASE
        WHEN faixa_salarial = 'Menos de R$ 1.000/mês' THEN 500
        WHEN faixa_salarial = 'de R$ 1.001/mês a R$ 2.000/mês' THEN 1500.5
        WHEN faixa_salarial = 'de R$ 2.001/mês a R$ 3.000/mês' THEN 2500.5
        WHEN faixa_salarial = 'de R$ 3.001/mês a R$ 4.000/mês' THEN 3500.5
        WHEN faixa_salarial = 'de R$ 4.001/mês a R$ 6.000/mês' THEN 5000.5
        WHEN faixa_salarial = 'de R$ 6.001/mês a R$ 8.000/mês' THEN 7000.5
        WHEN faixa_salarial = 'de R$ 8.001/mês a R$ 12.000/mês' THEN 10000.5
        WHEN faixa_salarial = 'de R$ 12.001/mês a R$ 16.000/mês' THEN 14000.5
        WHEN faixa_salarial = 'de R$ 16.001/mês a R$ 20.000/mês' THEN 18000.5
        WHEN faixa_salarial = 'de R$ 20.001/mês a R$ 25.000/mês' THEN 22500.5
        WHEN faixa_salarial = 'de R$ 25.001/mês a R$ 30.000/mês' THEN 27500.5
        WHEN faixa_salarial = 'de R$ 30.001/mês a R$ 40.000/mês' THEN 35000.5
        WHEN faixa_salarial = 'Acima de R$ 40.001/mês' THEN 40000.0  
        ELSE NULL
    END AS ponto_medio_faixa_salarial
FROM
    state_of_data_2022
GROUP BY
    faixa_salarial
ORDER BY 
	ponto_medio_faixa_salarial;