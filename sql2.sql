DROP TABLE public.n_tarjetas_caba_pba_v3_test ;

SELECT *
FROM public.n_tarjetas_caba_pba_v3_test 

SELECT *
FROM public.n_tarjetas_caba_pba  



/*VERIFICACION POR AGRUPAMIENTO*/




	
WITH ranking AS (
    SELECT *,
           
    		CASE
               WHEN caba_bool = TRUE AND pba_bool = TRUE THEN 'AMBAS JURISDICCIONES'
               WHEN caba_bool = FALSE AND pba_bool = TRUE THEN 'SÓLO PBA'
               WHEN caba_bool = TRUE AND pba_bool = FALSE THEN 'SÓLO CABA' 
               END
           	AS "jurisdicciones_description",
           
           	CASE
               WHEN bus_bool = TRUE AND tren_bool = FALSE AND subte_bool = FALSE THEN 'colectivo'
               WHEN bus_bool = TRUE AND tren_bool = TRUE AND subte_bool = FALSE THEN 'tren-colectivo'
               WHEN bus_bool = TRUE AND tren_bool = TRUE AND subte_bool = TRUE THEN 'tren-subte-colectivo'
               WHEN bus_bool = TRUE AND tren_bool = FALSE AND subte_bool = TRUE THEN 'subte-colectivo'
               WHEN bus_bool = FALSE AND tren_bool = TRUE AND subte_bool = FALSE THEN 'tren'
               WHEN bus_bool = FALSE AND tren_bool = TRUE AND subte_bool = TRUE THEN 'tren-subte'
               WHEN bus_bool = FALSE AND tren_bool = FALSE AND subte_bool = TRUE THEN 'subte' 
               END 
			AS "modos_utilizados",
			
           	RANK() OVER (PARTITION BY "FECHATRX_date_TRP" ORDER BY update_date DESC)
           	AS update_rank
           	
--  FROM public.n_tarjetas_caba_pba
    FROM public.n_tarjetas_caba_pba_v3_test 
   
    WHERE 1=1 
	
    AND	"FECHATRX_date_TRP" >= '2021-10-18'
	AND "FECHATRX_date_TRP" <= '2021-10-24'
)

,

TRANX AS (
SELECT 
	
	"FECHATRX_date_TRP",
	update_date ,
	CASE
		WHEN ciudad_primera_trx_dia IS NULL THEN NULL
		ELSE CONCAT(ciudad_primera_trx_dia, '-', jurisdicciones_description)
		END
	AS transaccion_viajes,
	jurisdicciones_description,
	"modos_utilizados",
	comuna_partido_primera_trx_dia,
	lineas_caba_bool,
	caba_bool,
	pba_bool,
	tren_bool,
	subte_bool,
	bus_bool,
	n_tarjetas,
	n_viajes,
	ntrx 
	  
FROM ranking
WHERE 1 = 1
	AND update_rank = 1
	
--	AND "FECHATRX_date_TRP" = '2021-10-20'
	AND ciudad_primera_trx_dia IS NOT NULL
)

SELECT 
	"FECHATRX_date_TRP"
,	update_date
,	SUM(n_tarjetas) AS TOTAL_TARJETAS
,	SUM(ntrx) AS TOTAL_TRX

FROM	TRANX
GROUP BY ("FECHATRX_date_TRP" , update_date)




SELECT 
	"FECHATRX_date_TRP"
,	update_date
,	SUM(n_tarjetas) AS TOTAL_TARJETAS
,	SUM(ntrx)	AS TOTAL_NTRX
,	SUM(ntrx_caba) AS TOTAL_NTRX_CABA
,	SUM(ntrx_pba) AS TOTAL_NTRX_PBA
,	SUM(ntrx_tren) AS TOTAL_NTRX_TREN
,	SUM(ntrx_subte) AS TOTAL_NTRX_SUBTE
,	SUM(ntrx_lineas_caba) AS TOTAL_NTRX_LINEAS_CABA 


FROM public.n_tarjetas_caba_pba_v3_test 


WHERE 1 = 1
AND ciudad_primera_trx_dia IS NOT  NULL
--AND update_date = '2021-10-25'
--AND "FECHATRX_date_TRP" = '2021-10-17'
GROUP BY "FECHATRX_date_TRP" , update_date ;


SELECT 
	"FECHATRX_date_TRP"
,	update_date
,	SUM(n_tarjetas) AS TOTAL_TARJETAS
,	SUM(ntrx)	AS TOTAL_NTRX
,	SUM(ntrx_caba) AS TOTAL_NTRX_CABA
,	SUM(ntrx_pba) AS TOTAL_NTRX_PBA
,	SUM(ntrx_tren) AS TOTAL_NTRX_TREN
,	SUM(ntrx_subte) AS TOTAL_NTRX_SUBTE
,	SUM(ntrx_lineas_caba) AS TOTAL_NTRX_LINEAS_CABA 



FROM public.n_tarjetas_caba_pba

WHERE 1 = 1
AND ciudad_primera_trx_dia IS NOT  NULL
AND update_date = '2021-10-25'
AND "FECHATRX_date_TRP" = '2021-10-17'
GROUP BY "FECHATRX_date_TRP" , update_date ;


