package allumettes;

import static org.junit.Assert.*;
import org.junit.Test;

public class StrategieRapideTest {

    @Test
    public void testPriseMax() {
        Jeu jeu = new JeuReel(13);
        StrategieRapide s = new StrategieRapide();
        assertEquals(3, s.getPrise(jeu));
    }

    @Test
    public void testDeuxAllumettes() {
        Jeu jeu = new JeuReel(2);
        StrategieRapide s = new StrategieRapide();
        assertEquals(2, s.getPrise(jeu));
    }

    @Test
    public void testUneAllumette() {
        Jeu jeu = new JeuReel(1);
        StrategieRapide s = new StrategieRapide();
        assertEquals(1, s.getPrise(jeu));
    }
}