
drop table if exists contrats;
drop table if exists podiums;
drop table if exists medailles;
drop table if exists participations;
drop table if exists matchs;
drop table if exists epreuves;


drop table if exists athletes;
drop table if exists participants;
drop table if exists sports;

create table athletes (
id serial primary key, 
prenom varchar(40),
nom varchar(40), 
date_de_naissance date,
genre boolean, -- true = homme, false = femme
nationalite varchar(40) -- nationalite
);

create table participants (
pid serial primary key, 
pays varchar(40), -- pays représenté
individuel boolean -- true = participant individuel , false = participant en equipe
);

create table sports (
sid serial primary key, 
nom varchar(40)
);

create table contrats (
id integer,
pid integer,
PRIMARY KEY (id, pid),
FOREIGN KEY (id) REFERENCES athletes(id),
FOREIGN KEY (pid) REFERENCES participants(pid)
);

create table epreuves(
eid serial primary key,
sid integer,
nom varchar(40),
genre boolean, -- true = categorie homme, false = categorie femme
individuel boolean, -- true = epreuve individuelle , false = epreuve en equipe
FOREIGN KEY (sid) REFERENCES sports(sid)

);

create table matchs(
mid serial primary key,
eid integer ,
tour varchar(40),
date_match date,
FOREIGN KEY (eid) REFERENCES epreuves(eid)
);

create table participations(
mid integer ,
pid integer ,
performance varchar(40) ,
FOREIGN KEY (pid) REFERENCES participants(pid),
FOREIGN KEY (mid) REFERENCES matchs(mid),

PRIMARY KEY (mid, pid)

);

create table medailles(
code_medaille serial primary key,
eid integer,
rang varchar(6),
FOREIGN KEY (eid) REFERENCES epreuves(eid),
CHECK (rang='or' OR rang='argent' OR rang='bronze')
);

create table podiums(
code_medaille integer,
pid integer,
FOREIGN KEY (pid) REFERENCES participants(pid),

PRIMARY KEY (code_medaille, pid),
FOREIGN KEY (code_medaille) REFERENCES medailles(code_medaille)
);

\COPY athletes (id,prenom,nom,genre,nationalite,date_de_naissance) FROM 'pack/athletes.csv' WITH (FORMAT csv, NULL '', DELIMITER ',', HEADER 0) ;
\COPY sports (sid,nom) FROM 'pack/sports.csv' WITH (FORMAT csv, NULL '', DELIMITER ',', HEADER 0) ;
\COPY participants (pid,pays,individuel) FROM 'pack/participants.csv' WITH (FORMAT csv, NULL '', DELIMITER ',', HEADER 0) ;
\COPY contrats (id,pid) FROM 'pack/contrats.csv' WITH (FORMAT csv, NULL '', DELIMITER ',', HEADER 0) ;
\COPY epreuves (eid,sid,nom,genre,individuel) FROM 'pack/epreuves.csv' WITH (FORMAT csv, NULL '', DELIMITER ',', HEADER 0) ;
\COPY medailles (eid,rang) FROM 'pack/medailles.csv' WITH (FORMAT csv, NULL '', DELIMITER ',', HEADER 0) ;
\COPY matchs (mid,eid,tour,date_match) FROM 'pack/matchs.csv' WITH (FORMAT csv, NULL '', DELIMITER ',', HEADER 1) ;
\COPY participations (mid,pid,performance) FROM 'pack/participations.csv' WITH (FORMAT csv, NULL '', DELIMITER ',', HEADER 1) ;
\COPY podiums (code_medaille,pid) FROM 'pack/podiums.csv' WITH (FORMAT csv, NULL '', DELIMITER ',', HEADER 1) ;

INSERT INTO participants (pid,pays,individuel) values 
(10000,'Etats-Unis',false),
(10001,'Serbie',false),
(10002,'Espagne',false),
(10003,'Allemagne',false),
(10004,'Bresil',false),
(10005,'Etats-Unis',false),
(10006,'Hongrie',false),
(10007,'Allemagne',false),
(10008,'Pologne',false),
(10009,'Grande-Bretagne',false),
(10010,'Nouvelle-Zelande',false),
(10011,'France',false),
(10012,'Bresil',false),
(10013,'Allemagne',false),
(10014,'Nigeria',false),
(10015,'Grande-Bretagne',false),
(10016,'Pays-Bas',false),
(10017,'Allemagne',false),
(10018,'Russie',false),
(10019,'Chine',false),
(10020,'Japon',false),
(10021,'Fidji',false),
(10022,'Grande-Bretagne',false),
(10023,'Afrique du Sud',false),
(10024,'Grande-Bretagne',false),
(10025,'Nouvelle-Zelande',false),
(10026,'France',false),
(10027,'Bresil',false),
(10028,'Italie',false),
(10029,'Etats-Unis',false)

;

INSERT INTO podiums (pid,code_medaille) values 
(10000,336),
(10001,335),
(10002,334),
(10003,345),
(10004,344),
(10005,343),
(10006,357),
(10007,356),
(10008,355),
(10009,369),
(10010,368),
(10011,367),
(10012,402),
(10013,401),
(10014,400),
(10015,441),
(10016,440),
(10017,439),
(10018,132),
(10019,131),
(10020,130),
(10021,483),
(10022,482),
(10023,481),
(10024,552),
(10025,551),
(10026,550),
(10027,558),
(10028,557),
(10029,556)
;