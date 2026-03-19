with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;         use Ada.Command_Line;
with Ada.Exceptions;           use Ada.Exceptions;

with Adresses; use Adresses;
with Table;    use Table;

procedure Routeur_Simple is

   -- Configuration par défaut des fichiers
   Nom_Fich_Table   : Unbounded_String := To_Unbounded_String ("table.txt");
   Nom_Fich_Paquets : Unbounded_String := To_Unbounded_String ("paquets.txt");
   Nom_Fich_Res     : Unbounded_String :=
     To_Unbounded_String ("resultats.txt");

   Fichier_Table     : File_Type;
   Fichier_Paquets   : File_Type;
   Fichier_Resultats : File_Type;
   Ligne_Lue         : Unbounded_String;
   Ma_Table          : T_Table;

   I : Positive := 1;

   -- Supprime les espaces en début et fin de chaîne
   function Nettoyer_Chaine (Source : String) return String is
      Debut : Integer := Source'First;
      Fin   : Integer := Source'Last;
   begin
      while Debut <= Fin and then Source (Debut) <= ' ' loop
         Debut := Debut + 1;
      end loop;
      while Fin >= Debut and then Source (Fin) <= ' ' loop
         Fin := Fin - 1;
      end loop;

      if Debut > Fin then
         return "";
      else
         return Source (Debut .. Fin);
      end if;
   end Nettoyer_Chaine;

   -- R2 : Comment traiter la ligne actuelle de table de routage ?
   procedure Traiter_Ligne_Table (Ligne : in Unbounded_String) is
      Texte      : String := To_String (Ligne);
      Cursor     : Integer := Texte'First;
      Debut, Fin : Integer;

      Dest_IP, Masque_IP : T_Adresse_IP;
      Interf_Txt         : Unbounded_String;
   begin
      -- R2 : Vérifier que la ligne n’est pas vide
      if Texte'Length > 0 then

         -- R2 : Extraire la destination
         while Cursor <= Texte'Last and then Texte (Cursor) <= ' ' loop
            Cursor := Cursor + 1;
         end loop;
         Debut := Cursor;
         while Cursor <= Texte'Last and then Texte (Cursor) > ' ' loop
            Cursor := Cursor + 1;
         end loop;
         Fin := Cursor - 1;

         if Fin >= Debut then
            -- R2 : Convertir la destination texte en entier
            Dest_IP := Convertir_Texte_Vers_IP (Texte (Debut .. Fin));

            -- R2 : Extraire le masque
            while Cursor <= Texte'Last and then Texte (Cursor) <= ' ' loop
               Cursor := Cursor + 1;
            end loop;
            Debut := Cursor;
            while Cursor <= Texte'Last and then Texte (Cursor) > ' ' loop
               Cursor := Cursor + 1;
            end loop;
            Fin := Cursor - 1;

            if Fin >= Debut then
               -- R2 : Convertir le masque texte en entier
               Masque_IP := Convertir_Texte_Vers_IP (Texte (Debut .. Fin));

               -- R2 : Extraire l'interface
               while Cursor <= Texte'Last and then Texte (Cursor) <= ' ' loop
                  Cursor := Cursor + 1;
               end loop;
               Debut := Cursor;
               while Cursor <= Texte'Last and then Texte (Cursor) > ' ' loop
                  Cursor := Cursor + 1;
               end loop;
               Fin := Cursor - 1;

               if Fin >= Debut then
                  Interf_Txt := To_Unbounded_String (Texte (Debut .. Fin));

                  -- R2 : Ajouter la route dans la table de routage
                  Ajouter_Route
                    (Ma_Table, Dest_IP, Masque_IP, To_String (Interf_Txt));
               end if;
            end if;
         end if;
      end if;
   end Traiter_Ligne_Table;
   -- R1 : Comment traiter les paquets
   procedure Traiter_Paquets
     (Nom_Fichier_Entree : String; Nom_Fichier_Sortie : String)
   is
      IP_Paquet    : T_Adresse_IP;
      Ligne_Propre : Unbounded_String;
      Continuer    : Boolean := True;
      Resultat     : Unbounded_String;
      Num_Ligne    : Natural := 0;
   begin
      -- R1 : Ouvrir les fichiers (paquets et résultats)
      Open (Fichier_Paquets, In_File, Nom_Fichier_Entree);
      Create (Fichier_Resultats, Out_File, Nom_Fichier_Sortie);

      -- R1 : Tant que la fin du fichier n’est pas atteinte et que "fin" n'est pas demandé
      while not End_Of_File (Fichier_Paquets) and Continuer loop
         -- R1 : Lire la ligne actuelle
         Ligne_Lue := Ada.Text_IO.Unbounded_IO.Get_Line (Fichier_Paquets);
         Num_Ligne := Num_Ligne + 1;
         Ligne_Propre :=
           To_Unbounded_String (Nettoyer_Chaine (To_String (Ligne_Lue)));

         if Length (Ligne_Propre) > 0 then

            -- R1 : Sinon (C'est une IP à router)
            if Element (Ligne_Propre, 1) in '0' .. '9' then
               -- R2 : Router le paquet et écrire le résultat
               IP_Paquet := Convertir_Texte_Vers_IP (To_String (Ligne_Propre));
               Resultat :=
                 To_Unbounded_String (Trouver_Interface (Ma_Table, IP_Paquet));

               Put (Fichier_Resultats, Ligne_Propre);
               Put (Fichier_Resultats, " ");
               Put_Line (Fichier_Resultats, To_String (Resultat));

            -- R1 : Si la ligne est une commande

            else
               New_Line;
               Put_Line
                 (To_String (Ligne_Propre)
                  & " (ligne"
                  & Natural'Image (Num_Ligne)
                  & ")");

               -- R2 : Exécuter la commande
               if Ligne_Propre = "table" then
                  Afficher_Table (Ma_Table);
               elsif Ligne_Propre = "cache" then
                  Put_Line ("Cache vide (Partie 1)");
               elsif Ligne_Propre = "stat" then
                  Put_Line ("Statistiques : Pas de cache.");
               elsif Ligne_Propre = "fin" then
                  Continuer := False; -- R2 : Arrêter la boucle principale
               else
                  Put_Line ("Commande inconnue : " & To_String (Ligne_Propre));
               end if;
            end if;
         end if;
      end loop;
      -- R1 : Fermer les fichiers
      Close (Fichier_Paquets);
      Close (Fichier_Resultats);
   end Traiter_Paquets;

begin
   -- R1 : Initialiser la table de routage par une liste chaînée vide
   Initialiser_Table (Ma_Table);
   -- Analyse des arguments
   while I <= Argument_Count loop
      if Argument (I) = "-t" then
         I := I + 1;
         if I <= Argument_Count then
            Nom_Fich_Table := To_Unbounded_String (Argument (I));
         end if;
      elsif Argument (I) = "-q" then
         I := I + 1;
         if I <= Argument_Count then
            Nom_Fich_Paquets := To_Unbounded_String (Argument (I));
         end if;
      elsif Argument (I) = "-r" then
         I := I + 1;
         if I <= Argument_Count then
            Nom_Fich_Res := To_Unbounded_String (Argument (I));
         end if;
      end if;
      I := I + 1;
   end loop;

   -- R1 : Ouvrir le fichier table de routage
   Put_Line ("Chargement de la table : " & To_String (Nom_Fich_Table));
   Open (Fichier_Table, In_File, To_String (Nom_Fich_Table));

   -- R1 : Tant que la fin du fichier n’est pas atteinte
   while not End_Of_File (Fichier_Table) loop
      Ligne_Lue := Ada.Text_IO.Unbounded_IO.Get_Line (Fichier_Table);
      -- R1 : Traiter la ligne pour l’ajouter à la liste
      Traiter_Ligne_Table (Ligne_Lue);
   end loop;
   -- R1 : Fermer le fichier
   Close (Fichier_Table);

   Put_Line ("Traitement des paquets : " & To_String (Nom_Fich_Paquets));
   Traiter_Paquets (To_String (Nom_Fich_Paquets), To_String (Nom_Fich_Res));

   Vider_Table (Ma_Table);
   Put_Line ("Terminé. Résultats dans : " & To_String (Nom_Fich_Res));

exception
   -- GESTION ROBUSTE DES ERREURS
   when E : others =>
      Put_Line ("ERREUR DETECTEE : " & Exception_Message (E));
      -- Nettoyage de la mémoire
      Vider_Table (Ma_Table);
      -- Fermeture propre des fichiers s'ils sont ouverts
      if Is_Open (Fichier_Table) then
         Close (Fichier_Table);
      end if;
      if Is_Open (Fichier_Paquets) then
         Close (Fichier_Paquets);
      end if;
      if Is_Open (Fichier_Resultats) then
         Close (Fichier_Resultats);
      end if;

end Routeur_Simple;
