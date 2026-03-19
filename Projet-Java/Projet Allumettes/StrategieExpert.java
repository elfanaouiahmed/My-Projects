package allumettes;

public class StrategieExpert implements Strategie {

    @Override
    public int getPrise(Jeu jeu) {
      int n = jeu.getNombreAllumettes();
      int prise = (n - 1) % (Jeu.PRISE_MAX + 1); // (n-1)%4
      if (prise == 0) {
        prise = 1;
      }
    return prise;
    }

    @Override
    public String getNom() { return "expert"; } 
}