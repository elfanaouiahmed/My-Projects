import org.junit.*;
import static org.junit.Assert.*;
import java.awt.Color;
/**
 * Classe de test de la classe Cercle.
 * Teste uniquement les exigences E12, E13 et E14.
 * 
 * @author EL FANAOUI AHMED
 */

public class CercleTest {
 
	public static final double EPSILON = 1e-6;
    /** Premier point utilisé pour les tests. */
	private Point p1;
	/** Deuxième point utilisé pour les tests. */
	private Point p2;
	/** Premier cercle pour les tests. */
	private Cercle c1;
	/** Deuxième cercle pour les tests. */
	private Cercle c2;
    /**
     * Initialisation des points et cercles avant chaque test.
     */
	@Before
	public void setUp() {
		//on initialise quelques points et cercles pour tous les tests
		p1 = new Point(1, 2);
		p2 = new Point(4, -2);
		c1 = new Cercle(p1, 3.0);// cercle avec centre et rayon
		c2 = new Cercle(p1, p2);// cercle avec deux points diamétralement opposés
	}
    
    /** 
     * Test de l'initialisation des cercles (E12).
     */
	@Test
	public void E12_testInitialisation() {
		// vérifie que les cercles ont bien été créés et que leurs valeurs sont correctes
		assertTrue(c1 != null);
		assertTrue(c2 != null);
		assertEquals(1.0,c1.getCentre().getX(),EPSILON);
		assertEquals(2.0,c1.getCentre().getY(),EPSILON);
		assertEquals(3.0,c1.getRayon(),EPSILON);
		assertEquals(2.5,c2.getCentre().getX(),EPSILON);
		assertEquals(0.0,c2.getCentre().getY(),EPSILON);
        assertEquals(p1.distance(p2) / 2.0, c2.getRayon(), EPSILON);
		assertEquals(Color.blue, c1.getCouleur());
        assertEquals(Color.blue, c2.getCouleur());	
	}
    /**
     * Test de la modification du rayon (E12).
     */
	@Test
    public void testE12Rayon() {
		// on teste la modification du rayon
        double oldRayon = c1.getRayon();
        c1.setRayon(3);
        assertEquals(oldRayon, c1.getRayon(), EPSILON);
    }
    /**
     * Test de la modification du diamètre (E12).
     */
	@Test
    public void testE12Diametre() {
		// on teste la modification du diamètre
        double oldRayon = c1.getRayon();
        c1.setDiametre(6.0);
        assertEquals(oldRayon, c1.getRayon(), EPSILON);
    }
    /**
     * Test de la couleur par défaut (E12).
     */
	@Test
	public void testE12Couleur() {
		// vérifie la couleur par défaut
		assertEquals(Color.blue, c1.getCouleur());
		assertEquals(Color.blue, c2.getCouleur());
	}
    /**
     * Test du changement de couleur (E12).
     */
	@Test
	public void testE12SetCouleur() {
			// on change la couleur et on vérifie que ça a bien été pris en compte
		c1.setCouleur(Color.red);
		assertEquals(Color.red, c1.getCouleur());
		c1.setCouleur(Color.yellow);
		assertEquals(Color.yellow, c1.getCouleur());
	}
	/**
     * Test de la méthode creerCercle (E14).
     */
	@Test
	public void E14_CreerCercle() {
		    // test de la méthode creerCercle pour construire un cercle à partir d'un centre et d'un point
		Cercle c = Cercle.creerCercle(p1, new Point(1, 6));
		assertEquals(1.0, c.getCentre().getX(), EPSILON);
		assertEquals(2.0, c.getCentre().getY(), EPSILON);
		assertEquals(4.0, c.getRayon(), EPSILON);
		   // on modifie le point utilisé pour créer le cercle
        p1.translater(10, 10);
		assertEquals(Color.blue, c.getCouleur());

           // le cercle ne doit pas être affecté
        assertEquals(1.0, c.getCentre().getX(), EPSILON);
        assertEquals(2.0, c.getCentre().getY(), EPSILON);
	}
	/**
     * Test du constructeur avec deux points et couleur (E13).
     */
	@Test
    public void E13_constructeurDeuxPointsCouleur() {
        Point p1 = new Point(2, 2);
        Point p2 = new Point(2, 6);
           //créer un cercle à partir de deux points,centre et un point de circonférence
        Cercle c = new Cercle(p1, p2, Color.red);

        assertEquals(2.0, c.getCentre().getX(), EPSILON);
        assertEquals(4.0, c.getCentre().getY(), EPSILON);
        assertEquals(2.0, c.getRayon(), EPSILON);
        assertEquals(Color.red, c.getCouleur());

        p1.translater(10, 10);
        assertEquals(2.0, c.getCentre().getX(), EPSILON);
        assertEquals(4.0, c.getCentre().getY(), EPSILON);
    }

}