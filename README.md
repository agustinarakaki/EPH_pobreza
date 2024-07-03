# Estimación de la pobreza monetaria en Argentina
Este repositorio incluye:
1. la metodología que el Instituto Nacional de Estadísticas y Censos (INDEC) publicó en 2016.
2. el diseño de registro de la Encuesta Permanente de Hogares (EPH) correspondiente al segundo trimestre de 2016, el cual se encuentra disponible en el sitio web del INDEC (https://www.indec.gob.ar/).
3. un do-file para el cálculo de la pobreza en Argentina utilizando las bases de microdatos de la EPH (también disponibles en el sitio web del INDEC).
4. un archivo Excel con las canastas hasta diciembre de 2023, las cuales han sido publicadas en los sucesivos informes de prensa del INDEC (también disponibles en su sitio web)

Aclaraciones:
1. Esta versión del do-file permite seleccionar bases para ir realizando el cálculo de cada semestre. Con una serie de loops es posible obtener una nueva versión en la que se calcule toda la serie.
2. El do-file no arroja exactamente lo mismo que el INDEC. Estas leves discrepancias podrían estar explicadas por: 
a) la forma en la que se construye la base semestral. En este caso se juntan dos bases trimestrales y se calcula el promedio de los ponderadores. Existen formas más sofisticadas de obtener una base semestral, pero ninguna es perfecta
b) las líneas que se utilizan (mensuales o trimestrales). En este caso se utiliza el promedio trimestral porque no es posible identificar a qué mes corresponden los ingresos del hogar. 
