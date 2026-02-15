# Valorizzazione economics
Ultimo aggiornamento: 12/2/2026

## 1. tabella ProjectEconomics

Contiene per progetto/mese i principali indicatori economici, come ad esempio: RevenueACT, CostACT, Revenue ETC...
Chiave: Projects_id, AnnoMese

## 2. Prerequisito: valorizzazione Ore

Prima della valorizzazione di ProjectEconomics, è necessario che siano valorizzati i valori in Hours tramite la procedura *REV3_HoursCostAndRevenueUpdate*
da lanciare tramite Batch.BAT

## 3. Aggiornamento Economics

La tabella viene aggiornata dalla Storage Procedure *SPcontrolloProgetti* che calcola (per uno o più progetti attivi) gli indicatori economici di marginalità 
al mese di cutoff corrente e li salva/aggiorna in ProjectEconomics.

La procedure ha come parametri di input Project_id, Manager_id, TipoContratto_id

In sintesi:

+ Determina la data di reporting leggendo cutoffPeriod/cutoffMonth/cutoffYear da Options e imposta @DataReport a fine mese.
+ Seleziona i progetti attivi (TipoContratto 1 o 2) filtrabili per @Project_id, @Manager_id, @TipoContratto_id.

+ Calcola gli ACT fino a @DataReport:
	+ RevenueACT e CostiACT sommando Hours.RevenueAmount e Hours.CostAmount
	+ SpeseACT sommando Expenses.AmountInCurrency
	+ GiorniActual da Hours.Hours / 8
	+ prima/ultima data di carico e conta record Hours con RevenueAmount = 0 (RecordWithoutCost)

+ Recupera l’ETC del mese successivo da ProjectEconomics (se esiste).
+ Se nono esiste stima giorni lavorativi e giorni lavorativi restanti con una approssimazione 5/7, poi calcola il burn rate (revenue/costi/spese per giorno lavorativo)
  e quindi calcola ETC come burn rate * giorni lavorativi restanti.

+ Calcola i valori economici:
	+ CostiBDG da budget e margine proposto	
	+ MargineACT, WriteUpACT
	+ RevenueEAC usando ETC del mese successivo se presente, altrimenti burn rate * giorni restanti
	+ SpeseEAC, CostiEAC, MargineEAC, WriteUpEAC
	+ MesiCopertura stimati da (residuo budget / burn rate / 20)

+ Infine fa un MERGE su ProjectEconomics per Projects_id + AnnoMese (mese corrente): update se esiste, insert se manca, popolando tutti i campi calcolati e tracciando LastModificationDate/By o CreationDate/By.

Nota implicita: la qualità di RevenueACT dipende dal fatto che Hours.RevenueAmount sia già stato valorizzato (come indicato nel commento iniziale).
