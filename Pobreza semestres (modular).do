/*==============================================================================
  Project:	     Estimación oficial de la pobreza en Argentina (metodología 2016)
  Author:	     Agustín Arakaki
  Creation Date: March 15, 2018
  Modified Date: April 4, 2024
===============================================================================*/

set more off

****************************** GLOBAL

********* DIRECTORIES

global path "C:\Users\Pobreza" /* Aquí se debe setear el directorio de trabajo */

global input  "C:\Users\EPH" /* Aquí se debe setear el directorio en el que se encuentran las bases de la EPH */

********* REGIONES

global regions "1 40 41 42 43 44"

global baskets "cba cbt"

local year 2022
local qtr1 1
local qtr2 2

global quarters "`qtr1' `qtr2'"

********* CANASTAS

import excel "${path}\Canastas.xlsx", sheet(stata) first clear /* este excel contiene el promedio trimestral de las canastas */

foreach q of global quarters {
foreach c of global baskets {
foreach r of global regions {
  levelsof `c'_`r' if quarter==`year'0`q', local(`c'`year'0`q'_`r')
}
}
}

****************************** ABRIR BASE

use "${input}\consoltot`year'0`qtr1'.dta", clear
  
append using "${input}\consoltot`year'0`qtr2'.dta", force


********* PONDERADORES

gen pondih_sem = pondih/2 /* hay maneras más sofisticadas de hacer esto, pero no está claro qué hace el INDEC */


********* UNIDADES DE ADULTO EQUIVALENTE

****** Unidades de adulto de la metodología 1996/7 (adeq)

gen     adeq=0
replace adeq=0.35 if ch06<1  /* para esta población existen dos coeficientes, yo uso el mayor */
replace adeq=0.37 if ch06==1
replace adeq=0.46 if ch06==2
replace adeq=0.51 if ch06==3
replace adeq=0.55 if ch06==4 
replace adeq=0.60 if ch06==5
replace adeq=0.64 if ch06==6
replace adeq=0.66 if ch06==7
replace adeq=0.68 if ch06==8
replace adeq=0.69 if ch06==9
replace adeq=0.79 if ch06==10            & ch04==1
replace adeq=0.82 if ch06==11            & ch04==1
replace adeq=0.85 if ch06==12            & ch04==1
replace adeq=0.90 if ch06==13            & ch04==1
replace adeq=0.96 if ch06==14            & ch04==1
replace adeq=1.00 if ch06==15            & ch04==1
replace adeq=1.03 if ch06==16            & ch04==1
replace adeq=1.04 if ch06==17            & ch04==1
replace adeq=0.70 if ch06==10            & ch04==2
replace adeq=0.72 if ch06==11            & ch04==2
replace adeq=0.74 if ch06==12            & ch04==2
replace adeq=0.76 if ch06==13            & ch04==2
replace adeq=0.76 if ch06==14            & ch04==2
replace adeq=0.77 if ch06==15            & ch04==2
replace adeq=0.77 if ch06==16            & ch04==2
replace adeq=0.77 if ch06==17            & ch04==2
replace adeq=1.02 if ch06>=18 & ch06<=29 & ch04==1
replace adeq=1.00 if ch06>=30 & ch06<=45 & ch04==1
replace adeq=1.00 if ch06>=46 & ch06<=60 & ch04==1
replace adeq=0.83 if ch06>=61 & ch06<=75 & ch04==1
replace adeq=0.74 if ch06>=76            & ch04==1
replace adeq=0.76 if ch06>=18 & ch06<=29 & ch04==2
replace adeq=0.77 if ch06>=30 & ch06<=45 & ch04==2
replace adeq=0.76 if ch06>=46 & ch06<=60 & ch04==2
replace adeq=0.67 if ch06>=61 & ch06<=75 & ch04==2
replace adeq=0.63 if ch06>=76            & ch04==2

label var adeq "Coeficiente de Adulto Equivalente"

*** Unidades de adulto equivalente del hogar (AE)

egen AE = sum(adeq), by(ano4 trimestre aglomerado codusu nro_hogar)

label var AE "Sumatoria de coef. adulto equiv. 1996"


********* CANASTAS

*** Canasta básica alimentaria (cba)

gen cba = .

foreach q of global quarters {
foreach r of global regions {
  replace cba=`cba`year'0`q'_`r'' if region==`r' & trimestre==`q'
}
}

label var cba "Canasta Basica Alimentaria promedio del trimestre"

*** Canasta básica total (cbt)

gen cbt = .

foreach q of global quarters {
foreach r of global regions {
  replace cbt=`cbt`year'0`q'_`r'' if region==`r' & trimestre==`q'
}
}

label var cbt "Canasta Basica Total promedio del trimestre"

********* LÍNEAS

*** Línea de indigencia (lind)

gen lind = cba*AE
label var lind "Linea de Indigencia"

*** Línea de pobreza (lp)

gen lp   = cbt*AE
label var lp "Linea de Pobreza"


********* ÍNDICES

*** Hogares

sepov itf if ch03==1 [w=pondih_sem], p(lind)

sepov itf if ch03==1 [w=pondih_sem], p(lp)

*** Personas

sepov itf [w=pondih_sem], p(lind)

sepov itf [w=pondih_sem], p(lp)
