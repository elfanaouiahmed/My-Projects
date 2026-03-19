package allumettes;

/** Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 * @author	Xavier Crégut
 * @version	$Revision: 1.5 $
 */
public class Jouer {

	/** Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) {
		try {
			verifierNombreArguments(args);

			boolean confiant = false;
			int i = 0;

			if (args.length == 3) {
				if (!"-confiant".equals(args[0])) {
					throw new ConfigurationException("Option inconnue : " + args[0]);
				}
				confiant = true;
				i = 1;
			}

			Joueur j1 = construireJoueur(args[i]);
			Joueur j2 = construireJoueur(args[i + 1]);

			Jeu jeu = new JeuReel(13);
			Arbitre arbitre = new Arbitre(j1, j2, confiant);
			arbitre.arbitrer(jeu);

		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		}
	}

	private static void verifierNombreArguments(String[] args) {
		final int nbJoueurs = 2;
		if (args.length < nbJoueurs) {
			throw new ConfigurationException("Trop peu d'arguments : "
					+ args.length);
		}
		if (args.length > nbJoueurs + 1) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		}
	}

	private static Joueur construireJoueur(String description) {
        String[] morceaux = description.split("@", -1);
        if (morceaux.length != 2 || morceaux[0].isEmpty() || morceaux[1].isEmpty()) {
            throw new ConfigurationException("Joueur incorrect : " + description);
        }

        String nom = morceaux[0];
        String strat = morceaux[1];

        Strategie strategie = construireStrategie(strat, nom);
        return new Joueur(nom, strategie);
}

	private static Strategie construireStrategie(String nomStrategie, String nomJoueur) {
		switch (nomStrategie) {
		case "humain":
			return new StrategieHumain(nomJoueur);
		case "naif":
			return new StrategieNaif();
		case "rapide":
			return new StrategieRapide();
		case "expert":
			return new StrategieExpert();
		case "tricheur":
			return new StrategieTricheur();
		default:
			throw new ConfigurationException("Strategie inconnue : " + nomStrategie);
		}
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Jouer joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Jouer Xavier@humain "
					   + "Ordinateur@naif"
				+ "\n"
				);
	}

}