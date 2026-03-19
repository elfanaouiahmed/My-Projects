package Adresses is

   type T_Adresse_IP is mod 2**32;

   -- Convertit une chaîne (ex: "192.168.1.1") en adresse IP numérique
   function Convertir_Texte_Vers_IP
     (Chaine_IP : in String) return T_Adresse_IP;

   -- Convertit une adresse IP numérique en chaîne formatée "a.b.c.d"
   function Convertir_IP_Vers_Texte (IP : in T_Adresse_IP) return String;

end Adresses;
