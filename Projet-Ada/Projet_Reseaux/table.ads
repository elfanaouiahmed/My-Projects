with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Adresses;              use Adresses;

package Table is

   type T_Table is private;

   -- Initialise une table vide
   procedure Initialiser_Table (Table : out T_Table);
   -- Ajoute une route à la table
   procedure Ajouter_Route
     (Table       : in out T_Table;
      Destination : in T_Adresse_IP;
      Masque      : in T_Adresse_IP;
      Interf      : in String);
   -- Trouve l'interface correspondant à une IP (Règle du masque le plus long)
   function Trouver_Interface
     (Table : in T_Table; Ip : in T_Adresse_IP) return String;
   -- Affiche le contenu de la table sur la sortie standard
   procedure Afficher_Table (Table : in T_Table);
   -- Vide la table et libère la mémoire
   procedure Vider_Table (Table : in out T_Table);

private
   type T_Route is record
      Destination : T_Adresse_IP;
      Masque      : T_Adresse_IP;
      Interf      : Unbounded_String;
   end record;
   type T_Cellule;
   type T_Table is access T_Cellule;
   type T_Cellule is record
      Donnee  : T_Route;
      Suivant : T_Table;
   end record;
end Table;
