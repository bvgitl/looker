view: distribution_familles {
  derived_table: {
    sql:
      SELECT
        tickets.doc_no AS doc_no,
        COUNT(DISTINCT tickets_2.CD_Niv_3) AS nb_famille
      FROM `bv-prod.Matillion_Perm_Table.Tickets` AS tickets
      LEFT JOIN `bv-prod.Matillion_Perm_Table.Tickets` AS tickets_2
        ON tickets_2.doc_no = tickets.doc_no
      LEFT JOIN `bv-prod.Matillion_Perm_Table.ARTICLE_ARBORESCENCE` AS article_arbo_2
        ON article_arbo_2.CodeArticle = tickets_2.CD_Article
      WHERE {% condition filtre_niv3 %}    tickets.CD_Niv_3  {% endcondition %}
        AND {% condition filtre_date %}    TIMESTAMP(tickets.doc_date)  {% endcondition %}
        AND {% condition filtre_magasin %} tickets.c_magasin {% endcondition %}
        AND (
          article_arbo_2.N3_SousFamille IN (
            'ACCESSOIRES ERGONOMIQUES','CABLES USB ETHERNET VIDÉO AUDIO ALIMENTA',
            'CASQUES OREILLETTES ET ENCEINTES','CLAVIERS','ECRANS D\'ORDINATEURS',
            'LOGICIELS','NETTOYAGE MATÉRIEL','SOURIS ET TAPIS',
            'WEBCAM ET CAMÉRAS IP','PRISES PARASURTENSEURS ET ONDULEURS',
            'SWITCHS ROUTEURS ET HUB','SAUVEGARDE')
          OR article_arbo_2.N4 IN ('Sacs a dos ordinateur','Serviettes et Sacoches', 'Prestation informatique')
          OR tickets_2.CD_Niv_3 = tickets.CD_Niv_3
        )
      GROUP BY 1 ;;
  }

  filter: filtre_niv3    { type: number }
  filter: filtre_date    { type: date }
  filter: filtre_magasin { type: string }

  dimension: nb_famille { type: number  sql: ${TABLE}.nb_famille ;; }
  dimension: doc_no     { type: string  sql: ${TABLE}.doc_no ;; }
  measure: count_tickets { type: count_distinct  sql: ${doc_no} ;; }
}
