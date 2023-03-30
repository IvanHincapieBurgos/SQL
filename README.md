# Interview Questions

1. Escriba una consulta que muestre el año de cada fecha de pedido y el mes numérico de cada  fecha de pedido en columnas separadas en los resultados. Incluya las columnas "A" y "B" sobre la tabla "TableX".

select 
   [A]
  ,[B]
  ,YEAR([Date]) as [Year]
  ,MONTH([Date]) AS [Month]
from [Database].[TableX]

2. Escriba una consulta utilizando la tabla "TableX" para mostrar un valor  ("Menos de 10" o "10-19" o "20-29" o "30-39" o "40 y más") basado en el valor de la columna "Order" utilizando la función CASE. Incluya las columnas A y "Order" en los resultados.

select 
  [A]
 ,[B]
 ,CASE
    WHEN
    ELSE
  END AS []
from [Database].[TableX]
