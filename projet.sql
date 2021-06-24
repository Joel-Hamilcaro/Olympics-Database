

\i pack/create_tables.sql 

\! echo "\n \n \n \n" 
\! echo "\t\t*************************************** \n" 
\! echo "\t\t*   Rio ne répond plus - PROJET BD3   * \n"
\! echo "\t\t*************************************** \n\n" 

\! echo "\t\t*************************************** \n" 
\! echo "Schéma relationnel : \n"
\! echo "\tAthletes (id*,prenom,nom,date_de_naissance,genre,pays)"
\! echo "\tParticipants(pid*,pays,individuel)"
\! echo "\tSports(sid*,nom)"
\! echo "\tContrats( (id#,pid#)* )"
\! echo "\tEpreuves(eid*,sid#,nom,genre,individuel)"
\! echo "\tMatchs(mid*,eid#,tour,date_match)"
\! echo "\tParticipations ( (mid#, pid#)* ,performance )"
\! echo "\tMedailles(code_medaille*,eid#,rang)"
\! echo "\tPodiums( (code_medaille#,pid#)* )\n"
\! echo "\t\t*************************************** \n\n" 

\! echo "\t\t*************************************** \n\n" 
