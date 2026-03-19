package allumettes;

public class StrategieRapide implements Strategie {

    @Override
    public int getPrise(Jeu jeu) {
        return Math.min(Jeu.PRISE_MAX, jeu.getNombreAllumettes());
    }

    @Override
    public String getNom() {
        return "rapide";
    }
}