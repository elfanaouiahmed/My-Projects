package allumettes;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class JeuReelTest {

    @Test
    public void retirerDiminueLeNombre() throws CoupInvalideException {
        Jeu jeu = new JeuReel(13);
        jeu.retirer(3);
        assertEquals(10, jeu.getNombreAllumettes());
    }

    @Test
    public void retirerUn() throws CoupInvalideException {
        Jeu jeu = new JeuReel(13);
        jeu.retirer(1);
        assertEquals(12, jeu.getNombreAllumettes());
    }
}