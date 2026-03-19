with Adresses;              use Adresses;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Cache is

   type T_Cache is private;
   type T_Politique is (FIFO, LRU);

   -- Initialise le cache avec une taille maximale
   procedure Initialiser (Cache : out T_Cache; Taille_Max : in Integer);

   -- Définit la politique (FIFO par défaut, ou LRU)
   procedure Definir_Politique
     (Cache : in out T_Cache; Politique : in T_Politique);

   -- Cherche une Adresse IP et gère la remontée en tête si la politique est LRU
   procedure Chercher_Cache(Cache  : in out T_Cache;IP: in T_Adresse_IP;Interf : out Unbounded_String;Trouve : out Boolean);

   -- Ajoute une route (IP -> Interface) et gère l'éviction si plein
   procedure Mettre_A_Jour_Cache(Cache  : in out T_Cache;IP: in T_Adresse_IP;Interf : in Unbounded_String);

   procedure Afficher_Cache (Cache : in T_Cache);

   procedure Vider_Cache (Cache : in out T_Cache);

private

   type T_Cellule_Cache;
   type T_Lien is access T_Cellule_Cache;
   type T_Cellule_Cache is record
      IP      : T_Adresse_IP;
      Interf  : Unbounded_String;
      Suivant : T_Lien;
   end record;
   type T_Cache is record
      Tete      : T_Lien;
      Taille    : Integer;
      Capacite  : Integer;
      Politique : T_Politique;
   end record;

end Cache;
