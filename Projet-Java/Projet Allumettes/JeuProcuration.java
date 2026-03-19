package allumettes;

/** Proxy (procuration) : empêche d'appeler retirer() côté joueur. */
public class JeuProcuration implements Jeu {
    private final Jeu jeuReel;

    public JeuProcuration(Jeu jeuReel) {
        this.jeuReel = jeuReel;
    }

    @Override
    public int getNombreAllumettes() {
        return jeuReel.getNombreAllumettes();
    }

    @Override
    public void retirer(int nbPrises)  {
        throw new OperationInterditeException("Operation interdite !");
    }

    @Override
    public String toString() {
        return jeuReel.toString();
    }
}