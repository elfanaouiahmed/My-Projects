with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;
with Adresses;              use Adresses;

package body Table is

   procedure Free is new Ada.Unchecked_Deallocation (T_Cellule, T_Table);

   procedure Initialiser_Table (Table : out T_Table) is
   begin
      Table := null;
   end Initialiser_Table;

   procedure Ajouter_Route
     (Table       : in out T_Table;
      Destination : in T_Adresse_IP;
      Masque      : in T_Adresse_IP;
      Interf      : in String)
   is
      Nouvelle_Cellule : T_Table;
   begin
      Nouvelle_Cellule :=
        new T_Cellule'
          (Donnee  => (Destination, Masque, To_Unbounded_String (Interf)),
           Suivant => Table);
      Table := Nouvelle_Cellule;
   end Ajouter_Route;

   -- R3 : Comment choisir l’interface pour une destination ?
   function Trouver_Interface
     (Table : in T_Table; Ip : in T_Adresse_IP) return String
   is
      -- R3 : Initialiser un curseur sur la tête
      Courant           : T_Table := Table;
      Interface_Trouvee : Unbounded_String := To_Unbounded_String ("");
      -- R3 : Initialiser “Meilleure_Route” à aucune
      Meilleur_Masque   : T_Adresse_IP := 0;
      Trouve            : Boolean := False;
   begin
      -- R3 : Tant que le curseur n’est pas Null faire
      while Courant /= null loop
         -- R3 : Calculer la correspondance : Reseau-Calcule ⇔ Ip_A_Route et Masque
         if (Ip and Courant.Donnee.Masque) = Courant.Donnee.Destination then

            -- R3 : Si Masque > Meilleur_Masque alors (Implémentation LPM)
            if (not Trouve) or else (Courant.Donnee.Masque > Meilleur_Masque)
            then
               -- R3 : Mémoriser Interface et Masque
               Interface_Trouvee := Courant.Donnee.Interf;
               Meilleur_Masque := Courant.Donnee.Masque;
               Trouve := True;
            end if;
         end if;
         -- R3 : Avancer le Curseur
         Courant := Courant.Suivant;
      end loop;

      -- R3 : Renvoyer Meilleure_Route
      return To_String (Interface_Trouvee);
   end Trouver_Interface;

   -- R3 : Comment parcourir la liste chaînée et afficher chaque route
   procedure Afficher_Table (Table : in T_Table) is
      Courant : T_Table := Table;
   begin
      while Courant /= null loop
         Put (Convertir_IP_Vers_Texte (Courant.Donnee.Destination));
         Put (" ");
         Put (Convertir_IP_Vers_Texte (Courant.Donnee.Masque));
         Put (" ");
         Put_Line (To_String (Courant.Donnee.Interf));

         Courant := Courant.Suivant;
      end loop;
   end Afficher_Table;

   procedure Vider_Table (Table : in out T_Table) is
      Courant : T_Table := Table;
      Temp    : T_Table;
   begin
      while Courant /= null loop
         Temp := Courant;
         Courant := Courant.Suivant;
         Free (Temp);
      end loop;
      Table := null;
   end Vider_Table;

end Table;
