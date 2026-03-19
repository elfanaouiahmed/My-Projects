with Ada.Strings;       use Ada.Strings;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package body Adresses is

   UN_OCTET : constant T_Adresse_IP := 2**8;

   function Convertir_Texte_Vers_IP (Chaine_IP : in String) return T_Adresse_IP
   is
      Resultat : T_Adresse_IP := 0;
      Octet    : T_Adresse_IP;
      Debut    : Integer := Chaine_IP'First;
      Fin      : Integer;
   begin
      -- Traitement des 3 premiers octets
      for I in 1 .. 3 loop
         Fin := Index (Chaine_IP, ".", From => Debut);
         Octet := T_Adresse_IP'Value (Chaine_IP (Debut .. Fin - 1));
         Resultat := Resultat * UN_OCTET + Octet;
         Debut := Fin + 1;
      end loop;

      -- Traitement du dernier octet
      Octet := T_Adresse_IP'Value (Chaine_IP (Debut .. Chaine_IP'Last));
      Resultat := Resultat * UN_OCTET + Octet;

      return Resultat;
   end Convertir_Texte_Vers_IP;

   function Convertir_IP_Vers_Texte (IP : in T_Adresse_IP) return String is
      O1, O2, O3, O4 : T_Adresse_IP;
   begin
      -- Extraction des octets
      O1 := (IP / UN_OCTET**3) mod UN_OCTET;
      O2 := (IP / UN_OCTET**2) mod UN_OCTET;
      O3 := (IP / UN_OCTET) mod UN_OCTET;
      O4 := IP mod UN_OCTET;

      -- Formatage sans espaces superflus
      return
        Trim (O1'Image, Both)
        & "."
        & Trim (O2'Image, Both)
        & "."
        & Trim (O3'Image, Both)
        & "."
        & Trim (O4'Image, Both);
   end Convertir_IP_Vers_Texte;

end Adresses;
