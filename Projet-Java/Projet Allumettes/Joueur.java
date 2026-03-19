package allumettes;

public class Joueur {

    private final String nom;
    private Strategie strategie;

    public Joueur(String nom, Strategie strategie) {
        this.nom = nom;
        this.strategie = strategie;
    }

    public String getNom() {
        return nom;
    }

    public int getPrise(Jeu jeu) {
        return strategie.getPrise(jeu);
    }

    public Strategie getStrategie() {
        return strategie;
    }

    public void setStrategie(Strategie strategie) {
        this.strategie = strategie;
    }

    @Override
    public String toString() {
        return nom + "@" + strategie.getNom();
    }
}