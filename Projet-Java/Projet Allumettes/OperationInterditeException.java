package allumettes;

/** Levée si un joueur tente de modifier le jeu via la procuration. */
public class OperationInterditeException extends RuntimeException {
    public OperationInterditeException(String message) {
        super(message);
    }
}