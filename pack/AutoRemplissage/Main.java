import au.com.bytecode.opencsv.* ;

import java.io.IOException;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.Arrays ;
import java.nio.file.Path ;
import java.nio.file.Paths ;
import java.nio.file.Files;
import java.nio.charset.Charset;
import java.io.FileReader;
import java.io.File ;

public class Main{

    public static void main (String [] args) {
        Generateur g = new Generateur();
        
        try{

            // SOLOS
            //////////////////////////////////////////////////////////
            CSVReader r = new CSVReader(new FileReader("athletes_init.csv"),',');
            ArrayList<String> lignes = new ArrayList<String>();

            String[] t = null;
            int cpt = 1;
            while((t=r.readNext()) != null){
                String prenom = (t[0].charAt(0)+"").toUpperCase();
                for (int i=1; i<t[0].length();i++){
                    prenom+=(t[0].charAt(i)+"").toLowerCase();
                }
                String nom = (t[1].charAt(0)+"").toUpperCase();
                for (int i=1; i<t[1].length();i++){
                    nom+=(""+t[1].charAt(i)).toUpperCase();
                }
                if (prenom.length()==1) prenom+=".";
                lignes.add(cpt+","+prenom+","+nom+","+t[2]+","+t[3]+","+g.dateRandom());
                cpt++;                
            }
            r.close();
                     
            Path fichier = Paths.get("../athletes.csv");
	    Files.write(fichier, lignes, Charset.forName("UTF-8"));


            // EQUIPES
            /////////////////////////////////////////////////////////
            
            File f0 = new File("equipes.csv");
            Scanner f = new Scanner(f0);
            
            lignes = new ArrayList<String>();
            cpt = 1;
            while(f.hasNextLine()){
                lignes.add(cpt+","+f.nextLine());
                cpt++;
            }
            f.close();
            
            fichier = Paths.get("equipes_full.csv");
	    Files.write(fichier, lignes, Charset.forName("UTF-8"));

            // PARTICIPANTS (EN EQUIPES)
            //////////////////////////////////////////////////////////////
            
             r = new CSVReader(new FileReader("equipes_full.csv"),',');

            ArrayList<String> lignes2 = new ArrayList<String>();

            t = null;
            cpt = 1;

            while((t=r.readNext()) != null){
            
                lignes2.add(cpt+","+t[1]+",false"); // Participants (equipes) id de 1 à k

                cpt++;
            }
            r.close();

            
            // CONTRATS (ATHLETES <-> EQUIPES)
            /////////////////////////////////////////////////////////////
            
            r = new CSVReader(new FileReader("contrats_eq.csv"),',');
            
            t = null;
            ArrayList<String> lignes3 = new ArrayList<String>();

            ArrayList<String> aid = new ArrayList<String>();
            while((t=r.readNext()) != null){
                if (!t[1].equals("0")){
                    lignes3.add(t[0]+","+t[1]); //id_athlete , id_participant (de 1 à k)
                    //System.out.println(t[0]+","+t[1]);
                    aid.add(t[0]);
                }                
            }
            
            r.close();
            r = new CSVReader(new FileReader("contrats_eq.csv"),',');
            while((t=r.readNext()) != null){
                if (t[1].equals("0")){
                    aid.remove(t[0]);
                    //System.out.println(aid);
                }                
            }
            r.close();
            

            // PARTICIPANTS (SOLO)
            //////////////////////////////////////////////////////////
            r = new CSVReader(new FileReader("../athletes.csv"),',');

            t = null;
            String[] t2 = null;
            //cpt = 1;
            while((t=r.readNext()) != null){
                //if (!aid.contains(t[0])){
                    lignes2.add(cpt+","+t[4]+",true"); // participants (solo) id de k+1 à n.
                    lignes3.add(""+t[0]+","+cpt); // Contrats (solo) id, pid (de k+1 à n),
                    //System.out.println(t[0]+",,"+cpt);
                    cpt++;


                    //}
                
                
            }
            r.close();

       

            
            Path fichier2 = Paths.get("../participants.csv");
	    Files.write(fichier2, lignes2, Charset.forName("UTF-8"));
            Path fichier3 = Paths.get("../contrats.csv");
	    Files.write(fichier3, lignes3, Charset.forName("UTF-8"));

            // MEDAILLES
            /////////////////////////////////////////////////////////////
            
            r = new CSVReader(new FileReader("../epreuves.csv"),',');  
            ArrayList<String> lignes4 = new ArrayList<String>();
            t = null;
            while((t=r.readNext()) != null){           
                lignes4.add(t[0]+",bronze"); //eid , type
                lignes4.add(t[0]+",argent"); //eid , type
                lignes4.add(t[0]+",or"); //eid , type

            }
            r.close();
            
            Path fichier4 = Paths.get("../medailles.csv");
	    Files.write(fichier4, lignes4, Charset.forName("UTF-8"));
            
            ////////////////////////////////////////////////////////////
            
        } catch (IOException e){
            e.printStackTrace();
        }

        
    }
}
