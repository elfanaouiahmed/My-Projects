with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;         use Ada.Command_Line;
with Ada.Exceptions;           use Ada.Exceptions;

with Adresses; use Adresses;
with Table;    use Table;
with Cache;    use Cache;

procedure Routeur_LL is
   -- Variables de configuration globales
   Nom_T : Unbounded_String := To_Unbounded_String ("table.txt");
   Nom_Q : Unbounded_String := To_Unbounded_String ("paquets.txt");
   Nom_R : Unbounded_String := To_Unbounded_String ("resultats.txt");
   Cap   : Integer := 10;
   Pol   : T_Politique := FIFO;
   Stat  : Boolean := True;

   -- Fichiers et structures de données
   F_T, F_Q, F_R : File_Type;
   Ligne         : Unbounded_String;
   Ma_Table      : T_Table;
   Mon_Cache     : T_Cache;

   -- Compteurs pour statistiques
   Cpt_L  : Integer := 0;
   Fini   : Boolean := False;
   Nb_D   : Integer := 0;
   Nb_Def : Integer := 0;
   -- R1 : Analyse des arguments de la ligne de commande
   procedure Lire_Arguments is
      I : Integer := 1;
   begin
      while I <= Argument_Count loop
         if Argument (I) = "-c" then
            Cap := Integer'Value (Argument (I + 1));
            I := I + 2;
         elsif Argument (I) = "-p" then
            if Argument (I + 1) = "LRU" then
               Pol := LRU;
            else
               Pol := FIFO;
            end if;
            I := I + 2;
         elsif Argument (I) = "-t" then
            Nom_T := To_Unbounded_String (Argument (I + 1));
            I := I + 2;
         elsif Argument (I) = "-q" then
            Nom_Q := To_Unbounded_String (Argument (I + 1));
            I := I + 2;
         elsif Argument (I) = "-r" then
            Nom_R := To_Unbounded_String (Argument (I + 1));
            I := I + 2;
         elsif Argument (I) = "-s" then
            Stat := True;
            I := I + 1;
         elsif Argument (I) = "-S" then
            Stat := False;
            I := I + 1;
         else
            I := I + 1;
         end if;
      end loop;
   end Lire_Arguments;
   -- R2 : Traiter une ligne de la table de routage (Extraction IP/Masque/Int)
   procedure Traiter_Ligne_Table (Ligne_Source : in Unbounded_String) is
      Texte              : String := To_String (Ligne_Source);
      Cursor             : Integer := Texte'First;
      Debut, Fin         : Integer;
      Dest_IP, Masque_IP : T_Adresse_IP;
      Interf_Txt         : Unbounded_String;

      -- Fonction utilitaire pour nettoyer les espaces
      function Nettoyer (S : String) return String is
         D : Integer := S'First;
         F : Integer := S'Last;
      begin
         while D <= F and then S (D) <= ' ' loop
            D := D + 1;
         end loop;
         while F >= D and then S (F) <= ' ' loop
            F := F - 1;
         end loop;
         if D > F then
            return "";
         else
            return S (D .. F);
         end if;
      end Nettoyer;

      Texte_Clean : String := Nettoyer (Texte);
   begin
      -- R2 : Vérifier que la ligne n'est pas vide
      if Texte_Clean'Length > 0 then

         -- R2 : Extraction Destination
         while Cursor <= Texte'Last and then Texte (Cursor) <= ' ' loop
            Cursor := Cursor + 1;
         end loop;
         Debut := Cursor;
         while Cursor <= Texte'Last and then Texte (Cursor) > ' ' loop
            Cursor := Cursor + 1;
         end loop;
         Fin := Cursor - 1;

         if Fin >= Debut then
            Dest_IP := Convertir_Texte_Vers_IP (Texte (Debut .. Fin));

            -- R2 : Extraction Masque
            while Cursor <= Texte'Last and then Texte (Cursor) <= ' ' loop
               Cursor := Cursor + 1;
            end loop;
            Debut := Cursor;
            while Cursor <= Texte'Last and then Texte (Cursor) > ' ' loop
               Cursor := Cursor + 1;
            end loop;
            Fin := Cursor - 1;

            if Fin >= Debut then
               Masque_IP := Convertir_Texte_Vers_IP (Texte (Debut .. Fin));

               -- R2 : Extraction Interface
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
                  -- R2 : Ajout dans la table
                  Ajouter_Route
                    (Ma_Table, Dest_IP, Masque_IP, To_String (Interf_Txt));
               end if;
            end if;
         end if;
      end if;
   end Traiter_Ligne_Table;
   -- R1 : Boucle principale de traitement des paquets
   procedure Traiter_Les_Paquets is
      IP_C   : T_Adresse_IP;
      Interf : Unbounded_String;
      Tr     : Boolean;

      -- Fonction utilitaire locale
      function Clean (Src : String) return String is
         D : Integer := Src'First;
         F : Integer := Src'Last;
      begin
         while D <= F and then Src (D) <= ' ' loop
            D := D + 1;
         end loop;
         while F >= D and then Src (F) <= ' ' loop
            F := F - 1;
         end loop;
         if D > F then
            return "";
         else
            return Src (D .. F);
         end if;
      end Clean;

   begin
      -- R1 : Tant que non fin de fichier et non commande "fin"
      while not End_Of_File (F_Q) and not Fini loop
         Ligne := Get_Line (F_Q);
         Cpt_L := Cpt_L + 1;

         declare
            S_Clean : String := Clean (To_String (Ligne));
         begin
            -- R1 : Exécuter la commande si c'en est une
            if S_Clean = "table" then
               New_Line;
               Put_Line ("table (ligne" & Integer'Image (Cpt_L) & ")");
               Afficher_Table (Ma_Table);

            elsif S_Clean = "cache" then
               New_Line;
               Put_Line ("cache (ligne" & Integer'Image (Cpt_L) & ")");
               Afficher_Cache (Mon_Cache);

            elsif S_Clean = "stat" then
               New_Line;
               Put_Line ("stat (ligne" & Integer'Image (Cpt_L) & ")");
               Put_Line ("Nombre de demandes : " & Integer'Image (Nb_D));
               Put_Line ("Nombre de defauts  : " & Integer'Image (Nb_Def));

            elsif S_Clean = "fin" then
               New_Line;
               Put_Line ("fin (ligne" & Integer'Image (Cpt_L) & ")");
               Fini := True;

            -- R1 : Sinon router le paquet
            elsif S_Clean'Length > 0
              and then S_Clean (S_Clean'First) in '0' .. '9'
            then
               Nb_D := Nb_D + 1;
               -- R2 : Conversion IP
               IP_C := Convertir_Texte_Vers_IP (S_Clean);

               -- R2 : Chercher d'abord dans le cache
               Chercher_Cache (Mon_Cache, IP_C, Interf, Tr);

               if not Tr then
                  Nb_Def := Nb_Def + 1;
                  -- R2 : Si pas trouvé, chercher dans la table
                  Interf :=
                    To_Unbounded_String (Trouver_Interface (Ma_Table, IP_C));
                  -- R2 : Mise à jour du cache (avec politique LRU/FIFO)
                  Mettre_A_Jour_Cache (Mon_Cache, IP_C, Interf);
               end if;

               -- R2 : Écriture du résultat
               Put (F_R, S_Clean & " " & To_String (Interf));
               New_Line (F_R);
            end if;
         end;
      end loop;
   end Traiter_Les_Paquets;
   -- PROGRAMME PRINCIPAL
begin
   -- 1. Configuration et Initialisation
   Lire_Arguments;

   -- R1 : Initialiser structures
   Initialiser_Table (Ma_Table);
   Initialiser (Mon_Cache, Cap);
   Definir_Politique (Mon_Cache, Pol);

   -- 2. Chargement de la table (R0)
   Open (F_T, In_File, To_String (Nom_T));
   while not End_Of_File (F_T) loop
      Ligne := Get_Line (F_T);
      Traiter_Ligne_Table (Ligne);
   end loop;
   Close (F_T);

   -- 3. Traitement des paquets (R0)
   Open (F_Q, In_File, To_String (Nom_Q));
   Create (F_R, Out_File, To_String (Nom_R));

   Traiter_Les_Paquets;

   -- 4. Nettoyage et Fermeture
   Vider_Cache (Mon_Cache);
   Vider_Table (Ma_Table);
   Close (F_Q);
   Close (F_R);

   if Stat then
      Put_Line ("Terminé. Résultats dans : " & To_String (Nom_R));
   end if;

exception
   when E : others =>
      Put_Line ("ERREUR DETECTEE : " & Exception_Name (E));
      Put_Line ("Message : " & Exception_Message (E));
end Routeur_LL;
