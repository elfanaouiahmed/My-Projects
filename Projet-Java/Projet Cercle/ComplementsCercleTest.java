import org.junit.*;
import static org.junit.Assert.*;
import java.awt.Color;
/**
 * Tests complémentaires liés explicitement aux exigences du sujet.
 */
public class ComplementsCercleTest {
    public static final double EPSILON = 1e-6;
    /**
       * E11
       * Vérifie que le constructeur (centre, rayon)
       * effectue une copie du point fourni.
       */
    @Test
    public void E11_CopieDefensiveConstructeurCentreRayon() {
        Point p = new Point(1, 2);
        Cercle c = new Cercle(p, 3.0);
        
        //modification du point d'origine après modification
        p.translater(10, -5);
        
        //Le cercle ne doit pass être affecté
        assertEquals(1.0, c.getCentre().getX(), EPSILON);
        assertEquals(2.0, c.getCentre().getY(), EPSILON);
        assertEquals(3.0, c.getRayon(), EPSILON);
    }
    /**
       * E12
       * Vérifie que le constructeur à deux points
       * ne conserve pas de référence vers les points fournis.
       */
    @Test

    public void E12_CopieDefensiveConstructeurDeuxPoints() {
        Point a = new Point(1, 2);
        Point b = new Point(4, -2);
        Cercle c = new Cercle(a, b);

        double x = c.getCentre().getX();
        double y = c.getCentre().getY();
        double r = c.getRayon();
        
        //Modification des points d'origine
        a.translater(100, 100);
        b.translater(-50, 70);

        //Le cercle doit rester inchangé
        assertEquals(x, c.getCentre().getX(), EPSILON);
        assertEquals(y, c.getCentre().getY(), EPSILON);
        assertEquals(r, c.getRayon(), EPSILON);
    }
    /**
       * E14
       * Vérifie que la méthode creerCercle crée
       * un cercle indépendant du point centre fourni.
       */
    @Test

    public void E14_CopieDefensiveCreerCercle() {
        Point centre = new Point(1, 2);
        Cercle c = Cercle.creerCercle(centre, new Point(1, 6));

        centre.translater(20, 20);

        assertEquals(1.0, c.getCentre().getX(), EPSILON);
        assertEquals(2.0, c.getCentre().getY(), EPSILON);
        assertEquals(4.0, c.getRayon(), EPSILON);
        assertEquals(Color.blue, c.getCouleur());
    }
    /**
       * E15
       * Vérifie que l’affichage respecte le format demandé :
       * Cr@(a, b)
       */
    @Test

    public void E15_TestToString() {
        Cercle c = new Cercle(new Point(1, 2), 2.5);

        String attendu = "C2.5@(1.0, 2.0)";
        assertEquals(attendu, c.toString());
    }
    /**
       * E5
       * Vérifie le comportement de la méthode contient
       * pour un point intérieur, frontière et extérieur.
       */
    @Test

    public void E5_TestContientCasFrontiere() {
        Cercle c = new Cercle(new Point(0, 0), 5.0);
        //Point sur la frontiére (distance=5)
        assertTrue(c.contient(new Point(3, 4)));
        
        //Point légèrement à l'extérieur  
        assertFalse(c.contient(new Point(5.01, 0))); 
    }
    /**
       * E18
       * Vérifie que getCentre() ne permet pas
       * de modifier l’état interne du cercle.
       */
    @Test

    public void E18_GetCentreNeModifiePasEtatInterne() {
        Cercle c = new Cercle(new Point(1, 2), 3.0);

        Point centre = c.getCentre();
        centre.translater(50, 50);

        // Le cercle doit rester inchangé
        assertEquals(1.0, c.getCentre().getX(), EPSILON);
        assertEquals(2.0, c.getCentre().getY(), EPSILON);
    }
}
