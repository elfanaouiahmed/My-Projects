package allumettes;

public class StrategieTricheur implements Strategie {

    @Override
    public int getPrise(Jeu jeu) {
        System.out.println("[Je triche...]");

        // Triche : enlever des allumettes pour en laisser 2.
        // Si jeu est une procuration, retirer() déclenche OperationInterditeException.
        try {
            while (jeu.getNombreAllumettes() > 2) {
                jeu.retirer(1);
            }
                    System.out.println("[Allumettes restantes : " + jeu.getNombreAllumettes() + "]");
        } catch (CoupInvalideException e) {
            // Ne devrait pas arriver ici (on retire 1 et on vérifie > 2), mais on ignore.
        }

        // Puis annonce qu'on prend 1.
        return 1;
    }

    @Override
    public String getNom() {
        return "tricheur";
    }
}