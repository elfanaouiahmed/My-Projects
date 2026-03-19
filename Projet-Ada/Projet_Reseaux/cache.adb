with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body Cache is

   procedure Free is new Ada.Unchecked_Deallocation (T_Cellule_Cache, T_Lien);

   procedure Initialiser (Cache : out T_Cache; Taille_Max : in Integer) is
   begin
      Cache.Tete := null;
      Cache.Taille := 0;
      Cache.Capacite := Taille_Max;
      Cache.Politique := FIFO;
   end Initialiser;

   procedure Definir_Politique
     (Cache : in out T_Cache; Politique : in T_Politique) is
   begin
      Cache.Politique := Politique;
   end Definir_Politique;

   procedure Chercher_Cache
     (Cache  : in out T_Cache;
      IP     : in T_Adresse_IP;
      Interf : out Unbounded_String;
      Trouve : out Boolean)
   is
      Courant   : T_Lien := Cache.Tete;
      Precedent : T_Lien := null;
   begin
      Trouve := False;
      Interf := To_Unbounded_String ("");

      while Courant /= null and then not Trouve loop
         if Courant.IP = IP then
            Trouve := True;
            Interf := Courant.Interf;

            -- Gestion LRU : Remontée en tête
            if Cache.Politique = LRU and then Precedent /= null then
               Precedent.Suivant := Courant.Suivant;
               Courant.Suivant := Cache.Tete;
               Cache.Tete := Courant;
            end if;
         else
            Precedent := Courant;
            Courant := Courant.Suivant;
         end if;
      end loop;
   end Chercher_Cache;

   procedure Mettre_A_Jour_Cache
     (Cache  : in out T_Cache;
      IP     : in T_Adresse_IP;
      Interf : in Unbounded_String)
   is
      Nouveau       : T_Lien;
      Courant, Prec : T_Lien;
   begin
      -- Protection contre taille 0 : On englobe tout dans un IF au lieu de return
      if Cache.Capacite > 0 then

         -- 1. Si le cache est PLEIN, on supprime le DERNIER élément
         if Cache.Taille >= Cache.Capacite then
            Courant := Cache.Tete;
            Prec := null;

            -- On va jusqu'au dernier
            while Courant.Suivant /= null loop
               Prec := Courant;
               Courant := Courant.Suivant;
            end loop;

            -- Suppression
            if Prec = null then
               Cache.Tete := null; -- C'était le seul élément

            else
               Prec.Suivant := null;
            end if;
            Free (Courant);
            Cache.Taille := Cache.Taille - 1;
         end if;

         -- 2. Insertion en TÊTE
         Nouveau := new T_Cellule_Cache'(IP, Interf, Cache.Tete);
         Cache.Tete := Nouveau;
         Cache.Taille := Cache.Taille + 1;
      end if;
   end Mettre_A_Jour_Cache;

   procedure Afficher_Cache (Cache : in T_Cache) is
      C : T_Lien := Cache.Tete;
   begin
      while C /= null loop
         Put_Line
           (Convertir_IP_Vers_Texte (C.IP) & " " & To_String (C.Interf));
         C := C.Suivant;
      end loop;
   end Afficher_Cache;

   procedure Vider_Cache (Cache : in out T_Cache) is
      C : T_Lien := Cache.Tete;
      T : T_Lien;
   begin
      while C /= null loop
         T := C;
         C := C.Suivant;
         Free (T);
      end loop;
      Cache.Tete := null;
      Cache.Taille := 0;
   end Vider_Cache;

end Cache;
