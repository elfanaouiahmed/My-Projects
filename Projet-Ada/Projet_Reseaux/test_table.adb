with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Adresses;              use Adresses;
with Table;                 use Table;

procedure Test_Table is
   Ma_Table : T_Table;

   -- IPs pour les tests
   IP_Dest_1 : T_Adresse_IP := Convertir_Texte_Vers_IP ("192.168.0.0");
   Masque_1  : T_Adresse_IP :=
     Convertir_Texte_Vers_IP ("255.255.0.0");     -- /16

   IP_Dest_2 : T_Adresse_IP := Convertir_Texte_Vers_IP ("192.168.1.0");
   Masque_2  : T_Adresse_IP :=
     Convertir_Texte_Vers_IP ("255.255.255.0");   -- /24 (Plus précis)

   IP_Defaut  : T_Adresse_IP := Convertir_Texte_Vers_IP ("0.0.0.0");
   Masque_Def : T_Adresse_IP := Convertir_Texte_Vers_IP ("0.0.0.0");

   Res_Str : Unbounded_String;
   -- Fonction locale pour vérifier le résultat
   function Check (Attendu : String; Obtenu : String) return String is
   begin
      if Attendu = Obtenu then
         return "OK";
      else
         return "ECHEC (Attendu: " & Attendu & " | Obtenu: " & Obtenu & ")";
      end if;
   end Check;

begin
   Initialiser_Table (Ma_Table);
   Put_Line ("--- DEBUT DES TESTS : PACKAGE TABLE ---");
   -- Construction de la table
   Ajouter_Route (Ma_Table, IP_Dest_1, Masque_1, "eth0");
   Ajouter_Route (Ma_Table, IP_Dest_2, Masque_2, "eth1");
   Ajouter_Route (Ma_Table, IP_Defaut, Masque_Def, "internet");
   Put_Line ("Table initialisee avec 3 routes.");
   -- TEST 1 : Masque le plus long (192.168.1.15) -> doit matcher /24 (eth1)
   Put ("Test 1 (Masque le plus long) : ");
   Res_Str :=
     To_Unbounded_String
       (Trouver_Interface
          (Ma_Table, Convertir_Texte_Vers_IP ("192.168.1.15")));
   Put_Line (Check ("eth1", To_String (Res_Str)));
   -- TEST 2 : Route large (192.168.2.50) -> doit matcher /16 (eth0)
   Put ("Test 2 (Route large) : ");
   Res_Str :=
     To_Unbounded_String
       (Trouver_Interface
          (Ma_Table, Convertir_Texte_Vers_IP ("192.168.2.50")));
   Put_Line (Check ("eth0", To_String (Res_Str)));
   -- TEST 3 : Route par défaut (8.8.8.8) -> internet
   Put ("Test 3 (Route par defaut) : ");
   Res_Str :=
     To_Unbounded_String
       (Trouver_Interface (Ma_Table, Convertir_Texte_Vers_IP ("8.8.8.8")));
   Put_Line (Check ("internet", To_String (Res_Str)));
   -- Nettoyage
   Vider_Table (Ma_Table);
   Put_Line ("Table videe.");
   Put_Line ("--- FIN DES TESTS TABLE ---");
end Test_Table;
