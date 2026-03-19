with Adresses;              use Adresses;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Cache_Arbre is
   type T_Cache_Arbre is private;
   --Initialiser le cache(arbre vide)
   procedure Initialiser (Cache : out T_Cache_Arbre);
   --Recherche d'une Adresse_IP dans le cache
   procedure Chercher_Cache (Cache : in T_Cache_Arbre; IP : in T_Adresse_IP; Interf : out Unbounded_String; Tr : out Boolean);
   -- Ajoute une association (IP -> interface) dans le cache
   procedure Ajouter_Cache (Cache : in out T_Cache_Arbre; IP : in T_Adresse_IP; Interf : in Unbounded_String);
   -- Affiche le contenu du cache
   procedure Afficher_Cache (Cache : in T_Cache_Arbre);
   -- Vide complètement le cache et libère la mémoire associée
   procedure Vider_Cache (Cache : in out T_Cache_Arbre);
private
   type T_Noeud;
   type T_Cache_Arbre is access T_Noeud;
   type T_Noeud is record
      IP : T_Adresse_IP; Interf : Unbounded_String;
      Gauche, Droite : T_Cache_Arbre;
   end record;
end Cache_Arbre;