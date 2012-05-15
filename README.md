We have three baskets, each containing a quantity (q1, q2, q3) of different
kind of food (vegetables, pasta, meat).

Each type of food has its own cost in relation to the other two types: you can get 
1 pasta swapping 3 vegetables, and 1 meat returning 3 pastas (or 9 vegetables).

Given an arbitrary distribution of these quantities, obtain the most
balanced (*) distribution of types of food.

(*) Balanced to eat all three meals for more consecutive days as possible.


### Here we go
Ipotesi: (constraints)
	
	ax + by + cz = Const (starting situation)
	y = 3x
	z = 3y

	(So, weights are 1, 3, 9.)

Thesis:

        ix + jy + kz = Const    (final situation)

	with

        i ~= j ~= k             (I mean near values)

        For perfect balance I mean i = j = k

Proof and notes:

	ax + by + cz = ax + 3bx + 9cx = (a + 3b + 9c) x = N x

	Need to find coeffients that describe new distribution:

	ix + jy + kz = (i + 3j + 9k) x = N x
	so
	i + 3j + 9k = N

	So i have

	i = N - 3j - 9k
	j = ?
	k = ?

	In Reals we have infinite solutions.
	In Naturals{0} we have constraints that bind problem to finite
	solutions:

        0 <= i <= N
        0 <= j <= N/3
        0 <= k <= N/9

	From this we can obtain finite number of tuples (i,j,k) with
	the coefficients that redistribute the N value.

	How to choose the most appropriate triplets? (the most balanced)

	I can take the minimum value of the three coefficients for each
	tuple and associate it to the tuple; after this, choosing the
	tuples with higher minimum I obtain best tuples in first approximation.


Notes:

	See Cluster Data Analysis.

        For N great values we can reduce range intervals to:

        N/2 < i <= N
        0   < j <= N/3
        0   < k <= N/9

	and cut (before to calculate) useless tuples. 



## Italiano

        Abbiamo tre ceste, ognuna con dentro una quantita'
        (q1, q2, q3) di cibo diversa (verdura, pasta, carne).
        Ogni cibo ha un costo proprio in relazione alle altre due
        tipologie:
        si puo' ottenere 1 pasta scambiando 3 verdure, e 1 carne
        scambiando 3 paste (o 9 verdure).
        Data una distribuzione arbitraria delle tre quantita', come
        ottenere una distribuzione di tipologie di cibo più
        equilibrata (*) possibile?

	* Equilibrato in modo da mangiare piu' giorni possibili
	consecutivi tutte e tre le pietanze.

### Here we go
Ipotesi: (vincoli)

          ax + by + cz = Const    (situazione iniziale)
          y = 3x
          z = 3y

Tesi:

        ix + jy + kz = Const    (situazione finale)
        con
        i ~= j ~= k             (valori vicini)

        Per equilibrati si intende i = j = k

Dimostrazione e procedure:

        ax + by + cz = ax + 3bx + 9cx = (a + 3b + 9c) x = N x

        Devo trovare i coefficienti che descrivono la nuova
        distribuzione.

        ix + jy + kz = (i + 3j + 9k) x = N x
        i + 3j + 9k = N

        quindi ho tre vettori linearmente dipendenti che produco
        un sistema lineare di 1 equazione con 3 incognite.

        i = N - 3j - 9k
        j = ?
        k = ?

        Nei Reali abbiamo infinite soluzioni.
        Nei Naturali{0} come in questo caso abbiamo delle
        condizioni che rendono finite le soluzioni.

        0 <= i <= N
        0 <= j <= N/3
        0 <= k <= N/9

        Da quel sistema e con queste condizioni si ottiene un numero
        finito di triplette (i,j,k) che indicano i coefficienti
        validi per ridistribuire le N quantità totali.

        Come scegliere le triplette piu' "equilibrate"?

        Per ogni tripletta di coefficienti identifico il minimo e
        lo associo alla sua tripletta. Confrontando i minimi di ogni
        tripletta, e scegliendo il massimo fra essi, ottengo le
        triplette piu' equilibrate.

        (Scegliere il minimo fra i coefficienti di una tripletta,
        equivale a indicare il numero di pasti equilibrati con quella
        tripletta; scegliere il massimo fra tutti i minimi trovati
        identifica le triplette col maggior numero di pasti
        equilibrati.)

Note:

        * Per valori grandi di N si possono ridurre gli intervalli a

        N/2 < i <= N
        0   < j <= N/3
        0   < k <= N/9

        e tagliare (prima di calcolarle) le triplette generate che
        sarebbero inutili.
        (stima migliorabile ?)

