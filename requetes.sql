\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 1.1 |  La liste des athlètes italiens ayant obtenu une médaille "
\! echo "--------------+--------------------------------------------------------------\n"

SELECT nom
FROM athletes,podiums,contrats
WHERE athletes.id = contrats.id
AND contrats.pid = podiums.pid 
AND athletes.nationalite='Italie'; 

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 1.2 |  Le nom et la nationalité des médaillés du 100m, 200m, et "
\! echo "              |  400m avec à chaque fois le type de médaille (or, argent, "
\! echo "              |  bronze) "
\! echo "--------------+--------------------------------------------------------------\n"

select a.nom, a.nationalite , me.rang, e.nom as epreuve from athletes a,contrats c ,podiums po,medailles me , epreuves e
where a.id =c.id and c.pid=po.pid and po.code_medaille = me.code_medaille and me.eid=e.eid
and (e.nom='100m(H)' or e.nom='100m(F)'or e.nom='200m(H)' or e.nom='200m(F)' or e.nom='400m(H)' or e.nom='400m(F)');

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 1.3 |  Les membres de l'équipe féminine de handball de moins de 25 "
\! echo "              |  ans "
\! echo "--------------+--------------------------------------------------------------\n"

SELECT DISTINCT participants.pays as equipe, athletes.prenom||' '||athletes.nom as membre, (EXTRACT (YEAR FROM age(CURRENT_DATE,date_de_naissance))) as âge
FROM matchs,sports,epreuves,participations,contrats,athletes,participants
WHERE sports.nom='HANDBALL'
AND sports.sid=epreuves.sid 
AND epreuves.genre='f'
AND matchs.eid=epreuves.eid
AND participations.mid=matchs.mid
AND contrats.pid=participations.pid
AND contrats.id=athletes.id
AND participants.pid=contrats.pid
--AND (extract (YEAR FROM NOW())- extract(YEAR FROM date_de_naissance)) <25; 
AND (EXTRACT (YEAR FROM age(CURRENT_DATE,date_de_naissance))) < 25 ;
\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 1.4 |  Les médailles gagnées par Michael Phelps, avec l'épreuve et "
\! echo "              |  le temps correspondants "
\! echo "--------------+--------------------------------------------------------------\n"

select distinct me.rang as medaille,e.nom as epreuve, p.performance as temps
from athletes a, epreuves e, medailles me ,contrats c,participations p,matchs ma,podiums po
where a.prenom='Michael' and a.nom ='PHELPS'and a.id =c.id and c.pid =p.pid and p.mid=ma.mid and ma.eid =e.eid
	and po.code_medaille =me.code_medaille and po.pid= p.pid and e.eid=me.eid;

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 1.5 |  La liste des sports pratiqués en équipe (on considère qu un "
\! echo "              |  sport est partiqué en équipe si il y a au moins une épreuve "
\! echo "              |  en equipe pour ce sport)"
\! echo "--------------+--------------------------------------------------------------\n"

SELECT DISTINCT sports.nom FROM sports,epreuves 
WHERE epreuves.sid=sports.sid
AND epreuves.individuel=false
ORDER BY sports.nom
;

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 1.6 |  Le meilleur temps réalisé au marathon"
\! echo "--------------+--------------------------------------------------------------\n"

select min(p.performance) as meilleur_temps from participations p, epreuves e ,matchs ma
where e.eid=ma.eid and ma.mid =p.mid and e.nom like 'Marathon%';

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 2.1 |  La moyenne des temps réalisés au 200 mètres nage libre par "
\! echo "              |  nationalité"
\! echo "--------------+--------------------------------------------------------------\n"

SELECT  athletes.nationalite, AVG(to_timestamp(   replace(performance,'s',',')    ,'SS,MS')::time) as temps_moyen FROM participations,contrats,athletes,matchs,epreuves
WHERE performance<>'DQ'
AND epreuves.nom LIKE '200m nage libre%'
AND epreuves.eid=matchs.eid
AND matchs.mid=participations.mid
AND participations.pid=contrats.pid
AND contrats.id=athletes.id 
GROUP BY athletes.nationalite
ORDER BY AVG(to_timestamp(   replace(performance,'s',',')    ,'SS,MS')::time);

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 2.2 |  Le nombre de médailles par pays représentés (rappel : une "
\! echo "              |  seule médaille est comptée pour une équipe) "
\! echo "--------------+--------------------------------------------------------------\n"

select count(*) as nombre_de_medailles,p.pays from podiums po , participants p
where p.pid =po.pid Group by p.pays
order by pays;

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 2.3 |  Pour chaque épreuve, le nom et la nationalité de l athlète "
\! echo "              |  ayant obtenu la médaille d'or, ainsi que le nom et la " 
\! echo "              |  nationalité de celui ayant obtenu la médaille d'argent "
\! echo "              | (tableau résultat avec 5 attributs)"
\! echo "--------------+--------------------------------------------------------------\n"

SELECT distinct s.nom||' '||e.nom as epreuve, a.nom as athlete_or, a.nationalite as nationalite_or ,a1.nom as athlete_ar, a1.nationalite as nationalite_ar
FROM epreuves e, athletes a , medailles me , podiums po, contrats c, sports s,
epreuves e1, athletes a1 , medailles me1 , podiums po1, contrats c1

WHERE me.rang='or'
and a.id =c.id
and c.pid =po.pid
AND me.code_medaille = po.code_medaille
AND me.eid=e.eid
and e.individuel=true

and me1.rang='argent'
and a1.id =c1.id
and c1.pid =po1.pid
AND me1.code_medaille = po1.code_medaille
AND me1.eid=e1.eid
and e1.individuel=true

and e.eid=e1.eid
AND s.sid=e.sid;

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 2.4 |  Les athlètes qui n'ont obtenu aucune médaille d'or "
\! echo "--------------+--------------------------------------------------------------\n"

(select distinct a.prenom,a.nom from athletes a order by a.nom)
except
(select distinct a.prenom,a.nom from athletes a, contrats c,podiums po ,medailles me
where a.id=c.id and c.pid=po.pid and po.code_medaille=me.code_medaille and me.rang='or' );


\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 2.5 |  Les sports individuels dans lesquels la France n'a pas "
\! echo "              |  obtenu de médaille "
\! echo "--------------+--------------------------------------------------------------\n"

with sports_indiv AS
(SELECT sports.nom FROM sports 
EXCEPT 
(SELECT sports.nom FROM sports,epreuves WHERE sports.sid=epreuves.sid
AND epreuves.individuel=false))  

SELECT sports_indiv.nom FROM sports_indiv
EXCEPT 
SELECT sports.nom FROM sports, epreuves ,medailles , podiums , participants
WHERE sports.sid=epreuves.eid 
AND epreuves.eid = medailles.eid
AND medailles.code_medaille = podiums.code_medaille
AND podiums.pid = participants.pid
AND participants.pays = 'France'
;

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 2.6 |  Les coureurs qui n'ont jamais mis plus de dix secondes au "
\! echo "              |  100m"
\! echo "--------------+--------------------------------------------------------------\n"

--ex2.6

SELECT a.prenom, a.nom from athletes a, contrats c, participations p  ,matchs ma,epreuves e
where a.id=c.id and c.pid =p.pid and p.mid =ma.mid and ma.eid=e.eid and (e.nom ='100m(H)' or e.nom='100m(F)')
EXCEPT
(select a.prenom, a.nom from athletes a, contrats c, participations p  ,matchs ma,epreuves e
where a.id=c.id and c.pid =p.pid and p.mid =ma.mid and ma.eid=e.eid and (e.nom ='100m(H)' or e.nom='100m(F)')
and to_timestamp( replace(performance,'s',',') , 'SS.MS')::time >'00:00:10.00'
and performance <>'DQ')
;

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 3.2 |  Les pays qui ont eu une médaille dans chaque catégorie "
\! echo "              |  sportive (pas forcément à toutes les épreuves de "
\! echo "              |  cette catégorie) "
\! echo "--------------+--------------------------------------------------------------\n"

with gagnant as
(select distinct pa.pays ,s.nom from participants pa,podiums po ,medailles me,epreuves e,sports s
where pa.pid=po.pid and po.code_medaille =me.code_medaille and me.eid=e.eid and e.sid=s.sid
order by s.nom)
select pays from gagnant group by pays having count(*) =(select count (*)from sports);

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 3.3 |  Les cinq catégories sportives pour lesquelles il y a le "
\! echo "              |  moins d'épreuves"
\! echo "--------------+--------------------------------------------------------------\n"

SELECT sports.nom, count(epreuves.nom) as nombre_epreuves FROM sports,epreuves
WHERE sports.sid=epreuves.sid
GROUP BY sports.nom
ORDER BY count(epreuves.nom)
LIMIT 5;

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 3.4 |  Le pourcentage de médailles remportées par des femmes "
\! echo "              |  (y compris en équipe)"
\! echo "--------------+--------------------------------------------------------------\n"

with medailles_femmes as
	(select count(*) x from podiums po , medailles me ,epreuves e
	where po.code_medaille=me.code_medaille and me.eid=e.eid and e.genre =false),
tot as 
	(select count(*)  y from podiums po , medailles me ,epreuves e
	where po.code_medaille = me.code_medaille and me.eid=e.eid )

select round( (x+0.0)*100/y+0.0 , 2 )||' %' as pourcentage from medailles_femmes , tot;

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 3.5 |  Le nombre total de points marqués par l'équipe féminine de " 
\! echo "              |  handball qui a marqué plus de points que chaque équipe " 
\! echo "              |  masculine de handball tout au long des jeux"
\! echo "--------------+--------------------------------------------------------------\n"

SELECT participants.pays as equipe,SUM(performance::integer) as total_pts FROM participants,participations, matchs, epreuves, sports
WHERE matchs.mid=participations.mid
AND matchs.eid=epreuves.eid
AND participants.pid=participations.pid
AND epreuves.sid=sports.sid
AND sports.nom='HANDBALL'
AND epreuves.genre=false
GROUP BY participants.pid
HAVING SUM(performance::integer)>all(
-- Somme des pts par equipes de hanball
SELECT SUM(performance::integer) FROM participations, matchs, epreuves, sports
WHERE matchs.mid=participations.mid
AND matchs.eid=epreuves.eid
AND epreuves.sid=sports.sid
AND sports.nom='HANDBALL'
AND epreuves.genre=true
GROUP BY pid
); 

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête 3.6 |  Les pays qui ont obtenu plus de médailles que la France dans" 
\! echo "              |  chaque sport" 
\! echo "--------------+--------------------------------------------------------------\n"

-- premiere interprétation de l'énoncé

with x as 
(select distinct 0 as nbrMed, participants.pays,sports.nom from participants, sports
UNION
(select count(*) as nbrMed, pa.pays,s.nom from podiums po ,participants pa, sports s ,epreuves e ,medailles me
where pa.pid= po.pid
and s.sid=e.sid and e.eid=me.eid and me.code_medaille = po.code_medaille  
group by pa.pays,s.nom)), tousLesPays as 
(select max(nbrMed) as nbrMed,pays,nom from x group by pays,nom order by pays,nom )
select * from tousLesPays tlp 
where nbrMed>(select nbrMed from TousLesPays tlp2 where pays='France' and tlp2.nom= tlp.nom)
;


-- deuxieme interpretation
with x as 
(select distinct 0 as nbrMed, participants.pays,sports.nom from participants, sports
UNION
(select count(*) as nbrMed, pa.pays,s.nom from podiums po ,participants pa, sports s ,epreuves e ,medailles me
where pa.pid= po.pid
and s.sid=e.sid and e.eid=me.eid and me.code_medaille = po.code_medaille  
group by pa.pays,s.nom)), tousLesPays as 
(select max(nbrMed) as nbrMed,pays,nom from x group by pays,nom order by pays,nom )
select pays from tousLesPays tlp 
except 
select pays from tousLesPays tlp 
where nbrMed<=(select nbrMed from TousLesPays tlp2 where pays='France' and tlp2.nom= tlp.nom)
;
-- 0 car aucun pays n'a plus que la France en Handball

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête     |  Le prénom et le nombre d'occurrence des athlètes distincts  " 
\! echo "  bonus 1     |  de la même équipe qui ont le même prénom (en précisant le "
\! echo "              |  prenom, l'équipe (pays et sport) pour lequel ils concourrent)"
\! echo "              |  dans l'odre décroissant du nombre d'occurrence"
\! echo "--------------+--------------------------------------------------------------\n"

--bonus1
with tab1 as
(select a.prenom, count(*)  num_de_occurrence ,pa.pays , pa.pid
from athletes a ,participants pa ,contrats c
where a.id=c.id and c.pid=pa.pid and pa.individuel=false
group by a.prenom,pa.pays,pa.pid
having count(*)>=2
order by   count(*) DESC),
tab2 as
(select distinct s.nom , a.prenom , p.pid from sports s , epreuves e ,matchs ma ,participations p ,contrats c, athletes a
where a.id =c.id and c.pid =p.pid and p.mid =ma.mid and ma.eid =e.eid and s.sid=e.sid order by a.prenom)
select tab1.prenom, tab1.num_de_occurrence ,tab1.pays ,tab2.nom from tab1 left join tab2 on tab1.prenom =tab2.prenom 
and tab1.pid=tab2.pid 
order by tab1.num_de_occurrence DESC;

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête     |  L'athlete le plus jeune et le plus agée de chaque épreuve  " 
\! echo "  bonus 2     |  en précisant l'âge (le plus précis possible) du plus jeune "
\! echo "              |  au moment de son premier match et du plus agé au moment de "
\! echo "              |  son dernier match"
\! echo "--------------+--------------------------------------------------------------\n"

with x as
(select e.eid, max(a.date_de_naissance) as le_plus_petit ,min(a1.date_de_naissance) as le_plus_grand 
from athletes a,contrats c,participations p,matchs ma,epreuves e
,athletes a1,contrats c1,participations p1,matchs ma1,epreuves e1
where a.id=c.id and c.pid= p.pid and p.mid =ma.mid and ma.eid=e.eid 
and a1.id=c1.id and c1.pid= p1.pid and p1.mid =ma1.mid and ma1.eid=e1.eid 
and p.pid=p1.pid
group by e.eid) 

SELECT DISTINCT 
	e.nom, 
	a1.nom as le_plus_jeune, age(MIN(m1.date_match),a1.date_de_naissance) as age,
	a2.nom as le_plus_age,  age(MAX(m2.date_match),a2.date_de_naissance) as age
FROM x,epreuves e, 
athletes a1, participations p1, contrats c1, matchs m1,
athletes a2, participations p2, contrats c2, matchs m2
WHERE e.eid=x.eid
AND a2.date_de_naissance = x.le_plus_grand and a2.id = c2.id and c2.pid = p2.pid and p2.mid = m2.mid and m2.eid= e.eid
AND a1.date_de_naissance = x.le_plus_petit and a1.id = c1.id and c1.pid = p1.pid and p1.mid = m1.mid and m1.eid= e.eid 
GROUP BY a1.nom, x.le_plus_petit, a1.date_de_naissance, a2.nom, x.le_plus_grand, a2.date_de_naissance, e.nom
ORDER BY e.nom
;

/*
with x as
(select e.eid, max(a.date_de_naissance) as le_plus_petit ,min(a1.date_de_naissance) as le_plus_grand 
from athletes a,contrats c,participations p,matchs ma,epreuves e
,athletes a1,contrats c1,participations p1,matchs ma1,epreuves e1
where a.id=c.id and c.pid= p.pid and p.mid =ma.mid and ma.eid=e.eid 
and a1.id=c1.id and c1.pid= p1.pid and p1.mid =ma1.mid and ma1.eid=e1.eid 
and p.pid=p1.pid
group by e.eid) 
SELECT DISTINCT 
	e.nom, 
	--a1.nom as le_plus_jeune, age(m1.date_match,a1.date_de_naissance) as age, x.le_plus_petit, 
	a2.nom as le_plus_age,   age(m2.date_match,a2.date_de_naissance) as age, x.le_plus_grand, m2.date_match
FROM x,epreuves e, 
athletes a1, participations p1, contrats c1, matchs m1,
athletes a2, participations p2, contrats c2, matchs m2
WHERE e.eid=x.eid
AND a2.date_de_naissance = x.le_plus_grand and a2.id = c2.id and c2.pid = p2.pid and p2.mid = m2.mid and m2.eid= e.eid
AND a1.date_de_naissance = x.le_plus_petit and a1.id = c1.id and c1.pid = p1.pid and p1.mid = m1.mid and m1.eid= e.eid 
ORDER BY a2.nom
;

(select e.eid, max(a.date_de_naissance) as le_plus_petit ,min(a1.date_de_naissance) as le_plus_grand 
from athletes a,contrats c,participations p,matchs ma,epreuves e
,athletes a1,contrats c1,participations p1,matchs ma1,epreuves e1
where a.id=c.id and c.pid= p.pid and p.mid =ma.mid and ma.eid=e.eid 
and a1.id=c1.id and c1.pid= p1.pid and p1.mid =ma1.mid and ma1.eid=e1.eid 
and p.pid=p1.pid
group by e.eid
order by e.eid) 
;
*/

\! echo "--------------+--------------------------------------------------------------"
\! echo "  Requête     | Afficher le calendrier des épreuves : le nombre de matchs en"
\! echo "  bonus 3     | fonction du jour et de l'épreuve (jXX correspond au XX/08/2016)"
\! echo "--------------+--------------------------------------------------------------\n"

with col1 as (
with col1 as (
with col1 as (

with col1 as (
with col1 as (
with col1 as (
with col1 as (

with col1 as (
with col1 as (
with col1 as (
with col1 as (

with col1 as (
with col1 as (
with col1 as (
with col1 as(select e.nom from epreuves e ),
col2 as(select e.nom ,count(ma.date_match)  j07 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='07/08/16'group by e.nom)
select col1.nom , col2.j07 from col1 left join col2 on col1.nom=col2.nom),

col2 as(
select e.nom ,count(ma.date_match)  j08 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='08/08/16'group by e.nom)
select col1.nom , col1.j07,col2.j08 from col1 left join col2 on col1.nom=col2.nom),

col2 as(
select e.nom ,count(ma.date_match)  j09 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='09/08/16'group by e.nom)
select col1.nom , col1.j07 ,col1.j08,col2.j09 from col1 left join col2 on col1.nom=col2.nom),

col2 as(
select e.nom ,count(ma.date_match)  j10 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='10/08/16'group by e.nom	)
select col1.nom , col1.j07 ,col1.j08,col1.j09 ,col2.j10 from col1 left join col2 on col1.nom=col2.nom),



col2 as(
select e.nom ,count(ma.date_match)  j11 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='11/08/16'group by e.nom	)
select col1.nom , col1.j07 ,col1.j08,col1.j09 ,col1.j10, col2.j11 from col1 left join col2 on col1.nom=col2.nom),

col2 as(
select e.nom ,count(ma.date_match)  j12 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='12/08/16'group by e.nom)
select col1.nom , col1.j07 ,col1.j08,col1.j09 ,col1.j10, col1.j11 ,col2.j12 from col1 left join col2 on col1.nom=col2.nom),

col2 as(
select e.nom ,count(ma.date_match)  j13 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='13/08/16'group by e.nom)
select col1.nom , col1.j07 ,col1.j08,col1.j09 ,col1.j10, col1.j11 ,col1.j12 ,col2.j13 from col1 left join col2 on col1.nom=col2.nom),

col2 as(
select e.nom ,count(ma.date_match)  j14 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='14/08/16'group by e.nom)
select col1.nom , col1.j07 ,col1.j08,col1.j09 ,col1.j10, col1.j11 ,col1.j12 ,col1.j13 ,col2.j14 from col1 left join col2 on col1.nom=col2.nom),

col2 as(
select e.nom ,count(ma.date_match)  j15 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='15/08/16'group by e.nom)
select col1.nom , col1.j07 ,col1.j08,col1.j09 ,col1.j10, col1.j11 ,col1.j12 ,col1.j13 ,col1.j14,col2.j15 from col1 left join col2 on col1.nom=col2.nom),

col2 as(
select e.nom ,count(ma.date_match)  j16 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='16/08/16'group by e.nom)
select col1.nom , col1.j07 ,col1.j08,col1.j09 ,col1.j10, col1.j11 ,col1.j12 ,col1.j13 ,col1.j14,col1.j15 ,col2.j16 from col1 left join col2 on col1.nom=col2.nom),

col2 as(
select e.nom ,count(ma.date_match)  j17 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='17/08/16'group by e.nom)
select col1.nom , col1.j07 ,col1.j08,col1.j09 ,col1.j10, col1.j11 ,col1.j12 ,col1.j13 ,col1.j14,col1.j15 ,col1.j16 ,col2. j17  from col1 left join col2 on col1.nom=col2.nom),

col2 as(
select e.nom ,count(ma.date_match)  j18 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='18/08/16'group by e.nom)
select col1.nom , col1.j07 ,col1.j08,col1.j09 ,col1.j10, col1.j11 ,col1.j12 ,col1.j13 ,col1.j14,col1.j15 ,col1.j16 ,col1. j17,col2.j18  from col1 left join col2 on col1.nom=col2.nom),

col2 as(
select e.nom ,count(ma.date_match)  j19 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='19/08/16'group by e.nom)
select col1.nom , col1.j07 ,col1.j08,col1.j09 ,col1.j10, col1.j11 ,col1.j12 ,col1.j13 ,col1.j14,col1.j15 ,col1.j16 ,col1. j17,col1.j18,col2.j19  from col1 left join col2 on col1.nom=col2.nom),

col2 as(
select e.nom ,count(ma.date_match)  j20 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='20/08/16'group by e.nom)
select col1.nom , col1.j07 ,col1.j08,col1.j09 ,col1.j10, col1.j11 ,col1.j12 ,col1.j13 ,col1.j14,col1.j15 ,col1.j16 ,col1. j17,col1.j18,col1.j19,col2.j20  from col1 left join col2 on col1.nom=col2.nom),

col2 as(
select e.nom ,count(ma.date_match)  j21 from epreuves e, matchs ma
where e.eid=ma.eid and ma.date_match='21/08/16'group by e.nom)
select col1.nom , col1.j07 ,col1.j08,col1.j09 ,col1.j10, col1.j11 ,col1.j12 ,col1.j13 ,col1.j14,col1.j15 ,col1.j16 ,col1. j17,col1.j18,col1.j19,col1.j20,col2.j21  from col1 left join col2 on col1.nom=col2.nom
;


