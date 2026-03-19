with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Cache_Arbre is

   procedure Free is new Ada.Unchecked_Deallocation (T_Noeud, T_Cache_Arbre);

   -- R1 : Initialisation du cache
   procedure Initialiser (Cache : out T_Cache_Arbre) is
   begin
      Cache := null;
   end Initialiser;

   -- R3 : Comment chercher une route dans le cache (Parcours ABR)
   procedure Chercher_Cache
     (Cache  : in T_Cache_Arbre;
      IP     : in T_Adresse_IP;
      Interf : out Unbounded_String;
      Tr     : out Boolean)
   is
      -- R3 : Initialiser un curseur sur la tête du cache
      Courant : T_Cache_Arbre := Cache;
   begin
      Tr := False;
      Interf := To_Unbounded_String ("");

      -- R3 : Tant que le curseur n’est pas Null
      while Courant /= null and then not Tr loop
         -- R3 : Si Reseau_Calcule = Destination (Ici égalité stricte IP)
         if Courant.IP = IP then
            Tr := True;
            Interf := Courant.Interf;
         -- R3 : Avancer le curseur (Logique Arbre : Gauche ou Droite)
         elsif IP < Courant.IP then
            Courant := Courant.Gauche;
         else
            Courant := Courant.Droite;
         end if;
      end loop;
   end Chercher_Cache;

   -- R4 : Comment ajouter une route cohérente dans le cache
   procedure Ajouter_Cache
     (Cache  : in out T_Cache_Arbre;
      IP     : in T_Adresse_IP;
      Interf : in Unbounded_String) is
   begin
   -- R4 : Insérer (Logique Récursive BST)
      if Cache = null then
         Cache := new T_Noeud'(IP, Interf, null, null);
      elsif IP < Cache.IP then
         Ajouter_Cache (Cache.Gauche, IP, Interf);
      elsif IP > Cache.IP then
         Ajouter_Cache (Cache.Droite, IP, Interf);
      else
         null;
      end if;
   end Ajouter_Cache;

   -- Parcours infixe pour la commande "cache"
   procedure Afficher_Cache (Cache : in T_Cache_Arbre) is
   begin
      if Cache /= null then
         Afficher_Cache (Cache.Gauche);
         Put_Line
           (Convertir_IP_Vers_Texte (Cache.IP)
            & " "
            & To_String (Cache.Interf));
         Afficher_Cache (Cache.Droite);
      end if;
   end Afficher_Cache;

   -- Vide complètement le cache
   procedure Vider_Cache (Cache : in out T_Cache_Arbre) is
   begin
      if Cache /= null then
         Vider_Cache (Cache.Gauche);
         Vider_Cache (Cache.Droite);
         Free (Cache);
         Cache := null;
      end if;
   end Vider_Cache;

end Cache_Arbre;
