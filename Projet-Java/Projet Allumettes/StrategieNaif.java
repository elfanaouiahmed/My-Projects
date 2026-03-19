package allumettes;

import java.util.Random;

public class StrategieNaif implements Strategie {

    private static final Random random = new Random();

    @Override
    public int getPrise(Jeu jeu) {
        int max = Math.min(Jeu.PRISE_MAX, jeu.getNombreAllumettes());
        return random.nextInt(max) + 1;
    }

    @Override
    public String getNom() {
        return "naif";
    }
}