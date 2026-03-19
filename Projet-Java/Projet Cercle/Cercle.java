import java.awt.Color;
/**
 * Classe représentant un cercle dans un plan 2D.
 * Permet de manipuler le centre, le rayon, la couleur et de calculer périmètre/aire.
 *
 * @author EL FANAOUI AHMED
 */
public class Cercle implements Mesurable2D {
	/** Constante PI pour les calculs, utilisée dans aire() et perimetre().*/
	public static final double PI = Math.PI;
	/** Centre du cercle. */
	private Point centre;
	/** Rayon du cercle.*/
	private double rayon;
	 /** Couleur du cercle, par défaut bleu.*/
	private Color couleur;


	/**
	 * E11: Construire un cercle à partir de son centre et de son rayon.
	 * @param centre le centre du cercle, non null.
     * @param rayon le rayon du cercle, strictement positif.
	 */
	public Cercle(Point centre, double rayon) {
		assert centre != null;
		assert rayon > 0;
		this.centre = new Point(centre.getX(), centre.getY());
		this.rayon = rayon;
		this.couleur = Color.blue;
	}
	/**
	 * E12: Construire un cercle à partir de deux points diamétralement opposés.
	 * la couleur par défaut est blue.
     * @param p1 premier point.
     * @param p2 deuxième point.
	 */
	public Cercle(Point p1, Point p2) {
		this(p1, p2, Color.blue);
	}
	/**
	 * E13:Construire un cercle à partir de deux points et d'une couleur.
	 * @param p1 premier point.
     * @param p2 deuxième point.
     * @param couleur couleur du cercle.
     */
	public Cercle(Point p1, Point p2, Color couleur) {
		assert p1 != null;
		assert p2 != null;
		assert couleur != null;
		double distance = p1.distance(p2);
		assert distance > 0;
		this.centre = new Point((p1.getX() + p2.getX()) / 2.0,
				(p1.getY() + p2.getY()) / 2.0);
		this.rayon = distance / 2.0;
		this.couleur = couleur;
	}
	/**
     * E14: Créer un cercle à partir d'un centre et d'un point du cercle.
     * @param centre centre du cercle.
     * @param pointCercle un point situé sur la circonférence.
     * @return un nouveau cercle bleu.
     */
	public static Cercle creerCercle(Point centre, Point pointCercle) {
		assert centre != null;
		assert pointCercle != null;
		double rayon = centre.distance(pointCercle); //Rayon=distanceentre centre et point
		return new Cercle(centre, rayon); //Couleur par défaut bleu
	}
	/**
     * E1: Translater le cercle.
     * @param dx déplacement en X.
     * @param dy déplacement en Y.
     */
	public void translater(double dx, double dy) {
		this.centre.translater(dx, dy);
	}
	/**
	 * E2: Obtenir le centre du cercle.
	 * @return une copie du centre.
	 */
	public Point getCentre() {
		return new Point(this.centre.getX(), this.centre.getY());
	}
	/**
	 * E3: Obtenir le rayon du cercle.
	 * @return le rayon.
	 */
	public double getRayon() {
		return this.rayon;
	}
	/**
	 * E4: Obtenir le diamètre du cercle.
	 * @return le diamétre.
	 */
	public double getDiametre() {
		return this.rayon * 2.0;
	}
	/**
	 * E5: Tester si un point est à l'intérieur (au sens large) du cercle.
	 * @param p point à tester.
     * @return true si le point est dans le cercle ou sur sa circonférence.
	 */
	public boolean contient(Point p) {
		assert p != null;
		return this.centre.distance(p) <= this.rayon;
	}
	/**
	 * E6: Obtenir le périmètre du cercle.
	 * @return le périmètre du cercle.
	 */
	public double perimetre() {
		return 2.0 * PI * this.rayon;
	}
	/**
	 * E7: Obtenir l'aire du cercle.
	 * @return l'aire du cercle.
	 */
	public double aire() {
		return PI * this.rayon * this.rayon;
	}
	/**
	 * E9: Obtenir la couleur du cercle.
	 *@return la couleur.
	 */
	public Color getCouleur() {
		return this.couleur;
	}
	/**
	 * E10: Changer la couleur du cercle.
	 * @param couleur nouvelle couleur.
	 */
	public void setCouleur(Color couleur) {
		assert couleur != null;
		this.couleur = couleur;
	}
	/**
	 * E16: Changer le rayon du cercle.
     * @param rayon nouveau rayon, strictement positif.
     */
	public void setRayon(double rayon) {
		assert rayon > 0;
		this.rayon = rayon;
	}
	/**
     * E17: Changer le diamètre du cercle.
     * @param diametre nouveau diamètre, strictement positif.
     */
	public void setDiametre(double diametre) {
		assert diametre > 0;
		this.rayon = diametre / 2.0;
	}
	/**
     * Représentation textuelle du cercle.
     * @return chaîne sous la forme Cr@(x, y).
     */
	public String toString() {
		return "C" + this.rayon + "@" + this.centre.toString();
	}
}
