/*
 *Proceso de agrupación de fechas y cantidad 
 * */


/*
 * Proceso en la tabla original
 * */

SELECT 
	n."FECHATRX_date_TRP"
,	n.update_date 
,	count(1) records
,	sum(n_tarjetas) cant_tarjetas
, 	sum(ntrx)	cant_trx

FROM public.n_tarjetas_caba_pba n  

WHERE 1=1
	
AND n."FECHATRX_date_TRP" = '2021-10-20'

GROUP BY	n."FECHATRX_date_TRP",	n.update_date 


/*
 * Proceso en la tabla prueba
 * */

SELECT 
	n."FECHATRX_date_TRP"
,	n.update_date 
,	count(1) records
,	sum(n_tarjetas) cant_tarjetas
, 	sum(ntrx)	cant_trx

FROM public.n_tarjetas_caba_pba_v4_test n  

WHERE 1=1

GROUP BY	n."FECHATRX_date_TRP",	n.update_date 


/*
 * 
 * DIFERENCIAS DE DOS PUNTAS
 * */



SELECT 
	*
FROM public.n_tarjetas_caba_pba n  

WHERE 1=1
AND n."FECHATRX_date_TRP" = '2021-10-20'
AND n.update_date = '2021-10-21'
AND n.ciudad_primera_trx_dia  LIKE 'PBA' 
AND n.comuna_partido_primera_trx_dia  LIKE 'PILAR'
AND	n.caba_bool = TRUE 
AND	n.pba_bool = TRUE
AND	n.bus_bool = TRUE
AND	n.tren_bool = TRUE
AND	n.subte_bool = TRUE
/*AND	n.lineas_caba_bool = TRUE*/


UNION ALL

SELECT 
	*
,	NULL
,	NULL 
,	NULL

FROM public.n_tarjetas_caba_pba_v3_test n  

WHERE 1=1
AND n."FECHATRX_date_TRP" = '2021-10-20'
AND n.update_date = '2021-10-21'
AND n.ciudad_primera_trx_dia  LIKE 'PBA' 
AND n.comuna_partido_primera_trx_dia  LIKE 'PILAR'
AND	n.caba_bool = TRUE 
AND	n.pba_bool = TRUE
AND	n.bus_bool = TRUE
AND	n.tren_bool = TRUE
AND	n.subte_bool = TRUE
/*AND	n.lineas_caba_bool = TRUE*/
;






/*  
 * Diferencias entre ambas fechas
 * Entre las fechas del 20 
 * 
 * Datos a tener en consideración:
 * 		la cantidad de registros es menor
 * 				records prueba									records original
 * 2021-10-20	1916	10142379	31157355	|	2021-10-20	2995	10156832	29107662
 * 		
 * Diferencia:
 * 		cantidad de tarjetas 	: 		14453
 * 		records 				:	 	1079
 * 		trx						:		2049693
 * */


WITH prueba AS(
	SELECT 
		n."FECHATRX_date_TRP"
	,	n.update_date 
	,	count(1) records
	,	sum(n_tarjetas) cant_tarjetas
	, 	sum(ntrx)	cant_trx
	
	FROM public.n_tarjetas_caba_pba_v2_test	n  
	
	WHERE 1=1
		
	AND n."FECHATRX_date_TRP" = '2021-10-20'

	GROUP BY	n."FECHATRX_date_TRP"
			,	n.update_date 

), 

original AS (
	SELECT 
		n."FECHATRX_date_TRP"
	,	n.update_date 
	,	count(1) records
	,	sum(n_tarjetas) cant_tarjetas
	, 	sum(ntrx)	cant_trx
	
	FROM public.n_tarjetas_caba_pba	n  
	
	WHERE 1=1
		
	AND n."FECHATRX_date_TRP" = '2021-10-20'
	
	GROUP BY	n."FECHATRX_date_TRP"
			,	n.update_date 

) 

SELECT 
	p.*
,	o.*

,	(p.records - o.records) DIFF_RECORDS
,	(p.cant_tarjetas - o.cant_tarjetas) DIFF_CANT_TARJETAS
,	(p.cant_trx - o.cant_trx) DIFF_CANT_TRX


FROM prueba p
	FULL JOIN original o
	ON p."FECHATRX_date_TRP" = o."FECHATRX_date_TRP"
	AND	p.update_date  = o.update_date
	
	
WHERE 1=1
	
AND n.udpate_date = '2021-10-21'






/*
 * 
 * */


SELECT  

	o."FECHATRX_date_TRP"	
,	o.ciudad_primera_trx_dia 
,	o.comuna_partido_primera_trx_dia
,	o.caba_bool
,	o.pba_bool
,	o.bus_bool
,	o.tren_bool
,	o.subte_bool
,	o.lineas_caba_bool
,	o.update_date
,  	(o.n_tarjetas - p.n_tarjetas) diff_tarjetas
,	(o.ntrx - p.ntrx) diff_trx
,	(o.ntrx_caba - p.ntrx_caba) diff_caba
,	(o.ntrx_pba - p.ntrx_pba) diff_pba
,	(o.ntrx_bus - p.ntrx_bus) diff_bus
,	(o.ntrx_tren - p.ntrx_tren) diff_tren
,	(o.ntrx_subte - p.ntrx_subte) diff_subte
,	(o.ntrx_lineas_caba - 0)  diff_ntrx_lineas_caba
,	(o.n_viajes - 0)  diff_n_viajes


FROM public.n_tarjetas_caba_pba	o

FULL JOIN public.n_tarjetas_caba_pba_v2_test p
	ON p."FECHATRX_date_TRP" = o."FECHATRX_date_TRP"
	AND	o.ciudad_primera_trx_dia  = p.ciudad_primera_trx_dia
	AND o.comuna_partido_primera_trx_dia = p.comuna_partido_primera_trx_dia
	AND o.caba_bool = p.caba_bool
	AND o.pba_bool = p.pba_bool
	AND	o.bus_bool = p.bus_bool
	AND	o.tren_bool = p.tren_bool
	AND	o.subte_bool = p.subte_bool
	AND	o.update_date = p.update_date
	

WHERE 1=1
AND o."FECHATRX_date_TRP" = '2021-10-20'
AND o.update_date = '2021-10-21'
AND (o.n_tarjetas - p.n_tarjetas) < 0

/*
AND o.ciudad_primera_trx_dia  = 'PBA'
AND	o.comuna_partido_primera_trx_dia = 'LA MATANZA'
AND	o.caba_bool = false
AND	o.pba_bool = true
AND	o.bus_bool = true
AND	o.tren_bool = false
AND	o.subte_bool = false
*/


AND o.lineas_caba_bool = false

ORDER BY diff_tarjetas 


 ==> lineas_caba_bool





SELECT * 
FROM public.n_tarjetas_caba_pba_v2_test	n
WHERE 1=1
AND n."FECHATRX_date_TRP" = '2021-10-20'
AND n.udpate_date = '2021-10-21'












SELECT 
	n."FECHATRX_date_TRP"
,	n.update_date 
,	count(1) records

FROM public.n_tarjetas_caba_pba n  
WHERE update_date > '2022-01-01'
GROUP BY	n."FECHATRX_date_TRP",	n.update_date 




DELETE FROM public.n_tarjetas_caba_pba n   
WHERE update_date = '2022-12-27'



SELECT
		*
FROM
	public.n_tarjetas_caba_pba_v2_test n
	
WHERE 1=1 
--AND 	n.update_date = '2021-10-20'
AND 	n."FECHATRX_date_TRP" = '2021-10-18'
-- AND	"FECHATRX_date_TRP" >= '2021-10-18'
-- AND 	"FECHATRX_date_TRP" <= '2021-10-24'


SELECT
	count(*)
FROM
	public.n_tarjetas_caba_pba



DROP TABLE IF EXISTS public.n_tarjetas_caba_pba_v2_test
	
	
	
SELECT
	*
FROM
	public.n_tarjetas_caba_pba
LIMIT 10




	SELECT
		n."FECHATRX_date_TRP" 
	, 	n.update_date
	,	count(1) cantidad
--	,	sum(n_tarjetas) cant_tarjetas
--	, 	sum(ntrx)	cant_trx
	
	FROM
		public.n_tarjetas_caba_pba_v2_test n
	--	public.n_tarjetas_caba_pba n 
		
	WHERE 1=1 
--	AND		n.update_date >= '2021-10-18'
--	AND		n.update_date <= '2021-10-20'
--	AND 	"FECHATRX_date_TRP" = '2021-10-18'
--	AND		"FECHATRX_date_TRP" >= '2021-10-18'
--	AND 	"FECHATRX_date_TRP" <= '2021-10-24'
	
	GROUP BY 	n."FECHATRX_date_TRP", n.update_date 
	ORDER BY 	n.update_date





WITH prueba AS(
	SELECT
		n."FECHATRX_date_TRP" 
	, 	n.update_date
	,	count(1) cantidad
	,	sum(n_tarjetas) cant_tarjetas
	, 	sum(ntrx)	cant_trx
	
	FROM
		public.n_tarjetas_caba_pba_v2_test n
	--	public.n_tarjetas_caba_pba n 
		
	WHERE 1=1 		
--	AND 	"FECHATRX_date_TRP" = '2021-10-20'
	AND		"FECHATRX_date_TRP" >= '2021-10-18'
	AND 	"FECHATRX_date_TRP" <= '2021-10-24'
	
	GROUP BY 	n."FECHATRX_date_TRP", n.update_date 
	ORDER BY 	n.update_date

), 

original AS (

	SELECT
		n."FECHATRX_date_TRP" 
	, 	n.update_date
	,	count(1) cantidad
	,	sum(n_tarjetas) cant_tarjetas
	, 	sum(ntrx)	cant_trx
	
	FROM
	--	public.n_tarjetas_caba_pba_v2_test n
		public.n_tarjetas_caba_pba n 
		
	WHERE 1=1 
--	AND 	"FECHATRX_date_TRP" = '2021-10-20'
	AND		"FECHATRX_date_TRP" >= '2021-10-18'
	AND 	"FECHATRX_date_TRP" <= '2021-10-24'
	
	GROUP BY 	n."FECHATRX_date_TRP", n.update_date 
	ORDER BY 	n.update_date

) 

SELECT 
	p.*
,	o.*

FROM prueba p
	FULL JOIN original o
	ON p."FECHATRX_date_TRP" = o."FECHATRX_date_TRP"
	AND	p.update_date  = o.update_date


	
	/*
	 * 
	 * SCRIPT DE VALIDACION
	 * 
	 * */




WITH ranking AS (
-- Agregar ranking segun fecha de actualización. Nos interesa solo la más reciente
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
           	
    FROM public.n_tarjetas_caba_pba_v6_test
    
    WHERE 1=1 
    AND		"FECHATRX_date_TRP" >= '2021-10-18'
    AND 	"FECHATRX_date_TRP" <= '2021-10-24'
)

SELECT 
	
	"FECHATRX_date_TRP",
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
	--n_viajes,
	NULL AS n_viajes,
	ntrx 
	  
FROM ranking
WHERE 
	update_rank = 1
	AND ciudad_primera_trx_dia IS NOT NULL


	
	
	
/*
 * 
 * VERIFICACION CON LA DATA ORIGINAL
 * */
	

	
	WITH ranking AS (
-- Agregar ranking segun fecha de actualización. Nos interesa solo la más reciente
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
           	
    FROM public.n_tarjetas_caba_pba
--    FROM public.n_tarjetas_caba_pba_v7_test
    
    
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
	--n_viajes,
	NULL AS n_viajes,
	ntrx 
	  
FROM ranking
WHERE 1 = 1
--	update_rank = 1
	
	AND "FECHATRX_date_TRP" = '2021-10-20'
--	AND ciudad_primera_trx_dia IS NOT NULL
)

SELECT 
	"FECHATRX_date_TRP"
,	update_date
,	SUM(n_tarjetas) AS TOTAL_TARJETAS
,	SUM(ntrx) AS TOTAL_TRX

FROM	TRANX
GROUP BY ("FECHATRX_date_TRP" , update_date)


	
	
	
	
	
	
	
/*
lineas_caba_bool
ntrx_lineas_caba
n_viajes
*/

			
/*
 * Dada la diferencia que no se encuentra correctamente en esas fechas
 * Se procede a recrear el restro de registros para poder re organizar el proceso que realiza internamente y obtener un nuevo validador
 * */
	
/*
 * hacer una copia de la tabla actual
 * */

	
	
	/*
	 * 
	 * FECHAS DE ACTUALIZACION DE DATOS
	 * 
	 * */
[
  "2021-10-18" ,
  "2021-10-19",
  "2021-10-20" ,
  "2021-10-21" ,
  "2021-10-22" ,
  "2021-10-25" ,
  "2021-10-26" ,
  "2021-10-27" ,
  "2021-10-28" ,
  "2021-10-29" ,
  "2021-11-01" ,
  "2021-11-02" ,
  "2021-11-03" ,
  "2021-11-04" ]

  
  
  /*FECHA DE NALISIS EL DIA 27*/
  
  SELECT *
  FROM public.n_tarjetas_caba_pba_v9_test ntcpvt 
  ORDER BY	 update_date  ASC 
  

  
  
/*
 * LECTURA COMPARATIVA DE FECHA DEL 10-28
 * */
	