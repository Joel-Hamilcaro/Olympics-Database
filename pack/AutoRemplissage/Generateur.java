import java.util.ArrayList;
import java.util.Arrays ;
import java.nio.file.Path ;
import java.nio.file.Paths ;
import java.nio.file.Files;
import java.nio.charset.Charset;
import java.io.IOException;
import java.util.Random;
import java.util.Scanner;

public class Generateur{
    
    public int tirage(int a, int b){
        int x = Math.min(a,b);
        int y = Math.max(a,b);
        Random r = new Random();
        int z  = r.nextInt(y-x+1)+x;
        return z;
    }
		

	
    public String dateRandom(){
        int annee = tirage(1998,1978);
        int mois = tirage(1,12);
        int jour = tirage(1,28);
        String s = annee+"-"+String.format("%02d",mois)+"-"+String.format("%02d",jour);
        return "\'"+s+"\'";
    }

    /*
    public String generer(String table, String colonne, String valeur){
            String s = "";
            s+="\n UPDATE "+table+" SET "+colonne+"= \'"+valeur+"\' ";
            s+="WHERE "+colonne+" IS NULL"; 
            System.out.println(s);
        return s;                    
    }
    */

    

}
