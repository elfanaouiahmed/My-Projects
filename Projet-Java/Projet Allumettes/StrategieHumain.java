package allumettes;

import java.util.Scanner;

public class StrategieHumain implements Strategie {

    /** Un seul Scanner pour toute l'application. */
    private static final Scanner scanner = new Scanner(System.in);

    private final String nom;

    public StrategieHumain(String nom) {
        this.nom = nom;
    }

    @Override
    public int getPrise(Jeu jeu) {
        while (true) {
            System.out.print(nom + ", combien d'allumettes ? ");

            // On lit un "token" (un mot). Ça permet de détecter "triche".
            if (!scanner.hasNext()) {
                // EOF / entrée fermée (tests, Ctrl-D)
                throw new java.util.NoSuchElementException();
            }

            String saisie = scanner.next();

            if ("triche".equals(saisie)) {
                // Triche possible seulement si l'arbitre est confiant (sinon proxy -> exception)
                if (jeu.getNombreAllumettes() > 1) {
                   try {
                      jeu.retirer(1);
                      System.out.println("[Une allumette en moins, plus que " + jeu.getNombreAllumettes()+ ". Chut !]");
                   } catch (CoupInvalideException e) {
                    // Ne devrait pas arriver, on ignore
                }
                }  
                continue; // redemander
            }

            try {
                return Integer.parseInt(saisie);
            } catch (NumberFormatException e) {
                System.out.println("Vous devez donner un entier.");                // IMPORTANT: on a consommé le token, donc pas de boucle infinie
            }
        }
    }

    @Override
    public String getNom() {
        return "humain";
    }
}