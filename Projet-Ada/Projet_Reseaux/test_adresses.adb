with Ada.Text_IO; use Ada.Text_IO;
with Adresses;    use Adresses;

procedure Test_Adresses is
   IP_Nulle : T_Adresse_IP;
   IP_Test  : T_Adresse_IP;
begin
   Put_Line ("--- DEBUT DES TESTS : PACKAGE ADRESSES ---");
   -- Test 1 : Conversion de "0.0.0.0"
   Put ("Test 1 (0.0.0.0 -> 0) : ");
   IP_Nulle := Convertir_Texte_Vers_IP ("0.0.0.0");
   if IP_Nulle = 0 then
      Put_Line ("OK");
   else
      Put_Line ("ECHEC (Valeur : " & T_Adresse_IP'Image (IP_Nulle) & ")");
   end if;
   -- Test 2 : Conversion inverse (0 -> "0.0.0.0")
   Put ("Test 2 (0 -> 0.0.0.0) : ");
   if Convertir_IP_Vers_Texte (0) = "0.0.0.0" then
      Put_Line ("OK");
   else
      Put_Line ("ECHEC");
   end if;
   -- Test 3 : Conversion d'une IP classique "192.168.1.1"
   Put ("Test 3 (Calcul 192.168.1.1) : ");
   IP_Test := Convertir_Texte_Vers_IP ("192.168.1.1");
   -- 3232235777 correspond bien à 192.168.1.1
   if IP_Test = 3232235777 then
      Put_Line ("OK");
   else
      Put_Line ("ECHEC (Valeur : " & T_Adresse_IP'Image (IP_Test) & ")");
   end if;
   -- Test 4 : Aller-Retour (Texte -> IP -> Texte)
   Put ("Test 4 (Aller-Retour 127.0.0.1) : ");
   if Convertir_IP_Vers_Texte (Convertir_Texte_Vers_IP ("127.0.0.1"))
     = "127.0.0.1"
   then
      Put_Line ("OK");
   else
      Put_Line ("ECHEC");
   end if;
   Put_Line ("--- FIN DES TESTS ADRESSES ---");
end Test_Adresses;
