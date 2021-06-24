drop table if exists sports2024;
drop table if exists competitions2024;

create table sports2024 (
sid serial primary key,
nom varchar(40),
lieu varchar(40),
nombre int
);

create table competitions2024 (
sid int,
ven26 int,
sam27 int,
dim28 int,
lun29 int,
mar30 int,
mer31 int,
jeu01 int,
ven02 int,
sam03 int,
dim04 int,
lun05 int,
mar06 int,
mer07 int,
jeu08 int,
ven09 int,
sam10 int,
dim11 int
);

\COPY sports2024 (sid,nom,lieu,nombre) FROM 'pack/sports2024.csv' WITH (FORMAT csv, NULL '', DELIMITER ',', HEADER 0) ;
\COPY competitions2024 (sid,ven26,sam27,dim28,lun29,mar30,mer31,jeu01,ven02,sam03 ,dim04 ,lun05 ,mar06 ,mer07 ,jeu08 ,ven09 ,sam10 ,dim11) FROM 'pack/competitions2024.csv' WITH (FORMAT csv, NULL '', DELIMITER ',', HEADER 1) ;


select  s.lieu , sum( round (ven26*(s.nombre*0.5),0))ven26 ,sum( round(sam27*(s.nombre*0.5),0)) sam27,
sum( round(dim28*(s.nombre*0.5),0)) dim28,sum( round(lun29*(s.nombre*0.5),0)) lun29,
sum( round(mar30*(s.nombre*0.5),0)) mar30,sum( round(mer31*(s.nombre*0.5),0)) mer31,
sum( round(jeu01*(s.nombre*0.5),0)) jeu01,sum( round(ven02*(s.nombre*0.5),0)) ven02,
sum( round(sam03*(s.nombre*0.5),0)) sam03,sum( round(dim04*(s.nombre*0.5),0)) dim04 ,
sum( round(lun05*(s.nombre*0.5),0)) lun05,sum( round(mar06*(s.nombre*0.5),0)) mar06,
sum( round(mer07*(s.nombre*0.5),0)) mer07,sum( round(jeu08*(s.nombre*0.5),0)) jeu08,
sum( round(ven09*(s.nombre*0.5),0)) ven09,sum( round(sam10 *(s.nombre*0.5),0))sam10,
sum( round(dim11*(s.nombre*0.5),0)) dim11
from sports2024 s, competitions2024 c where s.sid=c.sid group by s.lieu order by s.lieu;