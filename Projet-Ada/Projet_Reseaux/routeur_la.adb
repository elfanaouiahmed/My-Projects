with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;         use Ada.Command_Line;
with Ada.Exceptions;           use Ada.Exceptions;

with Adresses;    use Adresses;
with Table;       use Table;
with Cache_Arbre; use Cache_Arbre;

procedure Routeur_LA is
   -- Variables de configuration globales
   Nom_T : Unbounded_String := To_Unbounded_String ("table.txt");
   Nom_Q : Unbounded_String := To_Unbounded_String ("paquets.txt");
   Nom_R : Unbounded_String := To_Unbounded_String ("resultats.txt");
   Stat  : Boolean := True;

   -- Structures de données
   F_T, F_Q, F_R : File_Type;
   Ligne         : Unbounded_String;
   Ma_Table      : T_Table;
   Mon_Cache     : T_Cache_Arbre;

   -- Compteurs
   Cpt_L  : Integer := 0;
   Fini   : Boolean := False;
   Nb_D   : Integer := 0;
   Nb_Def : Integer := 0;
   -- R1 : Analyse des arguments
   procedure Lire_Arguments is
      I : Integer := 1;
   begin
      while I <= Argument_Count loop
         if Argument (I) = "-t" then
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
   -- R0 : Construire la table de routage (Lecture)
   procedure Traiter_Ligne_Table (Ligne_Source : in Unbounded_String) is
      Texte              : String := To_String (Ligne_Source);
      Cursor             : Integer := Texte'First;
      Debut, Fin         : Integer;
      Dest_IP, Masque_IP : T_Adresse_IP;
      Interf_Txt         : Unbounded_String;

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
      if Texte_Clean'Length > 0 then
         -- Parsing IP
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
            -- Parsing Masque
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
               -- Parsing Interface
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
                  Ajouter_Route
                    (Ma_Table, Dest_IP, Masque_IP, To_String (Interf_Txt));
               end if;
            end if;
         end if;
      end if;
   end Traiter_Ligne_Table;
   -- R1 : Traitement des paquets avec cache
   procedure Traiter_Les_Paquets is
      IP_C   : T_Adresse_IP;
      Interf : Unbounded_String;
      Tr     : Boolean;

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
      -- R1 : Tant que la fin du fichier n’est pas atteinte
      while not End_Of_File (F_Q) and not Fini loop
         Ligne := Get_Line (F_Q);
         Cpt_L := Cpt_L + 1;

         declare
            S_Clean : String := Clean (To_String (Ligne));
         begin
            -- R1 : Si la ligne est une commande
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
               Put_Line
                 ("Demandes :"
                  & Integer'Image (Nb_D)
                  & ", Defauts :"
                  & Integer'Image (Nb_Def));
            elsif S_Clean = "fin" then
               New_Line;
               Put_Line ("fin (ligne" & Integer'Image (Cpt_L) & ")");
               Fini := True;

            -- R1 : Sinon (Router le paquet)
            elsif S_Clean'Length > 0
              and then S_Clean (S_Clean'First) in '0' .. '9'
            then
               Nb_D := Nb_D + 1;
               -- R2 : Convertir la ligne en entier
               IP_C := Convertir_Texte_Vers_IP (S_Clean);

               -- R2 : Chercher l’interface dans le cache (Arbre)
               Chercher_Cache (Mon_Cache, IP_C, Interf, Tr);

               if not Tr then
                  Nb_Def := Nb_Def + 1;
                  -- R2 : Choisir l’interface dans la table de routage complète
                  Interf :=
                    To_Unbounded_String (Trouver_Interface (Ma_Table, IP_C));
                  -- R2 : Ajouter la route correcte dans le cache
                  Ajouter_Cache (Mon_Cache, IP_C, Interf);
               end if;

               -- R2 : Écrire l’IP et l’interface trouvée
               Put (F_R, S_Clean & " " & To_String (Interf));
               New_Line (F_R);
            end if;
         end;
      end loop;
   end Traiter_Les_Paquets;
begin
   -- 1. Configuration
   Lire_Arguments;

   -- R1 : Initialisation du cache et table
   Initialiser_Table (Ma_Table);
   Initialiser (Mon_Cache);

   -- 2. Chargement Table
   Open (F_T, In_File, To_String (Nom_T));
   while not End_Of_File (F_T) loop
      Ligne := Get_Line (F_T);
      Traiter_Ligne_Table (Ligne);
   end loop;
   Close (F_T);

   -- 3. Traitement Paquets
   Open (F_Q, In_File, To_String (Nom_Q));
   Create (F_R, Out_File, To_String (Nom_R));

   Traiter_Les_Paquets;

   -- 4. Statistiques et Nettoyage
   if Stat then
      New_Line;
      Put_Line ("Nombre de demandes : " & Integer'Image (Nb_D));
      Put_Line ("Nombre de defauts  : " & Integer'Image (Nb_Def));
   end if;
   Vider_Cache (Mon_Cache);
   Vider_Table (Ma_Table);
   Close (F_Q);
   Close (F_R);
exception
   when E : others =>
      Put_Line
        ("Erreur lors de l'execution de Routeur_LA : "
         & Exception_Message (E));
end Routeur_LA;
