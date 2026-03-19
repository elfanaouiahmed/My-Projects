package allumettes;

public class Arbitre {
    private final Joueur j1;
    private final Joueur j2;
    private final boolean confiant;

    /** Arbitre non confiant (par défaut). */
    public Arbitre(Joueur j1, Joueur j2) {
        this(j1, j2, false);
    }

    /** Arbitre confiant ou non (selon l'option -confiant). */
    public Arbitre(Joueur j1, Joueur j2, boolean confiant) {
        this.j1 = j1;
        this.j2 = j2;
        this.confiant = confiant;
    }

    public void arbitrer(Jeu jeu) {
        Joueur courant = j1;
        boolean premierTour = true;
        while (true) {
            
            if (!premierTour) {
                System.out.println();
            }
            premierTour = false;
            System.out.println("Allumettes restantes : " + jeu.getNombreAllumettes());

            try {
                // Donne au joueur soit le vrai jeu (confiant), soit la procuration (anti-triche)
                Jeu jeuPourJoueur = confiant ? jeu : new JeuProcuration(jeu);

                int prise = courant.getPrise(jeuPourJoueur);

                String mot = (prise <= 1) ? "allumette" : "allumettes";
                System.out.println(courant.getNom() + " prend " + prise + " " + mot + ".");
                jeu.retirer(prise);
                if (jeu.getNombreAllumettes() == 0) {
                    // Celui qui prend la dernière a perdu
                    Joueur gagnant = (courant == j1) ? j2 : j1;
                    System.out.println();
                    System.out.println(courant.getNom() + " perd !");
                    System.out.println(gagnant.getNom() + " gagne !");
                    return;
                }

                // Tour suivant
                courant = (courant == j1) ? j2 : j1;
            } catch (CoupInvalideException e) {
                System.out.println("Impossible ! Nombre invalide : " + e.getCoup() + " (" + e.getProbleme() + ")");
                

            } catch (OperationInterditeException e) {
                System.out.println("Abandon de la partie car " + courant.getNom() + " triche !");
                return;
            }
        }
    }
}