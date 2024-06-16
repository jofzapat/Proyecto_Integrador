
----CONSULTA PARA TRAER LA FECHA MINIMAY MAXIMA DE LOS INSUMOS OBTENIDOS DEL SIATA
select 'Humedad' as variable,
       min(fecha_hora) as fecha_minima, 
       max(fecha_hora) as fecha_maxima 
from tbl_siata_humedad_318
union all
select 'Precipitacion' as variable,
       min(fecha_hora) as fecha_minima, 
       max(fecha_hora) as fecha_maxima 
from tbl_siata_Precipitacion_318
union all
select 
       'presion' as variable, 
       min(fecha_hora) as fecha_minima, 
       max(fecha_hora) as fecha_maxima 
from tbl_siata_Presión_318
union all
select 
       'Temperatura' as variable, 
       min(fecha_hora) as fecha_minima, 
       max(fecha_hora) as fecha_maxima 
from tbl_siata_Temperatura_318
order by 3 desc
;
----CREACION DE TABLA PROPROCESAMIENTO HUMEDAD
CREATE TABLE preprocesamiento_humedad  as 
with tabla_h as (
SELECT
       fecha_hora,
       strftime('%Y-%m-%d %H', fecha_hora) as fecha_t_hora,
       humedad
  FROM tbl_siata_humedad
  where calidad in (1,2)
   ),  
t_humedad as (select fecha_t_hora, round(avg(humedad),3) as humedad
from tabla_h
group by 1
)
select * from t_humedad
;
----CREACION DE TABLA PROPROCESAMIENTO PRECIPITACION
CREATE TABLE preprocesamiento_precipitacion  as 
with tabla_p as  (
SELECT
       fecha_hora,
       strftime('%Y-%m-%d %H', fecha_hora) as fecha_t_hora,
       P1
  FROM tbl_siata_Precipitacion
  where calidad in (1,2)
   ),
t_precipitacion as (   
select fecha_t_hora, round(avg(P1),3) as precipitacion
from tabla_p
group by 1)
Select * from t_precipitacion
;
----CREACION DE TABLA PROPROCESAMIENTO TEMPERATURA
CREATE TABLE preprocesamiento_temperatura as  
with tabla_temp as (
SELECT
       fecha_hora,
       strftime('%Y-%m-%d %H', fecha_hora) as fecha_t_hora,
       Temperatura
  FROM tbl_siata_Temperatura
  where calidad in (1,2)
   ),
t_tabla_Temperatura as (   
select fecha_t_hora, round(avg(Temperatura),3) as temperatura
from tabla_temp
group by 1)
select * from  t_tabla_Temperatura
;
----CREACION DE TABLA PROPROCESAMIENTO PRESION
CREATE TABLE preprocesamiento_presion as 
with tabla_p as (
SELECT
       fecha_hora,
       strftime('%Y-%m-%d %H', fecha_hora) as fecha_t_hora,
       presion
  FROM tbl_siata_Presion
  where calidad in (1,2)
   ),
   
t_presion as (select fecha_t_hora, round(avg(presion),3) as presion
from tabla_p
group by 1
)
select * from t_presion
;
----CREACION DE TABLA PROPROCESAMIENTO HUMEDAD SUELO
CREATE TABLE preprocesamiento_humedad_suelo as 
with tabla_h as (
SELECT
       fecha_hora,
       strftime('%Y-%m-%d %H', fecha_hora) as fecha_t_hora,
       h2
  FROM tbl_siata_humedad_suelo
  --where calidad in (1,2)
   ), 
t_humedad_s as (select fecha_t_hora, round(avg(h2),3) as humedad_suelo
from tabla_h
group by 1
)
select * from t_humedad_s
;


----CREACION DE TABLA PROPROCESAMIENTO VIENTO
CREATE TABLE preprocesamiento_viento as 
with tabla_v as (
SELECT
       fecha_hora,
       strftime('%Y-%m-%d %H', fecha_hora) as fecha_t_hora,
       Velocidad_Prom,
       Velocidad_Max,
       Direccion_Prom,
       Direccion_Max
  FROM tbl_siata_viento
  where calidad in (1,2)
   ),
   
t_viento as (select fecha_t_hora, 
round(avg(Velocidad_Prom),3) as Velocidad_Prom,
round(avg(Velocidad_Max),3) as Velocidad_Max,
round(avg(Direccion_Prom),3) as Direccion_Prom,
round(avg(Direccion_Max),3) as Direccion_Max
from tabla_v
group by 1
)
select * from t_viento
;
----CREACION DE TABLA PROPROCESAMIENTO RADIACION
CREATE TABLE preprocesamiento_radiacion as 
with tabla_r as (
SELECT
       [Unnamed: 0],
       strftime('%Y-%m-%d %H', [Unnamed: 0]) as fecha_t_hora,
       radiacion
  FROM tbl_siata_radiacion
  where calidad in (1,2)
   ),
   
t_radiacion as (select fecha_t_hora, round(avg(radiacion),3) as radiacion
from tabla_r
group by 1
)
select * from t_radiacion

;
----CREACION DE TABLA PROCESAMIENTO INTEGRACION DE TABLAS PREPROCESADAS
CREATE TABLE procesamiento_proyecto_int as 
select fecha_hora,
       a.fecha_id,
       a.mes,
       a.dia_mes,
       a.semana as semana_año,
       a.dia as nombre_dia,
       b.precipitacion,
       c.presion,
       d.temperatura,
       e.humedad,
       g.Velocidad_Prom,
       g.Velocidad_Max,
       g.Direccion_Prom,
       g.Direccion_Max,
       h.radiacion,
       f.humedad_suelo
from tbl_dim_tiempo as a
left join preprocesamiento_precipitacion as b
on a.fecha_id  = b.fecha_t_hora 
left join preprocesamiento_presion as c
on a.fecha_id  = c.fecha_t_hora
left join preprocesamiento_temperatura as d
on a.fecha_id  = d.fecha_t_hora 
left join preprocesamiento_humedad as e
on a.fecha_id  = e.fecha_t_hora
left join preprocesamiento_humedad_suelo as f
on a.fecha_id  = f.fecha_t_hora
left join preprocesamiento_viento as g
on a.fecha_id  = g.fecha_t_hora
left join preprocesamiento_radiacion as h
on a.fecha_id  = h.fecha_t_hora