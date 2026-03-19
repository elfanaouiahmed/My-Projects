package allumettes;

/** Le jeu réel : stocke l'état (allumettes restantes) et applique les règles. */
public class JeuReel implements Jeu {
    private int nbAllumettes;

    public JeuReel(int nbInitial) {
        this.nbAllumettes = nbInitial;
    }

    @Override
    public int getNombreAllumettes() {
        return nbAllumettes;
    }

    @Override
    public void retirer(int nbPrises) throws CoupInvalideException {
        if (nbPrises < 1) {
            throw new CoupInvalideException(nbPrises, "< 1");
        }
        if (nbPrises > nbAllumettes) {
            throw new CoupInvalideException(nbPrises, "> " + nbAllumettes);
        }
        if (nbPrises > PRISE_MAX) {
            throw new CoupInvalideException(nbPrises, "> " + PRISE_MAX);
        }
        nbAllumettes -= nbPrises;
    }

    @Override
    public String toString() {
        return String.valueOf(nbAllumettes);
    }
}