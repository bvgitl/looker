
view: vue_tickets_complementaires_bi {
  derived_table: {
    sql: {% raw %} SELECT COUNT(tickets_2_doc_no) AS count, tickets_2_count_niv_3_1
      FROM
      (SELECT
          tickets_2.doc_no  AS tickets_2_doc_no,
          COUNT(DISTINCT tickets_2.CD_Niv_3 ) AS tickets_2_count_niv_3_1
      FROM `bv-prod.Matillion_Perm_Table.Tickets`  AS tickets
      LEFT JOIN `bv-prod.Matillion_Perm_Table.Tickets`  AS tickets_2 ON tickets_2.doc_no=tickets.doc_no
      LEFT JOIN `bv-prod.Matillion_Perm_Table.ARTICLE_ARBORESCENCE`
           AS article_arbo_2 ON article_arbo_2.CodeArticle=tickets_2.CD_Article
      WHERE (tickets.CD_Niv_3 ) = 4219 AND ((( tickets.doc_date  ) >= ((DATE_ADD(CURRENT_DATE('Europe/Paris'), INTERVAL -29 DAY))) AND ( tickets.doc_date  ) < ((DATE_ADD(DATE_ADD(CURRENT_DATE('Europe/Paris'), INTERVAL -29 DAY), INTERVAL 30 DAY))))) AND ((( article_arbo_2.N3_SousFamille  IN ('ACCESSOIRES ERGONOMIQUES', 'CABLES USB ETHERNET VIDÉO AUDIO ALIMENTA', 'CASQUES OREILLETTES ET ENCEINTES', 'CLAVIERS', 'ECRANS D\'ORDINATEURS', 'LOGICIELS', 'NETTOYAGE MATÉRIEL', 'PRISES PARASURTENSEURS ET ONDULEURS', 'SAUVEGARDE', 'SOURIS ET TAPIS', 'SWITCHS ROUTEURS ET HUB', 'WEBCAM ET CAMÉRAS IP')) OR ( article_arbo_2.N4  IN ('Sacs a dos ordinateur', 'Serviettes et Sacoches')) OR ( tickets_2.CD_Niv_3  =  tickets.CD_Niv_3)))
      GROUP BY
          1
      )
      GROUP BY 2
      ORDER BY 2 {% endraw %} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: count_ {
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension: tickets_2_count_niv_3_1 {
    type: number
    sql: ${TABLE}.tickets_2_count_niv_3_1 ;;
  }

  set: detail {
    fields: [
        count_,
	tickets_2_count_niv_3_1
    ]
  }
}
